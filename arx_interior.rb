# ============================================================
# Arx Interior -- Johann van Staal
# Crypt House | e-Moll | 118 BPM | 160 Takte
#
# 0-15 RUINAE | 16-31 FUNDAMENTA | 32-55 MURI
# 56-79 SCRIPTORIUM | 80-103 OBSIDIO | 104-119 LUCERNA
# 120-143 PORTA | 144-159 SEMEN
#
# Song 2 -- die Vorbereitung. Die Abwehr (R07) ist gescheitert;
# dieser Track baut eine Festung, waehrend draussen die Welt
# der frueheren Releases zerfaellt (Boots und Befehle aus R06,
# tief gefiltert -- das Regime ist nur noch Wetter).
#
# Der Anfang: Der Wind durch die leere Strasse eroeffnet
# allein (Takt 1 -- HAUSREGEL: keine Events auf Takt 0, sync-
# Loops verpassen den ersten Clock-Schlag). Die Musik setzt
# zur Haelfte des Windsamples ein (Takt 8).
#
# Baumaterial: E F# G A B D -- kein C. Aus diesem Vorrat laesst
# sich KEIN Tritonus bilden: Der diabolus in musica passt nicht
# durch die Tuer. Schlussstein des Bogens ist das D -- der Ton,
# fuer den sich Concordia/Discordia entschieden hat.
#
# Registerplan: RUINAE bis LUCERNA liegt alles eine Oktave
# tief (Krypta = ein Bogen unter der Erde). PORTA hebt Arp
# und Cantus um die Oktave -- die Tuer geht auf. SEMEN behaelt
# die Hoehe, und der Bass bekommt seine D/B-Bewegung zurueck.
#
# LUCERNA: 104-111 voellige Stille um Glocke, Lampe und
# Stimme; ab 112 kehrt der Herzschlag zurueck -- der Puls,
# der bleibt, wenn alles stillsteht, ist der eigene.
#
# Die Kraehe, zu Ende erzaehlt: bei 10 dunkel in den Ruinen
# (sie hatte recht), bei 151 unverfremdet im Offenen -- wenn
# draussen nichts mehr droht, ist sie nur noch ein Vogel.
#
# REGEL: Alle Vocals mit rate <= 0.9 (auch rueckwaerts).
# Vocal-Amps: 0.9-1.0 im vollen Arrangement, 0.85 wo die
# Stimme (fast) allein steht. Die Belagerungs-Geister draussen
# bleiben bewusst leiser -- sie sind Wetter, keine Stimmen.
#
# Benoetigt im Ordner (Kopien aus R05/R06): effect_craw,
# effect_marching_boots, vocal_obedite, vocal_procedite.
#
# Run:  run_file ".../R08_Arx_Interior/arx_interior.rb"
# (Stop vor Run!)
# ============================================================

set_volume! 1
set :takt, 0
set_sched_ahead_time! 1
use_bpm 118
use_random_seed 82

define :pfad do |name|
  "... insert local path name here ..." + name + ".wav"
end

puts "PFAD-TEST: " + pfad("vocal_semen").inspect

optionale = ["effect_wind_street", "effect_scriptorium",
             "effect_marching_boots", "effect_craw",
             "vocal_obedite", "vocal_procedite",
             "vocal_ducunt", "vocal_murus", "vocal_murus_kurz",
             "vocal_magnos_viros", "vocal_dux_atque_imperator",
             "vocal_semen", "vocal_semen_kurz",
             "vocal_fundamenta_iacimus", "vocal_lapis",
             "vocal_porta_patet", "vocal_exeamus"]

optionale.each do |n|
  if File.exist?(pfad(n))
    load_sample pfad(n)
    puts "GELADEN: " + n + ".wav"
  else
    puts "NOCH NICHT DA: " + n + ".wav (wird uebersprungen)"
  end
end

