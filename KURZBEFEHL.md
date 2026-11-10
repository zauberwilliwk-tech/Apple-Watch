# Kurzbefehl „Out“ (ohne Xcode) – Syned Soy Box

## Aktionen in der Kurzbefehle-App
1. **Nach Eingabe fragen** – Typ **Zahl**, Frage „Zahl?“
2. **Text** – die 52 Zeilen unten einfügen (Zeile 1 = Zahl 1 … Zeile 52 = Zahl 52)
3. **Text teilen** – nach **Neue Zeilen**
4. **Objekt aus Liste abrufen** – **Objekt am Index**, Index = **Angeforderte Eingabe**
5. **Ergebnis anzeigen** – **Objekt aus Liste**

Name: **Out**. ⓘ → **Auf Apple Watch anzeigen**.
Starten: Aktionstaste (Einstellungen › Aktionstaste › Kurzbefehl › Out), Home-Bildschirm-Symbol oder Watch-Komplikation.

## Bedeutung einer Zeile
`C · K♠ Pik-König · verdeckt · nächste Karte`
- **Code** A/B/C = welcher Stift zuerst gezogen wird (dann gleiche Seite → diagonal → letzter)
  - A: oben links → unten links → oben rechts → unten rechts
  - B: unten rechts → oben rechts → unten links → oben links
  - C: unten links → oben links → unten rechts → oben rechts
- **Karte** = Vorhersage (rot ♥♦ → Kuvert Naht oben, schwarz ♠♣ → Naht unten)
- **verdeckt / offen** = Spiel verdeckt (≤ 24) oder offen (> 24) abzählen lassen
- **nächste / letzte Karte** = ungerade Zahl → nächste Karte, gerade → letzte gezählte Karte
- **Etui** (49–52) = Ausnahme: Spiel ins „leere“ Etui (53 Karten), zweiter Zuschauer zählt

## Die 52 Zeilen
```
A · K♠ Pik-König · verdeckt · nächste Karte
A · K♠ Pik-König · verdeckt · letzte Karte
A · B♥ Herz-Bube · verdeckt · nächste Karte
A · B♥ Herz-Bube · verdeckt · letzte Karte
A · K♣ Kreuz-König · verdeckt · nächste Karte
A · K♣ Kreuz-König · verdeckt · letzte Karte
A · B♦ Karo-Bube · verdeckt · nächste Karte
A · B♦ Karo-Bube · verdeckt · letzte Karte
B · K♠ Pik-König · verdeckt · nächste Karte
B · K♠ Pik-König · verdeckt · letzte Karte
B · B♥ Herz-Bube · verdeckt · nächste Karte
B · B♥ Herz-Bube · verdeckt · letzte Karte
B · K♣ Kreuz-König · verdeckt · nächste Karte
B · K♣ Kreuz-König · verdeckt · letzte Karte
B · B♦ Karo-Bube · verdeckt · nächste Karte
B · B♦ Karo-Bube · verdeckt · letzte Karte
C · K♠ Pik-König · verdeckt · nächste Karte
C · K♠ Pik-König · verdeckt · letzte Karte
C · B♥ Herz-Bube · verdeckt · nächste Karte
C · B♥ Herz-Bube · verdeckt · letzte Karte
C · K♣ Kreuz-König · verdeckt · nächste Karte
C · K♣ Kreuz-König · verdeckt · letzte Karte
C · B♦ Karo-Bube · verdeckt · nächste Karte
C · B♦ Karo-Bube · verdeckt · letzte Karte
C · B♦ Karo-Bube · offen · nächste Karte
C · B♦ Karo-Bube · offen · letzte Karte
C · K♣ Kreuz-König · offen · nächste Karte
C · K♣ Kreuz-König · offen · letzte Karte
C · B♥ Herz-Bube · offen · nächste Karte
C · B♥ Herz-Bube · offen · letzte Karte
C · K♠ Pik-König · offen · nächste Karte
C · K♠ Pik-König · offen · letzte Karte
B · B♦ Karo-Bube · offen · nächste Karte
B · B♦ Karo-Bube · offen · letzte Karte
B · K♣ Kreuz-König · offen · nächste Karte
B · K♣ Kreuz-König · offen · letzte Karte
B · B♥ Herz-Bube · offen · nächste Karte
B · B♥ Herz-Bube · offen · letzte Karte
B · K♠ Pik-König · offen · nächste Karte
B · K♠ Pik-König · offen · letzte Karte
A · B♦ Karo-Bube · offen · nächste Karte
A · B♦ Karo-Bube · offen · letzte Karte
A · K♣ Kreuz-König · offen · nächste Karte
A · K♣ Kreuz-König · offen · letzte Karte
A · B♥ Herz-Bube · offen · nächste Karte
A · B♥ Herz-Bube · offen · letzte Karte
A · K♠ Pik-König · offen · nächste Karte
A · K♠ Pik-König · offen · letzte Karte
A · B♥ Herz-Bube · Etui · nächste Karte
A · B♥ Herz-Bube · Etui · letzte Karte
A · K♠ Pik-König · Etui · nächste Karte
A · K♠ Pik-König · Etui · letzte Karte
```
