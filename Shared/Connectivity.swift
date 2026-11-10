import Foundation
import WatchConnectivity

/// Synchronisiert die gewählte Zahl zwischen iPhone und Apple Watch.
/// Gibst du die Zahl am iPhone ein, erscheint das Ergebnis auch auf der Uhr – und umgekehrt.
final class Connectivity: NSObject, ObservableObject, WCSessionDelegate {
    static let shared = Connectivity()

    /// Zuletzt vom anderen Gerät empfangene Zahl.
    @Published var receivedNumber: Int?

    private override init() {
        super.init()
        if WCSession.isSupported() {
            WCSession.default.delegate = self
            WCSession.default.activate()
        }
    }

    func send(number: Int) {
        guard WCSession.isSupported() else { return }
        let session = WCSession.default
        guard session.activationState == .activated else { return }
        let payload: [String: Any] = ["number": number, "time": Date().timeIntervalSince1970]
        if session.isReachable {
            session.sendMessage(payload, replyHandler: nil, errorHandler: nil)
        }
        // Fallback, falls das andere Gerät gerade nicht aktiv ist
        try? session.updateApplicationContext(payload)
    }

    private func handle(_ payload: [String: Any]) {
        guard let n = payload["number"] as? Int else { return }
        DispatchQueue.main.async { self.receivedNumber = n }
    }

    // MARK: WCSessionDelegate
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {}

    func session(_ session: WCSession, didReceiveMessage message: [String: Any]) {
        handle(message)
    }

    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String: Any]) {
        handle(applicationContext)
    }

    #if os(iOS)
    func sessionDidBecomeInactive(_ session: WCSession) {}
    func sessionDidDeactivate(_ session: WCSession) { session.activate() }
    #endif
}