define :vox do |name, opts = {}|
  if File.exist?(pfad(name))
    puts "VOX SPIELT: " + name + " (Takt #{takt})"
    sample pfad(name), opts
  else
    puts "VOX FEHLT: " + name
  end
end

# ============================================================
# CLOCK -- set VOR cue, damit alle Loops denselben Takt sehen
# ============================================================

live_loop :puls, auto_cue: false do
  t = tick(:takt_counter)
  set :takt, t
  cue :puls
  puts "TAKT: #{t}"
  stop if t >= 160
  sleep 4
end

define :takt do
  get(:takt) || 0
end

# ============================================================
# ARCUS-THEMA -- der Bogen.
# Phrase A: E G A B | A G F# E  (alle Steine gleich gross)
# Phrase B: B D(doppelt -- der Schlussstein) B | A G F# E
# Jede Phrase 16 Beats = 4 Takte (Halbe).
# ============================================================

ARX_A = [[:e3, 2], [:g3, 2], [:a3, 2], [:b3, 2], [:a3, 2], [:g3, 2], [:fs3, 2], [:e3, 2]]
ARX_B = [[:b3, 2], [:d4, 4], [:b3, 2], [:a3, 2], [:g3, 2], [:fs3, 2], [:e3, 2]]

define :steine do |paare, oktav = 0, amp_level = 0.45, pan_pos = 0, quinte = false|
  paare.each do |n, d|
    if n
      play note(n) + oktav, attack: 0.3, release: d + 1.2, amp: amp_level, pan: pan_pos
      if quinte
        play note(n) + oktav + 7, attack: 0.35, release: d + 1.2, amp: amp_level * 0.5, pan: pan_pos * -1
      end
    end
    sleep d
  end
end

# ============================================================
# WIND -- die leere Strasse (effect_wind_street, 16 Takte
# auf dem 118er-Raster). Eroeffnet den Track allein ab Takt 1
# (Takt 0 traegt nie -- Hausregel); die Musik setzt zur
# Haelfte des Samples ein. OBSIDIO dunkler; PORTA ein Hauch.
# ============================================================

live_loop :wind, sync: :puls do
  t = takt
  stop if t >= 160

  if t == 1
    vox "effect_wind_street", rate: 1.0, amp: 0.55

  elsif t == 80
    with_fx :lpf, cutoff: 62 do
      vox "effect_wind_street", rate: 1.0, amp: 0.40
    end

  elsif t == 96
    # nur die erste Haelfte -- endet genau zum LUCERNA-Beginn
    with_fx :lpf, cutoff: 58 do
      vox "effect_wind_street", rate: 1.0, finish: 0.5, amp: 0.30
    end

  elsif t == 120
    # PORTA: die Tuer ist offen, draussen nur noch ein Hauch
    with_fx :lpf, cutoff: 54 do
      vox "effect_wind_street", rate: 1.0, finish: 0.5, amp: 0.16
    end
  end

  sleep 4
end

# ============================================================
# GRUND-DRONE -- die Krypta atmet. Setzt bei Takt 8 ein:
# die erste Musik, zur Haelfte des Winds. Nur E (und ab MURI
# die leere Quinte E+B). Keine Akkordwechsel: Die Festung steht.
# ============================================================

live_loop :grund_drone, sync: :puls do
  t = takt
  stop if t >= 160

  if t < 8
    sleep 16
  else
    amp_level =
      if t < 16
        0.28
      elsif t < 104
        0.34
      elsif t < 120
        0.30
      else
        0.28
      end

    use_synth :dark_ambience

    with_fx :lpf, cutoff: 60 do
      with_fx :reverb, room: 1, mix: 0.7 do
        play :e2, attack: 4, sustain: 8, release: 5, amp: amp_level
        play :b2, attack: 5, sustain: 7, release: 6, amp: amp_level * 0.5 if t >= 32
      end
    end

    sleep 16
  end
end

