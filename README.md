# Out – Apple Watch & iPhone

Hilfe für die **Syned Soy Box**: Zeigt zu jeder Zuschauer-Zahl **1–52** sofort an –
auf dem **iPhone** und auf der **Apple Watch**:

- **Code A/B/C** + Reihenfolge der 4 Stifte
- **Forcierkarte** (2 = Pik-König, 4 = Herz-Bube, 6 = Kreuz-König, 8 = Karo-Bube) + wie das Kuvert zu öffnen ist
- Spiel **verdeckt** (≤ 24) oder **offen** (> 24) abzählen
- **nächste Karte** (ungerade) oder **letzte gezählte Karte** (gerade)
- Ausnahme **49–52** (Etui-Spiel)

👉 Ohne Xcode: siehe **[KURZBEFEHL.md](KURZBEFEHL.md)**.

## Funktionen

**iPhone**
- Zahl eintippen (springt automatisch zum Ergebnis) oder aus dem 1–52-Raster antippen
- 🎤 Spracheingabe auf Deutsch („siebenundzwanzig“ oder „27“) – funktioniert auch offline
- Großes Ergebnis: Code + Karte, darunter der Rechenweg (gerade machen, 50 minus …)
- Tabellen-Symbol oben rechts zeigt die komplette Tabelle

**Apple Watch**
- Digitale Krone drehen → Zahl antippen oder ✓
- 🎤 Diktat (gelber Knopf) – Zahl einfach sagen
- Zahlenfeld (Raster-Knopf)
- Ergebnis riesig in Gelb (Code) + Weiß (Karte), Vibration als Bestätigung; Tippen = neu

**Synchron:** Gibst du die Zahl am iPhone ein, erscheint das Ergebnis automatisch auch auf der Uhr – und umgekehrt.

## Installation (Mac mit Xcode 16 oder neuer nötig)

1. Auf dem Mac einmalig XcodeGen installieren: `brew install xcodegen`
2. Repository klonen und im Ordner ausführen: `xcodegen generate`
3. `OutApp.xcodeproj` öffnen
4. Bei beiden Targets (**Out** und **OutWatch**) unter *Signing & Capabilities* dein Apple-ID-Team wählen.
   Ggf. die Bundle-ID `com.example.out` durch eine eigene ersetzen (Watch-ID muss mit `….watchkitapp` enden
   und `WKCompanionAppBundleIdentifier` muss zur iPhone-ID passen – steht alles in `project.yml`).
5. iPhone 17 Pro Max per Kabel anschließen, Schema **Out** wählen, ▶︎ Run.
   Die Watch-App wird automatisch mitinstalliert (oder in der Watch-App auf dem iPhone unter „Verfügbare Apps“ installieren).

Beim ersten Start der Spracheingabe fragt das iPhone nach Mikrofon- und Spracherkennungs-Erlaubnis.

### Alternative ohne XcodeGen
In Xcode *File › New › Project › watchOS › App* („Watch App with New Companion iOS App“) anlegen,
dann die Dateien aus `iOS/` + `Shared/` ins iOS-Target und `Watch/` + `Shared/` ins Watch-Target ziehen
(die vorgefertigten `ContentView`/`App`-Dateien von Xcode löschen) und im iOS-Target unter *Info* die Schlüssel
`Privacy - Microphone Usage Description` und `Privacy - Speech Recognition Usage Description` ergänzen.

## Dateien
| Ordner | Inhalt |
|---|---|
| `Shared/OutTable.swift` | Die komplette Tabelle (52 Einträge) + Erkennung deutscher Zahlwörter |
| `Shared/Connectivity.swift` | Synchronisation iPhone ⇄ Watch |
| `iOS/` | iPhone-App inkl. Spracherkennung |
| `Watch/` | Apple-Watch-App |
