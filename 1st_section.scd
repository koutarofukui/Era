
(

var countNum, measureSelectNum;

measureSelectNum = 0;
countNum = 0;

~first_section_Task =
Task({
	inf.do({
		|i|
		var set_1,set_2,set_3, set_4, set_5, set_6 ,set_7,set_8, set_9, set_10;
		set_1 = 0.125;
		set_2 = set_1 + set_1;
		set_3 = set_1 + set_2;
		set_4 = set_2;
		set_5 = set_4+set_4;
		set_6 = set_4+set_5;// set_6 = set_1 + set_2 + set_3

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



		if(measureSelectNum == 1 && countNum == 0, {
			m.sendMsg("/start", 1);

			Pdef(\sine, Pbind(
				\instrument, \saw,
				\out, 0,
				\sampleRate, 1,
				\bitRate, 32,
				\freq, Pfunc({~sine_freqData = ~sine_freqSeqStream.next; }),
				\dur, Pfunc({~sine_durData = ~sine_durSeqStream.next; }),
				\sustain, Pkey(\dur)/1.125,
				\OSC_Sender, Pfunc({m.sendMsg("/event/sine", ~sine_durData);})
			)).play(~tempoClock);
		});

		if(measureSelectNum == 2 && countNum == 4, {
			//Pdef(\sine).stop;
			~sine_durSeqStream = Pseq([4],1).asStream;
			Pdef(\sine, Pbind(
				\instrument, \saw,
				\sampleRate, 0.5,
				\bitRate, 8,
				\freq, Pfunc({~sine_freqData = ~sine_freqSeqStream.next; }),
				\dur, Pfunc({~sine_durData = ~sine_durSeqStream.next; }),
				\sustain, Pkey(\dur)/1.125,
				\OSC_Sender, Pfunc({m.sendMsg("/event/sine", ~sine_durData);})
			)).play(~tempoClock);

			}
		);

		if(measureSelectNum == 3 && countNum == 0, {

			~sine_durSeqStream = Pxrand([Pn(0.125, 6), Pseq([0.125, 0.25, 0.5, 0.125], 1),Pseq([0.125, 0.25, 0.25, 0.125], 1)], inf).asStream;
			Pdef(\sine, Pbind(
				\instrument, \saw,
				\sampleRate, 0.5,
				\bitRate, 32,
				\freq, Pfunc({~sine_freqData = ~sine_freqSeqStream.next; }),
				\dur, Pfunc({~sine_durData = ~sine_durSeqStream.next; }),
				\sustain, Pkey(\dur)/1.5,
				\OSC_Sender, Pfunc({m.sendMsg("/event/sine", ~sine_durData);})
			)).play(~tempoClock);
			//Click Start
			Pdef(\snare,
				Pbind(\instrument,\click,
					\out, 0,
					\room,0.125,
					\dur,Pfunc({~click_durData = ~click_durSeqStream.next /2; }),
					\gate,1,
					\amp,Prand([0.75,0.5,0.25],inf)/2,
					\sustain,Pkey(\dur)-(Pkey(\dur)/1.5),
					\OSC_Sender, Pfunc({m.sendMsg("/event/click", ~click_durData);})
			)).play(~tempoClock);

		});

		if(measureSelectNum == 7 && countNum == 0, {
			~kick_durSeqStream = Pseq([set_1, 8 - set_1],inf).asStream;
			Pdef(\kick, Pbind(\instrument, \kick, \amp, 1,\dur,Pfunc({~kick_durData = ~kick_durSeqStream.next; }),
				\osc, Pfunc({arg env;
				m.sendMsg("/event/kick", ~kick_durData);
			}))).play(~tempoClock);
			Pdef(\sineBass, Pbind(\instrument, \sin, \freq, 36, \dur, 4, \sustain, 4, \amp, 0.125)).play(~tempoClock);
		});
		if(measureSelectNum == 9 && countNum == 0, {
			~kick_durSeqStream = Pseq([set_1, set_2, 8 - set_1 - set_2],inf).asStream;
			Pdef(\kick, Pbind(\instrument, \kick, \amp, 1,\dur,Pfunc({~kick_durData = ~kick_durSeqStream.next; }),
				\OSC_Sender, Pfunc({
				m.sendMsg("/event/kick", ~kick_durData);
			}))).play(~tempoClock);
		});
		if(measureSelectNum == 11 && countNum == 0, {
			~sine_freqSeqStream = Pxrand([108,115,108], inf).asStream;
			Pdef(\sine, Pbind(\instrument, \saw, \freq, Pfunc({~sine_freqData = ~sine_freqSeqStream.next - 5; }),
				\sampleRate, 0.9,
				\bitRate, 32,
				\dur, Pfunc({~sine_durData = ~sine_durSeqStream.next; }),
				\sustain, Pkey(\dur)/1.5,
				\OSC_Sender, Pfunc({m.sendMsg("/event/sine", ~sine_durData);})
			));
			~kick_durSeqStream = Pseq([set_1, set_2, set_3, 8 - set_1 - set_2 - set_3],inf).asStream;
			Pdef(\kick, Pbind(\instrument, \kick, \amp, 1,\dur, Pfunc({~kick_durData = ~kick_durSeqStream.next; }),
				\OSC_Sender, Pfunc({
				m.sendMsg("/event/kick", ~kick_durData);
			}))).play(~tempoClock);
		});
		if(measureSelectNum == 13 && countNum == 0, {
			~kick_durSeqStream = Pseq([set_1, set_2, set_3, set_4, 8 - set_1 - set_2 - set_3 - set_4],inf).asStream;
			Pdef(\kick, Pbind(\instrument, \kick, \amp, 1,\dur,Pfunc({~kick_durData = ~kick_durSeqStream.next; }),
				\OSC_Sender, Pfunc({
				m.sendMsg("/event/kick", ~kick_durData);
			}))).play(~tempoClock);
		});
		if(measureSelectNum == 15 && countNum == 0, {
			~sine_freqSeqStream = Pxrand([108,115,108], inf).asStream;
			Pdef(\sine, Pbind(\instrument, \saw, \freq, Pfunc({~sine_freqData = ~sine_freqSeqStream.next - 5; }),
				\dur, Pfunc({~sine2_durData = ~sine_durSeqStream.next; }),
				\sustain, Pkey(\dur)/1.5,
				\panPos, -1,
				\OSC_Sender, Pfunc({m.sendMsg("/event/sine", ~sine_durData);})
			));

			Pdef(\sine_2, Pbind(\instrument, \saw, \freq, Pfunc({~sine2_freqData = ~sine_freqSeqStream.next; }),
				\dur, Pfunc({~sine2_durData = ~sine_durSeqStream.next; }),
				\sustain, Pkey(\dur)/1.5,
				\panPos, 1,
				\OSC_Sender, Pfunc({m.sendMsg("/event/sine_2", ~sine_durData);})
			)).play(~tempoClock);

			~kick_durSeqStream = Pseq([set_1, set_2, set_3, set_4, 8 - set_1 - set_2 - set_3 - set_4],inf).asStream;
			Pdef(\kick, Pbind(\instrument, \kick, \amp, 1,\dur, Pfunc({~kick_durData = ~kick_durSeqStream.next; }),
				\OSC_Sender, Pfunc({
				m.sendMsg("/event/kick", ~kick_durData);
			}))).play(~tempoClock);
		});

		if(measureSelectNum == 17 && countNum == 0, {
			~kick_durSeqStream = Pseq([set_1, set_2, set_3, set_4, set_5, set_1, set_2, set_3, 8 - set_1 - set_2 - set_3 - set_4 - set_5 - set_6 ],inf).asStream;
			Pdef(\kick,
				Pbind(\instrument, \kick, \amp, 1,
					\dur, Pfunc({~kick_durData = ~kick_durSeqStream.next; }),
					\OSC_Sender, Pfunc({
						m.sendMsg("/event/kick", ~kick_durData);
					})
			)).play(~tempoClock);
		});

		if(measureSelectNum == 18 && countNum == 4, {
			Pdef(\kick).stop;
			Pdef(\snare).stop;
			Pdef(\sineBass).stop;
			Pdef(\sine_2).stop;

			~sine_freqSeqStream = Pxrand([108,115,108], inf).asStream;
			~sine_durSeqStream = Pseq([4],1).asStream;
			Pdef(\sine, Pbind(
				\instrument, \saw,
				\freq, Pfunc({~sine_freqData = ~sine_freqSeqStream.next; }),
				\dur, Pfunc({~sine_durData = ~sine_durSeqStream.next; }),
				\sustain, Pkey(\dur)/1.125,
				\panPos, 0,
				\OSC_Sender, Pfunc({m.sendMsg("/event/sine", ~sine_durData);})
			));

			Pdef(\whiteNoise, Pbind(\instrument, \whiteNoise, \amp, 0.25,\dur,4, \sustain, Pkey(\dur))).play(~tempoClock);

		});
		//
		if(measureSelectNum == 19 && countNum == 0, {
			Pdef(\whiteNoise).stop;
			~sine_durSeqStream = Pxrand([Pn(0.125, 6), Pseq([0.125, 0.25, 0.5, 0.125], 1),Pseq([0.125, 0.25, 0.25, 0.125], 1)], inf).asStream;
			Pdef(\sine, Pbind(
				\instrument, \saw,
				\freq, Pfunc({~sine_freqData = ~sine_freqSeqStream.next; }),
				\dur, Pfunc({~sine_durData = ~sine_durSeqStream.next; }),
				\sustain, Pkey(\dur)/1.5,
				\OSC_Sender, Pfunc({m.sendMsg("/event/sine", ~sine_durData);})
			)).play(~tempoClock);

			Pdef(\kick,
				Pbind(\instrument, \kick,
					\out, 0,
					\dur,Pfunc({
						~sine_durData;
					}),
					\amp,Pfunc({if(~sine_durData >= 0.5, 0, 1)}),
					//\dur,Pfunc({~kick_durData = ~kick_freqSeqStream.next}),
					\OSC_Sender, Pfunc({m.sendMsg("/event/kick", ~kick_durData = ~sine_durData);})
				)
			).play(~tempoClock);
		});

		if(measureSelectNum == 26 && countNum == 0, {//more work!!!!!! something should be happen here.
			Pdef(\sine).stop;
			Pdef(\kick).stop;
			Pdef(\whiteNoise, Pbind(\instrument, \whiteNoise, \amp, 0.25,\dur,4, \sustain, Pkey(\dur))).play(~tempoClock);
			~sine_durSeqStream = Pseq([8],1).asStream;
			Pdef(\sine, Pbind(
				\instrument, \sin,
				\freq, 36,
				\dur, Pfunc({~sine_durData = ~sine_durSeqStream.next; }),
				\sustain, Pkey(\dur),
				\OSC_Sender, Pfunc({m.sendMsg("/event/sine", ~sine_durData);})
			)).play(~tempoClock);
		});

		if(measureSelectNum == 27 && countNum == 0, {
			Pdef(\whiteNoise).stop;
			~sine_durSeqStream = Pxrand([Pn(0.125, 6), Pseq([0.125, 0.25, 0.5, 0.125], 1),Pseq([0.125, 0.25, 0.25, 0.125], 1)], inf).asStream;
			Pdef(\sine, Pbind(
				\instrument, \saw,
				\freq, Pfunc({~sine_freqData = ~sine_freqSeqStream.next; }),
				\dur, Pfunc({~sine_durData = ~sine_durSeqStream.next; }),
				\sustain, Pkey(\dur)/1.5,
				\OSC_Sender, Pfunc({m.sendMsg("/event/sine", ~sine_durData);})
			)).play(~tempoClock);

			Pdef(\snare,
				Pbind(\instrument,\click,

					\room,Pxrand([0.125,0.25, 0.5, 0.75],inf),
					\dur,Pfunc({~click_durData = ~click_durSeqStream.next /2; }),
					\gate,1,
					\amp,Prand([0.75,0.5,0.25],inf)/2,
					\sustain,Pkey(\dur)-(Pkey(\dur)/1.5),
					\OSC_Sender, Pfunc({m.sendMsg("/event/click", ~click_durData);})
			)).play(~tempoClock);

			Pdef(\kick,
				Pbind(\instrument, \kick,
					\out, 0,
					\dur,Pfunc({
						~sine_durData;
					}),
					\amp,Pfunc({if(~sine_durData >= 0.5, 0, 1)}),
					\OSC_Sender, Pfunc({m.sendMsg("/event/kick", ~kick_durData = ~sine_durData );})
				)
			).play(~tempoClock);

			Pdef(\logisticMapBass,
				Pbind(\instrument, \logisticMap_Bass,

					\rel, 0,
					\chaos, Pfunc({(0.99).rand + 3}),
					\width, Pfunc({(0.125).rand + 0.5}),
					\logiFreq, Pkey(\freq)*Pseq([8, 16, 32],inf),
					\dur,Pfunc({
						~logisticMapBass_durData = ~sine_durData;
					}),
					\amp,Pfunc({if(~sine_durData == 0.5, 0.125, 0.125/2)}),
					\freq,Pfunc({if(~sine_durData == 0.5, 33, 48)}),
					\sustain,Pkey(\dur)-(Pkey(\dur)*0.25),
					//\dur,Pfunc({~kick_durData = ~kick_freqSeqStream.next}),
					\OSC_Sender, Pfunc({m.sendMsg("/event/logisticMap", ~logisticMapBass_durData);})
				)
			).play(~tempoClock);


			Pdef(\sineBass,
				Pbind(\instrument, \sin,
					\freq,Pfunc({if(~sine_durData == 0.5, 33, 48)})-12,

					\dur,Pfunc({
						~sineBass_durData = ~sine_durData;
					}),
					\amp, Pfunc({if(~sineBass_durData ==1.5, 0, 0.5)})/4,
					\sustain,Pkey(\dur)-(Pkey(\dur)*0.25),
					\OSC_Sender, Pfunc({m.sendMsg("/event/sineBass", ~sineBass_durData);})
				)
			).play(~tempoClock);

		});
		if(measureSelectNum == 31 && countNum == 0, {

			~sine_durSeqStream = Pxrand([Pn(0.125, 6), Pseq([0.125, 0.25, 0.5, 0.125], 1),Pseq([0.125, 0.25, 0.25, 0.125], 1)], inf).asStream;

			Pdef(\logisticMapBass,
				Pbind(\instrument, \logisticMap_Bass,

					\rel, 0,
					\chaos, Pfunc({(0.5).rand + 3}),
					\width, Pfunc({(0.99).rand + 0.5}),
					//\logiFreq, Pkey(\freq)*Pseq([8, 16, 32],inf),
					\dur,Pfunc({
						~logisticMapBass_durData = ~sine_durData;
					}),
					\amp,Pfunc({if(~sine_durData == 0.5, 0.125, 0.125/2)}),
					\freq,Pfunc({if(~sine_durData == 0.5, 33, 48)}),
					\logiFreq, Pkey(\freq)*Pseq([8, 16, 32],inf),
					\sustain,Pkey(\dur)-(Pkey(\dur)*0.25),
					//\dur,Pfunc({~kick_durData = ~kick_freqSeqStream.next}),
					\OSC_Sender, Pfunc({m.sendMsg("/event/logisticMap", ~logisticMapBass_durData);})
				)
			).play(~tempoClock);


			Pdef(\sineBass,
				Pbind(\instrument, \sin,
					\freq,Pfunc({if(~sine_durData == 0.5, 33, 48)})-12,

					\dur,Pfunc({
						~sineBass_durData = ~sine_durData;
					}),
					\amp, Pfunc({if(~sineBass_durData ==1.5, 0, 0.5)})/4,
					\sustain,Pkey(\dur)-(Pkey(\dur)*0.25),
					\OSC_Sender, Pfunc({m.sendMsg("/event/sineBass", ~sineBass_durData);})
				)
			).play(~tempoClock);

			Pdef(\whiteNoise,
				Pbind(\instrument, \whiteNoise,
					\rel, 0,
					\amp, Pfunc({if(~sine_durData == 0.5, 0.15, 0)}),
					/*\dur,Pfunc({
					~sineBass_durData = ~sine_durData;
					}),*/
					\dur,1/24,
					\sustain, Pkey(\dur)/2
				)
			).play(~tempoClock);

		});

		if(measureSelectNum == 35 && countNum == 0, {//
			//~sine_durSeqStream = Pxrand([Pn(0.125, 6), Pseq([0.125, 0.25, 0.5, 0.125], 1),Pseq([0.125, 0.25, 0.25, 0.125], 1)], inf).asStream;
			~sine_durSeqStream = Pxrand(
				[
					Pn(0.125, 6),
					Pseq([0.125, 0.25, Pn(0.125, 3)],1),
					Pseq([0.125, 0.25, Pn(0.125, 3)], 1)
			], inf).asStream;

			Pdef(\sine, Pbind(
				\instrument, \saw,
				\freq, Pfunc({~sine_freqData = ~sine_freqSeqStream.next - 5; }),
				\dur, Pfunc({~sine_durData = ~sine_durSeqStream.next; }),
				\sustain, Pkey(\dur)/1.5,
				\panPos, -1,
				\OSC_Sender, Pfunc({m.sendMsg("/event/sine", ~sine_durData);})
			)).play(~tempoClock);

			Pdef(\sine_2, Pbind(\instrument, \saw, \freq, Pfunc({~sine2_freqData = ~sine_freqSeqStream.next; }),
				\dur, Pfunc({~sine2_durData = ~sine_durSeqStream.next; }),
				\sustain, Pkey(\dur)/1.5,
				\panPos, 1,
				\OSC_Sender, Pfunc({m.sendMsg("/event/sine_2", ~sine2_durData);})
			)).play(~tempoClock);

			~click_durSeqStream = Prand([0.5,Pn(0.25,4)],inf).asStream;
			Pdef(\snare,
				Pbind(\instrument,\click,
					\room,Pxrand([0.125,0.25, 0.5, 0.75],inf),
					\dur,Pfunc({~click_durData = ~click_durSeqStream.next/2; }),
					\gate,1,
					\amp,Prand([0.75,0.5,0.25],inf)/2,
					\sustain,Pkey(\dur)-(Pkey(\dur)/1.5),
					\OSC_Sender, Pfunc({m.sendMsg("/event/click", ~click_durData);})
			));

			Pdef(\logisticMapBass,
				Pbind(\instrument, \logisticMap_Bass,

					\rel, 0,
					\chaos, Pfunc({(0.5).rand + 3}),
					\width, Pfunc({(0.99).rand + 0.5}),

					\dur,Pfunc({
						~logisticMapBass_durData = ~sine_durData;
					}),
					\amp,0.125/2,
					\freq,Pfunc({if(~sine_durData == 0.5, 33, 48)}),
					\logiFreq, Pkey(\freq)*Pseq([8, 16, 32],inf),
					\sustain,Pkey(\dur)-(Pkey(\dur)*0.25),
					\OSC_Sender, Pfunc({m.sendMsg("/event/logisticMap", ~logisticMapBass_durData);})
				)
			).play(~tempoClock);

			Pdef(\sineBass,
				Pbind(\instrument, \sin,
					\freq,Pfunc({if(~sine_durData == 0.5, 33, 48)})-12,

					\dur,Pfunc({
						~sineBass_durData = ~sine_durData;
					}),
					\amp, Pfunc({if(~sineBass_durData ==1.5, 0, 0.5)})/4,
					\sustain,Pkey(\dur)-(Pkey(\dur)*0.25),
					\OSC_Sender, Pfunc({m.sendMsg("/event/sineBass", ~sineBass_durData);})
				)
			)
		});
		if(measureSelectNum == 39 && countNum == 0, {
			Pdef(\whiteNoise,
				Pbind(\instrument, \whiteNoise,
					\rel, 0,
					\amp, Pfunc({if(~sine_durData == 0.125, 0.25, 0.125)}),
					/*\dur,Pfunc({
					~sineBass_durData = ~sine_durData;
					}),*/
					\dur,1/12,
					\sustain, Pkey(\dur)/2
				)
			).play(~tempoClock);

		});

		if(measureSelectNum == 43 && countNum == 0, {

			var break = 1;
			Pdef(\whiteNoise).stop;
			Pdef(\sine_2).stop;
			Pdef(\snare).stop;

			~sine_durSeqStream = Pxrand([Pn(0.125, 6), Pseq([0.125, 0.25, Pwrand([0.5, break],[2,3].normalizeSum, 1), 0.125], 1),Pseq([0.125, 0.25, 0.25, 0.125], 1)], inf).asStream;
			Pdef(\sine, Pbind(
				\instrument, \saw,
				\freq, Pfunc({~sine_freqData = ~sine_freqSeqStream.next; }),
				\dur, Pfunc({~sine_durData = ~sine_durSeqStream.next; }),
				\sustain, Pkey(\dur)/1.5,
				\panPos, 0,
				\OSC_Sender, Pfunc({m.sendMsg("/event/sine", ~sine_durData);})

			)).play(~tempoClock);

			Pdef(\kick,
				Pbind(\instrument, \kick,
					\dur,Pfunc({
						~sine_durData;
					}),
					\amp,Pfunc({
						if(~sine_durData >= 0.5, 0, 1);
					}),
					\OSC_Sender, Pfunc({m.sendMsg("/event/kick", ~kick_durData = ~sine_durData);})
				)
			).play(~tempoClock);

			Pdef(\logisticMapBass,
				Pbind(\instrument, \logisticMap_Bass,

					\rel, 0,
					\chaos, Pfunc({(0.99).rand + 3}),
					\width, Pfunc({(0.125).rand + 0.5}),

					\dur,Pfunc({
						~logisticMapBass_durData = ~sine_durData;
					}),
					\amp,Pfunc({
						if(~sine_durData == break, 0, 0.125/2);
					}),
					\freq,Pfunc({if(~sine_durData == 0.5, 33, 48)}),
					\logiFreq, Pkey(\freq)*Pseq([8, 16, 32],inf),
					\sustain,Pkey(\dur)-(Pkey(\dur)*0.25),
					\OSC_Sender, Pfunc({m.sendMsg("/event/logisticMap", ~logisticMapBass_durData);})
				)
			).play(~tempoClock);
			Pdef(\sineBass,
				Pbind(\instrument, \sin,

					\freq,Pfunc({if(~sine_durData == 0.5, 33, 48)})-12,

					\dur,Pfunc({
						~sineBass_durData = ~sine_durData;
					}),
					\amp, Pfunc({
						if(~sine_durData == break, 0, 0.125/2)/4;
					}),
					\sustain,Pkey(\dur)-(Pkey(\dur)*0.25),
					\OSC_Sender, Pfunc({m.sendMsg("/event/sineBass", ~sineBass_durData);})
				)
			)
		});

		if(measureSelectNum == 45 && countNum == 0, {

			Pdef(\sineBass, Pbind(\instrument, \sin, \freq, 29, \dur, 4, \sustain, 4)).play(~tempoClock);

		});

		if(measureSelectNum == 47 && countNum == 0, {
			Pdef(\sineBass).stop;
			Pdef(\sine).stop;
			Pdef(\kick).stop;
			Pdef(\logisticMapBass).stop;
			Pdef(\snare).stop;
			Pdef(\logisticMap_Synth,
				Pbind(\instrument, \logisticMap_Synth,
					\chaos,Pn(Penv([3.5, 3.95], [8], -2)),
					\atk, 0.01,
					\rel, 0.01,
					\logiFreq, 500,
					\dur, 1/16,
					\sustain, 1/16,
					\amp, Pn(Penv([0.125, 0.25], [8], -2)),
				)
			).play(~tempoClock);
			~sine_durSeqStream = Pseq([8],1).asStream;
			Pdef(\sine, Pbind(
				\instrument, \sin,
				\freq, 60,
				\dur, Pfunc({~sine_durData = ~sine_durSeqStream.next; }),
				\sustain, Pkey(\dur),
				\OSC_Sender, Pfunc({m.sendMsg("/event/sine", ~sine_durData);})
			)).play(~tempoClock);
		});

		if(measureSelectNum == 48 && countNum == 0, {
			Pdef(\logisticMap_Synth).stop;
		});


		1.wait;
	})
});
~first_section_Task.play(~tempoClock)
)