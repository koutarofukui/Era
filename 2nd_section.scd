(

var countNum, measureSelectNum;
var set_1,set_2,set_3, set_4, set_5, set_6 ,set_7,set_8, set_9, set_10;
		set_1 = 0.125;
		set_2 = set_1 + set_1;
		set_3 = set_1 + set_2;
		set_4 = set_2;
		set_5 = set_4+set_4;
		set_6 = set_4+set_5;// set_6 = set_1 + set_2 + set_3

measureSelectNum = 0;
countNum = 0;


~second_section_Task =
Task({

	inf.do({
		|i|

		//measureSelectNum = i;
		countNum = i % 8; // time measure


		//Print"count"&"measure"
		if(countNum == 0,
			{
				measureSelectNum = measureSelectNum  + 1;
				("measure : "++ measureSelectNum).postln;

			}
		);

		//if(measureSelectNum <= 193 && countNum == 0, m.sendMsg("/event/reset", 1));

		("count : "++ countNum).postln;

//55
		////////////////////////////////////////////////////////////////////////////////////////////
		if(measureSelectNum == 1 && countNum == 0, {

			Pdef(\kick,
				Pbind(\instrument, \kick,
					\out, 0,
					\dur, Pfunc({~kick_durData = ~kick_durSeqStream.next}),
					\amp,0.5,

					\OSC_Sender, Pfunc({m.sendMsg("/event/kick", ~kick_durData);})
				)
			).play(~tempoClock);
			//henonC Start
			Pdef(\henonC,
				Pbind(
					\instrument, \henonC,
					\freq, Pfunc({84}),
					\param_a, Pxrand([1, 0.5, 0.25, 2],inf),
					\param_b, Pxrand([0.25, 2, 0.5, 1],inf),
					\amp, Prand([0.75,0.5,0.25],inf)/4,
					\dur, Pfunc({~henonC_durData = ~kick_durData }),
					\sustain, Pkey(\dur)-(Pkey(\dur)*0.25),
					\OSC_Sender, Pfunc({m.sendMsg("/event/sine",  ~henonC_durData);})
				)
			).play(~tempoClock);


		});
		if(measureSelectNum == 8 && countNum == 4, {
			Pdef(\kick,
				Pbind(\instrument, \kick,
					\out, 0,
					\dur, Pfunc({~kick_durData = ~kick_durSeqStream.next}),
					\amp,0,

					\OSC_Sender, Pfunc({m.sendMsg("/event/kick", ~kick_durData);})
				)
			);

		});

		if(measureSelectNum == 9 && countNum == 0, {
			Pdef(\kick).stop;
			//henonC change pitch
			Pdef(\henonC,
				Pbind(
					\instrument, \henonC,
					\freq, Pfunc({96}),
					\param_a, Pxrand([0.25, 0.5, 0.25, 2],inf),
					\param_b, Pxrand([0.5, 1, 0.75, 0.5],inf),
					\amp, Prand([0.75,0.5,0.25],inf)/4,
					\dur, Pfunc({~henonC_durData = ~kick_durSeqStream.next }),
					\sustain, Pkey(\dur)-(Pkey(\dur)*0.25),
					\OSC_Sender, Pfunc({m.sendMsg("/event/henonC", ~henonC_durData);})
				)
			).play(~tempoClock);

			~sineBass_durSeqStream = Pseq([0.75, 0.75, 0.75, 1.5, 0.25], inf).asStream;

			Pdef(\sineBass,
				Pbind(\instrument, \sin,
					\freq, 31,
					\dur, Pfunc({~sineBass_durData = ~sineBass_durSeqStream.next}),
					\amp, Pfunc({if(~sineBass_durData ==1.5, 0, 0.5)}),
					\sustain, Pkey(\dur)*0.75,
					\OSC_Sender, Pfunc({m.sendMsg("/event/sineBass", ~sineBass_durData);})
				)
			).play(~tempoClock);

			Pdef(\kick,
				Pbind(\instrument, \kick,
					\dur, Pfunc({~sineBass_durData}),
					\amp,0.5,

					\OSC_Sender, Pfunc({m.sendMsg("/event/kick", ~sineBass_durData);})
				)
			).play(~tempoClock);

		});
		if(measureSelectNum == 12 && countNum == 6, {

			Pdef(\kick).stop;
			Pdef(\henonC).stop;
			Pdef(\sineBass).stop;
			Pdef(\noise_inst,
				Pbind(
					\instrument, \noise,
					\sampleRate, 0.5,
					\atk, 0,
					\rel, 0,
					\amp, 0.15,
					\dur, 2,
					\sustain, Pkey(\dur)/1.5
				)
			).play(~tempoClock);
			Pdef(\kick,
				Pbind(\instrument, \kick,
					\dur, 1/4,
					\amp,Pseq([Pn(0,4), Pn(0.5, 4)],1),

					\OSC_Sender, Pfunc({m.sendMsg("/event/kick", ~sineBass_durData);})
				)
			).play(~tempoClock);

		});
		if(measureSelectNum == 13 && countNum == 0, {
			Pdef(\kick).stop;
			Pdef(\noise_inst).stop;
			//henonC change pitch
			Pdef(\henonC,
				Pbind(
					\instrument, \henonC,
					\freq, Pfunc({96}),
					\param_a, Pxrand([0.25, 0.5, 0.25, 2],inf),
					\param_b, Pxrand([0.5, 1, 0.75, 0.5],inf),
					\amp, Prand([0.75,0.5,0.25],inf)/4,
					\dur, Pfunc({~henonC_durData = ~kick_durSeqStream.next }),
					\sustain, Pkey(\dur)-(Pkey(\dur)*0.25),
					\OSC_Sender, Pfunc({m.sendMsg("/event/henonC", ~henonC_durData);})
				)
			).play(~tempoClock);

			~sineBass_durSeqStream = Pseq([0.75, 0.75, 0.75, 1.5, 0.25], inf).asStream;

			Pdef(\sineBass,
				Pbind(\instrument, \sin,
					\freq, 31,
					\dur, Pfunc({~sineBass_durData = ~sineBass_durSeqStream.next}),
					\amp, Pfunc({if(~sineBass_durData ==1.5, 0, 0.5)}),
					\sustain, Pkey(\dur)*0.75,
					\OSC_Sender, Pfunc({m.sendMsg("/event/sineBass", ~sineBass_durData);})
				)
			).play(~tempoClock);

			Pdef(\kick,
				Pbind(\instrument, \kick,
					\dur, Pfunc({~sineBass_durData}),
					\amp,0.5,

					\OSC_Sender, Pfunc({m.sendMsg("/event/kick", ~sineBass_durData);})
				)
			).play(~tempoClock);

		});

		if(measureSelectNum == 16 && countNum == 6, {

			Pdef(\kick).stop;
			Pdef(\noise_inst,
				Pbind(
					\instrument, \noise,
					\sampleRate, 0.5,
					\atk, 0,
					\rel, 0,
					\amp, Pseq([Pn(0,12),Pn(0.125, 4)],1),
					\dur, 1/8,
					\sustain, Pkey(\dur)/1.5
				)
			).play(~tempoClock);

		});

		if(measureSelectNum == 17 && countNum == 0, {
			Pdef(\noise_inst).stop;
			Pdef(\kick,
				Pbind(\instrument, \kick,
					\dur, Pfunc({~sineBass_durData}),
					\amp,0.5,

					\OSC_Sender, Pfunc({m.sendMsg("/event/kick", ~sineBass_durData);})
				)
			).play(~tempoClock);

			Pdef(\henonC,
				Pbind(
					\instrument, \henonC,
					\freq, Pfunc({96}),
					\param_a, Pxrand([0.25, 0.5, 0.25, 2],inf),
					\param_b, Pxrand([0.5, 1, 0.75, 0.5],inf),
					\amp, Prand([0.75,0.5,0.25],inf)/4,
					\dur, Pfunc({~henonC_durData = ~kick_durSeqStream.next }),
					\sustain, Pkey(\dur)-(Pkey(\dur)*0.25),
					\OSC_Sender, Pfunc({m.sendMsg("/event/henonC", ~henonC_durData);})
				)
			).play(~tempoClock);
			~sineBass_durSeqStream = Pseq(
				[
					Pseq([0.75, 0.75, 0.75, 1.5, 0.25], 1),
					Prand([
						Pseq([0.75, 0.75, 0.75, Pn(0.25, 7)], 1),
						Pseq([0.75, 0.75, Pn(0.25, 2), 0.75, Pn(0.25, 5)], 1)
					],1)
			], inf).asStream;

			Pdef(\sineBass,
				Pbind(\instrument, \sin,
					\freq, 31,
					\dur, Pfunc({~sineBass_durData = ~sineBass_durSeqStream.next}),
					\amp, Pfunc({if(~sineBass_durData ==1.5, 0, 0.5)}),
					\sustain, Pkey(\dur)*if(~sineBass_durData <=0.25, 0.5, 0.75),
					\OSC_Sender, Pfunc({m.sendMsg("/event/sineBass", ~sineBass_durData);})
				)
			);

			~click_durSeqStream = Prand([Pn(0.25, Prand([2, 4], 1)),Pn(0.125,Prand([2, 4], 1))],inf).asStream;

			Pdef(\snare_2,
				Pbind(\instrument,\click_2,
					\out, 0,
					\room,Pxrand([0.125,0.25, 0.5, 0.75],inf),
					\dur,Pfunc({~click_durData = ~click_durSeqStream.next; }),
					\gate,1,
					\amp,Prand([0.75,0.5,0.25],inf),
					\sustain,Pkey(\dur)-(Pkey(\dur)/1.5),
					\OSC_Sender, Pfunc({m.sendMsg("/event/click", ~click_durData);})
			)).play(~tempoClock);

		});


		if(measureSelectNum == 24 && countNum == 4, {

			Pdef(\kick).stop;
			Pdef(\noise_inst,
				Pbind(
					\instrument, \noise,
					\sampleRate, 0.5,
					\atk, 0,
					\rel, 0,
					\amp, Pseq([Pn(0,12),Pn(0.125, 4)],inf),
					\dur, Pn(1/8, 16),
					\sustain, Pkey(\dur)/1.5
				)
			).play(~tempoClock);

		});

		if(measureSelectNum == 25 && countNum == 0, {
			Pdef(\noise_inst).stop;
			~sineBass_durSeqStream =Prand(
				[
					Pseq([0.75, 0.75, 0.75, Pn(0.25, 7)], 1),
					Pseq([0.75, 0.75, Pn(0.25, 2), 0.75, Pn(0.25, 5)], 1)
				]
				,inf).asStream;

			Pdef(\sineBass,
				Pbind(\instrument, \sin,
					\freq, 31,
					\dur, Pfunc({~sineBass_durData = ~sineBass_durSeqStream.next}),
					\amp, Pfunc({if(~sineBass_durData <= 0.25, 0.25, 0.5)}),
					\sustain, Pkey(\dur)*0.5,
					\OSC_Sender, Pfunc({m.sendMsg("/event/sineBass", ~sineBass_durData);})
				)
			);
			Pdef(\henonC,
				Pbind(
					\instrument, \henonC,
					\freq, Pfunc({84}),
					\param_a, Pxrand([1, 0.5, 0.25, 2],inf),
					\param_b, Pxrand([0.25, 2, 0.5, 1],inf),
					\amp, Prand([0.75,0.5,0.25],inf)/4,
					\dur, Pfunc({~henonC_durData = ~kick_durData }),
					\sustain, Pkey(\dur)-(Pkey(\dur)*0.25),
					\OSC_Sender, Pfunc({m.sendMsg("/event/henonC", ~henonC_durData);})
				)
			);
			Pdef(\kick,
				Pbind(\instrument, \kick,
					\out, 0,
					\dur, Pfunc({~kick_durData = ~kick_durSeqStream.next}),
					\amp,0.5,

					\OSC_Sender, Pfunc({m.sendMsg("/event/kick", ~kick_durData);})
				)
			).play(~tempoClock);

			Pdef(\noise_inst,
				Pbind(
					\instrument, \noise,
					\sampleRate, 0.5,
					\atk, 0,
					\rel, 0,
					\amp, Prand([Pseq([0, 0.125,0,Pn(0.125, 4)],1), Pseq([0, 0,0,Pn(0.125, 4)],1)],inf),
					\dur, Pseq([1.5, 1.5, 4.5, Pn(1/8, 4)],inf),
					\sustain, Pkey(\dur)/1.5
				)
			).play(~tempoClock);


		});

		if(measureSelectNum == 34 && countNum == 0, {

			Pdef(\logisticMap_Synth,
				Pbind(\instrument, \logisticMap_Synth,
					\out, 0,
					\rel, 3,
					\chaos,3.99,
					\logiFreq, Pxrand([1000, 750, 2000, 400, 200],inf),
					\dur, 8,
					\sustain, Pkey(\dur)-2,
					\amp, 0.125/4
				)
			).play(~tempoClock);

			Pdef(\sine, Pbind(
				\instrument, \saw,
				\out, [0, 33],
				\freq, 108,
				\dur, 16,
				\sustain, 0.125/2,
				\amp,0.25,
				\panPos, 0,
				\OSC_Sender, Pfunc({m.sendMsg("/event/sine", ~sine_durData);})
			)).play(~tempoClock);

		});
		if(measureSelectNum == 41 && countNum == 0, {


			~sineBass_durSeqStream =Prand(
				[
					Pseq([0.75, 0.75, 0.75, Pn(0.25, 7)], 1),
					Pseq([0.75, 0.75, 0.75, 0.75, Pn(0.25, 4)], 1),
					Pseq([0.75, 0.75, Pn(0.25, 2), 0.75, Pn(0.25, 5)], 1)
				],
				inf).asStream;

			Pdef(\sineBass,
				Pbind(\instrument, \sin,

					\freq, 31,
					\dur, Pfunc({~sineBass_durData = ~sineBass_durSeqStream.next}),
					\amp, Pfunc({if(~sineBass_durData <= 0.25, 0.25, 0.5)}),
					\sustain, Pkey(\dur)*0.5,
					\OSC_Sender, Pfunc({m.sendMsg("/event/sineBass", ~sineBass_durData);})
				)
			);

		});

		if(measureSelectNum == 49 && countNum == 0, {
			Pdef(\logisticMap_Synth).stop;
			Pdef(\snare_2).stop;
			Pdef(\henonC,
				Pbind(
					\instrument, \henonC,
					\freq, Pfunc({84}),
					\param_a, Pxrand([1, 0.5, 0.25, 2],inf),
					\param_b, Pxrand([0.25, 2, 0.5, 1],inf),
					\amp, 0,
					\dur, Pfunc({~henonC_durData = ~kick_durData }),
					\sustain, Pkey(\dur)-(Pkey(\dur)*0.25),
					\OSC_Sender, Pfunc({m.sendMsg("/event/henonC", ~henonC_durData);})
				)
			);
			~sineBass_durSeqStream = Pxrand(
				[
					Pseq([0.75, 0.75, 0.75, Pn(0.25, 7)], 1),
					Pseq([0.75, 0.75, 0.75, 0.75, Pn(0.25, 4)], 1),
					Pseq([0.75, 0.75, Pn(0.25, 2), 0.75, Pn(0.25, 5)], 1)
				]
				,inf).asStream;

			Pdef(\sineBass,
				Pbind(\instrument, \sin,
					\out, 0,
					\freq, 31,
					\dur, Pfunc({~sineBass_durData = ~sineBass_durSeqStream.next}),
					\amp, Pfunc({if(~sineBass_durData <= 0.125, 0.25, 0.5)}),
					\sustain, Pkey(\dur)*0.5,
					\OSC_Sender, Pfunc({m.sendMsg("/event/sineBass", ~sineBass_durData);})
				)
			);

			Pdef(\kick,
				Pbind(\instrument, \kick,
					\out, 0,
					\dur, Pfunc({~sineBass_durData}),
					\amp,0.5,

					\OSC_Sender, Pfunc({m.sendMsg("/event/kick", ~sineBass_durData);})
				)
			).play(~tempoClock);
			Pdef(\noise_inst,
				Pbind(
					\instrument, \noise,
					\sampleRate, 0.49,
					\atk, 0,
					\rel, 0,
					\amp, Prand([Pseq([0, 0.125,0,Pn(0.125, 4)],1), Pseq([0, 0,0,Pn(0.125, 4)],1)],inf),
					\dur, Pseq([1.5, 1.5, 4.5, Pn(1/8, 4)],inf),
					\sustain, Pkey(\dur)/1.5
				)
			).play(~tempoClock);
		});

		if(measureSelectNum == 57 && countNum == 0, {
			~click_durSeqStream = Prand([Pn(0.25, Prand([2, 4], 1)),Pn(0.125,Prand([2, 4], 1))],inf).asStream;

			Pdef(\snare_2,
				Pbind(\instrument,\click_2,
					\out, 0,
					\room,Pxrand([0.125,0.25, 0.5, 0.75],inf),
					\dur,Pfunc({~click_durData = ~click_durSeqStream.next; }),
					\gate,1,
					\amp,Prand([0.75,0.5,0.25],inf),
					\sustain,Pkey(\dur)-(Pkey(\dur)/1.5),
					\OSC_Sender, Pfunc({m.sendMsg("/event/click", ~click_durData);})
			)).play(~tempoClock);
			Pdef(\sineBass).stop;
			/*Pdef(\henonC,
			Pbind(
			\instrument, \henonC,
			\freq, Pfunc({96}),
			\param_a, Pxrand([0.25, 0.5, 0.25, 0.125],inf),
			\param_b, Pxrand([0.25, 2, 0.5, 0.25],inf),
			\amp, Prand([0.75,0.5,0.25],inf)/4,
			\dur, Pfunc({~henonC_durData = ~kick_durData })/1.5,
			\sustain, Pkey(\dur)*0.5,
			\OSC_Sender, Pfunc({m.sendMsg("/event/henonC", ~henonC_durData);})
			)
			);*/
			Pdef(\henonC,
				Pbind(
					\instrument, \henonC,
					\freq, Pfunc({84}),
					\param_a, Pxrand([1, 0.5, 0.25, 2],inf),
					\param_b, Pxrand([0.25, 2, 0.5, 1],inf),
					\amp, Prand([0.75,0.5,0.25],inf)/4,
					\dur, Pfunc({~henonC_durData = ~kick_durData }),
					\sustain, Pkey(\dur)-(Pkey(\dur)*0.25),
					\OSC_Sender, Pfunc({m.sendMsg("/event/sine",  ~henonC_durData);})
				)
			);
			Pdef(\kick,
				Pbind(\instrument, \kick,
					\out, 0,
					\dur, Pfunc({~kick_durData = ~kick_durSeqStream.next}),
					\amp,0,

					\OSC_Sender, Pfunc({m.sendMsg("/event/kick", ~kick_durData);})
				)
			);
			Pdef(\grayNoise,
				Pbind(\instrument, \grayNoise,
					\out, 0,
					\filtSel, Prand([0,1], inf),
					\dur, Pfunc({~click_durData}),
					\amp, Prand([0.25, 0.5, 0.125, 0.0625],inf)/2,
					\sustain, Pkey(\dur)*Prand([0.25, 0.5, 0.125, 0.0625],inf),
					\OSC_Sender, Pfunc({m.sendMsg("/event/grayNoise", ~grayNoise_durData);})
				)
			).play(~tempoClock);
			Pdef(\noise_inst,
				Pbind(
					\instrument, \noise,
					\sampleRate, 0.5,
					\atk, 0,
					\rel, 0,
					\amp, Prand([Pseq([0.125/3, 0.125,0,Pn(0.125, 4)],1), Pseq([0, 0.125/3,0,Pn(0.125, 4)],1)],inf),
					\dur, Pseq([1.5, 1.5, 4.5, Pn(1/8, 4)],inf),
					\sustain, Pkey(\dur)/1.5
				)
			).play(~tempoClock);

		});
		if(measureSelectNum == 65 && countNum == 0, {
			Pdef(\noise_inst).stop;

			~click_durSeqStream = Prand([Pn(0.25, Prand([2, 4], 1)),Pn(0.125,Prand([2, 4], 1))],inf).asStream;

			Pdef(\snare_2,
				Pbind(\instrument,\click_2,
					\out, 0,
					\room,Pxrand([0.125,0.25, 0.5, 0.75],inf),
					\dur,Pfunc({~click_durData = ~click_durSeqStream.next; }),
					\gate,1,
					\amp,Prand([0.75,0.5,0.25],inf),
					\sustain,Pkey(\dur)-(Pkey(\dur)/1.5),
					\OSC_Sender, Pfunc({m.sendMsg("/event/click", ~click_durData);})
			)).play(~tempoClock);
			Pdef(\sineBass).stop;
			Pdef(\henonC,
				Pbind(
					\instrument, \henonC,
					\freq, Pfunc({96}),
					\param_a, Pxrand([0.25, 0.5, 0.25, 0.125],inf),
					\param_b, Pxrand([0.25, 2, 0.5, 0.25],inf),
					\amp, Prand([0.75,0.5,0.25],inf)/4,
					\dur, Pfunc({~henonC_durData = ~kick_durData })/1.5,
					\sustain, Pkey(\dur)*0.5,
					\OSC_Sender, Pfunc({m.sendMsg("/event/henonC", ~henonC_durData);})
				)
			);
			Pdef(\kick,
				Pbind(\instrument, \kick,
					\out, 0,
					\dur, Pfunc({~kick_durData = ~kick_durSeqStream.next}),
					\amp,0,

					\OSC_Sender, Pfunc({m.sendMsg("/event/kick", ~kick_durData);})
				)
			);
			Pdef(\grayNoise,
				Pbind(\instrument, \grayNoise,
					\out, 0,
					\filtSel, Prand([0,1], inf),
					\dur, Pfunc({~click_durData}),
					//\dur, Pseq([0.625, 0.375,3, 0.625, Pn(0.125, 3), 3],inf),
					//\amp, Pseq([0, 0.125, 0, 0, Pn(0.125, 3), 0],inf),
					\amp, 0,
					\sustain, Pkey(\dur)*Prand([0.125, 0.25, 0.125/2, 0.0625/2],inf),
					\OSC_Sender, Pfunc({m.sendMsg("/event/grayNoise", ~grayNoise_durData);})
				)
			).play(~tempoClock);

		});
		if(measureSelectNum == 72 && countNum == 0, {
			Pdef(\snare_2).stop;
			~click_durSeqStream = Prand([Pn(0.25, Prand([0.5, 1], 1)),Pn(0.125,Prand([0.5, 1], 1))],inf).asStream;

			Pdef(\snare_2,
				Pbind(\instrument,\click_2,
					\out, 0,
					\room,Pxrand([0.125,0.25, 0.5, 0.75],inf),
					\dur,0.125,
					\gate,1,
					\amp,Prand([0.75,0.5,0.25],inf),
					\sustain,Pkey(\dur)-(Pkey(\dur)/1.5),

			)).play(~tempoClock);


		});
		if(measureSelectNum == 73 && countNum == 0, {

			Pdef(\henonC).stop;
			Pdef(\grayNoise).stop;
			Pdef(\kick).stop;
			Pdef(\snare_2).stop;
			Pdef(\sine).stop;


		});



		1.wait;
	})
});

~second_section_Task.play(~tempoClock);

)