(

Pdef(\sine).stop;
Pdef(\pulse).stop;

~currentDocPath="/Users/koutarofukui/Dropbox/Application/SC related files/Piece/Era/";
(~currentDocPath++"Era_Instrument.scd").load;
(~currentDocPath++"Era_Setting.scd").load;

~tempoClock = TempoClock(70/60);

a = [108,115,108].scramble;
b = [0.125,0.25, 0.5,1].scramble;

~freq_seq = Pxrand(a, inf);
~dur_seq = Pxrand([Pn(0.125, 6), Pseq([0.125, 0.25, 0.5, 0.125], 1),Pseq([0.125, 0.25, 0.25, 0.125], 1)], inf);
~freq_seqStream = ~freq_seq.asStream;
~dur_seqStream = ~dur_seq.asStream;

Pdef(\sine, Pbind(
	\instrument, \sin,
	\freq, Pfunc({~freqData = ~freq_seqStream.next; }),
	\dur, Pfunc({~durData = ~dur_seqStream.next; }),
	\sustain, Pkey(\dur)/1.5,
	\OSC_Sender, Pfunc({m.sendMsg("/event", ~freqData , ~durData);})
)).play(~tempoClock);

Pdef(\pulse, Pbind(
	\instrument, \puls,
	\freq, Pfunc({~freqData = ~freq_seqStream.next -48; }),
	\dur, Pfunc({~durData = ~dur_seqStream.next; }),
	\sustain, Pkey(\dur)/1.5,
	//\OSC_Sender, Pfunc({m.sendMsg("/event", ~freqData , ~durData);})
)).play(~tempoClock);

)



