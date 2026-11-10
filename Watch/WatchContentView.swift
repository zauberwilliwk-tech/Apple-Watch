import SwiftUI
import WatchKit

struct WatchContentView: View {
    @ObservedObject private var connectivity = Connectivity.shared

    @State private var crownValue: Double = 1
    @State private var result: OutEntry?
    @State private var showKeypad = false

    private var crownNumber: Int { min(max(Int(crownValue.rounded()), 1), 52) }

    var body: some View {
        NavigationStack {
            Group {
                if let result {
                    resultView(result)
                } else {
                    pickerView
                }
            }
        }
        .onReceive(connectivity.$receivedNumber.compactMap { $0 }) { n in
            show(n, sync: false)
        }
    }

    // MARK: Eingabe

    private var pickerView: some View {
        VStack(spacing: 6) {
            Text("\(crownNumber)")
                .font(.system(size: 54, weight: .bold, design: .rounded).monospacedDigit())
                .focusable()
                .digitalCrownRotation($crownValue, from: 1, through: 52, by: 1,
                                      sensitivity: .low, isContinuous: false,
                                      isHapticFeedbackEnabled: true)
                .onTapGesture { show(crownNumber) }

            HStack(spacing: 6) {
                // Spracheingabe (Diktat) + Kritzeln
                TextFieldLink(prompt: Text("Zahl sagen")) {
                    Image(systemName: "mic.fill")
                        .frame(maxWidth: .infinity)
                } onSubmit: { text in
                    if let n = NumberParser.parse(text) { show(n) }
                    else { WKInterfaceDevice.current().play(.failure) }
                }
                .buttonStyle(.borderedProminent)
                .tint(.yellow)
                .foregroundStyle(.black)

                Button { showKeypad = true } label: {
                    Image(systemName: "circle.grid.3x3.fill")
                        .frame(maxWidth: .infinity)
                }

                Button { show(crownNumber) } label: {
                    Image(systemName: "checkmark")
                        .frame(maxWidth: .infinity)
                }
                .tint(.green)
            }
        }
        .navigationTitle("Out")
        .sheet(isPresented: $showKeypad) {
            KeypadView { n in
                showKeypad = false
                show(n)
            }
        }
    }

    // MARK: Ergebnis

    private func resultView(_ e: OutEntry) -> some View {
        ScrollView {
            VStack(spacing: 2) {
                Text("\(e.number)")
                    .font(.headline.monospacedDigit())
                    .foregroundStyle(.secondary)
                HStack(alignment: .firstTextBaseline, spacing: 10) {
                    Text(e.code)
                        .font(.system(size: 64, weight: .black, design: .rounded))
                        .foregroundStyle(.yellow)
                    Text(e.cardShort)
                        .font(.system(size: 52, weight: .black, design: .rounded))
                        .foregroundStyle(e.isRed ? .red : .white)
                }
                .minimumScaleFactor(0.5)
                Text(e.cardName).font(.footnote.bold())
                VStack(alignment: .leading, spacing: 2) {
                    Text(e.isException ? "⚠️ Etui-Spiel" : (e.faceUp ? "👁 offen zählen" : "🂠 verdeckt zählen"))
                    Text(e.nextCard ? "➡️ nächste Karte" : "⏹ letzte Karte")
                    Text("📌 " + e.pinOrder.joined(separator: " → "))
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
                .font(.footnote)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 4)
                Button("Neu") {
                    withAnimation { result = nil }
                }
                .buttonStyle(.bordered)
                .padding(.top, 4)
            }
        }
    }

    private func show(_ n: Int, sync: Bool = true) {
        guard let entry = OutTable.entry(for: n) else { return }
        crownValue = Double(n)
        withAnimation(.spring) { result = entry }
        WKInterfaceDevice.current().play(.success)
        if sync { Connectivity.shared.send(number: n) }
    }
}

// MARK: - Zahlenfeld

struct KeypadView: View {
    let onDone: (Int) -> Void
    @State private var text = ""

    private let keys = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "⌫", "0", "OK"]
    private let columns = Array(repeating: GridItem(.flexible(), spacing: 4), count: 3)

    var body: some View {
        VStack(spacing: 4) {
            Text(text.isEmpty ? "–" : text)
                .font(.title2.monospacedDigit().bold())
                .foregroundStyle(valid ? .yellow : .primary)
            LazyVGrid(columns: columns, spacing: 4) {
                ForEach(keys, id: \.self) { key in
                    Button { tap(key) } label: {
                        Text(key)
                            .font(.body.bold())
                            .frame(maxWidth: .infinity, minHeight: 26)
                    }
                    .buttonStyle(.bordered)
                    .tint(key == "OK" ? .green : nil)
                    .disabled(key == "OK" && !valid)
                }
            }
        }
    }

    private var valid: Bool {
        guard let n = Int(text) else { return false }
        return OutTable.range.contains(n)
    }

    private func tap(_ key: String) {
        switch key {
        case "⌫": if !text.isEmpty { text.removeLast() }
        case "OK": if let n = Int(text), valid { onDone(n) }
        default:
            guard text.count < 2 else { return }
            text += key
        }
    }
}
