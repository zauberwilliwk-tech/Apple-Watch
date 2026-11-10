import SwiftUI

struct ContentView: View {
    @StateObject private var speech = SpeechRecognizer()
    @ObservedObject private var connectivity = Connectivity.shared

    @State private var selected: Int?
    @State private var typed = ""
    @State private var showTable = false
    @FocusState private var fieldFocused: Bool

    private let columns = Array(repeating: GridItem(.flexible(), spacing: 8), count: 6)

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    ResultCard(entry: selected.flatMap(OutTable.entry))

                    inputRow

                    if speech.isListening || !speech.transcript.isEmpty || speech.errorMessage != nil {
                        speechStatus
                    }

                    LazyVGrid(columns: columns, spacing: 8) {
                        ForEach(OutTable.range, id: \.self) { n in
                            Button { choose(n) } label: {
                                Text("\(n)")
                                    .font(.headline.monospacedDigit())
                                    .frame(maxWidth: .infinity, minHeight: 44)
                                    .background(n == selected ? Color.accentColor : Color(.secondarySystemBackground))
                                    .foregroundStyle(n == selected ? .black : .primary)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                            }
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Out")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button { showTable = true } label: { Image(systemName: "tablecells") }
                }
                ToolbarItem(placement: .topBarLeading) {
                    if selected != nil {
                        Button("Neu") { reset() }
                    }
                }
            }
            .sheet(isPresented: $showTable) { TableView(highlight: selected) }
        }
        .tint(.yellow)
        .onAppear { speech.onNumber = { choose($0) } }
        .onReceive(connectivity.$receivedNumber.compactMap { $0 }) { n in
            withAnimation(.spring) { selected = n }
        }
    }

    private var inputRow: some View {
        HStack(spacing: 12) {
            TextField("Zahl 1–52", text: $typed)
                .keyboardType(.numberPad)
                .focused($fieldFocused)
                .font(.title2.monospacedDigit())
                .padding(.horizontal, 14)
                .frame(height: 56)
                .background(Color(.secondarySystemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 14))
                .onChange(of: typed) { _, value in
                    let digits = String(value.filter(\.isNumber).prefix(2))
                    if digits != value { typed = digits }
                    if let n = Int(digits), OutTable.range.contains(n),
                       digits.count == 2 || n >= 6 {
                        choose(n)
                    }
                }
                .toolbar {
                    ToolbarItemGroup(placement: .keyboard) {
                        Spacer()
                        Button("OK") {
                            if let n = Int(typed), OutTable.range.contains(n) { choose(n) }
                            fieldFocused = false
                        }
                    }
                }

            Button { speech.toggle() } label: {
                Image(systemName: speech.isListening ? "stop.fill" : "mic.fill")
                    .font(.title2)
                    .frame(width: 56, height: 56)
                    .background(speech.isListening ? Color.red : Color.accentColor)
                    .foregroundStyle(.black)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
            }
            .accessibilityLabel(speech.isListening ? "Spracheingabe stoppen" : "Spracheingabe starten")
        }
    }

    private var speechStatus: some View {
        HStack {
            if speech.isListening {
                ProgressView().tint(.red)
                Text(speech.transcript.isEmpty ? "Ich höre zu … sag eine Zahl" : speech.transcript)
            } else if let error = speech.errorMessage {
                Image(systemName: "exclamationmark.triangle")
                Text(error)
            } else {
                Text("Erkannt: \(speech.transcript)")
            }
            Spacer()
        }
        .font(.subheadline)
        .foregroundStyle(.secondary)
    }

    private func choose(_ n: Int) {
        withAnimation(.spring) { selected = n }
        typed = ""
        fieldFocused = false
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        Connectivity.shared.send(number: n)
    }

    private func reset() {
        withAnimation { selected = nil }
        typed = ""
        speech.transcript = ""
    }
}

// MARK: - Ergebnis

struct ResultCard: View {
    let entry: OutEntry?

    var body: some View {
        VStack(spacing: 6) {
            if let entry {
                Text("Zuschauer: \(entry.number)  ·  Schlüsselzahl \(entry.keyNumber)")
                    .font(.headline)
                    .foregroundStyle(.secondary)
                HStack(alignment: .firstTextBaseline, spacing: 28) {
                    VStack(spacing: 0) {
                        Text(entry.code)
                            .font(.system(size: 110, weight: .black, design: .rounded))
                            .foregroundStyle(.yellow)
                        Text("CODE").font(.caption).foregroundStyle(.secondary)
                    }
                    VStack(spacing: 0) {
                        Text(entry.cardShort)
                            .font(.system(size: 90, weight: .black, design: .rounded))
                            .foregroundStyle(entry.isRed ? .red : .primary)
                        Text("OUT \(entry.out) · \(entry.cardName.uppercased())").font(.caption).foregroundStyle(.secondary)
                    }
                }
                VStack(alignment: .leading, spacing: 6) {
                    Label("Stifte: " + entry.pinOrder.enumerated()
                            .map { "\($0.offset + 1). \($0.element)" }.joined(separator: ", "),
                          systemImage: "pin")
                    Label(entry.deckText, systemImage: entry.isException ? "exclamationmark.triangle" : (entry.faceUp ? "eye" : "eye.slash"))
                    Label(entry.positionText, systemImage: "hand.point.up")
                    if entry.isException {
                        Label("Ausnahme: Spiel ins Etui auf die 4 Karten, zweiter Zuschauer zählt", systemImage: "info.circle")
                            .foregroundStyle(.orange)
                    }
                }
                .font(.subheadline)
                .padding(.horizontal)
                .padding(.top, 6)
                Text(steps(entry))
                    .font(.footnote.monospacedDigit())
                    .foregroundStyle(.secondary)
                    .padding(.top, 4)
            } else {
                Image(systemName: "number.circle")
                    .font(.system(size: 64))
                    .foregroundStyle(.secondary)
                Text("Zahl eingeben, sprechen oder antippen")
                    .foregroundStyle(.secondary)
            }
        }
        .frame(maxWidth: .infinity, minHeight: 260)
        .padding(.vertical, 12)
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 24))
    }

    private func steps(_ e: OutEntry) -> String {
        var parts = ["\(e.number)"]
        if e.even != e.number { parts.append("gerade: \(e.even)") }
        if let m = e.mirrored { parts.append("50 − \(e.even) = \(m)") }
        return parts.joined(separator: "  →  ")
    }
}

// MARK: - Komplette Tabelle

struct TableView: View {
    let highlight: Int?
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            List(OutTable.entries) { e in
                HStack {
                    Text("\(e.number)").frame(width: 36, alignment: .trailing)
                    Text(e.even != e.number ? "\(e.even)" : "").frame(width: 36, alignment: .trailing)
                        .foregroundStyle(.secondary)
                    Text(e.mirrored.map(String.init) ?? "").frame(width: 36, alignment: .trailing)
                        .foregroundStyle(.secondary)
                    Spacer()
                    Text(e.code).bold().foregroundStyle(.yellow).frame(width: 30)
                    Text(e.cardShort).bold().foregroundStyle(e.isRed ? .red : .primary).frame(width: 40)
                }
                .font(.body.monospacedDigit())
                .listRowBackground(e.number == highlight ? Color.yellow.opacity(0.25) : nil)
            }
            .navigationTitle("Tabelle")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) { Button("Fertig") { dismiss() } }
            }
        }
    }
}
