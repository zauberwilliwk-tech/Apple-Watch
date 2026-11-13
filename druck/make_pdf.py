# Erzeugt das A4-Blatt "Zahlenwahl-Studie" (Spickzettel) als PDF.
import json, subprocess, sys, pathlib
raw = "A2A2A4A4A6A6A8A8B2B2B4B4B6B6B8B8C2C2C4C4C6C6C8C8C8C8C6C6C4C4C2C2B8B8B6B6B4B4B2B2A8A8A6A6A4A4A2A2A4A4A2A2"
def secret(n):
    c, k = raw[(n-1)*2], int(raw[(n-1)*2+1])
    return c + ("E" if n > 48 else "U" if n > 24 else "O") + ("N" if n % 2 else "Z") + str(k // 2)

# Gleiche Daten wie im Zahlenlabor
TOTAL = 12486; seed = 52017
def rnd():
    global seed
    seed = (seed * 16807) % 2147483647
    return seed / 2147483647
boost = {7:3.1,17:2.7,3:2.0,13:1.9,27:1.8,37:1.7,23:1.6,42:1.5,11:1.4,21:1.35,33:1.3,9:1.25,19:1.25}
w = []
for i in range(1, 53):
    v = 0.75 + rnd() * 0.5
    if i in boost: v *= boost[i]
    if i % 10 == 0: v *= 0.7
    if i in (1, 52): v *= 0.55
    w.append(v)
s = sum(w)
# JS Math.round == floor(x+0.5) für positive Zahlen
import math
counts = [math.floor(x / s * TOTAL + 0.5) for x in w]
counts[6] += TOTAL - sum(counts)
order = sorted(range(52), key=lambda i: -counts[i])
rank = {i + 1: order.index(i) + 1 for i in range(52)}

def de(x, d=1): return f"{x:.{d}f}".replace(".", ",")
def thousands(x): return f"{x:,}".replace(",", ".")

# Diagramm
W, H, L, B, T = 760, 230, 40, 24, 8
ymax = math.ceil(max(counts) / 200) * 200
bw = (W - L - 4) / 52
def y(v): return T + (H - T - B) * (1 - v / ymax)
svg = [f'<svg viewBox="0 0 {W} {H}" xmlns="http://www.w3.org/2000/svg">']
for g in range(0, ymax + 1, 200):
    svg.append(f'<line x1="{L}" x2="{W-4}" y1="{y(g):.1f}" y2="{y(g):.1f}" stroke="#d6dbe2" stroke-width="0.8"/>')
    svg.append(f'<text x="{L-6}" y="{y(g)+3.5:.1f}" text-anchor="end">{g}</text>')
for i, c in enumerate(counts):
    n = i + 1; x = L + i * bw + 1.2
    fill = "#2f5d7c" if rank[n] <= 5 else "#9aa9ba"
    svg.append(f'<rect x="{x:.1f}" y="{y(c):.1f}" width="{bw-2.4:.1f}" height="{(H-T-B)*c/ymax:.1f}" rx="1.5" fill="{fill}"/>')
    if n == 1 or n % 5 == 0 or n == 52:
        svg.append(f'<text x="{x+(bw-2.4)/2:.1f}" y="{H-8}" text-anchor="middle">{n}</text>')
svg.append("</svg>")

# Tabelle in 4 Spalten à 13 Zeilen
blocks = []
for b in range(4):
    rows = []
    for n in range(b*13 + 1, b*13 + 14):
        c = counts[n-1]
        rows.append(f"<tr><td class=n>{n}</td><td>{thousands(c)}</td><td>{de(c/TOTAL*100)}&nbsp;%</td><td>{rank[n]}</td><td class=id>{secret(n)}</td></tr>")
    blocks.append("<table><thead><tr><th>Zahl</th><th>Nenn.</th><th>Anteil</th><th>Rang</th><th>ID</th></tr></thead><tbody>" + "".join(rows) + "</tbody></table>")

top5 = ", ".join(f"{i+1} ({de(counts[i]/TOTAL*100)} %)" for i in order[:5])
html = f"""<!doctype html><html lang=de><meta charset=utf-8><title>Zahlenwahl-Studie</title>
<style>
@page {{ size: A4; margin: 14mm 13mm 12mm; }}
* {{ box-sizing: border-box; }}
body {{ font-family: "DejaVu Sans", "Liberation Sans", Arial, sans-serif; color: #18222e; font-size: 9pt; margin: 0; }}
.eyebrow {{ font-size: 7.5pt; letter-spacing: .12em; text-transform: uppercase; color: #5c6878; }}
h1 {{ font-size: 21pt; margin: 2mm 0 1mm; letter-spacing: -.01em; }}
.lead {{ color: #4a5666; margin: 0 0 4mm; max-width: 150mm; line-height: 1.45; }}
.facts {{ display: flex; gap: 6mm; margin-bottom: 4mm; }}
.fact {{ border-top: 1.2pt solid #18222e; padding-top: 1.5mm; flex: 1; }}
.fact b {{ display: block; font-size: 14pt; }}
.fact span {{ color: #5c6878; font-size: 7.5pt; }}
h2 {{ font-size: 10pt; margin: 3mm 0 1.5mm; }}
svg {{ width: 100%; height: auto; display: block; }}
svg text {{ font-size: 9px; fill: #6b7787; font-family: inherit; }}
.cap {{ color: #6b7787; font-size: 7.5pt; margin: 1mm 0 3mm; }}
.grid {{ display: grid; grid-template-columns: repeat(4, 1fr); gap: 4mm; }}
table {{ border-collapse: collapse; width: 100%; font-variant-numeric: tabular-nums; }}
th {{ font-size: 6.5pt; text-transform: uppercase; letter-spacing: .05em; color: #5c6878; text-align: right; font-weight: normal; border-bottom: .8pt solid #18222e; padding: 0 1mm 1mm; }}
th:first-child {{ text-align: left; }}
td {{ text-align: right; padding: 2.35mm 1mm; border-bottom: .4pt solid #e1e5ea; font-size: 8pt; }}
td.n {{ text-align: left; font-weight: bold; font-size: 10pt; }}
td.id {{ white-space: nowrap; font-family: "DejaVu Sans Mono", monospace; font-size: 8.5pt; font-weight: bold; color: #4a5666; letter-spacing: .02em; }}
tr:nth-child(even) td {{ background: #f4f6f9; }}
.foot {{ margin-top: 4mm; display: flex; justify-content: space-between; color: #8a95a4; font-size: 7pt; border-top: .4pt solid #d6dbe2; padding-top: 2mm; }}
</style>
<div class=eyebrow>Erhebung 2026 · Freie Zahlenwahl im Bereich 1–52</div>
<h1>Zahlenwahl-Studie</h1>
<p class=lead>Die Teilnehmenden sollten sich ein Kartenspiel vorstellen und in Gedanken irgendwo abheben. Erfasst wurde, wie viele Karten sie dabei abgehoben hätten.</p>
<div class=facts>
 <div class=fact><b>{thousands(TOTAL)}</b><span>befragte Personen</span></div>
 <div class=fact><b>{order[0]+1}</b><span>häufigste Zahl ({de(counts[order[0]]/TOTAL*100)} %)</span></div>
 <div class=fact><b>{order[-1]+1}</b><span>seltenste Zahl ({de(counts[order[-1]]/TOTAL*100)} %)</span></div>
 <div class=fact><b>1&nbsp;:&nbsp;2.704</b><span>Zufall: Zahl und Karte zugleich</span></div>
</div>
<h2>Nennungen je Zahl</h2>
{''.join(svg)}
<p class=cap>Dunkel markiert: die fünf häufigsten Zahlen – {top5}.</p>
<h2>Alle Ergebnisse</h2>
<div class=grid>{''.join(blocks)}</div>
<div class=foot><span>ID = Kennung der Erhebungsgruppe</span><span>Stand 11/2026</span></div>
</html>"""
pathlib.Path("zahlenwahl-studie.html").write_text(html, encoding="utf-8")
