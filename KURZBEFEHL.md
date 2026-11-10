# Kurzbefehl „Out“ (ohne Xcode) – Syned Soy Box

## Aktionen in der Kurzbefehle-App
1. **Nach Eingabe fragen** – Typ **Zahl**, Frage „Zahl?“
2. **Text** – die 52 Zeilen unten einfügen (Zeile 1 = Zahl 1 … Zeile 52 = Zahl 52)
3. **Text teilen** – nach **Neue Zeilen**
4. **Objekt aus Liste abrufen** – **Objekt am Index**, Index = **Angeforderte Eingabe**
5. **Ergebnis anzeigen** – **Objekt aus Liste**

Name: **Out**. ⓘ → **Auf Apple Watch anzeigen**.
Starten: Aktionstaste (Einstellungen › Aktionstaste › Kurzbefehl › Out), Home-Bildschirm-Symbol oder Watch-Komplikation.

## Deine Outs
| Out | Karte | Code-Zahl (Tabelle) | ersetzt im Original |
|---|---|---|---|
| Out 1 | Kreuz 4 | 2 | Pik-König |
| Out 2 | Herz 2 | 4 | Herz-Bube |
| Out 3 | Karo 7 | 6 | Kreuz-König |
| Out 4 | Kreuz 3 | 8 | Karo-Bube |

**Stapel 1 vorbereiten (von unten nach oben):** 25 Karten · **Kreuz 3** · beliebig · **Karo 7** · beliebig · **Herz 2** · beliebig · **Kreuz 4** · beliebig = 33 Karten.
Double-Ender: Out 2 + Out 4 (Herz 2 / Kreuz 3) auf einer Karte, Out 1 + Out 3 (Kreuz 4 / Karo 7) auf der anderen.

## Bedeutung einer Zeile
`C · Out 1 Kreuz 4 · verdeckt · nächste Karte`
- **Code** A/B/C = welcher Stift zuerst (dann gleiche Seite → diagonal → letzter)
  - A: oben links → unten links → oben rechts → unten rechts
  - B: unten rechts → oben rechts → unten links → oben links
  - C: unten links → oben links → unten rechts → oben rechts
- **Out** = Vorhersagekarte
- **verdeckt / offen** = Spiel verdeckt (≤ 24) oder offen (> 24) abzählen lassen
- **nächste / letzte Karte** = ungerade → nächste Karte, gerade → letzte gezählte
- **Etui** (49–52) = Ausnahme: Spiel ins „leere“ Etui (53 Karten), zweiter Zuschauer zählt

## Die 52 Zeilen
```
A · Out 1 Kreuz 4 · verdeckt · nächste Karte
A · Out 1 Kreuz 4 · verdeckt · letzte Karte
A · Out 2 Herz 2 · verdeckt · nächste Karte
A · Out 2 Herz 2 · verdeckt · letzte Karte
A · Out 3 Karo 7 · verdeckt · nächste Karte
A · Out 3 Karo 7 · verdeckt · letzte Karte
A · Out 4 Kreuz 3 · verdeckt · nächste Karte
A · Out 4 Kreuz 3 · verdeckt · letzte Karte
B · Out 1 Kreuz 4 · verdeckt · nächste Karte
B · Out 1 Kreuz 4 · verdeckt · letzte Karte
B · Out 2 Herz 2 · verdeckt · nächste Karte
B · Out 2 Herz 2 · verdeckt · letzte Karte
B · Out 3 Karo 7 · verdeckt · nächste Karte
B · Out 3 Karo 7 · verdeckt · letzte Karte
B · Out 4 Kreuz 3 · verdeckt · nächste Karte
B · Out 4 Kreuz 3 · verdeckt · letzte Karte
C · Out 1 Kreuz 4 · verdeckt · nächste Karte
C · Out 1 Kreuz 4 · verdeckt · letzte Karte
C · Out 2 Herz 2 · verdeckt · nächste Karte
C · Out 2 Herz 2 · verdeckt · letzte Karte
C · Out 3 Karo 7 · verdeckt · nächste Karte
C · Out 3 Karo 7 · verdeckt · letzte Karte
C · Out 4 Kreuz 3 · verdeckt · nächste Karte
C · Out 4 Kreuz 3 · verdeckt · letzte Karte
C · Out 4 Kreuz 3 · offen · nächste Karte
C · Out 4 Kreuz 3 · offen · letzte Karte
C · Out 3 Karo 7 · offen · nächste Karte
C · Out 3 Karo 7 · offen · letzte Karte
C · Out 2 Herz 2 · offen · nächste Karte
C · Out 2 Herz 2 · offen · letzte Karte
C · Out 1 Kreuz 4 · offen · nächste Karte
C · Out 1 Kreuz 4 · offen · letzte Karte
B · Out 4 Kreuz 3 · offen · nächste Karte
B · Out 4 Kreuz 3 · offen · letzte Karte
B · Out 3 Karo 7 · offen · nächste Karte
B · Out 3 Karo 7 · offen · letzte Karte
B · Out 2 Herz 2 · offen · nächste Karte
B · Out 2 Herz 2 · offen · letzte Karte
B · Out 1 Kreuz 4 · offen · nächste Karte
B · Out 1 Kreuz 4 · offen · letzte Karte
A · Out 4 Kreuz 3 · offen · nächste Karte
A · Out 4 Kreuz 3 · offen · letzte Karte
A · Out 3 Karo 7 · offen · nächste Karte
A · Out 3 Karo 7 · offen · letzte Karte
A · Out 2 Herz 2 · offen · nächste Karte
A · Out 2 Herz 2 · offen · letzte Karte
A · Out 1 Kreuz 4 · offen · nächste Karte
A · Out 1 Kreuz 4 · offen · letzte Karte
A · Out 2 Herz 2 · Etui · nächste Karte
A · Out 2 Herz 2 · Etui · letzte Karte
A · Out 1 Kreuz 4 · Etui · nächste Karte
A · Out 1 Kreuz 4 · Etui · letzte Karte
```
