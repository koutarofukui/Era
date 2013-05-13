(

var countNum, measureSelectNum;

measureSelectNum = 0;
countNum = 0;
~intro_section_Task =
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
					\bitRate, 32,
					\sampleRate,1,
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
					\sampleRate,0.999,
					\pan, Pn(Penv([-1, 2], [4])),
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
					\sampleRate,0.99,
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
					// \freq, 440 * 8,
					\rel, 1/128,
					\sampleRate, Prand([0.125,0.25, 0.5], inf)/4,
					\bitRate, Pn(Penv([8, 1], [4])),
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
					\pan, Pn(Penv([1, -1], [4])),
					\sampleRate, 0.75,
					\bitRate, 4,
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
					\amp, 0.125,
					\dur, Pseq([Pn(1/16, 8),Pn(1/32, 48)],1)

				)
			).play(~tempoClock);

		});
		//
		if(measureSelectNum == 3 && countNum == 4, {
			Pdef(\sineBass_inst).stop;
			Pdef(\pulseSegment_inst,
				Pbind(
					\instrument, \pulseSegment,
					\freq, Pn(Penv([440*16, 440*32, 440*32],[4, 6],2)),
					\sampleRate, Pn(Penv([1, 1, 0.125],[8, 2],2)),
					\bitRate, Pn(Penv([32, 32, 4],[8, 2],2)),
					\atk, 0,
					\rel, 1/128,
					\amp, 0.75,
					\dur, 1/6,
					\dur, Pn(Penv([1/6, 1/6, 1/12],[8, 2],2))
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
					\sampleRate, Pn(Penv([0.01, 0.04, 0.06], [2, 2], 0)),
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
					//\sampleRate, Prand([0.125,0.25, 0.5], inf)/4,
					\bitRate, Prand([0, 1, 2, 3 , 4],inf),
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
			Pdef(\sineBass2_inst,
				Pbind(
					\instrument, \sineBass,
					\midinote, 108,
					\sampleRate, 0.2,
					\atk, 0,
					\decay, 1/128,
					\sustain, 0.125,
					\rel, 0.01,
					//\amp, Pseq([Pseq([Pn(36, 2), Pn(41,14)], 1), Pseq([Pn(36, 4), Pn(41,12)], 1), Pseq([Pn(36, 6), Pn(41,22)], 1)],1),
					\amp, Pseq([Pseq([Pn(0.5, 1), Pn(0,15)], 1), Pseq([Pn(0.5, 2), Pn(0,14)], 1), Pseq([Pn(0.5, 4), Pn(0,24)], 1)],1)/2,
					//\dur, Pseq([Pn(1/4, 2),Pn(1/3, 2)], 1),
					\dur, 1/4/2,
					\sustain, Pkey(\dur)/2,

				)
			).play(~tempoClock);


		});
		if(measureSelectNum == 7 && countNum == 0, {
			Pdef(\sineBass2_inst).stop;
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
					\out, 0,
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


		1.wait;
	})
});

~intro_section_Task.play(~tempoClock);

)