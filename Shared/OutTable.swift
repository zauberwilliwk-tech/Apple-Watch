import Foundation

/// Ein Eintrag der Tabelle (Zuschauer-Zahl → Code + Karte).
struct OutEntry: Identifiable, Equatable {
    let number: Int        // Spectators number (1–52)
    let even: Int          // "Make even (+1)"
    let mirrored: Int?     // "If > 24, subtract from 50" (nil = nicht nötig / ---)
    let code: String       // CODE  (A, B, C)
    let card: Int          // CARD minus 0, 8 or 16

    var id: Int { number }

    /// Deine Outs (Forcierkarten). Hier ändern, falls du andere Karten benutzt.
    /// Code-Zahl 2 → Out 1, 4 → Out 2, 6 → Out 3, 8 → Out 4
    static let outs: [(short: String, name: String, red: Bool)] = [
        ("♣4", "Kreuz 4", false),   // Out 1  (Code-Zahl 2)
        ("♥2", "Herz 2", true),     // Out 2  (Code-Zahl 4)
        ("♦7", "Karo 7", true),     // Out 3  (Code-Zahl 6)
        ("♣3", "Kreuz 3", false),   // Out 4  (Code-Zahl 8)
    ]

    /// Out 1–4
    var out: Int { card / 2 }
    var cardName: String { Self.outs[out - 1].name }
    var cardShort: String { Self.outs[out - 1].short }
    var isRed: Bool { Self.outs[out - 1].red }

    /// 49–52: Ausnahme – Spiel aus dem „leeren“ Etui (53 Karten inkl. Joker) verwenden.
    var isException: Bool { number > 48 }

    /// ≤ 24 → vom verdeckten Spiel abzählen, > 24 → vom offenen Spiel.
    var faceUp: Bool { number > 24 }

    /// Ungerade → die NÄCHSTE Karte, gerade → die LETZTE abgezählte Karte.
    var nextCard: Bool { !number.isMultiple(of: 2) }

    /// Schlüsselzahl (Key Number) laut Anleitung.
    var keyNumber: Int { mirrored ?? even }

    var deckText: String {
        if isException { return "Etui-Spiel (53 Karten)" }
        return faceUp ? "Spiel OFFEN abzählen" : "Spiel VERDECKT abzählen"
    }

    var positionText: String {
        nextCard ? "\(number) abzählen → NÄCHSTE Karte" : "\(number). Karte = LETZTE gezählte"
    }

    /// Reihenfolge der Stifte (Fig. 8, Blick von oben auf die Box).
    var pinOrder: [String] {
        switch code {
        case "A": return ["oben links", "unten links", "oben rechts", "unten rechts"]
        case "B": return ["unten rechts", "oben rechts", "unten links", "oben links"]
        default:  return ["unten links", "oben links", "unten rechts", "oben rechts"]
        }
    }

    /// Kurzzeile für Watch / Kurzbefehl.
    var summary: String {
        "\(code) · Out \(out) \(cardName) · \(isException ? "Etui" : (faceUp ? "offen" : "verdeckt")) · \(nextCard ? "nächste Karte" : "letzte Karte")"
    }
}

enum OutTable {
    /// Exakt die Werte aus der Tabelle.
    /// Reihenfolge je Eintrag: (Code, Karte)
    private static let raw: [(String, Int)] = [
        // 1–8
        ("A", 2), ("A", 2), ("A", 4), ("A", 4), ("A", 6), ("A", 6), ("A", 8), ("A", 8),
        // 9–16
        ("B", 2), ("B", 2), ("B", 4), ("B", 4), ("B", 6), ("B", 6), ("B", 8), ("B", 8),
        // 17–24
        ("C", 2), ("C", 2), ("C", 4), ("C", 4), ("C", 6), ("C", 6), ("C", 8), ("C", 8),
        // 25–32
        ("C", 8), ("C", 8), ("C", 6), ("C", 6), ("C", 4), ("C", 4), ("C", 2), ("C", 2),
        // 33–40
        ("B", 8), ("B", 8), ("B", 6), ("B", 6), ("B", 4), ("B", 4), ("B", 2), ("B", 2),
        // 41–48
        ("A", 8), ("A", 8), ("A", 6), ("A", 6), ("A", 4), ("A", 4), ("A", 2), ("A", 2),
        // 49–52
        ("A", 4), ("A", 4), ("A", 2), ("A", 2),
    ]

