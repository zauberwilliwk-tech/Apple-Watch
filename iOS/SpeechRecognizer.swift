import Foundation
import Speech
import AVFoundation

/// Spracheingabe (Deutsch) – erkennt eine Zahl von 1 bis 52.
@MainActor
final class SpeechRecognizer: ObservableObject {
    @Published var transcript = ""
    @Published var isListening = false
    @Published var errorMessage: String?

    /// Wird aufgerufen, sobald eine gültige Zahl erkannt wurde.
    var onNumber: ((Int) -> Void)?

    private let recognizer = SFSpeechRecognizer(locale: Locale(identifier: "de-DE"))
    private let audioEngine = AVAudioEngine()
    private var request: SFSpeechAudioBufferRecognitionRequest?
    private var task: SFSpeechRecognitionTask?

    func toggle() {
        isListening ? stop() : start()
    }

    func start() {
        errorMessage = nil
        transcript = ""
        SFSpeechRecognizer.requestAuthorization { status in
            Task { @MainActor in
                guard status == .authorized else {
                    self.errorMessage = "Spracherkennung nicht erlaubt (Einstellungen › Datenschutz)."
                    return
                }
                AVAudioApplication.requestRecordPermission { granted in
                    Task { @MainActor in
                        if granted { self.begin() }
                        else { self.errorMessage = "Mikrofon nicht erlaubt (Einstellungen › Datenschutz)." }
                    }
                }
            }
        }
    }

    private func begin() {
        guard let recognizer, recognizer.isAvailable else {
            errorMessage = "Spracherkennung gerade nicht verfügbar."
            return
        }
        do {
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)

            let request = SFSpeechAudioBufferRecognitionRequest()
            request.shouldReportPartialResults = true
            if recognizer.supportsOnDeviceRecognition {
                request.requiresOnDeviceRecognition = true   // funktioniert auch offline
            }
            request.contextualStrings = (1...52).map(String.init)
            self.request = request

            let input = audioEngine.inputNode
            let format = input.outputFormat(forBus: 0)
            input.removeTap(onBus: 0)
            input.installTap(onBus: 0, bufferSize: 1024, format: format) { buffer, _ in
                request.append(buffer)
            }
            audioEngine.prepare()
            try audioEngine.start()
            isListening = true

            task = recognizer.recognitionTask(with: request) { [weak self] result, error in
                Task { @MainActor in
                    guard let self else { return }
                    if let result {
                        let text = result.bestTranscription.formattedString
                        self.transcript = text
                        if let n = NumberParser.parse(text) {
                            self.onNumber?(n)
                            self.stop()
                            return
                        }
                        if result.isFinal { self.stop() }
                    }
                    if error != nil { self.stop() }
                }
            }
        } catch {
            errorMessage = "Audio-Fehler: \(error.localizedDescription)"
            stop()
        }
    }

    func stop() {
        guard isListening || task != nil else { return }
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
        request?.endAudio()
        task?.cancel()
        request = nil
        task = nil
        isListening = false
        try? AVAudioSession.sharedInstance().setActive(false, options: .notifyOthersOnDeactivation)
    }
}