# ============================================================
# BELAGERUNG -- die frueheren Releases als Aussenwelt.
# Boots und Befehle aus R06, tief gefiltert: Was einmal
# Befehl war, ist nur noch Wetter hinter Mauern.
# (Boots-Sample liegt auf dem 126er-Raster: rate 118/126.)
# Bewusst leiser als die Stimmen drinnen.
# ============================================================

live_loop :belagerung, sync: :puls do
  t = takt
  stop if t >= 160

  case t

  when 12
    # RUINAE -- ferne Erinnerung an die Kolonne, nur 4 Takte
    with_fx :lpf, cutoff: 50 do
      with_fx :reverb, room: 1, mix: 0.8 do
        vox "effect_marching_boots", rate: 118.0 / 126.0, finish: 0.25, amp: 0.24, pan: -0.3
      end
    end

  when 82
    # OBSIDIO -- der alte Befehl, machtlos vor der Mauer
    with_fx :lpf, cutoff: 54 do
      with_fx :reverb, room: 1, mix: 0.82 do
        vox "vocal_obedite", rate: 0.72, amp: 0.55, pan: -0.55
      end
    end

  when 84
    # die Kolonne marschiert an -- 16 Takte, bis ~Takt 100
    with_fx :lpf, cutoff: 58 do
      with_fx :reverb, room: 0.9, mix: 0.6 do
        vox "effect_marching_boots", rate: 118.0 / 126.0, amp: 0.50, pan: 0.25
      end
    end

  when 88
    with_fx :lpf, cutoff: 52 do
      with_fx :reverb, room: 1, mix: 0.84 do
        vox "vocal_procedite", rate: 0.68, amp: 0.48, pan: 0.55
      end
    end

  when 96
    # der Befehl zerfaellt: rueckwaerts, kaum noch Sprache
    with_fx :lpf, cutoff: 48 do
      with_fx :reverb, room: 1, mix: 0.88 do
        vox "vocal_obedite", rate: -0.72, amp: 0.35, pan: -0.4
      end
    end
  end

  sleep 4
end

# ============================================================
# KRAEHE -- das Omen des Projekts, zu Ende erzaehlt.
# 10: dunkel in den Ruinen -- sie hatte recht.
# 151: dieselbe Kraehe im Offenen, unverfremdet -- nur noch
# ein Vogel. Panorama getauscht: Sie ist weitergeflogen.
# ============================================================

live_loop :kraehe, sync: :puls do
  t = takt
  stop if t >= 160

  if t == 10
    with_fx :lpf, cutoff: 74 do
      with_fx :reverb, room: 1, mix: 0.7 do
        vox "effect_craw", rate: 0.78, amp: 0.50, pan: -0.4
      end
    end

  elsif t == 151
    with_fx :reverb, room: 0.6, mix: 0.22 do
      vox "effect_craw", rate: 1.0, amp: 0.55, pan: 0.3
    end
  end

  sleep 4
end

# ============================================================
# KICK -- Four-on-the-floor, dunkel (rate 0.72).
# FUNDAMENTA: Herzschlag | Drop bei 80-83 | LUCERNA: 104-111
# voellige Stille, ab 112 der eigene Puls (tiefer, weicher) |
# SEMEN: zurueck zum Herzschlag, dann Stille.
# ============================================================

live_loop :kick, sync: :puls do
  t = takt
  stop if t >= 160

  if t < 16 || (t >= 80 && t < 84) || (t >= 104 && t < 112) || t >= 156
    sleep 4

  elsif t >= 112 && t < 120
    # LUCERNA, zweite Haelfte -- der Puls, der bleibt, wenn
    # alles stillsteht, ist der eigene. Tiefer und leiser als
    # der FUNDAMENTA-Herzschlag; PORTA bekommt eine Rampe.
    sample :bd_haus, rate: 0.68, amp: 0.48
    sleep 2
    sample :bd_haus, rate: 0.68, amp: 0.36
    sleep 2

  elsif t < 32 || (t >= 152 && t < 156)
    # Herzschlag: nur 1 und 3
    sample :bd_haus, rate: 0.72, amp: 1.00
    sleep 2
    sample :bd_haus, rate: 0.72, amp: 0.85
    sleep 2

  else
    kick_amp =
      if t < 56
        1.15
      elsif t < 80
        1.25
      elsif t < 104
        1.42
      elsif t < 144
        1.30
      else
        1.15
      end

    4.times do
      with_fx :distortion, distort: (t >= 84 && t < 104 ? 0.12 : 0.06), mix: 0.15 do
        sample :bd_haus, rate: 0.72, amp: kick_amp
      end
      sleep 1
    end
  end
