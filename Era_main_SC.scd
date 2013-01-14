(//Set up
~currentDocPath = "/Users/koutarofukui/Dropbox/Application/SC related files/Piece/Era/";

)
(
~currentDocPath = thisProcess.nowExecutingPath.replace("Era_main_SC.scd", "");
(~currentDocPath++"Era_Instrument.scd").load;
(~currentDocPath++"Era_Instrument.scd").load;
(~currentDocPath++"Era_Setting.scd").load;
)
(

//ProxySpace.push(s);

var countNum, measureSelectNum, reverb, logisticFilterFx;
var set_1,set_2,set_3, set_4, set_5, set_6 ,set_7,set_8, set_9, set_10;
set_1 = 0.125;
set_2 = set_1 + set_1;
set_3 = set_1 + set_2;
set_4 = set_2;
set_5 = set_4+set_4;
set_6 = set_4+set_5;// set_6 = set_1 + set_2 + set_3

// init var
measureSelectNum = 0;

//loading files

~currentDocPath = thisProcess.nowExecutingPath.replace("Era_main_SC.scd", "");
(~currentDocPath++"Era_Instrument.scd").load;
(~currentDocPath++"Era_Setting.scd").load;

~tempoClock = TempoClock(90/60);

//sine pattern set
~sine_freqSeqStream = Pxrand([108,115,108], inf).asStream;
~sine_durSeqStream = Pxrand([Pn(0.125, 6), Pseq([0.125, 0.25, 0.5, 0.125], 1),Pseq([0.125, 0.25, 0.25, 0.125], 1)], inf).asStream;

//click pattern set
~click_durSeqStream = Prand([0.5,Pn(0.25,4)],inf).asStream;

//kick pattern set
~kick_durSeqStream = Pstutter(2, Pseq([set_1, set_2,set_3, set_4, set_5, set_1, set_2,set_3],inf) ).asStream;

//HenonC AM mod Sine pattern set
~henonC_freqSeqStream = Prand([0.5,Pn(0.25,4)],inf).asStream;
~henonC_durSeqStream = Prand([0.5,Pn(0.25,4)],inf).asStream;




//FX setting
~logisticFilterFx.free;
~henonFx.free;
reverb.free;
reverb = Synth.after(1, \reverb);
reverb.set(\in, 33,\mix, 0.5, \room, 0.99, \dump, 0.5);

~logisticFilterFx = Synth.after(1, \logisticMap_FX);
~logisticFilterFx.set(\in, 35, \chaos, 3.99, \logiFreq, 2000);

~henonFx = Synth.after(1, \henonC_FX);
~henonFx.set(\in, 37);


Task({
	inf.do({
		|i|
		//measureSelectNum = i;
		countNum = i % 8; // time measure

		//Print"count"&"measure"
		if(countNum == 0,
			{
				("measure : "++ measureSelectNum).postln;
				measureSelectNum = measureSelectNum  + 1;

			}
		);

		if(measureSelectNum <= 193 && countNum == 0, m.sendMsg("/event/reset", 1));

		("count : "++ countNum).postln;

		if(measureSelectNum ==1 && countNum == 0, {
			//Pdef(\pulse).play(~tempoClock);
			Pdef(\sine, Pbind(
				\instrument, \saw,
				\out, 0,
				\freq, Pfunc({~sine_freqData = ~sine_freqSeqStream.next; }),
				\dur, Pfunc({~sine_durData = ~sine_durSeqStream.next; }),
				\sustain, Pkey(\dur)/1.125,
				\OSC_Sender, Pfunc({m.sendMsg("/event/sine", ~sine_durData);})
			)).play(~tempoClock);
		});

		if(measureSelectNum ==2 && countNum == 4, {

			~sine_durSeqStream = Pseq([4],1).asStream;
			Pdef(\sine, Pbind(
				\instrument, \saw,

				\freq, Pfunc({~sine_freqData = ~sine_freqSeqStream.next; }),
				\dur, Pfunc({~sine_durData = ~sine_durSeqStream.next; }),
				\sustain, Pkey(\dur)/1.125,
				\OSC_Sender, Pfunc({m.sendMsg("/event/sine", ~sine_durData);})
			)).play(~tempoClock);

			}
		);

		if(measureSelectNum ==3 && countNum == 0, {

			~sine_durSeqStream = Pxrand([Pn(0.125, 6), Pseq([0.125, 0.25, 0.5, 0.125], 1),Pseq([0.125, 0.25, 0.25, 0.125], 1)], inf).asStream;
			Pdef(\sine, Pbind(
				\instrument, \saw,
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

		if(measureSelectNum ==7 && countNum == 0, {
			Pdef(\kick, Pbind(\instrument, \kick, \amp, 1,\dur,Pseq([set_1, 8 - set_1],inf))).play(~tempoClock);
			Pdef(\sineBass, Pbind(\instrument, \sin, \freq, 36, \dur, 4, \sustain, 4, \amp, 0.125)).play(~tempoClock);
		});
		if(measureSelectNum ==9 && countNum == 0, {
			Pdef(\kick, Pbind(\instrument, \kick, \amp, 1,\dur,Pseq([set_1, set_2, 8 - set_1 - set_2],inf)))
		});
		if(measureSelectNum ==11 && countNum == 0, {
			~sine_freqSeqStream = Pxrand([108,115,108], inf).asStream;
			Pdef(\sine, Pbind(\instrument, \saw, \freq, Pfunc({~sine_freqData = ~sine_freqSeqStream.next - 5; }),
				\dur, Pfunc({~sine_durData = ~sine_durSeqStream.next; }),
				\sustain, Pkey(\dur)/1.5,
				\OSC_Sender, Pfunc({m.sendMsg("/event/sine", ~sine_durData);})
			));
			Pdef(\kick, Pbind(\instrument, \kick, \amp, 1,\dur,Pseq([set_1, set_2, set_3, 8 - set_1 - set_2 - set_3],inf)))
		});
		if(measureSelectNum ==13 && countNum == 0, {
			Pdef(\kick, Pbind(\instrument, \kick, \amp, 1,\dur,Pseq([set_1, set_2, set_3, set_4, 8 - set_1 - set_2 - set_3 - set_4],inf)))
		});
		if(measureSelectNum ==15 && countNum == 0, {
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
				\OSC_Sender, Pfunc({m.sendMsg("/event/sine", ~sine2_freqData , ~sine_durData);})
			)).play(~tempoClock);
			Pdef(\kick, Pbind(\instrument, \kick, \amp, 1,\dur,Pseq([set_1, set_2, set_3, set_4, set_5, 8 - set_1 - set_2 - set_3 - set_4 - set_5],inf)))
		});

		if(measureSelectNum ==17 && countNum == 0, {
			Pdef(\kick, Pbind(\instrument, \kick, \amp, 1,\dur,Pseq([set_1, set_2, set_3, set_4, set_5, set_1, set_2, set_3, 8 - set_1 - set_2 - set_3 - set_4 - set_5 - set_6 ],inf)))
		});

		if(measureSelectNum ==18 && countNum == 4, {
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

		if(measureSelectNum ==19 && countNum == 0, {
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

		if(measureSelectNum ==27 && countNum == 0, {
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
						~sine_durData;
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
				\OSC_Sender, Pfunc({m.sendMsg("/event/sine", ~sine2_freqData , ~sine2_durData);})
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
					\chaos, Pfunc({(0.99).rand + 3}),
					\width, Pfunc({(0.125).rand + 0.5}),

					\dur,Pfunc({
						~sine_durData;
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

		if(measureSelectNum ==43 && countNum == 0, {

			var break = 1;
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
						~sine_durData;
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

		if(measureSelectNum ==45 && countNum == 0, {

			Pdef(\sineBass, Pbind(\instrument, \sin, \freq, 29, \dur, 4, \sustain, 4)).play(~tempoClock);

		});

		if(measureSelectNum ==47 && countNum == 0, {
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
		if(measureSelectNum == 55 && countNum == 4, {
			Pdef(\kick,
				Pbind(\instrument, \kick,
					\out, 0,
					\dur, Pfunc({~kick_durData = ~kick_durSeqStream.next}),
					\amp,0,

					\OSC_Sender, Pfunc({m.sendMsg("/event/kick", ~kick_durData);})
				)
			);

		});

		if(measureSelectNum == 56 && countNum == 0, {
			Pdef(\kick).stop;
			//henonC change pitch
			Pdef(\henonC,
				Pbind(
					\instrument, \henonC,
					\freq, Pfunc({96}),
					\param_a, Pxrand([1, 0.5, 0.25, 2],inf),
					\param_b, Pxrand([0.25, 2, 0.5, 1],inf),
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

		if(measureSelectNum ==63 && countNum == 6, {

			Pdef(\kick).stop;

		});

		if(measureSelectNum ==64 && countNum == 0, {

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
					\param_a, Pxrand([1, 0.5, 0.25, 2],inf),
					\param_b, Pxrand([0.25, 2, 0.5, 1],inf),
					\amp, Prand([0.75,0.5,0.25],inf)/4,
					\dur, Pfunc({~henonC_durData = ~kick_durData }),
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
		if(measureSelectNum ==71 && countNum == 4, {

			Pdef(\kick).stop;

		});

		if(measureSelectNum ==72 && countNum == 0, {

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

			Pdef(\logisticMap_Synth,
				Pbind(\instrument, \logisticMap_Synth,
					\out, 0,
					\rel, 3,
					\chaos,3.99,
					\logiFreq, Pxrand([1000, 750, 2000, 400, 200],inf),
					\dur, 8,
					\sustain, Pkey(\dur)-2,
					\amp, 0.125/2
				)
			).play(~tempoClock);

		});

		if(measureSelectNum == 80 && countNum == 0, {

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
		if(measureSelectNum == 88 && countNum == 0, {


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

		if(measureSelectNum == 96 && countNum == 0, {
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
			~sineBass_durSeqStream = Prand(
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
		});

		if(measureSelectNum == 104 && countNum == 0, {
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
					\amp, Prand([0.25, 0.5, 0.125, 0.0625],inf),
					\sustain, Pkey(\dur)*Prand([0.25, 0.5, 0.125, 0.0625],inf),
					\OSC_Sender, Pfunc({m.sendMsg("/event/grayNoise", ~grayNoise_durData);})
				)
			).play(~tempoClock);

		});
		if(measureSelectNum == 112 && countNum == 0, {
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
					\sustain, Pkey(\dur)*Prand([0.25, 0.5, 0.125, 0.0625],inf),
					\OSC_Sender, Pfunc({m.sendMsg("/event/grayNoise", ~grayNoise_durData);})
				)
			).play(~tempoClock);

		});

		////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

		if(measureSelectNum == 120 && countNum == 0, {
			m.sendMsg("/event/reset", 1);

			Pdef(\henonC).stop;
			Pdef(\grayNoise).stop;
			Pdef(\kick).stop;
			Pdef(\snare_2).stop;
			Pdef(\sine).stop;



		});

		1.wait;
	})
}).play(~tempoClock)

)



