# Johann van Staal

Music composed and performed as code, using [Sonic Pi](https://sonic-pi.net).
These tracks explore what happens when the old world's dead languages meet
the dancefloor — **Crypt House**: Latin voices, bells, crows, rain and
sirens over trance, house and witch-house grooves.

Each track is a single, self-contained `.rb` file. It plays the entire
arrangement from the first gust of wind to the final resting note and
stops by itself.

This repository contains **"Arx Interior"**, Song 2 of a
pair. *Concordia/Discordia* (R07) asked what a single person can do to
defend a republic - the defence. This track asks what they do when the
defence has failed - the preparation. The answers come from those who
actually lived through the fall: the Stoics under Nero, Tacitus under
Domitian, the copyists of the fifth and sixth centuries. And history's
verdict frames the pair: the defence failed, the preparation worked —
what the scribes saved came back through the monasteries and became
the Renaissance.

## Tracks

- **`arx_interior.rb` — "Arx Interior"** ("the inner fortress") — Crypt
  House, 118 BPM, E minor, ~5:40. The track is the building of a
  fortress while the world of the previous releases collapses outside.
  It opens with nothing but wind through an empty street; a lone voice
  speaks Seneca's *Ducunt volentem fata, nolentem trahunt* before a
  single note has sounded, and the music enters halfway through the
  wind. Outside stays outside for the whole piece: the marching boots
  and the barked commands of *Fragor Noctis (Ferrum et Ordo Mix)*
  return low-pass-filtered into weather — what was once an order is
  now just wind against the walls. Inside, everything is built from a
  six-note vocabulary (E, F#, G, A, B, D — no C) from which **no
  tritone can be formed**: the diabolus in musica that poisoned the
  two previous releases is structurally impossible here. The melody is
  an arch — equal stones up and down, and its keystone is a doubled D:
  the very note Concordia/Discordia chose as its resolution now bears
  the vault. An eighth-note arpeggio — the same arch as a faithful
  copying loop — drives the track like a scriptorium: the same motoric
  gesture as the machine of Fragor Noctis, turned to the opposite
  purpose, complete with a quill scratching on parchment in time with
  the grid. The walls rise stone by stone (each phrase repeats
  everything already built and adds one note — the inversion of Fama
  Volat, where every copy was a mutation), a second voice copies the
  theme faithfully, and when the siege comes, the melody does not
  stagger: for the first time on this label, a melody survives its
  track uncorrupted. At the innermost point everything stops except a
  low flickering arpeggio — the lamp — and Sallust's line returns from
  R07, almost dry: *Dux atque imperator vitae mortalium animus est.*
  Then a heartbeat, lower and softer than any other drum in the piece:
  the pulse that remains when everything stands still is your own.
  The door opens — *Porta patet* — the whole music steps up an octave
  into the open, and in the final section the bass regains its motion
  and the melodic skeleton of Fragor Noctis (A–G–F–E, the descent that
  refused resolution forever) is planted, copied into the new key as
  B–A–G–F# — and finds ground for the first time: E. The crow that has
  haunted every release appears twice: darkened among the ruins at the
  start, and unprocessed in the open near the end — when nothing out
  there threatens any more, it is just a bird. The last spoken word is
  *Semen* — seed — and the final E is, for the first time in this
  project, a home note with a foundation under it.

## Requirements

- **Sonic Pi v4 or later** — free, available for macOS, Windows and Linux
  at [sonic-pi.net](https://sonic-pi.net). No other software is needed.
- The **sample files** (`*.wav`) from this repository, stored on your
  local machine in one folder.

## Setup

1. **Clone or download this repository** to your computer.

2. **Keep the track's `.wav` files together in one local folder.**
   The track loads them from disk at startup. Loading is tolerant: a
   missing file is logged as `NOCH NICHT DA` and its slot is simply
   skipped when the bar comes (`VOX FEHLT`), so the piece plays even
   with an incomplete sample set. Four of the samples are shared with
   earlier releases (see below) — copy them into the same folder.

   > ⚠️ If you store the folder in a cloud-synced location (iCloud
   > Drive, OneDrive, Dropbox), make sure the files are *actually
   > downloaded* and not just cloud placeholders. On macOS: right-click
   > the folder → *"Keep Downloaded"*. A track that hangs silently at
   > startup is almost always a sample file that the cloud has offloaded.

3. **Set your local path.** Near the top of the file you will find:

   ```ruby
   define :pfad do |name|
     "... insert local path name here ..." + name + ".wav"
   end
   ```

   Replace the placeholder with the absolute path to your sample folder,
   **written as a single line** and **ending with a trailing `/`**. On
   startup the log prints a `PFAD-TEST:` line with the full path the
   track has built — if every file is reported missing, compare that
   line character by character with the real location of your folder.

4. **Run the track as a file — do not paste it into a buffer.**
   Sonic Pi's editor is limited to roughly 10,000 characters per buffer;
   this track is far beyond that size. Put a single line into an empty
   buffer and press *Run*:

   ```ruby
   run_file "/path/to/your/folder/arx_interior.rb"
   ```

   Press *Stop* to end playback at any time — and always press *Stop*
   before re-running, otherwise loops from the previous run keep going
   and you hear doubled material.

## Samples

```
vocal_ducunt.wav                vocal_fundamenta_iacimus.wav
vocal_lapis.wav                 vocal_murus.wav
vocal_murus_kurz.wav            vocal_magnos_viros.wav
vocal_dux_atque_imperator.wav   vocal_porta_patet.wav
vocal_exeamus.wav               vocal_semen.wav
vocal_semen_kurz.wav
effect_wind_street.wav          effect_scriptorium.wav

Shared with earlier releases (copy into this folder):
effect_marching_boots.wav       effect_craw.wav
vocal_obedite.wav               vocal_procedite.wav
```

Voice recordings by Johann van Staal. `effect_wind_street.wav` (wind
through an empty street — gusts, whistling edges, a rattling sign,
canyon reflections) and `effect_scriptorium.wav` (a quill on parchment,
its strokes locked to the eighth-note grid at 118 BPM) were synthesized
for this release. `effect_marching_boots.wav` was synthesized for R06
and is re-pitched here from its 126 BPM grid (rate 118/126). The crow
comes from a free sample library; see its source for license details.
The siege voices are the R06 command recordings — a release besieged
by its own back catalogue.

## The Latin texts

All spoken samples are transcribed in **`arx_interior_texte.txt`**,
with translations, sources and context. Inside the walls, the voices
are human from the first word — the ghosts are all outside:

- **Seneca, *Epistulae morales* 107,11** — *Ducunt volentem fata,
  nolentem trahunt*: fate leads the willing and drags the unwilling.
  Spoken alone in the wind, before any music.
- **Seneca, *Epistulae morales* 82,5** — *Philosophia circumdanda est,
  inexpugnabilis murus…*: build philosophy around you, an impregnable
  wall that Fortune, wearied by many siege engines, cannot cross. The
  track's thesis — and the text that its own scriptorium later copies.
- **Tacitus, *Agricola* 42** — *posse etiam sub malis principibus
  magnos viros esse*: there can be great men even under bad rulers.
  Spoken calmly in the middle of the siege.
- **Sallust, *Bellum Iugurthinum* 1,3** — *Dux atque imperator vitae
  mortalium animus est*: the mind is the leader and commander of life.
  The line that explained the decision in R07 returns as the lamp.
- **Original formulas by Johann van Staal** — *Fundamenta iacimus*
  (we lay the foundations), *Lapis super lapidem* (stone upon stone —
  the famous demolition prophecy reversed into a building formula),
  *Porta patet* (the door stands open), *Exeamus* (let us go out —
  a plural invitation, not a command), and the closing original text:
  *Quod descripsimus, non peribit. Quod servavimus, semen est.* —
  what we have copied will not perish; what we have preserved is seed.

## Troubleshooting

- **Every file is reported `NOCH NICHT DA`** — the path definition does
  not point at your sample folder. Compare the `PFAD-TEST:` log line
  with the real path.
- **A voice is loaded but never plays** — check the log: the track
  prints a `VOX SPIELT:` line for every vocal event. If the line
  appears but you hear nothing, Sonic Pi is serving an old cached
  version of the sample: run `sample_free_all` once in an empty buffer
  (or restart Sonic Pi), then start the track again.
- **The opening seems silent** — the first bar is empty by design
  (events on bar 0 are unreliable in this architecture); the street
  wind enters at bar 1 and the first drone at bar 8.
- **Samples or melodies sound doubled** — loops from a previous run are
  still alive. Press *Stop*, then *Run*.
- **The editor refuses to accept new lines** — you have hit the ~10,000
  character buffer limit. Edit the `.rb` file in an external editor and
  use `run_file` as described above.