end

# ============================================================
# HATS -- Offbeat; in PORTA heller (die Tuer ist offen),
# in LUCERNA still, in SEMEN nur noch einzelne.
# ============================================================

live_loop :hats, sync: :puls do
  t = takt
  stop if t >= 160

  if t < 32 || (t >= 104 && t < 120) || t >= 152
    sleep 4

  elsif t >= 144
    # SEMEN -- ausduennen
    sleep 0.5
    sample :drum_cymbal_closed, rate: 0.72, amp: 0.14, release: 0.05
    sleep 1.5
    sleep 0.5
    sample :drum_cymbal_closed, rate: 0.72, amp: 0.12, release: 0.05
    sleep 1.5

  else
    hat_rate = (t >= 120 ? 0.72 : 0.60)
    hat_amp = (t >= 80 && t < 104 ? 0.24 : 0.21)

    4.times do
      sleep 0.5
      sample :drum_cymbal_closed, rate: hat_rate, amp: hat_amp, release: 0.05
      sleep 0.5
    end
  end
end

# ============================================================
# CLAP -- auf 2 und 4, dunkel und verhallt.
# ============================================================

live_loop :clap, sync: :puls do
  t = takt
  stop if t >= 160

  aktiv = (t >= 32 && t < 80) || (t >= 84 && t < 104) || (t >= 120 && t < 152)

  if aktiv
    2.times do
      sleep 1
      with_fx :lpf, cutoff: 80 do
        with_fx :reverb, room: 0.85, mix: 0.40 do
          sample :sn_dolf, rate: 0.55, amp: (t >= 80 && t < 104 ? 0.52 : 0.45)
        end
      end
      sleep 1
    end
  else
    sleep 4
  end
end

# ============================================================
# FUNDAMENT -- der Bass. Solange der Arp unten wohnt, nur
# E-Herzschlag (kein Matsch). In LUCERNA schweigt er ganz --
# die Kammer bleibt Kammer. Erst in SEMEN, wenn Arp und
# Cantus oben sind, bekommt er D und B zurueck.
# ============================================================

live_loop :fundament, sync: :puls do
  t = takt
  stop if t >= 160

  if t < 16 || (t >= 104 && t < 120) || t >= 156
    sleep 4

  else
    use_synth :fm
    use_synth_defaults divisor: 1, depth: 1.6, release: 0.28, cutoff: 72

    voll = (t >= 144)
    bass_amp = (t >= 80 && t < 104 ? 1.0 : 0.85)

    play :e1, amp: bass_amp
    sleep 0.75
    play :e2, amp: bass_amp * 0.55
    sleep 0.25
    sleep 0.5
    play :e1, amp: bass_amp * 0.88
    sleep 0.5
    play (voll ? :d2 : :e1), amp: bass_amp * (voll ? 0.7 : 0.4)
    sleep 0.5
    play :e1, amp: bass_amp * 0.88
    sleep 0.5
    play (voll ? :b1 : :e2), amp: bass_amp * (voll ? 0.7 : 0.5)
    sleep 0.5
    play :e1, amp: bass_amp * 0.8
    sleep 0.5
  end
end

