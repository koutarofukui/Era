

(

var countNum, measureSelectNum;
Pdef(\saw_1).stop;
Pdef(\saw_2).stop;
Pdef(\saw_3).stop;
Pdef(\pink).stop;
Pdef(\loopBass).stop;
Pdef(\revSaw).stop;
Pdef(\sinPulse).stop;
measureSelectNum = 0;
countNum = 0;

~tempoClock = TempoClock(180/60);
~ampLevel = 1.5;
~break_section_Task =
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
			//~reverb = Synth.after(1, \reverb);
			~reverb.set(\in, 33,\mix, 0.5, \room, 0.99, \dump, 0.01);
			~atk = 0.125;
			~rel = 0.5;
			~sustain = Pkey(\dur);
			~data = [4, 7, 9, 14, 10];
			//~data = [0, 5];
			//~data = [0, 7];
			~indice = [0, 1, 2, 3, 4];
			Pdef(\saw_1,
				Pbind(\instrument, \sawSynth,
					\choice, Prand(~indice, inf),
					\amp, Pfunc({0.125.rand + 0.03125})*~ampLevel,
					\midinote, Pindex(~data, Pkey(\choice), inf) + 48,
					\phase, Pfunc({1.0.rand}),
					\detune, Pfunc({1.0.rand}),
					\dur, 0.125,
					\sustain, ~sustain,
					\atk, ~atk,
					\rel, ~rel,
					\pan, Pfunc({2.0.rand - 1.0 })
				)
			).play(~tempoClock);
			Pdef(\pink,
				Pbind(\instrument, \resNoise,
					\amp, 0.0625*~ampLevel,
					\midinote, [45, 48],
					\phase, Pfunc({1.0.rand}),
					\dur, 1,
					\sustain, ~sustain,
					\atk, 0.25,
					\rel, 1,
					\pan, Pfunc({2.0.rand - 1.0 })
				)
			).play(~tempoClock);

		});

		if(measureSelectNum == 17 && countNum == 0, {
			m.sendMsg("/event/modeType", 6);
			Pdef(\saw_2,
				Pbind(\instrument, \sawSynth,
					\amp, Pfunc({0.03125.rand + 0.03125})*~ampLevel,
					\midinote, 108,
					\dur, Pxrand([Pn(0.5, 2), Pn(0.25, 3), Pn(0.25, 1)], inf),
					\sustain, ~sustain*0.75,
					\atk, 0.0005,
					\rel, 0.0005,
					\pan, Pfunc({2.0.rand - 1.0})
				)
			).play(~tempoClock);
			Pdef(\saw_3,
				Pbind(\instrument, \sawSynth,
					\amp, Pfunc({0.03125.rand + 0.03125})/2.5*~ampLevel,
					\midinote, 127,
					\dur, 0.125,
					\sustain, ~sustain/16,
					\atk, 0.0,
					\rel, 0.015/1.5,
					\pan, Prand([-1, 1],inf)
				)
			).play(~tempoClock);
		});

		if(measureSelectNum == 33 && countNum == 0, {
			Pdef(\sinPulse,
				Pbind(\instrument, \loopBass,
					\amp, Pseq([0.03125, 0], inf)/1.5*~ampLevel,
					\midinote, 84,
					\dur, Pseq([12, 4], inf)/8,
					\sustain, ~sustain/2,
					\atk, 0.0001,
					\decay, 0.03125/2,
					\sus, 0.75,
					\rel, 0.0001
				)
			).play(~tempoClock);

		});

		if(measureSelectNum == 49 && countNum == 0, {
			m.sendMsg("/event/modeType", 7);
			Pdef(\loopBass,
				Pbind(\instrument, \loopBass,
					\amp, Pseq([0.125, 0], inf)*~ampLevel,
					\midinote, 31,
					\dur, Pseq([12, 4], inf),
					\sustain, ~sustain,
					\atk, 0.0005,
					\rel, 0.004,
					\pan, 0,
					\osc, Pfunc({arg env;
						m.sendMsg("/event/loopBassAmp", env[\amp]);
					})
				)
			).play(~tempoClock);


		});
		if(measureSelectNum == 63 && countNum == 0, {
			Pdef(\revSaw, Pbind(
				\instrument, \revSaw,
				\out, [0, 33],
				\freq, 120,
				\amp, Pseq([0, 0.125], inf)*~ampLevel,
				\dur, Pseq([12, 4], inf),
				\sustain, 0.125/2,
				\panPos, 0,
				\osc, Pfunc({arg env;
						m.sendMsg("/event/revSaw", env[\amp]);
					})
			)).play(~tempoClock);
		});
		if(measureSelectNum == 64 && countNum == 4, {
			Pdef(\saw_1).stop;
			Pdef(\saw_2).stop;
			Pdef(\saw_3).stop;
			Pdef(\pink).stop;
			Pdef(\sinPulse).stop;

		});
		if(measureSelectNum == 65 && countNum == 0, {
			Pdef(\saw_1,
				Pbind(\instrument, \sawSynth,
					\choice, Prand(~indice, inf),
					\amp, Pfunc({0.125.rand + 0.03125})*~ampLevel,
					\midinote, Pindex(~data, Pkey(\choice), inf) + 48,
					\phase, Pfunc({1.0.rand}),
					\detune, Pfunc({1.0.rand}),
					\dur, 0.125,
					\sustain, ~sustain,
					\atk, ~atk,
					\rel, ~rel,
					\pan, Pfunc({2.0.rand - 1.0 })
				)
			).play(~tempoClock);

			Pdef(\saw_2,
				Pbind(\instrument, \sawSynth,
					\amp, Pfunc({0.03125.rand + 0.03125})*~ampLevel,
					\midinote, 120,//108
					\dur, Pxrand([Pn(0.5, 2), Pn(0.25, 3), Pn(0.25, 1)], inf),
					\sustain, ~sustain*0.75,
					\atk, 0.0005,
					\rel, 0.0005,
					\pan, Pfunc({2.0.rand - 1.0})
				)
			).play(~tempoClock);

			Pdef(\sinPulse,
				Pbind(\instrument, \loopBass,
					\amp, Pseq([0.03125, 0], inf)/1.5*~ampLevel,
					\midinote, 84,
					\dur, Pseq([12, 4], inf)/32,
					\sustain, ~sustain/2,
					\atk, 0.0001,
					\decay, 0.03125/2,
					\sus, 0.75,
					\rel, 0.0001
				)
			).play(~tempoClock);

			Pdef(\pink,
				Pbind(\instrument, \resNoise,
					\amp, 0.0625*~ampLevel,
					\midinote, [45, 48],
					\phase, Pfunc({1.0.rand}),
					\dur, 1,
					\sustain, ~sustain,
					\atk, 0.25,
					\rel, 1,
					\pan, Pfunc({2.0.rand - 1.0 })
				)
			).play(~tempoClock);

			Pdef(\saw_3,
				Pbind(\instrument, \sawSynth,
					\amp, Pfunc({0.03125.rand + 0.03125}),
					\midinote, 127,
					\dur, 0.125,
					\sustain, ~sustain/16,
					\atk, 0.0,
					\rel, 0.015,
					\pan, Prand([-1, 1],inf)
				)
			).play(~tempoClock);


		});
		if(measureSelectNum == 73 && countNum == 0, {
			Pdef(\saw_2,
				Pbind(\instrument, \sawSynth,
					\amp, Pfunc({0.03125.rand + 0.03125})*~ampLevel,
					\midinote, 108,
					\dur, Pxrand([Pn(0.5, 2), Pn(0.25, 3), Pn(0.25, 1)], inf),
					\sustain, ~sustain*0.75,
					\atk, 0.0005,
					\rel, 0.0005,
					\pan, Pfunc({2.0.rand - 1.0})
				)
			).play(~tempoClock);

		});
		if(measureSelectNum == 96 && countNum == 4, {

			Pdef(\saw_1).stop;
			Pdef(\saw_2).stop;
			Pdef(\saw_3).stop;
			Pdef(\pink).stop;
			Pdef(\sinPulse).stop;

		});
		if(measureSelectNum == 97 && countNum == 0, {
			Pdef(\sinPulse,
				Pbind(\instrument, \loopBass,
					\amp, Pseq([0.03125, 0], inf)/1.5*~ampLevel,
					\midinote, 84,
					\dur, Pseq([12, 4], inf)/8,
					\sustain, ~sustain/2,
					\atk, 0.0001,
					\decay, 0.03125/2,
					\sus, 0.75,
					\rel, 0.0001,
					\pan, Pseq([-1, 1],inf)
				)
			).play(~tempoClock);


		});
		if(measureSelectNum == 108 && countNum == 0, {
			Pdef(\saw_3,
				Pbind(\instrument, \sawSynth,
					\amp, Pfunc({0.03125.rand + 0.03125})*~ampLevel,
					\midinote, 127,
					\dur, 0.125,
					\sustain, ~sustain/16,
					\atk, 0.0,
					\rel, 0.015,
					\pan, Prand([-1, 1],inf)
				)
			).play(~tempoClock);
			Pdef(\sinPulse,
				Pbind(\instrument, \loopBass,
					\amp, Pseq([0.03125, 0.03125/2], inf)/1.5*~ampLevel,
					\midinote, 84,
					\dur, 1,
					\sustain, Pseq([~sustain/1.5, ~sustain/8], inf),
					\atk, 0.0001,
					\decay, 0.03125/2,
					\sus, 0.75,
					\rel, 0.0001,
					\pan, Pseq([-1, 1],inf)
				)
			).play(~tempoClock);


		});
		if(measureSelectNum == 120 && countNum == 4, {
			Pdef(\saw_3).stop;
			Pdef(\sinPulse).stop;
		});

		if(measureSelectNum == 121 && countNum == 0, {
			Pdef(\loopBass).stop;
			Pdef(\revSaw).stop;

		});


		1.wait;
	})
});

~break_section_Task.play(TempoClock(180/60));

)