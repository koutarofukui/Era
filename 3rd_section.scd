(

var countNum, measureSelectNum;

measureSelectNum = 0;
countNum = 0;

~tempoClock = TempoClock(180/60);
~third_section_Task =
Task({
	inf.do({
		|i|

		countNum = i % 8; // time measure

		//Print"count"&"measure"
		if(countNum == 0,
			{
				measureSelectNum = measureSelectNum  + 1;
				("measure : "++ measureSelectNum).postln;

			}
		);

		("count : "++ countNum).postln;


		////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

		if(measureSelectNum == 1 && countNum == 0, {
			m.sendMsg("/event/reset", 1);

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
			~sineHit_durSeqStream = Pwrand([1,2,1],[6,6,1].normalizeSum,inf).asStream; //
			~sinePulse_L_durSeqStream = Pxrand([0.25,0.25,0.5,Pn(0.25, 4)],inf).asStream;
			~sinePulse_R_durSeqStream = Pxrand([0.25,0.25,0.5,Pn(0.25, 4)],inf).asStream;

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


			~sinePulse_L_durSeqStream = Pxrand([0.25,0.25,0.5,Pn(0.25, 4)],inf).asStream;
			~sinePulse_R_durSeqStream = Pxrand([0.25,0.25,0.5,Pn(0.25, 4)],inf).asStream;

			Pdef(\sinePulse_L,
				Pbind(\instrument,\sinePulse,
					//\midiPitch,Pxrand([103,108],inf),
					\pan,-1,
					\decay,0.02,
					\sus,0.25,
					\dur,Pfunc({~sinePulse_L_durData = ~sinePulse_L_durSeqStream.next }),
					\midiPitch, Pfunc({if(~sinePulse_L_durData == 0.5, 108, 103)}),
					\sustain,Pkey(\dur)-(Pkey(\dur)/4),
					\OSC_Sender, Pfunc({m.sendMsg("/event/sinePulse_L", ~sinePulse_L_durData);})
				)
			);

			Pdef(\sinePulse_R,
				Pbind(\instrument,\sinePulse,
					//\midiPitch,Pxrand([103,108],inf),
					\pan,1,
					\decay,0.02,
					\sus,0.25,
					\dur,Pfunc({~sinePulse_R_durData = ~sinePulse_R_durSeqStream.next }),
					\midiPitch, Pfunc({if(~sinePulse_R_durData == 0.5, 108, 103)}),
					\sustain,Pkey(\dur)-(Pkey(\dur)/4),
					\OSC_Sender, Pfunc({m.sendMsg("/event/sinePulse_R", ~sinePulse_R_durData);})
				)
			);

		});

		if(measureSelectNum == 25 && countNum == 0, {
			Pdef(\beat).stop;
			Pdef(\beat).reset;
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

		if(measureSelectNum == 26 && countNum == 0, {
			Pdef(\grain_2).play(~tempoClock);
			Pdef(\beat).play(~tempoClock);
			Pdef(\snare).play(~tempoClock);
			Pdef(\grain).play(~tempoClock);
			Pdef(\grain_2).play(~tempoClock);
			Pdef(\sineHit).play(~tempoClock);
			Pdef(\grayNoise).play(~tempoClock);
			Pdef(\whiteNoise).play(~tempoClock);
			Pdef(\amSineBass).play(~tempoClock);

			~kick_durSeqStream = Pseq([8,7,Pn(0.25,4),0.5,7.5,0.5,6,Pn(0.25,6)],inf).asStream;

			Pdef(\beat,
				Pbind(\instrument,\kick,
					\amp,1,
					\dur,Pfunc({~kick_durData = ~kick_durSeqStream.next}),
					\sustain,Pkey(\dur)-(Pkey(\dur)/1.5),
					\OSC_Sender, Pfunc({m.sendMsg("/event/kick", ~kick_durData);})
				)
			);

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
		if(measureSelectNum == 32 && countNum == 0, {
			~sinePulse_R_durSeqStream = ~sinePulse_L_durSeqStream = Pseq([1],inf).asStream;

			Pdef(\sinePulse_L,
				Pbind(\instrument,\sinePulse,
					\midiPitch,96,
					\pan,-1,
					\decay,0.02,
					\sus,0.25,
					\dur,Pfunc({~sinePulse_L_durData = ~sinePulse_L_durSeqStream.next }),
					\sustain,Pkey(\dur)-(Pkey(\dur)/1.5),
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
					\sustain,Pkey(\dur)-(Pkey(\dur)/1.5),
					\OSC_Sender, Pfunc({m.sendMsg("/event/sinePulse_R", ~sinePulse_R_durData);})
				)
			);

		});

		if(measureSelectNum == 34 && countNum == 0, {
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

		if(measureSelectNum == 42 && countNum == 0, {
			Pdef(\beat).stop;
			Pdef(\beat).reset;

			Pdef(\amSineBass).reset;
			~sinePulse_R_durSeqStream = ~sinePulse_L_durSeqStream = Pseq([0.5,Prand([0.5,Pn(0.25,2)],inf)],inf).asStream;

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
			/////////////////////////////////////
			~kick_durSeqStream=	Pseq([Pn(0.25,8),6,Pn(0.25,8),5,Pn(0.25,4),0.5,7.5,0.5,Pn(0.5,4),4,Pn(0.25,6)],inf).asStream;

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
					\amp,0.0625/3,
					\gate,1,
					\dur,~chord_durSeqStream,
					\sustain, 0.5,
					\OSC_Sender, Pfunc({m.sendMsg("/event/chord", ~chord_durData);})
				)

			).play(~tempoClock);


		});

		if(measureSelectNum == 50 && countNum == 0, {
			Pdef(\beat).stop;
			Pdef(\sinePulse_L).stop;
			Pdef(\sinePulse_R).stop;

			~sinePulse_R_durSeqStream = ~sinePulse_L_durSeqStream = Pxrand([0.25,0.25,0.5,Pn(0.25, 4)],inf).asStream;

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
					\amp,0.0625/3,
					\gate,1,
					\dur,~chord_durSeqStream,
					\sustain, 0.5,
					\OSC_Sender, Pfunc({m.sendMsg("/event/chord", ~chord_durData);})
				)
			).play(~tempoClock);

			~kick_durSeqStream=
			Pseq([
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
				Prand([
					Pseq([0.5,Pn(0.5,4),Pn(0.25,8),Pn(0.5,4),Pn(0.25,6)],1),
					Pseq([0.5,Pn(0.25,8),Pn(0.5,2),Pn(0.5,6),Pn(0.25,6)],1),
					Pseq([Pn(0.5,3),Pn(0.25,4),Pn(0.5,2),Pn(0.25,10),0.5,Pn(0.25,6)],1)
				],1);
				],inf
			).asStream;


			Pdef(\beat,
				Pbind(\instrument,\kick,
					\amp,1,
					\rel,0.03125/4,
					\dur,Pfunc({~kick_durData = ~kick_durSeqStream.next})
				)
			).play(~tempoClock);

			~amSine_durSeqStream = Pseq([32],inf).asStream;
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

		if(measureSelectNum == 58 && countNum == 0, {
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

		if(measureSelectNum == 62 && countNum == 0, {

			Pdef(\sinePulse_L).stop;
			Pdef(\sinePulse_R).stop;

		});


		if(measureSelectNum == 66 && countNum == 0, {

			Pdef(\chord).stop;


		});





		1.wait;
	})
});

~third_section_Task.play(TempoClock(90/60));

)