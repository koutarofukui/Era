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

//~tempoClock = TempoClock(180/60);
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
				measureSelectNum = measureSelectNum  + 1;
				("measure : "++ measureSelectNum).postln;

			}
		);

		if(measureSelectNum <= 193 && countNum == 0, m.sendMsg("/event/reset", 1));

		("count : "++ countNum).postln;

		if(measureSelectNum == 1 && countNum == 0, {

			Pdef(\pulseSegment_inst,
				Pbind(
					\instrument, \pulseSegment,
					\freq, 440 * 4,
					\rel, 1/128,
					\amp, 1,
					\dur, 1/3/2,
				)
			).play(~tempoClock);

		});

		if(measureSelectNum == 1 && countNum == 1, {

			Pdef(\pulseSegment_inst,
				Pbind(
					\instrument, \pulseSegment,
					\freq, 440 * 24,
					\rel, 1/32,
					\sampleRate,0.6,
					\amp, 1,
					\dur, 1/16,
				)
			).play(~tempoClock);

		});

		if(measureSelectNum == 1 && countNum == 4, {

			Pdef(\pulseSegment_inst,
				Pbind(
					\instrument, \pulseSegment,
					\freq, 440 * 32,
					\rel, 1/32,
					\sampleRate,0,
					\amp, 1,
					\dur, 1/4,
				)
			).play(~tempoClock);

		});
		if(measureSelectNum == 1 && countNum == 6, {

			Pdef(\pulseSegment_inst,
				Pbind(
					\instrument, \pulseSegment,
					\freq, 440 * 0.5,
					\rel, 1/32,
					\amp, 0.5,
					\dur, Pn(Penv([1/4, 1/24], [2]))
				)
			).play(~tempoClock);

		});

		if(measureSelectNum == 2 && countNum == 0, {

			Pdef(\pulseSegment_inst,
				Pbind(
					\instrument, \pulseSegment,
					\freq, 440 * 8,
					\rel, 1/128,
					\sampleRate, Prand([0.125,0.25, 0.5], inf)/128,
					\amp, 1,
					\dur, 1/8/2,

				)
			).play(~tempoClock);

		});
		if(measureSelectNum == 2 && countNum == 4, {

			Pdef(\pulseSegment_inst,
				Pbind(
					\instrument, \pulseSegment,
					\freq, 440 * 32,
					\atk, Pn(Penv([1/128, 1/64], [4])),
					\rel, Pn(Penv([0, 1/64], [4])),
					\sampleRate, 0.02,
					\amp, 0.75,
					\dur, Pn(Penv([1/8, 1/2], [5])),

				)
			).play(~tempoClock);

		});

		if(measureSelectNum == 3 && countNum == 0, {

			Pdef(\pulseSegment_inst,
				Pbind(
					\instrument, \pulseSegment,
					\freq, 440 /4,
					\atk, 0,
					//\rel, Pn(Penv([1/16, 1/64], [4])),
					\rel, Pn(Penv([1/16, 1/256], [4], -4)),
					\amp, Pseq([Pn(0.75, 7), 0.25, 0.75],1),
					\dur, Pseq([1/2, Pn(1/4, 2), Pn(1/3, 6)],1)/2,

				)
			).play(~tempoClock);

		});
		if(measureSelectNum == 3 && countNum == 2, {

			Pdef(\sineBass_inst,
				Pbind(
					\instrument, \sineBass,
					\freq, Pseq([440*32,440*12],inf),
					\atk, 0,
					//\rel, Pn(Penv([1/16, 1/64], [4])),
					\rel, 0,
					\amp, 0.25,
					\dur, Pseq([Pn(1/16, 8),Pn(1/32, 48)],1)

				)
			).play(~tempoClock);

		});

		if(measureSelectNum == 3 && countNum == 4, {
			Pdef(\sineBass_inst).stop;
			Pdef(\pulseSegment_inst,
				Pbind(
					\instrument, \pulseSegment,
					\freq, Pn(Penv([440*16, 440*32, 440*32],[4, 6],2)),
					\atk, 0,
					\rel, 1/128,
					\amp, 0.75,
					\dur, 1/6,

				)
			).play(~tempoClock);

		});
		if(measureSelectNum == 4 && countNum == 6, {

			Pdef(\pulseSegment_inst,
				Pbind(
					\instrument, \pulseSegment,
					\freq, Pseq([Pn(440* 2, 6),440*0.25],1),
					\atk, 0,
					\rel, Pseq([Pn(1/256, 8),1/8],1),
					\amp, 0.75,
					\dur, Pseq([1, Pn(1/4, 6)].reverse,1)/2,

				)
			).play(~tempoClock);

		});
		if(measureSelectNum == 4 && countNum == 7, {

			Pdef(\sineBass_inst,
				Pbind(
					\instrument, \sineBass,
					\freq, Pseq([440*32,440*24],inf),
					\atk, 0,
					//\rel, Pn(Penv([1/16, 1/64], [4])),
					\rel, 0,
					\amp, 0.25,
					\dur, 1/16,

				)
			).play(~tempoClock);

		});
		if(measureSelectNum == 5 && countNum == 0, {
			Pdef(\sineBass_inst).stop;
			Pdef(\noise_inst,
				Pbind(
					\instrument, \noise,
					//\sampleRate, Pn(Penv([0.01, 0.04, 0.04], [2, 2], 0)),
					\atk, 0,
					\rel, 0,
					\amp, 0.25,
					\dur, Pn(1/8,8*4),
					\sustain, Pkey(\dur)

				)
			).play(~tempoClock);

		});
		if(measureSelectNum == 5 && countNum == 4, {

			Pdef(\noise_inst,
				Pbind(
					\instrument, \noise,
					\sampleRate, 0.002,
					\atk, 1/128,
					\rel, 0,
					\amp, Pn(Penv([0.25, 0.25], [5], -2)),
					\dur, Pseq([Pn(1/2, 3), Pn(1/8,12)], 1)/2,
					\sustain, Pkey(\dur)/4
				)
			).play(~tempoClock);

			Pdef(\pulseSegment_inst,
				Pbind(
					\instrument, \pulseSegment,
					\freq, Pseq([Pn(440/2, 3), Pn(440*8, 12)],1),
					\atk, 0,
					\rel, 1/128,
					\amp, 0.75,
					\dur, Pseq([Pn(1/2, 3), Pn(1/8,12)], 1)/2
				)
			).play(~tempoClock);

		});
		if(measureSelectNum == 5 && countNum == 6, {

			Pdef(\noise_inst,
				Pbind(
					\instrument, \noise,
					\sampleRate, 0.004,
					\atk, 1/128,
					\rel, 0,
					\amp, Pn(Penv([0.25, 0.25], [4], -2)),
					\dur, Pseq([Pn(1/2, 3), Pn(1/8,12)].reverse, 1)/2,
					\sustain, Pkey(\dur)/4
				)
			).play(~tempoClock);

			Pdef(\pulseSegment_inst,
				Pbind(
					\instrument, \pulseSegment,
					\freq, Pseq([Pn(440/2, 3), Pn(440*8, 12)],1),
					\atk, 0,
					\rel, 1/128,
					\amp, 0.75,
					\dur, Pseq([Pn(1/2, 3), Pn(1/8,12)].reverse, 1)/2
				)
			).play(~tempoClock);

		});
		if(measureSelectNum == 6 && countNum == 0, {

			Pdef(\sineBass_inst,
				Pbind(
					\instrument, \sineBass,
					\midinote, Pseq([Pseq([Pn(36, 2), Pn(41,14)], 1), Pseq([Pn(36, 4), Pn(41,12)], 1), Pseq([Pn(36, 6), Pn(41,22)], 1)],1),
					\sampleRate, 0.001,
					\atk, 0.00001,
					\decay, 1/128,
					\sustain, 0.5,
					\rel, 0.01,
					\amp, 0.4,
					\dur, 1/4/2,
					\sustain, Pkey(\dur)/1.5,

				)
			).play(~tempoClock);
			Pdef(\pulseSegment_inst,
				Pbind(
					\instrument, \pulseSegment,
					\freq, Pfunc({220.rand + 440*32}),
					\atk, 0.0001,
					\rel, 1/512,
					\amp, 1,
					\pan, Pseq([-0.25,0,0.25, 0, -0.5, 0, 0.5],inf),
					\dur, Pn(1/6, 90)/2
				)
			).play(~tempoClock);


		});
		if(measureSelectNum == 7 && countNum == 0, {

			Pdef(\sineBass_inst,
				Pbind(
					\instrument, \sineBass,
					\freq, Pseq([440*32,440*24],inf),
					\atk, 0,
					//\rel, Pn(Penv([1/16, 1/64], [4])),
					\rel, 0,
					\amp, Pn(Penv([0, 0.5], [8], -4)),
					\dur, 1/24,

				)
			).play(~tempoClock);

		});
		if(measureSelectNum == 8 && countNum == 0, {
			Pdef(\sineBass_inst).stop;
			Pdef(\pulseSegment_inst,
				Pbind(
					\instrument, \pulseSegment,
					\freq, Pseq([Pn(440/2, 3), Pn(440*24, 12)],1),
					\atk, 0,
					\rel, Pseq([Pn(1/256, 3),Pn(1/512, 12)],1),
					\amp, 1,
					\dur, Pseq([Pn(1/2, 3), Pn(1/8,12)], 1)/2
				)
			).play(~tempoClock);

		});
		if(measureSelectNum == 8 && countNum == 2, {

			Pdef(\sineBass_inst,
				Pbind(
					\instrument, \sineBass,
					\midinote, 108,
					\sampleRate, 0.2,
					\atk, 0,
					\decay, 1/128,
					\sustain, 0.125,
					\rel, Pseq([Pn(0.001, 3), 0.01], 1),
					\amp, 0.5,
					//\dur, Pseq([Pn(1/4, 2),Pn(1/3, 2)], 1),
					\dur, Pn(1/4,1),
					\sustain, Pkey(\dur)/2,

				)
			).play(~tempoClock);


		});

		if(measureSelectNum == 9 && countNum == 0, {
			m.sendMsg("/start", 1);

			Pdef(\sine, Pbind(
				\instrument, \saw,
				\out, 0,
				\freq, Pfunc({~sine_freqData = ~sine_freqSeqStream.next; }),
				\dur, Pfunc({~sine_durData = ~sine_durSeqStream.next; }),
				\sustain, Pkey(\dur)/1.125,
				\OSC_Sender, Pfunc({m.sendMsg("/event/sine", ~sine_durData);})
			)).play(~tempoClock);
		});

		if(measureSelectNum == 10 && countNum == 4, {

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

		if(measureSelectNum == 11 && countNum == 0, {

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

		if(measureSelectNum == 15 && countNum == 0, {
			Pdef(\kick, Pbind(\instrument, \kick, \amp, 1,\dur,Pseq([set_1, 8 - set_1],inf))).play(~tempoClock);
			Pdef(\sineBass, Pbind(\instrument, \sin, \freq, 36, \dur, 4, \sustain, 4, \amp, 0.125)).play(~tempoClock);
		});
		if(measureSelectNum == 17 && countNum == 0, {
			Pdef(\kick, Pbind(\instrument, \kick, \amp, 1,\dur,Pseq([set_1, set_2, 8 - set_1 - set_2],inf)))
		});
		if(measureSelectNum == 19 && countNum == 0, {
			~sine_freqSeqStream = Pxrand([108,115,108], inf).asStream;
			Pdef(\sine, Pbind(\instrument, \saw, \freq, Pfunc({~sine_freqData = ~sine_freqSeqStream.next - 5; }),
				\dur, Pfunc({~sine_durData = ~sine_durSeqStream.next; }),
				\sustain, Pkey(\dur)/1.5,
				\OSC_Sender, Pfunc({m.sendMsg("/event/sine", ~sine_durData);})
			));
			Pdef(\kick, Pbind(\instrument, \kick, \amp, 1,\dur,Pseq([set_1, set_2, set_3, 8 - set_1 - set_2 - set_3],inf)))
		});
		if(measureSelectNum == 21 && countNum == 0, {
			Pdef(\kick, Pbind(\instrument, \kick, \amp, 1,\dur,Pseq([set_1, set_2, set_3, set_4, 8 - set_1 - set_2 - set_3 - set_4],inf)))
		});
		if(measureSelectNum == 23 && countNum == 0, {
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

		if(measureSelectNum == 25 && countNum == 0, {
			Pdef(\kick, Pbind(\instrument, \kick, \amp, 1,\dur,Pseq([set_1, set_2, set_3, set_4, set_5, set_1, set_2, set_3, 8 - set_1 - set_2 - set_3 - set_4 - set_5 - set_6 ],inf)))
		});

		if(measureSelectNum == 26 && countNum == 4, {
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

		if(measureSelectNum == 34 && countNum == 0, {//more work!!!!!! something should be happen here.
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

		if(measureSelectNum == 35 && countNum == 0, {
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
		if(measureSelectNum == 39 && countNum == 0, {

			~sine_durSeqStream = Pxrand([Pn(0.125, 6), Pseq([0.125, 0.25, 0.5, 0.125], 1),Pseq([0.125, 0.25, 0.25, 0.125], 1)], inf).asStream;

			Pdef(\logisticMapBass,
				Pbind(\instrument, \logisticMap_Bass,

					\rel, 0,
					\chaos, Pfunc({(0.5).rand + 3}),
					\width, Pfunc({(0.99).rand + 0.5}),
					//\logiFreq, Pkey(\freq)*Pseq([8, 16, 32],inf),
					\dur,Pfunc({
						~sine_durData;
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

		if(measureSelectNum == 43 && countNum == 0, {//
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
					\chaos, Pfunc({(0.5).rand + 3}),
					\width, Pfunc({(0.99).rand + 0.5}),

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
		if(measureSelectNum == 47 && countNum == 0, {
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

		if(measureSelectNum == 51 && countNum == 0, {

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

		if(measureSelectNum == 53 && countNum == 0, {

			Pdef(\sineBass, Pbind(\instrument, \sin, \freq, 29, \dur, 4, \sustain, 4)).play(~tempoClock);

		});

		if(measureSelectNum == 55 && countNum == 0, {
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

		////////////////////////////////////////////////////////////////////////////////////////////
		if(measureSelectNum == 56 && countNum == 0, {
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
		if(measureSelectNum == 63 && countNum == 4, {
			Pdef(\kick,
				Pbind(\instrument, \kick,
					\out, 0,
					\dur, Pfunc({~kick_durData = ~kick_durSeqStream.next}),
					\amp,0,

					\OSC_Sender, Pfunc({m.sendMsg("/event/kick", ~kick_durData);})
				)
			);

		});

		if(measureSelectNum == 64 && countNum == 0, {
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
		if(measureSelectNum == 67 && countNum == 6, {

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
		if(measureSelectNum == 68 && countNum == 0, {
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

		if(measureSelectNum == 71 && countNum == 6, {

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

		if(measureSelectNum == 72 && countNum == 0, {
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


		if(measureSelectNum == 79 && countNum == 4, {

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

		if(measureSelectNum == 80 && countNum == 0, {
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

		if(measureSelectNum == 88 && countNum == 0, {

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
		if(measureSelectNum == 96 && countNum == 0, {


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

		if(measureSelectNum == 104 && countNum == 0, {
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
					\amp, Prand([0.25, 0.5, 0.125, 0.0625],inf),
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
		if(measureSelectNum == 120 && countNum == 0, {
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

		////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

		if(measureSelectNum == 128 && countNum == 0, {
			m.sendMsg("/event/reset", 1);
			~tempoClock = TempoClock(180/60);
			Pdef(\henonC).stop;
			Pdef(\grayNoise).stop;
			Pdef(\kick).stop;
			Pdef(\snare_2).stop;
			Pdef(\sine).stop;


			Pdef(\beat).play(~tempoClock);
			Pdef(\snare).play(~tempoClock);
			Pdef(\grain).play(~tempoClock);
			Pdef(\grain_2).play(~tempoClock);
			Pdef(\sineHit).play(~tempoClock);
			Pdef(\grayNoise).play(~tempoClock);
			Pdef(\amSine).play(~tempoClock);

			Pdef(\sinePulse_L).play(~tempoClock);
			Pdef(\sinePulse_R).play(~tempoClock);
			Pdef(\whiteNoise).play(~tempoClock);

			~kick_durSeqStream = Pseq([8,7,Pn(0.25,4),0.5,7.5,0.5,6,Pn(0.25,6)],inf).asStream;
			~click_durSeqStream = Prand([0.5,Pn(0.25,4)],inf).asStream;
			~grayNoise_durSeqStream = Pseq([6.5,1.5,4,4],inf).asStream;
			~whiteNoise_durSeqStream = Pseq([30.75,1.25],inf).asStream;
			~amSine_durSeqStream = Pseq([11,5],inf).asStream;
			~grainSin_durSeqStream = Pseq([4,12],inf).asStream;
			~grainSin2_durSeqStream = Pseq([24.75,1,6.25],inf).asStream;
			~sineHit_durSeqStream = Pwrand([1,2,0.125],[6,6,1].normalizeSum,inf).asStream;
			~sinePulse_L_durSeqStream = Pxrand([0.5,0.75,0.25,0.5],inf).asStream;
			~sinePulse_R_durSeqStream = Pxrand([0.5,0.75,0.25,0.5],inf).asStream;

			Pdef(\beat,
				Pbind(\instrument,\kick,
					\amp,1,
					\dur,Pfunc({~kick_durData = ~kick_durSeqStream.next}),
					\sustain,Pkey(\dur)-(Pkey(\dur)/1.5),
					\OSC_Sender, Pfunc({m.sendMsg("/event/kick", ~kick_durData);})
				)
			);

			Pdef(\grayNoise,
				Pbind(\instrument,\grayNoise,
					\amp,Pseq([0,0.4,0,0],inf),
					\rel,0,
					\gate,1,
					\dur,Pfunc({~grayNoise_durData = ~grayNoise_durSeqStream.next}),
					\sustain,Prand([180/240,180/180],inf)),
				\OSC_Sender, Pfunc({m.sendMsg("/event/greyNoise", ~grayNoise_durData);})
			);

			Pdef(\whiteNoise,
				Pbind(\instrument,\whiteNoise,
					\amp,Pseq([0,0.25],inf),
					\atk,0,
					\rel,0,
					\gate,1,
					\dur,Pfunc({~whiteNoise_durData = ~whiteNoise_durSeqStream.next}),
					\sustain,Pkey(\dur),
					\OSC_Sender, Pfunc({m.sendMsg("/event/whiteNoise", ~whiteNoise_durData);})
				)
			);

			Pdef(\amSine,
				Pbind(\instrument,\amSine,
					\amp,Pseq([0,0.75,0,0.75],inf),
					\freq,32.midicps,
					\modRate,200/30,
					\modDepth,Pseq([0,0],inf),
					\rel,0,
					\dur,Pfunc({~amSine_durData = ~amSine_durSeqStream.next}),
					\sustain,Pkey(\dur)-(Pkey(\dur)/2)),
				\OSC_Sender, Pfunc({m.sendMsg("/event/amSineNoise", ~amSine_durData);})
			);

			Pdef(\snare,
				Pbind(\instrument,\click,
					\room,0.25,
					\dur,Pfunc({~click_durData = ~click_durSeqStream.next }),
					\gate,1,
					\amp,Prand([0.5,0.25,0.125],inf)/2,
					\sustain,Pkey(\dur)-(Pkey(\dur)/1.5),
					\OSC_Sender, Pfunc({m.sendMsg("/event/click", ~click_durData);})
				)
			);

			Pdef(\grain,
				Pbind(\instrument,\grainSin,
					\amp,Pseq([0,0.75],inf),
					\pulseSpeed,Pseq([24,12,48,36],inf),
					\midiPitch,Pseq([24,12,48,36],inf),
					\freqMod,Prand([0,500,1000,2000,4000,8000],inf),
					\dur,Pfunc({~grainSin_durData = ~grainSin_durSeqStream.next }),
					\OSC_Sender, Pfunc({m.sendMsg("/event/grainSin", ~grainSin_durData);})
				)
			);

			Pdef(\grain_2,
				Pbind(\instrument,\grainSin_2,
					\amp,Pseq([0,0.125,0],inf),
					\pulseSpeed,Pseq([24],inf)*4,
					\midiPitch,120,
					\freqMod,Prand([100,200,400],inf),
					\dur,Pfunc({~grainSin2_durData = ~grainSin2_durSeqStream.next }),
					\sustain,Pkey(\dur)-(Pkey(\dur)/2),
					\OSC_Sender, Pfunc({m.sendMsg("/event/grainSin2", ~grainSin2_durData);})
				)
			);

			Pdef(\sineHit,
				Pbind(\instrument,\sine,
					\rel,0.125,
					\amp,0.125,
					\dur,Pfunc({~sineHit_durData = ~sineHit_durSeqStream.next/0.25 }),
					\OSC_Sender, Pfunc({m.sendMsg("/event/sineHit", ~sineHit_durData);})
				)
			);

			Pdef(\sinePulse_L,
				Pbind(\instrument,\sinePulse,
					\midiPitch,96,
					\pan,-1,
					\decay,0.02,
					\sus,0.25,
					\dur,Pfunc({~sinePulse_L_durData = ~sinePulse_L_durSeqStream.next }),
					\sustain,Pkey(\dur)-(Pkey(\dur)/4)),
				\OSC_Sender, Pfunc({m.sendMsg("/event/sinePulse_L", ~sinePulse_L_durData);})
			);

			Pdef(\sinePulse_R,
				Pbind(\instrument,\sinePulse,
					\midiPitch,96,
					\pan,1,
					\decay,0.02,
					\sus,0.25,
					\dur,Pfunc({~sinePulse_R_durData = ~sinePulse_R_durSeqStream.next }),
					\sustain,Pkey(\dur)-(Pkey(\dur)/4)),
				\OSC_Sender, Pfunc({m.sendMsg("/event/sinePulse_R", ~sinePulse_R_durData);})
			);


		});

		if(measureSelectNum == 136 && countNum == 0, {

			Pdef(\snare,
				Pbind(\instrument,\click,
					\room,Pseq([Pn(1,4),2.5],inf),//Room Change
					\dur,Pfunc({~click_durData = ~click_durSeqStream.next }),
					\gate,1,
					\amp,Prand([0.5,0.25,0.125],inf)/2,
					\sustain,Pkey(\dur)-(Pkey(\dur)/1.5),
					\OSC_Sender, Pfunc({m.sendMsg("/event/click", ~click_durData);})
				)
			);


		});

		if(measureSelectNum==144 && countNum == 0, {

			Pdef(\amSineBass).play(~tempoClock);

			~amSineBass_durSeqStream = Pseq([Pn(0.5,3),2.5,28],inf).asStream;
			Pdef(\amSineBass,
				Pbind(\instrument,\amSine,
					\amp,Pseq([Pn(0.5,3),[0.5,0.25],0],inf),//change
					\freq,Pseq([Pn(39,3),[28,44],32],inf).midicps,//change
					\modRate,200/30,
					\modDepth,Pseq([0,0],inf),
					\rel,0,
					\dur,Pfunc({~amSineBass_durData = ~amSineBass_durSeqStream.next}),
					\sustain,Pseq([Pn(0.25,3),2.5,28],inf),//change
					\OSC_Sender, Pfunc({m.sendMsg("/event/amSineBass", ~amSineBass_durData);})
				)
			).play(~tempoClock);


			~sinePulse_L_durSeqStream = Pxrand([0.5,0.375,0.25,0.5],inf).asStream;
			~sinePulse_R_durSeqStream = Pxrand([0.5,0.375,0.25,0.5],inf).asStream;

			Pdef(\sinePulse_L,
				Pbind(\instrument,\sinePulse,
					\midiPitch,Pxrand([103,108],inf),
					\pan,-1,
					\decay,0.02,
					\sus,0.25,
					\dur,Pfunc({~sinePulse_L_durData = ~sinePulse_L_durSeqStream.next }),
					\sustain,Pkey(\dur)-(Pkey(\dur)/4),
					\OSC_Sender, Pfunc({m.sendMsg("/event/sinePulse_L", ~sinePulse_L_durData);})
				)
			);

			Pdef(\sinePulse_R,
				Pbind(\instrument,\sinePulse,
					\midiPitch,Pxrand([103,108],inf),
					\pan,1,
					\decay,0.02,
					\sus,0.25,
					\dur,Pfunc({~sinePulse_R_durData = ~sinePulse_R_durSeqStream.next }),
					\sustain,Pkey(\dur)-(Pkey(\dur)/4),
					\OSC_Sender, Pfunc({m.sendMsg("/event/sinePulse_R", ~sinePulse_R_durData);})
				)
			);

		});

		if(measureSelectNum == 152 && countNum == 0, {
			Pdef(\beat).stop;
			Pdef(\snare).stop;
			Pdef(\grain).stop;
			Pdef(\grain_2).stop;
			Pdef(\sineHit).stop;
			Pdef(\amSine).stop;
			Pdef(\amSine).reset;
			Pdef(\grayNoise).stop;
			Pdef(\whiteNoise).stop;
			Pdef(\amSineBass).stop;
			Pdef(\sinePulse_L).reset;
			Pdef(\sinePulse_R).reset;

			Synth(\kick);//one hit

			~amSine_durSeqStream = Pseq([13,3],inf).asStream;

			Pdef(\amSine,
				Pbind(\instrument,\amSine,
					\amp,Pseq([0.5,0],inf),
					\freq,25.midicps,
					\modRate,200/30,
					\modDepth,Pseq([0,0],inf),
					\rel,0,
					\dur,Pfunc({~amSine_durData = ~amSine_durSeqStream.next}),
					\sustain,Pkey(\dur),
					\OSC_Sender, Pfunc({m.sendMsg("/event/amSineNoise", ~amSine_durData);})
				)
			).play(~tempoClock);

			~sinePulse_R_durSeqStream = ~sinePulse_L_durSeqStream = Pseq([4],inf).asStream;

			Pdef(\sinePulse_L,
				Pbind(\instrument,\sinePulse,
					\midiPitch,96,
					\pan,-1,
					\decay,0.02,
					\sus,0.25,
					\dur,Pfunc({~sinePulse_L_durData = ~sinePulse_L_durSeqStream.next }),
					\sustain,Pkey(\dur)-(Pkey(\dur)/1.125),
					\OSC_Sender, Pfunc({m.sendMsg("/event/sinePulse_L", ~sinePulse_L_durData);})
				)
			);

			Pdef(\sinePulse_R,
				Pbind(\instrument,\sinePulse,
					\midiPitch,96,
					\pan,1,
					\decay,0.02,
					\sus,0.25,
					\dur,Pfunc({~sinePulse_R_durData = ~sinePulse_R_durSeqStream.next }),
					\sustain,Pkey(\dur)-(Pkey(\dur)/1.125),
					\OSC_Sender, Pfunc({m.sendMsg("/event/sinePulse_R", ~sinePulse_R_durData);})
				)
			);

			~whiteNoise_durSeqStream = Pseq([13,3],1).asStream;

			Pdef(\whiteNoise,
				Pbind(\instrument,\whiteNoise,
					\amp,Pseq([0,0.25],1),
					\atk,0,
					\rel,0,
					\gate,1,
					\dur,Pfunc({~whiteNoise_durData = ~whiteNoise_durSeqStream.next}),
					\sustain,Pkey(\dur),
					\OSC_Sender, Pfunc({m.sendMsg("/event/whiteNoise", ~whiteNoise_durData);})
				)
			).play(~tempoClock);



		});

		if(measureSelectNum == 153 && countNum == 0, {
			Pdef(\grain_2).play(~tempoClock);
			Pdef(\beat).play(~tempoClock);
			Pdef(\snare).play(~tempoClock);
			Pdef(\grain).play(~tempoClock);
			Pdef(\grain_2).play(~tempoClock);
			Pdef(\sineHit).play(~tempoClock);
			Pdef(\grayNoise).play(~tempoClock);
			Pdef(\whiteNoise).play(~tempoClock);
			Pdef(\amSineBass).play(~tempoClock);

			~amSine_durSeqStream = Pseq([11,5],inf).asStream;
			Pdef(\amSine,
				Pbind(\instrument,\amSine,
					\amp,Pseq([0,0.75,0,0.75],inf),
					\freq,32.midicps,
					\modRate,200/30,
					\modDepth,Pseq([0,0],inf),
					\rel,0,
					\dur,Pfunc({~amSine_durData = ~amSine_durSeqStream.next}),
					\sustain,Pkey(\dur)*0.5,
					\OSC_Sender, Pfunc({m.sendMsg("/event/amSineNoise", ~amSine_durData);})
				)
			).reset;

			~whiteNoise_durSeqStream = Pseq([30.75,1.25],inf).asStream;

			Pdef(\whiteNoise,
				Pbind(\instrument,\whiteNoise,
					\amp,Pseq([0,0.25],1),
					\atk,0,
					\rel,0,
					\gate,1,
					\dur,Pfunc({~whiteNoise_durData = ~whiteNoise_durSeqStream.next}),
					\sustain,Pkey(\dur),
					\OSC_Sender, Pfunc({m.sendMsg("/event/whiteNoise", ~whiteNoise_durData);})
				)
			).reset;

			Pdef(\sinePulse_L).reset;
			Pdef(\sinePulse_R).reset;

			~sinePulse_R_durSeqStream = ~sinePulse_L_durSeqStream = Pseq([2],inf).asStream;

			Pdef(\sinePulse_L,
				Pbind(\instrument,\sinePulse,
					\midiPitch,96,
					\pan,-1,
					\decay,0.02,
					\sus,0.25,
					\dur,Pfunc({~sinePulse_L_durData = ~sinePulse_L_durSeqStream.next }),
					\sustain,Pkey(\dur)-(Pkey(\dur)/1.125),
					\OSC_Sender, Pfunc({m.sendMsg("/event/sinePulse_L", ~sinePulse_L_durData);})
				)
			);

			Pdef(\sinePulse_R,
				Pbind(\instrument,\sinePulse,
					\midiPitch,96,
					\pan,1,
					\decay,0.02,
					\sus,0.25,
					\dur,Pfunc({~sinePulse_R_durData = ~sinePulse_R_durSeqStream.next }),
					\sustain,Pkey(\dur)-(Pkey(\dur)/1.125),
					\OSC_Sender, Pfunc({m.sendMsg("/event/sinePulse_R", ~sinePulse_R_durData);})
				)
			);

		});

		if(measureSelectNum == 161 && countNum == 0, {
			Pdef(\beat).stop;
			Pdef(\sineHit).stop;

			~kick_durSeqStream=	Pseq([Pn(0.25,8),6,Pn(0.25,8),5,Pn(0.25,4),0.5,7.5,0.5,Pn(0.5,4),4,Pn(0.25,6)],inf).asStream;

			Pdef(\beat,
				Pbind(\instrument,\kick,
					\amp,1,
					\dur,Pfunc({~kick_durData = ~kick_durSeqStream.next}),
					\sustain,Pkey(\dur)-(Pkey(\dur)/1.5)
				)
			).play(~tempoClock);

			~sineHit_durSeqStream = Pseq([Pn(0.5,1),Pwrand([0.5,Pn(0.5/3,3)],[10,3].normalizeSum,1)],inf).asStream;

			Pdef(\sineHit,
				Pbind(\instrument,\sine,
					\rel,0,
					\amp,Pseq([0.125,0.05,0.05],inf),
					\dur,Pfunc({~sineHit_durData = ~sineHit_durSeqStream.next }),
					\OSC_Sender, Pfunc({m.sendMsg("/event/sineHit", ~sineHit_durData);})
				)
			);

			Pdef(\snare,
				Pbind(\instrument,\click,
					\room,0.25,
					\dur,Pfunc({~click_durData = ~click_durSeqStream.next }),
					\gate,1,
					\amp,Prand([0.5,0.25,0.125],inf)/2,
					\sustain,Pkey(\dur)-(Pkey(\dur)/1.5),
					\OSC_Sender, Pfunc({m.sendMsg("/event/click", ~click_durData);})
				)
			);



		});

		if(measureSelectNum == 169 && countNum == 0, {
			Pdef(\beat).stop;
			//Pdef(\sinePulse_L).stop;
			//Pdef(\sinePulse_R).stop;

			~sinePulse_R_durSeqStream = ~sinePulse_L_durSeqStream = Pseq([0.5,Prand([0.5,Pn(0.25,2)],inf)],inf).asStream;

			Pdef(\sinePulse_L,
				Pbind(\instrument,\sinePulse,
					\midiPitch,96,
					\pan,-1,
					\decay,0.02,
					\sus,0.25,
					\dur,Pfunc({~sinePulse_L_durData = ~sinePulse_L_durSeqStream.next }),
					\sustain,Pkey(\dur)-(Pkey(\dur)/4),
					\OSC_Sender, Pfunc({m.sendMsg("/event/sinePulse_L", ~sinePulse_L_durData);})
				)
			);

			Pdef(\sinePulse_R,
				Pbind(\instrument,\sinePulse,
					\midiPitch,96,
					\pan,1,
					\decay,0.02,
					\sus,0.25,
					\dur,Pfunc({~sinePulse_R_durData = ~sinePulse_R_durSeqStream.next }),
					\sustain,Pkey(\dur)-(Pkey(\dur)/4),
					\OSC_Sender, Pfunc({m.sendMsg("/event/sinePulse_R", ~sinePulse_R_durData);})
				)
			);

			~kick_durSeqStream=	Pseq([
				Prand(
					[
						Pseq([Pn(0.25,8),6],1),
						Pseq([1,Pn(0.25,8),5],1)
					],
					1),
				Prand(
					[
						Pseq([7,Pn(0.25,4)],1),
						Pseq([5,Pn(0.25,8)],1)
					],
					1),
				Prand(
					[
						Pseq([0.5,7,0.5],1),
						Pseq([0.5,3.5,Pn(0.25,6),0.5,Pn(0.25,8)],1)
					],
					1),
				Prand(
					[
						Pseq([0.5,6,Pn(0.25,6)],1),
						Pseq([0.5,Pn(0.25,8),4,Pn(0.25,6)],1),
						Pseq([1.5,Pn(0.25,4),1,Pn(0.25,10),0.5,Pn(0.25,6)],1)
					],
					1);
				],inf
			).asStream;

			Pdef(\snare,
				Pbind(\instrument,\click,
					\room,Pseq([Pn(1,4),2.5],inf),
					\dur,Pfunc({~click_durData = ~click_durSeqStream.next }),
					\gate,1,\amp,Prand([0.5,0.25,0.125],inf)/2,
					\sustain,Pkey(\dur)-(Pkey(\dur)/1.5),
					\OSC_Sender, Pfunc({m.sendMsg("/event/click", ~click_durData);})
				)
			);

			Pdef(\beat,
				Pbind(\instrument,\kick,
					\amp,1,
					\dur,Pfunc({~kick_durData = ~kick_durSeqStream.next}),
					\sustain,Pkey(\dur)-(Pkey(\dur)/1.5)
				)
			).play(~tempoClock);

			~chord_durSeqStream = 0.25;

			Pdef(\chord,
				Pbind(\instrument,\chord,
					\midiPitch,Pxrand([[48,53,55],[48,53,57],[50,53,55]],inf),
					\atk,0.25,
					\rel,0.25,
					\amp,0.0625/2,
					\gate,1,
					\dur,~chord_durSeqStream,
					\OSC_Sender, Pfunc({m.sendMsg("/event/chord", ~chord_durData);})
				)

			).play(~tempoClock);


		});

		if(measureSelectNum == 177 && countNum == 0, {
			Pdef(\beat).stop;
			Pdef(\sinePulse_L).stop;
			Pdef(\sinePulse_R).stop;

			~sinePulse_R_durSeqStream = ~sinePulse_L_durSeqStream = Pxrand([0.5,0.375,0.25,0.5],inf).asStream;

			Pdef(\sinePulse_L,
				Pbind(\instrument,\sinePulse,
					\midiPitch,Pxrand([103,108],inf),
					\pan,-1,
					\decay,0.02,
					\sus,0.25,
					\dur,Pfunc({~sinePulse_L_durData = ~sinePulse_L_durSeqStream.next }),
					\sustain,Pkey(\dur)-(Pkey(\dur)/4),
					\OSC_Sender, Pfunc({m.sendMsg("/event/sinePulse_L", ~sinePulse_L_durData);})
				)
			).play(~tempoClock);

			Pdef(\sinePulse_R,
				Pbind(\instrument,\sinePulse,
					\midiPitch,Pxrand([103,108],inf),
					\pan,1,
					\decay,0.02,
					\sus,0.25,
					\dur,Pfunc({~sinePulse_R_durData = ~sinePulse_R_durSeqStream.next }),
					\sustain,Pkey(\dur)-(Pkey(\dur)/4),
					\OSC_Sender, Pfunc({m.sendMsg("/event/sinePulse_R", ~sinePulse_R_durData);})
				)

			).play(~tempoClock);

			Pdef(\chord).stop;

			Pdef(\chord,
				Pbind(\instrument,\chord,
					\midiPitch,Pxrand([[60,53,55],[60,53,57],[62,53,55]],inf),
					\atk,0.25,
					\rel,0.25,
					\amp,0.0625/2,
					\gate,1,
					\dur,~chord_durSeqStream,
					\OSC_Sender, Pfunc({m.sendMsg("/event/chord", ~chord_durData);})
				)
			).play(~tempoClock);

			~kick_durSeqStream=	Pseq([
				Prand([
					Pseq([Pn(0.25,8),Pn(0.5,2),0.5,Pn(0.25,6),Pn(0.5,4)],1),
					Pseq([1,Pn(0.25,8),Pn(0.5,2),Pn(0.25,8),Pn(0.25,8)],1)
				],1),
				Prand([
					Pseq([Pn(0.25,8),Pn(0.5,2),Pn(0.25,8),Pn(0.5,4),Pn(0.25,4)],1),
					Pseq([Pn(0.25,8),Pn(0.5,2),Pn(0.25,6),0.5,Pn(0.25,8)],1)
				],1),
				Prand([
					Pseq([0.5,0.5,Pn(0.5,2),Pn(0.25,4),Pn(0.25,6),0.5,Pn(0.25,8),Pn(0.5,2)],1),
					Pseq([0.5,Pn(0.5,4),0.5,Pn(0.5,2),Pn(0.25,6),0.5,Pn(0.25,8)],1)
				],1),
				Prand(
					[
						Pseq([0.5,Pn(0.5,4),Pn(0.25,8),Pn(0.5,4),Pn(0.25,6)],1),
						Pseq([0.5,Pn(0.25,8),Pn(0.5,2),Pn(0.5,6),Pn(0.25,6)],1),
						Pseq([Pn(0.5,3),Pn(0.25,4),Pn(0.5,2),Pn(0.25,10),0.5,Pn(0.25,6)],1)
					],
					1);
				],inf
			).asStream;


			Pdef(\beat,
				Pbind(\instrument,\kick,
					\amp,1,
					\rel,0.03125/4,
					\dur,Pfunc({~kick_durData = ~kick_durSeqStream.next})
				)
			).play(~tempoClock);

			~amSine_durSeqStream = Pseq([256],inf).asStream;
			Pdef(\amSine,
				Pbind(\instrument,\amSine,
					\amp,0.5,
					\freq,[25,37].midicps,
					\modRate,200/30,
					\modDepth,Pseq([0,0],inf),
					\rel,0,
					\dur,Pfunc({~amSine_durData = ~amSine_durSeqStream.next}),
					\sustain,Pkey(\dur),
					\OSC_Sender, Pfunc({m.sendMsg("/event/amSineNoise", ~amSine_durData);})
				)
			);

			Pdef(\amSineBass).stop;
		});

		if(measureSelectNum == 185 && countNum == 0, {
			Synth(\kick).stop;
			Pdef(\beat).stop;
			Pdef(\snare).stop;
			Pdef(\grain).stop;
			Pdef(\grain_2).stop;
			Pdef(\sineHit).stop;
			Pdef(\amSine).stop;
			Pdef(\grayNoise).stop;
			Pdef(\whiteNoise).stop;
			Pdef(\amSineBass).stop;
			Synth(\kick);
			//Pdef(\sinePulse_L).stop;
			//Pdef(\sinePulse_R).stop;

		});

		if(measureSelectNum == 193 && countNum == 0, {

			Pdef(\sinePulse_L).stop;
			Pdef(\sinePulse_R).stop;

		});


		if(measureSelectNum == 201 && countNum == 0, {

			Pdef(\chord).stop;


		});
		if(measureSelectNum == 202 && countNum == 0, {

			Pdef(\sine).stop;
			m.sendMsg("/event/end", 1);


		});


		1.wait;
	})
}).play(~tempoClock)

)