    static let entries: [OutEntry] = raw.enumerated().map { index, value in
        let n = index + 1
        let even = n.isMultiple(of: 2) ? n : n + 1
        let mirrored: Int? = (even > 24 && even <= 48) ? 50 - even : nil
        return OutEntry(number: n, even: even, mirrored: mirrored, code: value.0, card: value.1)
    }

    static let range = 1...52

    static func entry(for number: Int) -> OutEntry? {
        guard range.contains(number) else { return nil }
        return entries[number - 1]
    }
}

// MARK: - Zahlen aus Sprache / Text erkennen

enum NumberParser {
    private static let units = ["", "eins", "zwei", "drei", "vier", "fünf", "sechs", "sieben", "acht", "neun"]
    private static let unitsPrefix = ["", "ein", "zwei", "drei", "vier", "fünf", "sechs", "sieben", "acht", "neun"]
    private static let teens = ["zehn", "elf", "zwölf", "dreizehn", "vierzehn", "fünfzehn",
                                "sechzehn", "siebzehn", "achtzehn", "neunzehn"]
    private static let tens = [2: "zwanzig", 3: "dreißig", 4: "vierzig", 5: "fünfzig"]

    /// Wortform → Zahl für 1–52 (Deutsch, plus ein paar Varianten).
    private static let words: [(String, Int)] = {
        var map: [String: Int] = [:]
        for n in 1...52 {
            let name: String
            switch n {
            case 1...9: name = units[n]
            case 10...19: name = teens[n - 10]
            default:
                let t = tens[n / 10]!
                name = n % 10 == 0 ? t : unitsPrefix[n % 10] + "und" + t
            }
            map[name] = n
        }
        map["ein"] = 1; map["eine"] = 1; map["einer"] = 1; map["zwo"] = 2
        // Varianten ohne Umlaut / ß
        for (k, v) in map {
            let alt = k.replacingOccurrences(of: "ü", with: "ue")
                       .replacingOccurrences(of: "ö", with: "oe")
                       .replacingOccurrences(of: "ß", with: "ss")
            map[alt] = v
            map[k.replacingOccurrences(of: "ß", with: "ss")] = v
        }
        // Längste zuerst, damit "einundzwanzig" vor "ein" gefunden wird
        return map.sorted { $0.key.count > $1.key.count }
    }()

    /// Liefert die erste Zahl (1–52) im Text – Ziffern oder deutsche Zahlwörter.
    static func parse(_ text: String) -> Int? {
        // 1. Ziffern
        let digits = text.split(whereSeparator: { !$0.isNumber })
        for d in digits {
            if let n = Int(d), OutTable.range.contains(n) { return n }
        }
        // 2. Zahlwörter
        let tokens = text.lowercased()
            .replacingOccurrences(of: "-", with: " ")
            .split(whereSeparator: { !$0.isLetter && $0 != "ß" })
            .map(String.init)
        // Wörter zusammenziehen ("sieben und zwanzig" → "siebenundzwanzig")
        let joined = tokens.joined()
        // a) zusammengesetzte Zahlen (21–52) zuerst
        for (word, value) in words where word.contains("und") {
            if joined.contains(word) { return value }
        }
        // b) einzelne Wörter exakt
        for (word, value) in words {
            if tokens.contains(word) { return value }
        }
        // c) Wort irgendwo im Text (z. B. "fünfzehnte")
        for (word, value) in words where word.count > 3 {
            if joined.contains(word) { return value }
        }
        return nil
    }
}