# ============================================================
# SKRIPTORIUM-ARP -- der Bogen als treue Kopierschleife,
# Motor des Tracks. Pro Sektion oeffnet sich der Filter;
# in LUCERNA bleibt er als Einziger uebrig (die Lampe
# flackert im Achtelpuls); in PORTA springt er die Oktave
# hinauf.
# ============================================================

live_loop :skriptorium_arp, sync: :puls do
  t = takt
  stop if t >= 160

  if t < 32
    sleep 4

  else
    oktav = (t >= 120 ? 12 : 0)

    cutoff_level =
      if t < 56
        66
      elsif t < 80
        74
      elsif t < 104
        82
      elsif t < 120
        58
      else
        95
      end

    arp_amp = (t >= 104 && t < 120 ? 0.24 : 0.36)

    use_synth :zawa

    with_fx :lpf, cutoff: cutoff_level do
      with_fx :echo, phase: 0.75, decay: 4, mix: 0.20 do
        arp = (ring :e2, :g2, :b2, :d3, :e3, :d3, :b2, :g2)
        8.times do |i|
          play note(arp[i]) + oktav, release: 0.35, amp: (i.even? ? arp_amp : arp_amp * 0.6)
          sleep 0.5
        end
      end
    end
  end
end

# ============================================================
# CANTUS -- die Mauer. FUNDAMENTA: die Pfeiler | MURI: der
# Bogen waechst additiv, Stein fuer Stein, nichts wird je
# verworfen | SCRIPTORIUM: Vorschreiber und Nachschreiber --
# die treue Kopie | OBSIDIO: unerschuettert, in Quinten
# verdoppelt (dicke Mauern) | LUCERNA: nur der Schlussstein
# glueht | PORTA: der volle Bogen, eine Oktave hoeher.
# ============================================================

live_loop :cantus, sync: :puls do
  t = takt
  stop if t >= 160

  use_synth :hollow

  if t < 16
    sleep 8

  elsif t < 32
    # FUNDAMENTA -- die Pfeiler: E, ab 24 die leere Quinte
    with_fx :lpf, cutoff: 76 do
      with_fx :reverb, room: 0.95, mix: 0.6 do
        play :e2, attack: 1, sustain: 4, release: 3, amp: 0.42
        play :e3, attack: 1.2, sustain: 3.5, release: 3, amp: 0.30
        play :b2, attack: 1.5, sustain: 3.5, release: 3, amp: 0.24 if t >= 24
      end
    end
    sleep 8

  elsif t < 40
    # MURI, Stufe 1 -- die ersten Steine
    with_fx :lpf, cutoff: 80 do
      with_fx :reverb, room: 0.95, mix: 0.6 do
        steine [[:e3, 2], [:g3, 2], [:e3, 4]], 0, 0.42
      end
    end

  elsif t < 48
    # MURI, Stufe 2 -- ein Stein mehr, alle alten bleiben
    with_fx :lpf, cutoff: 82 do
      with_fx :reverb, room: 0.95, mix: 0.58 do
        steine [[:e3, 2], [:g3, 2], [:a3, 2], [:e3, 2]], 0, 0.44
      end
    end

  elsif t < 56
    # MURI, Stufe 3 -- der Bogen schliesst sich fast
    with_fx :lpf, cutoff: 84 do
      with_fx :reverb, room: 0.95, mix: 0.56 do
        steine [[:e3, 1], [:g3, 1], [:a3, 2], [:b3, 2], [:a3, 1], [:e3, 1]], 0, 0.46
      end
    end

  elsif t < 64
    # SCRIPTORIUM -- Phrase A: vorspielen, dann treu nachschreiben
    with_fx :reverb, room: 0.9, mix: 0.5 do
      with_fx :lpf, cutoff: 86 do
        use_synth :blade
        steine ARX_A, 0, 0.40, -0.2
        use_synth :hollow
        steine ARX_A, 0, 0.34, 0.3
      end
    end

  elsif t < 72
    # SCRIPTORIUM -- Phrase B mit dem Schlussstein D
    with_fx :reverb, room: 0.9, mix: 0.5 do
      with_fx :lpf, cutoff: 86 do
        use_synth :blade
        steine ARX_B, 0, 0.42, -0.2
        use_synth :hollow
        steine ARX_B, 0, 0.36, 0.3
      end
    end

  elsif t < 80
    # SCRIPTORIUM -- Phrase A, zweite Abschrift
    with_fx :reverb, room: 0.9, mix: 0.5 do
      with_fx :lpf, cutoff: 86 do
        use_synth :blade
        steine ARX_A, 0, 0.40, -0.2
        use_synth :hollow
        steine ARX_A, 0, 0.34, 0.3
      end
    end

  elsif t < 104
    # OBSIDIO -- unerschuettert: der Bogen in Quinten.
    # Die Melodie stockt NICHT. Kein einziger falscher Ton.
    with_fx :lpf, cutoff: 82 do
      with_fx :reverb, room: 0.9, mix: 0.5 do
        steine ARX_A, 0, 0.44, -0.1, true
      end
    end

  elsif t < 120
    # LUCERNA -- nur der Schlussstein glueht: B - D - B
    with_fx :reverb, room: 1, mix: 0.7 do
      with_fx :lpf, cutoff: 78 do
        steine [[:b3, 2], [:d4, 4], [:b3, 2], [nil, 8]], 0, 0.34
      end
    end

  elsif t < 144
    # PORTA -- die Tuer ist offen: der volle Bogen, oktavhoeher
    with_fx :reverb, room: 0.95, mix: 0.55 do
      with_fx :lpf, cutoff: 96 do
        steine ARX_A, 12, 0.42, -0.08
        steine ARX_B, 12, 0.44, -0.08
      end
    end

  else
    # SEMEN -- der Cantus schweigt: jetzt spricht das Bewahrte
    sleep 4
  end
