(
//ProxySpace.push(s);
var countNum, measureSelectNum;

// init var
measureSelectNum = 0;


//loading files
~currentDocPath = "/Users/koutarofukui/Dropbox/Application/SC related files/Piece/Era/";
(~currentDocPath++"Era_Instrument.scd").load;
(~currentDocPath++"Era_Setting.scd").load;

~tempoClock = TempoClock(70/60);

~sine_freqSeqStream = Pxrand([108,115,108], inf).asStream;
~sine_durSeqStream = Pxrand([Pn(0.125, 6), Pseq([0.125, 0.25, 0.5, 0.125], 1),Pseq([0.125, 0.25, 0.25, 0.125], 1)], inf).asStream;
~click_durSeqStream =	Prand([0.5,Pn(0.25,4)],inf);


Pdef(\sine, Pbind(
	\instrument, \sin,
	\freq, Pfunc({~sine_freqData = ~sine_freqSeqStream.next; }),
	\dur, Pfunc({~sine_durData = ~sine_durSeqStream.next; }),
	\sustain, Pkey(\dur)/1.5,
	\OSC_Sender, Pfunc({m.sendMsg("/event", ~sine_freqData , ~sine_durData);})
));

Pdef(\pulse, Pbind(
	\instrument, \puls,
	\freq, Pfunc({~pulse_freqData}),
	\dur, Pfunc({~pulse_durData}),
	\sustain, Pkey(\dur)/1.5,
	\OSC_Sender, Pfunc({m.sendMsg("/event", ~pulse_freqData , ~pulse_durData);})
));



Task({
	inf.do({
	|i|
		//measureSelectNum = i;
		countNum = i % 16; // time measure

		//Print"count"&"measure"
		if(countNum == 0,
			{
				("measure : "++ measureSelectNum).postln;
				measureSelectNum = measureSelectNum  + 1;
			}
		);

		("count : "++ countNum).postln;

		if(measureSelectNum ==1 && countNum == 0, {

			Pdef(\pulse).play(~tempoClock);
			Pdef(\sine).play(~tempoClock);
		});

		if(measureSelectNum ==3 && countNum == 0, {

			Pdef(\sine).stop;
			~dur_seq = Pseq([4],1);
			~sine_durSeqStream = ~dur_seq.asStream;
			Pdef(\sine, Pbind(
				\instrument, \sin,
				\freq, Pfunc({~sine_freqData = ~sine_freqSeqStream.next; }),
				\dur, Pfunc({~sine_durData = ~sine_durSeqStream.next; }),
				\sustain, Pkey(\dur)/1.125,
				\OSC_Sender, Pfunc({m.sendMsg("/event", ~sine_freqData , ~sine_durData);})
			)).play(~tempoClock);

			}
		);

		if(measureSelectNum ==3 && countNum == 4, {

			Pdef(\sine).stop;
			~dur_seq = Pxrand([Pn(0.125, 6), Pseq([0.125, 0.25, 0.5, 0.125], 1),Pseq([0.125, 0.25, 0.25, 0.125], 1)], inf);
			~sine_durSeqStream = ~dur_seq.asStream;
			Pdef(\sine, Pbind(
				\instrument, \sin,
				\freq, Pfunc({~sine_freqData = ~sine_freqSeqStream.next; }),
				\dur, Pfunc({~sine_durData = ~sine_durSeqStream.next; }),
				\sustain, Pkey(\dur)/1.5,
				\OSC_Sender, Pfunc({m.sendMsg("/event", ~sine_freqData , ~sine_durData);})
			)).play(~tempoClock);

			}
		);


		if(measureSelectNum ==4 && countNum == 0, {

			Pdef(\sine).stop;
			~dur_seq = Pxrand([Pn(0.125, 6), Pseq([0.125, 0.25, 0.5, 0.125], 1),Pseq([0.125, 0.25, 0.25, 0.125], 1)], inf);
			~sine_durSeqStream = ~dur_seq.asStream;
			Pdef(\sine, Pbind(
				\instrument, \sin,
				\freq, Pfunc({~sine_freqData = ~sine_freqSeqStream.next; }),
				\dur, Pfunc({~sine_durData = ~sine_durSeqStream.next; }),
				\sustain, Pkey(\dur)/1.5,
				\OSC_Sender, Pfunc({m.sendMsg("/event", ~sine_freqData , ~sine_durData);})
			)).play(~tempoClock);
			//Click Start
			Pdef(\snare,
				Pbind(\instrument,\click,
					\room,0.25,
					\dur,Pfunc({~click_durData = ~click_durSeqStream.next/2; }),
					\gate,1,
					\amp,Prand([0.5,0.25,0.125],inf)/2,
					\sustain,Pkey(\dur)-(Pkey(\dur)/1.5)
				).play(~tempoClock);
			);
		});




		1.wait;
	})
}).play(~tempoClock)

)



