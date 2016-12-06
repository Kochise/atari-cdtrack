# cdtrack

Atari program to transform a Falcon030 into a jukebox

* Hardware and software needed

You need the following to get this program working :

\- Atari Falcon030 (original or upgraded)<br>
\- MetaDOS or CDTools, CD driver software<br>
\- CD drive attached on IDE or SCSI port<br>

* List of programs

\- CDTRACK.PRG : original version, just play CD tracks<br>
\- CDTRACK1.PRG : first DSP version, adds support for some effects, load LOD file from disk<br>
\- CDTRACK2.PRG : second DSP version, integrates the LOD file into the program<br>
\- TESTHOST.PRG : test the DSP HOST port to send commands to control the DSP effects<br>
\- UNLOCK.PRG : sometimes the DSP refuse to load a new program, this solves the issue<br>
\- VIDELCUT.PRG : switch the screen off and control the CD and DSP previously loaded<br>
\- AFM.LOD : hexadecimal version of the DSP program<br>
\- AFM.P56 : binary version of the DSP program (for a different loading methodology)<br>
\- \\AFM-HACK : source code of the DSP program, some hacks and tricks<br>
\- \\CDUSE : MetaDOS SDK to control the CD drive (remember Adaptec's ASPI ? This is the same)<br>

* How to use it

Launch the 'CDTRACK2.PRG' program with a music CD inside the drive. If the CD contains data tracks, selecting them will result with no effect.

By default the program set the DSP and launch track 1 then exit.

If you hold [L-Shift] down, nothing happens and the program exit (nice for the AUTO sequence).
 
If you hold [Control] down, you can... control the program.

"   F1 -> F10 : Track 1 - 10"<br>
" + [Shift]   : +10"<br>
" + [Control] : +20"<br>
"   [*]       : Mute"<br>
"   [-]       : Volume Down"<br>
"   [+]       : Volume Up"<br>
" ->[Esc]     : Exit"<br>

The DSP equilizer is set automatically to a predefined level that suited my taste (see 'EqualizerTable' in the source code). After all it was not supposed to replace the full blown 'Audio Fun Machine' DSP demo bundled with every Falcon030.

If you then launch the 'VIDELCUT.PRG' program, it will zero the Videl GPU clock and switch off EnergyStar compatible screens that will turn into powersaving mode (orange led). You can control the program with the same shortcuts, turning the Falcon030 into a simple CD player with DSP effect. Exit by pressing the [Esc] key and the Videl clock is restored before returning to the desktop.

* Some infos

This is some legacy hacking into Motorola 56001 DSP assembly featured in the Atari Falcon030. That was rather fun to hack at that time.

If some characters doesn't display well on Windows, Mac or Linux, that's because the charset Atari used for accented characters was not ANSI compatible, hence the code is different and is not the one intended.