end

# ============================================================
# SCHREIBSTUBE -- effect_scriptorium (8 Takte, auf dem
# Achtelraster von 118 BPM). Voll im SCRIPTORIUM; in OBSIDIO
# leiser und dumpfer, aber: ES WIRD WEITERGESCHRIEBEN.
# ============================================================

live_loop :schreibstube, sync: :puls do
  t = takt
  stop if t >= 160

  if t >= 56 && t < 80 && t % 8 == 0
    vox "effect_scriptorium", rate: 1.0, amp: 0.62, pan: 0.15

  elsif t >= 80 && t < 104 && t % 8 == 0
    with_fx :lpf, cutoff: 70 do
      vox "effect_scriptorium", rate: 1.0, amp: 0.34, pan: 0.15
    end
  end

  sleep 4
end

# ============================================================
# GLOCKE -- der Schlussstein als Klang: D in LUCERNA,
# E beim Oeffnen der Tuer.
# ============================================================

live_loop :glocke, sync: :puls do
  t = takt
  stop if t >= 160

  use_synth :pretty_bell

  if t == 104
    with_fx :reverb, room: 1, mix: 0.8 do
      play :d4, release: 6, amp: 0.40
      play :d5, release: 5, amp: 0.14
    end

  elsif t == 112
    with_fx :reverb, room: 1, mix: 0.85 do
      play :d4, release: 6, amp: 0.28
    end

  elsif t == 120
    # die Tuer geht auf -- die Glocke schlaegt den Grundton
    with_fx :reverb, room: 1, mix: 0.75 do
      play :e4, release: 7, amp: 0.42
      play :e5, release: 6, amp: 0.12
    end
  end

  sleep 4
end

