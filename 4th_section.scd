(

var countNum, measureSelectNum;

measureSelectNum = 0;
countNum = 0;

~tempoClock = TempoClock(180/60);
~fourth_section_Task =
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

//193
		if(measureSelectNum == 1 && countNum == 0, {
			~loop_SinewaveSeq = Pseq([Pn(72, 3),Pn(79, 3)],inf);
			~rand_SinewaveSeq = Prand([Pseq([Pn(72, 3),Pn(79, 3)],1), Pseq([Pn(72, 1), Pn(79, 2)],1), Pseq([Pn(72, 2), Pn(79, 1)],1)], inf);
			Pdef(\sineWave,
				Pbind(
					\instrument, \sineWave,
					\midinote, Pseq([Pn(72, 3),Pn(79, 3)],inf) + 0,
					\midinote, Prand([Pseq([Pn(72, 3),Pn(79, 3)],1), Pseq([Pn(72, 1), Pn(79, 2)],1)], inf) + 0,
					\dur, Pseq([Pn(0.25, 2), 0.5, Pn(0.25, 4) ],inf),
					\amp, Pn(Penv([0.0625, 0.25],[16],-3)),
					\sustain, Pkey(\dur)/1.5
				)
			).play(~tempoClock);


		});

		if(measureSelectNum == 2 && countNum == 0, {
			Pdef(\kick).stop;
			Pdef(\sine).stop;
			m.sendMsg("/event/end", 1);

			//3rd Part

			~thirdPart_indices = [1,0];

			~seq_1 = Pseq([1.5, Pn(0.5, 3), 1.5, Pn(0.5, 3), Pn(0.25, 8)],1);
			~seq_length_1 = Pseq([1, Prand([0.125, 0.25, 0.375], 3), 1, Pseq([Prand([0.125,0.25], 3),Pn(0.125, 8)], 1) ],1);

			~seq_2 = Pseq([1.5, Pn(0.5, 3), 1.5, Pn(0.5, 7)],1);
			~seq_length_2 = Pseq([1, Prand([0.125, 0.25, 0.375], 3), 1, Prand([0.125,0.25], 7)],1);

			~data_dur = [~seq_1, ~seq_2];
			~data_length = [~seq_length_1, ~seq_length_2];

			/////////

			~kickSeq_1 = Pseq([2.5, 0.5,1,1.75, 0.75,1.5, 2, 0.5,0.5,1,0.75,0.75,1.5,1], 1);

			~kickSeq_2 = Pseq([2.5,1,0.5,1.75,0.75,0.75, 0.25,0.25,0.25, 2, 0.5,0.5,1,0.75, 0.75,0.75,0.5, 0.25,0.25,0.75],1);

			~kick_data_dur = [~kickSeq_1, ~kickSeq_2];

			/////////

			~sourceOsc = Synth.before(1, \phasorNoise);
			~sourceOsc.set(\out, 37);

			~stutterOsc = Synth.before(1, \stutter);
			~stutterOsc.set(\out, 39);


			/////////
			~thirdPart_snareIndices = [0,1,2];
			~snareSeq_1 = Pseq([0.25,0.25,0.5,Pseq([0.5,0.5,Pn(Pseq([0.5,0.25,0.25],1),3),], 3), 0.5, 0.5,0.5,0.5],inf);
			~snareSeq_Length_1 = Pseq([0.125,0.125,0.375,Pseq([Prand([0.25, 0.375, 0.5],1),0.125,Pn(Pseq([0.375,0.125,0.125],1),3),], 3), 0.375, 0.25,Prand([0.25, 0.375, 0.5],1),0.25],inf);
			~snareSeq_2 = Pseq([0.25,0.25,Pn(0.25, 2),Pseq([0.5,0.5,Pn(Pseq([0.5,0.25,0.25],1),3),], 3), 0.5, Pn(0.25,6)],inf);
			~snareSeq_Length_2 = Pseq([0.125,0.125,Pn(0.125,2),Pseq([Prand([0.25, 0.375, 0.5],1),0.125,Pn(Pseq([0.375,0.125,0.125],1),3),], 3), 0.375, Pn(0.125, 6)],inf);

			~snareSeq_3 = Pseq([0.25,0.25,Pn(0.25, 2),Pseq([Pn(0.25, 4),Pn(Pseq([0.5,0.25,0.25],1),3),], 3), Pn(0.25,8)],inf);
			~snareSeq_Length_3 = Pseq([0.125,0.125,Pn(0.125,2),Pseq([Pn(0.125, 4),Pn(Pseq([0.375,0.125,0.125],1),3),], 3), Pn(0.125, 8)],inf);

			~snare_data_dur = [~snareSeq_1, ~snareSeq_2, ~snareSeq_3];
			~snare_data_length = [~snareSeq_Length_1, ~snareSeq_Length_2,~snareSeq_Length_3];

			~tempoClock = TempoClock(180/60);

			Pdef(\sineWave,
				Pbind(
					\instrument, \sineWave,
					\midinote, ~rand_SinewaveSeq + 0,
					\dur, Pseq([Pn(0.25, 2), 0.5, Pn(0.25, 4) ],inf),
					\amp, 0.25,
					\sustain, Pkey(\dur)/1.5
				)
			).play(~tempoClock);

			Pdef(\sineBass,
				Pbind(\instrument, \sin,
					\choice, Prand([Pseq(~thirdPart_indices, 1), Pseq(~thirdPart_indices.reverse, 1)], inf),
					\out, 0,
					\freq, 31,
					\atk, 0.005,
					\decay, 0.02,
					\sus, 0.25,
					\rel, 0.01,
					\dur, Pindex(~data_dur,Pkey(\choice), inf),
					\amp, 1,
					\sustain, Pindex(~data_length,Pkey(\choice), inf),

				)
			).play(~tempoClock);

			Pdef(\kick,
				Pbind(\instrument, \kick,
					\choice, Prand([Pseq(~thirdPart_indices, 1), Pseq(~thirdPart_indices.reverse, 1)], inf),
					\dur, Pindex(~kick_data_dur, Pkey(\choice),inf),
					\rel,Pkey(\dur)/16 + 0.03125,
					\amp,0.5,
				)
			).play(~tempoClock);

			Pdef(\phasorNoise,
				Pbind(
					\instrument, \envelopeGen,
					\group, 1,
					\outBus, 39,
					\choice, Prand([Pseq(~thirdPart_snareIndices, 1), Pseq(~thirdPart_snareIndices.reverse, 1)], inf),
					\dur, Pindex(~snare_data_dur,Pkey(\choice), inf),

					\sustain, Pindex(~snare_data_length,Pkey(\choice), inf),
					\amp, Prand([0.35, 0.25],inf),
					\rel, 0,
					\decay, 0.02,
					\sus, 0,
					\atk, 0,
					\pan, Prand([-0.75, 0.75],inf)
				)
			).play(~tempoClock);




		});

		if(measureSelectNum == 6 && countNum == 0, {


			Pdef(\snare_2,
				Pbind(\instrument,\click_2,
					\out, 0,
					\room,Pxrand([0.125,0.25, 0.5, 0.75],inf),
					//\dur,Prand([Pn(0.25, Prand([2, 4], 1)),Pn(0.125,Prand([2, 4], 1))],inf)*2,
					\dur,0.25,
					\gate,1,
					\amp,Prand([0.75,0.5,0.25],inf),
					\sustain,Pkey(\dur)-(Pkey(\dur)/1.5),
			)).play(~tempoClock);

		});

		if(measureSelectNum == 10 && countNum == 0, {
			Pdef(\phasorNoise,
				Pbind(
					\instrument, \envelopeGen,
					\group, 1,
					\outBus, 0,
					\choice, Prand([Pseq(~thirdPart_snareIndices, 1), Pseq(~thirdPart_snareIndices.reverse, 1)], inf),
					\dur, Pindex(~snare_data_dur,Pkey(\choice), inf),

					\sustain, Pindex(~snare_data_length,Pkey(\choice), inf),
					\amp, Prand([0.35, 0.25],inf),
					\rel, 0,
					\decay, 0.02,
					\sus, 0.3,
					\atk, 0,
					\pan, Prand([-0.75, 0.75],inf)
				)
			).play(~tempoClock);

		});
		if(measureSelectNum == 11 && countNum == 4, {
			Pdef(\sineWave).stop;
			Pdef(\phasorNoise,
				Pbind(
					\instrument, \envelopeGen,
					\group, 1,
					\outBus, 39,
					\choice, Prand([Pseq(~thirdPart_snareIndices, 1), Pseq(~thirdPart_snareIndices.reverse, 1)], inf),
					\dur, Pindex(~snare_data_dur,Pkey(\choice), inf),

					\sustain, Pindex(~snare_data_length,Pkey(\choice), inf),
					\amp, Prand([0.35, 0.25],inf),
					\rel, 0,
					\decay, 0.02,
					\sus, 0.3,
					\atk, 0,
					\pan, Prand([-0.75, 0.75],inf)
				)
			).play(~tempoClock);

			Pdef(\stutter,
				Pbind(
					\instrument, \stutter,
					\group, 1,
					\outBus, 0,
					\dur, 0.125,
					\rel, 0,
					\decay, 0,
					\sus, 0.5,
					\atk, 0,
					\sustain, Pkey(\dur),
					\amp, Pseq([1,0],inf),
				)
			).play(~tempoClock);

		});
		if(measureSelectNum == 12 && countNum == 0, {

			Pdef(\phasorNoise,
				Pbind(
					\instrument, \envelopeGen,
					\group, 1,
					\outBus, 0,
					\choice, Prand([Pseq(~thirdPart_snareIndices, 1), Pseq(~thirdPart_snareIndices.reverse, 1)], inf),
					\dur, Pindex(~snare_data_dur,Pkey(\choice), inf),

					\sustain, Pindex(~snare_data_length,Pkey(\choice), inf),
					\amp, Prand([0.35, 0.25],inf),
					\rel, 0,
					\decay, 0.02,
					\sus, 0.3,
					\atk, 0,
					\pan, Prand([-0.75, 0.75],inf)
				)
			).play(~tempoClock);

			Pdef(\sineWave,
				Pbind(
					\instrument, \sineWave,
					\midinote, ~loop_SinewaveSeq + 12,
					\dur, Pseq([Pn(0.25, 2), 0.5, Pn(0.25, 4) ],inf),
					\amp, 0.4,
					\sustain, Pkey(\dur)/1.5
				)
			).play(~tempoClock);



		});
		if(measureSelectNum == 15 && countNum == 4, {
			Pdef(\sineBass,
				Pbind(\instrument, \sin,
					\out, 0,
					\freq, 31,
					\atk, 0.005,
					\decay, 0.02,
					\sus, 0.25,
					\rel, 0.01,
					\dur, Pn(0.5, 16),
					\amp, 1,
					\sustain, Pkey(\dur)/2

				)
			).play(~tempoClock);
			Pdef(\kick,
				Pbind(\instrument, \kick,
					\dur, Pn(0.5, 13),//check
					\amp,0.5,
				)
			).play(~tempoClock);

			Pdef(\phasorNoise,
				Pbind(
					\instrument, \envelopeGen,
					\group, 1,
					\outBus, 39,
					\choice, Prand([Pseq(~thirdPart_snareIndices, 1), Pseq(~thirdPart_snareIndices.reverse, 1)], inf),
					\dur, Pindex(~snare_data_dur,Pkey(\choice), inf),

					\sustain, Pindex(~snare_data_length,Pkey(\choice), inf),
					\amp, Prand([0.35, 0.25],inf),
					\rel, 0,
					\decay, 0.02,
					\sus, 0.3,
					\atk, 0,
					\pan, Prand([-0.75, 0.75],inf)
				)
			).play(~tempoClock);

			Pdef(\stutter,
				Pbind(
					\instrument, \stutter,
					\group, 1,
					\outBus, 0,
					\dur, 0.125,
					\rel, 0,
					\decay, 0,
					\sus, 0.5,
					\atk, 0,
					\sustain, Pkey(\dur),
					\amp, Pseq([1,0],inf),
				)
			).play(~tempoClock);

			Pdef(\sineWave,
				Pbind(
					\instrument, \sineWave,
					\midinote, ~rand_SinewaveSeq + 0,
					\dur, Pseq([Pn(0.25, 2), 0.5, Pn(0.25, 4) ],inf),
					\amp, 0.4,
					\sustain, Pkey(\dur)/1.5
				)
			).play(~tempoClock);

			Pdef(\pulseSnare,
				Pbind(
					\instrument, \pulseSnare,
					\dur, 4,
					\amp, 0.5,
					\sustain, Pkey(\dur)
				)
			).play(~tempoClock);


		});

		if(measureSelectNum == 16 && countNum == 0, {
			Pdef(\phasorNoise).stop;
			Pdef(\sineBass,
				Pbind(\instrument, \sin,
					\out, 0,
					\freq, 31,
					\atk, 0.005,
					\decay, 0.02,
					\sus, 0.25,
					\rel, 0.01,
					\dur, 8,
					\amp, 1,
					\sustain, Pkey(\dur)/2

				)
			).play(~tempoClock);
			Pdef(\kick,
				Pbind(\instrument, \kick,

					\dur, Pn(0.5, 1),
					\amp,0.5,
				)
			).play(~tempoClock);

			Pdef(\sineWave,
				Pbind(
					\instrument, \sineWave,
					\midinote, ~rand_SinewaveSeq + 12,
					\dur, Pseq([Pn(0.25, 2), 0.5, Pn(0.25, 4) ],inf),
					\amp, 0.4,
					\sustain, Pkey(\dur)/1.5
				)
			).play(~tempoClock);

			Pdef(\pulseSnare,
				Pbind(
					\instrument, \pulseSnare,
					\dur, Pseq([1.5, 1.5, 4, Pn(0.25, 4),  1.5, Pn(0.25, 6), 3.5, Pn(0.5, 3),  1.5, Pn(0.25, 6), 3.5, Pn(0.25, 6)],inf),
					\amp, 0.75,
					\sustain, Pkey(\dur)/3
				)
			).play(~tempoClock);

		});
		if(measureSelectNum == 18 && countNum == 0, {
			Pdef(\sineBass,
				Pbind(\instrument, \sin,
					\choice, Prand([Pseq(~thirdPart_indices, 1), Pseq(~thirdPart_indices.reverse, 1)], inf),
					\out, 0,
					\freq, 31,
					\atk, 0.005,
					\decay, 0.02,
					\sus, 0.25,
					\rel, 0.01,
					\dur, Pindex(~data_dur,Pkey(\choice), inf),
					\amp, 1,
					\sustain, Pindex(~data_length,Pkey(\choice), inf),

				)
			).play(~tempoClock);
			Pdef(\kick,
				Pbind(\instrument, \kick,
					\choice, Prand([Pseq(~thirdPart_indices, 1), Pseq(~thirdPart_indices.reverse, 1)], inf),
					\dur, Pindex(~kick_data_dur, Pkey(\choice),inf),
					\rel,Pkey(\dur)/16 + 0.03125,
					\amp,0.5,
				)
			).play(~tempoClock);

			Pdef(\snare_2,
				Pbind(\instrument,\click_2,
					\out, 0,
					\room,Pxrand([0.125,0.25, 0.5, 0.75],inf),
					//\dur,Prand([Pn(0.25, Prand([2, 4], 1)),Pn(0.125,Prand([2, 4], 1))],inf)*2,
					\dur,0.25,
					\gate,1,
					\amp,Prand([0.75,0.5,0.25],inf),
					\sustain,Pkey(\dur)-(Pkey(\dur)/1.5),
			)).play(~tempoClock);

			Pdef(\phasorNoise,
				Pbind(
					\instrument, \envelopeGen,
					\group, 1,
					\outBus, 0,
					\choice, Prand([Pseq(~thirdPart_snareIndices, 1), Pseq(~thirdPart_snareIndices.reverse, 1)], inf),
					\dur, Pindex(~snare_data_dur,Pkey(\choice), inf),

					\sustain, Pindex(~snare_data_length,Pkey(\choice), inf),
					\amp, Prand([0.35, 0.25],inf),
					\rel, 0,
					\decay, 0.02,
					\sus, 0.3,
					\atk, 0,
					\pan, Prand([-0.75, 0.75],inf)
				)
			).play(~tempoClock);

			Pdef(\sineWave,
				Pbind(
					\instrument, \sineWave,
					\midinote, ~rand_SinewaveSeq + 24,
					\dur, Pseq([Pn(0.25, 2), 0.5, Pn(0.25, 4) ],inf),
					\amp, 0.4,
					\sustain, Pkey(\dur)/1.5
				)
			).play(~tempoClock);

			Pdef(\pulseSnare,
				Pbind(
					\instrument, \pulseSnare,
					\dur, Pseq([1.5, 1.5, 4, Pn(0.25, 4),  1.5, Pn(0.25, 6), 3.5, Pn(0.5, 3),  1.5, Pn(0.25, 6), 3.5, Pn(0.25, 6)],inf),
					\amp, 0.75,
					\sustain, Pkey(\dur)/3
				)
			).play(~tempoClock);

		});
		if(measureSelectNum == 22 && countNum == 0, {

			Pdef(\phasorNoise).stop;
			Pdef(\phasorNoise,
				Pbind(
					\instrument, \envelopeGen,
					\group, 1,
					\outBus, 0,
					\dur, Pseq([1.5, 1.5, 4, Pn(0.25, 4),  1.5, Pn(0.25, 6), 3.5, Pn(0.5, 3),  1.5, Pn(0.25, 6), 3.5, Pn(0.25, 6)],inf),
					\amp, Prand([0.35, 0.25],inf),
					\rel, 0,
					\decay, 0.02,
					\sus, 0.3,
					\atk, 0,
					\sustain, Pkey(\dur)/3
				)
			).play(~tempoClock);

			Pdef(\pulseSnare,
				Pbind(
					\instrument, \pulseSnare,

					\choice, Prand([Pseq(~thirdPart_snareIndices, 1), Pseq(~thirdPart_snareIndices.reverse, 1)], inf),
					\dur, Pindex(~snare_data_dur,Pkey(\choice), inf),

					\sustain, Pindex(~snare_data_length,Pkey(\choice), inf),
					\amp, Prand([0.35, 0.25],inf),
					\pan, Prand([-0.75, 0.75],inf)
				)
			).play(~tempoClock);

			Pdef(\sineWave,
				Pbind(
					\instrument, \sineWave,
					\midinote, ~rand_SinewaveSeq + 12,
					\dur, Pseq([Pn(0.25, 2), 0.5, Pn(0.25, 4) ],inf),
					\amp, 0.4,
					\sustain, Pkey(\dur)/1.5
				)
			).play(~tempoClock);

			Pdef(\sineWave_octave,
				Pbind(
					\instrument, \sineWave,
					\midinote, Pseq([Pn(72, 3),Pn(79, 3)],inf) + 36,
					\dur, Pxrand([Pn(0.25, 2), 0.5, Pn(0.25, 4) ],inf),
					\amp, 0.2,
					\sustain, Pkey(\dur)/1.5
				)
			).play(~tempoClock);

		});
		if(measureSelectNum == 29 && countNum == 4, {
			Pdef(\kick,
				Pbind(\instrument, \kick,

					\dur, Pn(0.5, 1),
					\amp,0.5,
				)
			).play(~tempoClock);

			Pdef(\sineWave).stop;
			Pdef(\snare_2).stop;
			Pdef(\sineBass).stop;
			Pdef(\pulseSnare,
				Pbind(
					\instrument, \pulseSnare,
					\dur, 4,
					\amp, 0.125,
					\sustain, Pkey(\dur)
				)
			).play(~tempoClock);



		});
		if(measureSelectNum == 30 && countNum == 0, {
			Pdef(\sineWave_octave).reset;
			Pdef(\sineWave).reset;
			Pdef(\sineWave_octave,
				Pbind(
					\instrument, \sineWave,
					\midinote, ~rand_SinewaveSeq + 36,
					\dur, Pseq([Pn(0.25, 2), 0.5, Pn(0.25, 4) ],inf),
					\amp, 0.4,
					\sustain, Pkey(\dur)/1.5
				)
			).play(~tempoClock);
			Pdef(\sineWave,
				Pbind(
					\instrument, \sineWave,
					\midinote, Pseq([Pn(72, 3),Pn(79, 3)],inf) + 0,
					\dur, Pseq([Pn(0.25, 2), 0.5, Pn(0.25, 4) ],inf),
					\amp, 0.4,
					\sustain, Pkey(\dur)/1.5
				)
			).play(~tempoClock);

			Pdef(\sineBass,
				Pbind(\instrument, \sin,
					\choice, Prand([Pseq(~thirdPart_indices, 1), Pseq(~thirdPart_indices.reverse, 1)], inf),
					\out, 0,
					\freq, 31,
					\atk, 0.005,
					\decay, 0.02,
					\sus, 0.25,
					\rel, 0.01,
					\dur, Pindex(~data_dur,Pkey(\choice), inf),
					\amp, 1,
					\sustain, Pindex(~data_length,Pkey(\choice), inf),

				)
			).play(~tempoClock);

			Pdef(\kick,
				Pbind(\instrument, \kick,
					\choice, Prand([Pseq(~thirdPart_indices, 1), Pseq(~thirdPart_indices.reverse, 1)], inf),
					\dur, Pindex(~kick_data_dur, Pkey(\choice),inf),
					\rel,Pkey(\dur)/16 + 0.03125,
					\amp,0.5,
				)
			).play(~tempoClock);

			Pdef(\snare_2,
				Pbind(\instrument,\click_2,
					\out, 0,
					\room,Pxrand([0.125,0.25, 0.5, 0.75],inf),
					//\dur,Prand([Pn(0.25, Prand([2, 4], 1)),Pn(0.125,Prand([2, 4], 1))],inf)*2,
					\dur,0.25,
					\gate,1,
					\amp,Prand([0.75,0.5,0.25],inf),
					\sustain,Pkey(\dur)-(Pkey(\dur)/1.5),
			)).play(~tempoClock);

			Pdef(\phasorNoise,
				Pbind(
					\instrument, \envelopeGen,
					\group, 1,
					\outBus, 0,
					\choice, Prand([Pseq(~thirdPart_snareIndices, 1), Pseq(~thirdPart_snareIndices.reverse, 1)], inf),
					\dur, Pindex(~snare_data_dur,Pkey(\choice), inf),

					\sustain, Pindex(~snare_data_length,Pkey(\choice), inf),
					\amp, Prand([0.35, 0.25],inf),
					\rel, 0,
					\decay, 0.02,
					\sus, 0.3,
					\atk, 0,
					\pan, Prand([-0.75, 0.75],inf)
				)
			).play(~tempoClock);

			Pdef(\pulseSnare,
				Pbind(
					\instrument, \pulseSnare,
					\dur, Pseq([1.5, 1.5, 4, Pn(0.25, 4),  1.5, Pn(0.25, 6), 3.5, Pn(0.5, 3),  1.5, Pn(0.25, 6), 3.5, Pn(0.25, 6)],inf),
					\amp, 0.75,
					\sustain, Pkey(\dur)/3
				)
			).play(~tempoClock);


		});
		if(measureSelectNum == 33 && countNum == 4, {
			Pdef(\phasorNoise,
				Pbind(
					\instrument, \envelopeGen,
					\group, 1,
					\outBus, 39,
					\choice, Prand([Pseq(~thirdPart_snareIndices, 1), Pseq(~thirdPart_snareIndices.reverse, 1)], inf),
					\dur, Pindex(~snare_data_dur,Pkey(\choice), inf),

					\sustain, Pindex(~snare_data_length,Pkey(\choice), inf),
					\amp, Prand([0.35, 0.25],inf),
					\rel, 0,
					\decay, 0.02,
					\sus, 0.3,
					\atk, 0,
					\pan, Prand([-0.75, 0.75],inf)
				)
			).play(~tempoClock);

			Pdef(\stutter,
				Pbind(
					\instrument, \stutter,
					\group, 1,
					\outBus, 0,
					\dur, 0.125,
					\rel, 0,
					\decay, 0,
					\sus, 0.5,
					\atk, 0,
					\sustain, Pkey(\dur),
					\amp, Pseq([1,0],inf),
				)
			).play(~tempoClock);

		});
		if(measureSelectNum == 34 && countNum == 0, {
			Pdef(\phasorNoise,
				Pbind(
					\instrument, \envelopeGen,
					\group, 1,
					\outBus, 0,
					\choice, Prand([Pseq(~thirdPart_snareIndices, 1), Pseq(~thirdPart_snareIndices.reverse, 1)], inf),
					\dur, Pindex(~snare_data_dur,Pkey(\choice), inf),

					\sustain, Pindex(~snare_data_length,Pkey(\choice), inf),
					\amp, Prand([0.35, 0.25],inf),
					\rel, 0,
					\decay, 0.02,
					\sus, 0.3,
					\atk, 0,
					\pan, Prand([-0.75, 0.75],inf)
				)
			).play(~tempoClock);

		});
		if(measureSelectNum == 37 && countNum == 4, {
			Pdef(\phasorNoise,
				Pbind(
					\instrument, \envelopeGen,
					\group, 1,
					\outBus, 39,
					\choice, Prand([Pseq(~thirdPart_snareIndices, 1), Pseq(~thirdPart_snareIndices.reverse, 1)], inf),
					\dur, Pindex(~snare_data_dur,Pkey(\choice), inf),

					\sustain, Pindex(~snare_data_length,Pkey(\choice), inf),
					\amp, Prand([0.35, 0.25],inf),
					\rel, 0,
					\decay, 0.02,
					\sus, 0.3,
					\atk, 0,
					\pan, Prand([-0.75, 0.75],inf)
				)
			).play(~tempoClock);

			Pdef(\stutter,
				Pbind(
					\instrument, \stutter,
					\group, 1,
					\outBus, 0,
					\dur, 0.125,
					\rel, 0,
					\decay, 0,
					\sus, 0.5,
					\atk, 0,
					\sustain, Pkey(\dur),
					\amp, Pseq([1,0],inf),
				)
			).play(~tempoClock);

		});
		if(measureSelectNum == 38 && countNum == 0, {
			Pdef(\phasorNoise).stop;
			Pdef(\pulseSnare).stop;
			Pdef(\snare_2).stop;
			Pdef(\sineBass).stop;
			Pdef(\pulseSnare).stop;
			Pdef(\kick,
				Pbind(\instrument, \kick,

					\dur, Pn(0.5, 1),
					\amp,0.5,
				)
			).play(~tempoClock);
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
////////////////////////////////////////////////////////////////
		});
		if(measureSelectNum == 42 && countNum == 0, {

			Pdef(\sineWave_octave,
				Pbind(
					\instrument, \sineWave,
					\midinote, ~rand_SinewaveSeq + 36,
					\dur, Pn(Penv([0.25, 0.25/8],[64],0)),
					\sampleRate, Pn(Penv([0.25, 0.25/8],[16],0)),
					\bitRate, Pn(Penv([32, 1],[64],0)),
					\amp, Pn(Penv([0.4, 0],[96],-4)),
					\sampleRate, Pn(Penv([1, 0.01],[64],0)),
					\bitRate, Pn(Penv([32, 1],[64],0)),
					\sustain, Pkey(\dur)/1.5
				)
			).play(~tempoClock);

			Pdef(\sineWave,
				Pbind(
					\instrument, \sineWave,
					\midinote, ~rand_SinewaveSeq + 0,
					\dur, Pn(Penv([0.25, 0.25/8],[64],0)),
					\sampleRate, Pn(Penv([1, 0.01],[64],0)),
					\bitRate, Pn(Penv([32, 1],[64],0)),
					\amp, Pn(Penv([0.4, 0],[96],-4)),
					\sustain, Pkey(\dur)/1.5
				)
			).play(~tempoClock);


		});
		if(measureSelectNum == 46 && countNum == 0, {

			Pdef(\sineWave_octave).stop;
			Pdef(\sineWave).stop;
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
					\dur, Pn(1/4,1),
					\sustain, Pkey(\dur)/2,

				)
			).play(~tempoClock);

		});


		1.wait;
	})
});

~fourth_section_Task.play(TempoClock(90/60));

)