# ============================================================
# STIMMEN -- von Anfang an menschlich: Drinnen wird nicht
# gespukt. Geister gibt es nur draussen (:belagerung).
# Alle rates <= 0.9. Amps: 0.9-1.0 im vollen Arrangement,
# 0.85 wo die Stimme (fast) allein steht.
#
#   4 ducunt (allein im Wind) | 24 fundamenta iacimus |
#  34+52 lapis super lapidem | 40 murus (6.35 Takte) |
#  64 murus als Diktat (leise: der Text, der kopiert wird) |
#  84+100 murus_kurz | 92 magnos_viros |
# 108 dux_atque_imperator (fast allein) | 122 porta patet |
# 130 exeamus | 146 semen | 156 semen_kurz -- das letzte Wort
# ============================================================

live_loop :stimmen, sync: :puls do
  t = takt
  stop if t >= 160

  case t

  when 4
    # DUCUNT VOLENTEM FATA, NOLENTEM TRAHUNT -- eine Stimme
    # allein im Wind, noch vor der ersten Musik.
    with_fx :lpf, cutoff: 90 do
      with_fx :reverb, room: 0.8, mix: 0.45 do
        vox "vocal_ducunt", rate: 0.9, amp: 0.85, pan: 0
      end
    end

  when 24
    # FUNDAMENTA IACIMUS -- die Stimme benennt, was die Musik
    # gerade tut: die Quinte tritt zum E. Endet ~25.4.
    with_fx :reverb, room: 0.75, mix: 0.35 do
      vox "vocal_fundamenta_iacimus", rate: 0.9, amp: 0.85, pan: 0
    end

  when 34
    # LAPIS SUPER LAPIDEM -- die Abrissformel (Mt 24,2),
    # umgedreht: Hier wird Stein AUF Stein gesetzt.
    with_fx :reverb, room: 0.8, mix: 0.38 do
      vox "vocal_lapis", rate: 0.9, amp: 0.90, pan: -0.15
    end

  when 40
    # PHILOSOPHIA CIRCUMDANDA EST... -- Senecas These, waehrend
    # die Mauern hochgehen. "Multis machinis lassata": die
    # Maschinen von R06 als Belagerungsgeraet, an dem Fortuna
    # scheitert. Endet ~46.4, sicher vor Stufe 3.
    with_fx :lpf, cutoff: 94 do
      with_fx :reverb, room: 0.85, mix: 0.40 do
        vox "vocal_murus", rate: 0.9, amp: 1.00, pan: 0
      end
    end

  when 52
    # LAPIS SUPER LAPIDEM -- noch ein Stein, andere Seite.
    with_fx :reverb, room: 0.8, mix: 0.38 do
      vox "vocal_lapis", rate: 0.9, amp: 0.90, pan: 0.15
    end

  when 64
    # DAS DIKTAT -- der Text, der im Skriptorium abgeschrieben
    # wird, ist Senecas Mauersatz: dieselbe Aufnahme wie bei
    # 40, leise und gefiltert unter dem Arp (endet ~70.7).
    # Genau so hat der Satz die echten 2000 Jahre ueberlebt.
    with_fx :lpf, cutoff: 70 do
      with_fx :reverb, room: 0.9, mix: 0.55 do
        vox "vocal_murus", rate: 0.85, amp: 0.40, pan: 0.35
      end
    end

  when 84
    # MURUS! -- die Antwort der Mauer auf den Ansturm
    # (finish: 0.55 schneidet auf das blosse "Murus!")
    with_fx :reverb, room: 0.7, mix: 0.30 do
      vox "vocal_murus_kurz", rate: 0.9, finish: 0.55, amp: 1.00, pan: 0
    end

  when 92
    # POSSE ETIAM SUB MALIS PRINCIPIBUS MAGNOS VIROS ESSE --
    # die Antwort auf das Obedite ist kein Gegenbefehl,
    # sondern Gelassenheit. Endet ~95.6.
    with_fx :lpf, cutoff: 92 do
      with_fx :reverb, room: 0.75, mix: 0.32 do
        vox "vocal_magnos_viros", rate: 0.9, amp: 1.00, pan: 0
      end
    end

  when 100
    # MURUS INEXPUGNABILIS! -- diesmal ganz
    with_fx :reverb, room: 0.7, mix: 0.30 do
      vox "vocal_murus_kurz", rate: 0.9, amp: 0.95, pan: 0
    end

  when 108
    # DUX ATQUE IMPERATOR VITAE MORTALIUM ANIMUS EST --
    # die Lampe. Fast trocken, in voelliger Stille (der
    # Herzschlag antwortet erst bei 112). Endet ~111.4.
    with_fx :reverb, room: 0.5, mix: 0.15 do
      vox "vocal_dux_atque_imperator", rate: 0.9, amp: 0.85, pan: 0
    end

  when 122
    # PORTA PATET -- eine Feststellung, fast unglaeubig.
    with_fx :reverb, room: 0.9, mix: 0.45 do
      vox "vocal_porta_patet", rate: 0.9, amp: 0.90, pan: 0
    end

  when 130
    # EXEAMUS -- kein Befehl (das war die Sprache der
    # Maschine): eine Einladung, Wir-Form.
    with_fx :reverb, room: 0.85, mix: 0.40 do
      vox "vocal_exeamus", rate: 0.9, amp: 0.95, pan: 0
    end

  when 146
    # QUOD DESCRIPSIMUS, NON PERIBIT. QUOD SERVAVIMUS, SEMEN
    # EST. -- die Einloesung von "Sed meminimus". Endet ~150.5.
    with_fx :reverb, room: 0.55, mix: 0.18 do
      vox "vocal_semen", rate: 0.9, amp: 0.95, pan: 0
    end

  when 156
    # SEMEN. -- das letzte gesprochene Wort, fast allein.
    with_fx :reverb, room: 0.7, mix: 0.30 do
      vox "vocal_semen_kurz", rate: 0.9, amp: 0.85, pan: 0
    end
  end

  sleep 4
end

# ============================================================
# SAAT -- das Melodie-Skelett aus Fragor Noctis, in die
# eigene Tonart abgeschrieben: B - A - G - F#. Dort verweigerte
# es die Aufloesung; hier, als treue Kopie im neuen Zuhause,
# findet es zum ersten Mal Grund: E.
# ============================================================

live_loop :saat, sync: :puls do
  t = takt
  stop if t >= 160

  if t == 152
    use_synth :hollow

    with_fx :reverb, room: 0.95, mix: 0.6 do
      with_fx :lpf, cutoff: 90 do
        play :b3, attack: 0.3, release: 3, amp: 0.44
        play :b2, attack: 0.4, release: 3, amp: 0.20
        sleep 2
        play :a3, attack: 0.3, release: 3, amp: 0.42
        sleep 2
        play :g3, attack: 0.3, release: 3, amp: 0.40
        sleep 2
        play :fs3, attack: 0.3, release: 3, amp: 0.38
        sleep 2
        play :e3, attack: 0.5, sustain: 3, release: 9, amp: 0.46
        play :e2, attack: 0.6, sustain: 3, release: 10, amp: 0.26
        sleep 8
      end
    end
  else
    sleep 4
  end
end

# ============================================================
# FINALE -- das E kommt zur Ruhe. Zum ersten Mal im Projekt
# hat der Grundton ein Fundament unter sich.
# ============================================================

live_loop :finale, sync: :puls do
  t = takt
  stop if t >= 160

  if t == 157
    use_synth :dark_ambience

    with_fx :reverb, room: 1, mix: 0.8 do
      with_fx :lpf, cutoff: 64 do
        play :e1, attack: 1.5, sustain: 4, release: 14, amp: 0.40
        play :e2, attack: 1.2, sustain: 4, release: 12, amp: 0.30
        play :b2, attack: 2, sustain: 3, release: 12, amp: 0.14
        # Dur-Terz-Option ("der Spalt Licht unter der Tuer"):
        # play :gs3, attack: 2.5, sustain: 3, release: 12, amp: 0.10
      end
    end
  end

  sleep 4
end