//1
SynthDef(\pulseSegment,
	{|out = 0, freq, atk = 0, rel = 0.125, amp = 1, sampleRate = 1, bitRate = 32, pan = 0|
		var osc, ampEnv, pitchEnv;
		ampEnv = EnvGen.kr(Env.perc(atk, rel, amp, -8), doneAction:2);
		osc = SinOsc.ar(freq, 0, amp).distort();
		osc = Decimator.ar(osc,LinLin.kr(sampleRate, 0, 1, 0, SampleRate.ir), bitRate);
		osc = Pan2.ar(osc, pan);
		Out.ar(out, osc * ampEnv);
	}
).store;
//2
SynthDef(\noise,
	{|out = 0, gate = 1, freq, atk = 0, decay=0,sus = 1, rel = 0.125, amp = 1, sampleRate = 0.5, bitRate = 32, pan = 0|
		var osc, ampEnv;
		ampEnv = EnvGen.kr(Env.adsr(atk, decay, sus, rel, amp, -4), gate, doneAction:2);
		osc = WhiteNoise.ar(amp);
		osc = Decimator.ar(osc,LinLin.kr(sampleRate, 0, 1, 0, SampleRate.ir), bitRate);
		osc = Pan2.ar(osc, 0);
		Out.ar(out, osc * ampEnv);
	}
).store;
//3
SynthDef(\sineBass,
	{|out = 0, gate = 1, freq, atk = 0, decay=0,sus = 1, rel = 0.125, amp = 1, sampleRate = 0.5, bitRate = 0, pan = 0|
		var osc, ampEnv;
		ampEnv = EnvGen.kr(Env.adsr(atk, decay, sus, rel, amp, -4), gate, doneAction:2);
		osc = SinOsc.ar(freq, 0, amp);
		osc = Latch.ar(osc, Impulse.ar(LinLin.kr(sampleRate, 0, 1, 0, SampleRate.ir)));
		osc = Pan2.ar(osc, 0);
		Out.ar(out, osc * ampEnv);
	}
).store;

///////////////////////////////////////////////////////////////////////////////////////



~cellNum = 256;
~cellBufNum = 80;
~cellBuf = Buffer.alloc(s, ~cellNum * 2, 1, bufnum: ~cellBufNum);
~array = Array.fill(~cellNum, {[0,1].choose});
~tempArray = Array.fill(~cellNum, {[0,1].choose});

//Update Cellular Automaton

~update = {~cellNum.do({|i|
	var counter, left, center, right;

	counter = i % ~cellNum;
	left = if((counter - 1) < 0, {~cellNum - 1}, {counter - 1});
	center = counter;
	right = if((counter + 1) > (~cellNum-1), {0}, {counter + 1});

	if(~array[left] == 1 && ~array[center] == 1 && ~array[right] == 1, {~tempArray[counter] = 0});
	if(~array[left] == 1 && ~array[center] == 1 && ~array[right] == 0, {~tempArray[counter] = 0});
	if(~array[left] == 1 && ~array[center] == 0 && ~array[right] == 1, {~tempArray[counter] = 0});
	if(~array[left] == 1 && ~array[center] == 0 && ~array[right] == 0, {~tempArray[counter] = 1});
	if(~array[left] == 0 && ~array[center] == 1 && ~array[right] == 1, {~tempArray[counter] = 1});
	if(~array[left] == 0 && ~array[center] == 1 && ~array[right] == 0, {~tempArray[counter] = 1});
	if(~array[left] == 0 && ~array[center] == 0 && ~array[right] == 1, {~tempArray[counter] = 1});
	if(~array[left] == 0 && ~array[center] == 0 && ~array[right] == 0, {~tempArray[counter] = 0});

	});

	~array = ~tempArray.copy;
	~array.postln;
	~sig = Signal.fill(~cellNum, { |i| ~array[i] });
	~cellBuf.loadCollection(~sig.asWavetable);

};

//SynthDef

SynthDef(\cellSynth,
	{ |modFreq = 800, modWidth = 500, freq = 60, gate =1, amp = 0.5, panSpeed = 1|
		var mainOsc, modOsc,panmodOsc, en, eg;
		en = Env.adsr(0.01, 0.25, 1, 0.01);
		eg = EnvGen.kr(en, gate, doneAction:2);
		modOsc = Osc.kr(~cellBufNum, modFreq, 0, 1);
		panmodOsc = Osc.kr(~cellBufNum, panSpeed.midicps, 0, 2, -1).range(-1, 1) * -1;
		mainOsc = Osc.ar(80, modOsc*modWidth + freq.midicps, 0, 1);
		mainOsc = Pan2.ar(mainOsc, panmodOsc, 0.125);
		Out.ar(0, mainOsc * eg * amp);
}).store;


//4
SynthDef(\sin, {
	|out = 0, freq, amp = 0.125, gate = 1, panPos = 0,atk = 0.001, decay = 0, sus = 1, rel = 0.025|

	var osc, env;

	osc = SinOsc.ar(freq.midicps, 0, amp);
	env = EnvGen.kr(Env.adsr(atk,0.05,sus,rel),gate,  doneAction:2);
	osc = osc * env;
	osc = Pan2.ar(osc, panPos);
	out = Out.ar(out, osc);

}).store;
//5
SynthDef(\saw, {
	|out = 0, freq, amp = 0.125, gate = 1, sampleRate = 0.5, bitRate = 32, panPos = 0|

	var osc, env;
	osc = Saw.ar(freq.midicps, amp);

	env = EnvGen.kr(Env.adsr(0.0,0 ,1,0.0),gate,  doneAction:2);
	osc = osc * env;
	osc = Decimator.ar(osc,LinLin.kr(sampleRate, 0, 1, 0, SampleRate.ir), bitRate);
	osc = Pan2.ar(osc, panPos);
	out = Out.ar(out, osc);

}).store;
//6
SynthDef(\logisticMap_Bass, {
	|out = 0, amp =1, gate=1, atk=0 ,decay=0, sus=1, rel=0, width=0.25, chaos=3, freq, logiFreq = 100, init = 0.125|
	var osc, mod, env;
	mod = Logistic.kr(chaos, logiFreq, init, 1);
	osc = Pulse.ar(freq, width);
	osc = RLPF.ar(osc, mod * 15000, 0.75);
	env = EnvGen.kr(Env.adsr(atk, decay, sus, rel), gate, doneAction:2);
	osc = osc * env * amp;
	osc = Pan2.ar(osc);
	Out.ar(out, osc);
}).store;
//
SynthDef(\kick, {|out = 0, atk= 0, rel= 0.03125, amp= 1, pan = 0|
	var e= EnvGen.ar(Env.perc(atk, rel), doneAction:2);
	var z= SinOsc.ar(e * 100 +50, 0, amp);
	z = Pan2.ar(z, pan, 1.5).distort;
	Out.ar(out, z*e);
}).store;

//7
SynthDef(\logisticMap_Synth, {
	|out = 0, amp =1, gate=1, atk=0 ,decay=0, sus=1, rel=0, chaos=3, logiFreq = 100, init = 0.125|
	var osc, mod, env;
	osc = Logistic.ar(chaos, logiFreq, init, 1);
	env = EnvGen.kr(Env.adsr(atk, decay, sus, rel), gate, doneAction:2);
	osc = osc * env * amp;
	osc = Pan2.ar(osc);
	Out.ar(out, osc);
}).store;

//8
SynthDef(\henonC, {
	|out =0, freq, amp = 0.125, gate = 1, param_a = 0.5, param_b = 0.5|

	var osc, env, mod;
	osc = SinOsc.ar(freq.midicps, 0, amp);
	mod = HenonC.ar(SampleRate.ir/4, param_a, param_b/2, 0.25, 0.25) ;
	osc = osc * mod;
	osc = Limiter.ar(osc, 0.5, 0.001);
	env = EnvGen.kr(Env.adsr(0.001,0,1,0.001),gate,  doneAction:2);
	osc = osc * env * 0.8;
	osc = Pan2.ar(osc);
	Out.ar(out, osc);

}).store;

//9
SynthDef(\allpassPulse, {
	|out = 0, freq, gate = 1, atk = 0.0001, decay= 0, sus = 0, rel = 0.00001 , amp = 1|
	var osc, env;
	osc = Pulse.ar(freq, 0.01, 1);
	osc = osc + AllpassN.ar(osc, 0.5, 0.02, 1, 1, 0);
	osc = RHPF.ar(osc, 10000, 1, 1, 0);
	env = EnvGen.ar(Env.adsr(atk, decay, sus, rel, 1, -4));
	osc = osc * env;
	osc = Pan2.ar(osc, 0, amp);
	Out.ar(out, osc);
}).store;

//10
SynthDef(\puls, {
	|out = 0, freq, gate = 1, atk = 0, decay= 0.25, sus = 0, rel = 0.00001 , amp = 1|
	var osc, env;
	osc = Pulse.ar(freq, 0.01, 1);
	osc = osc + AllpassN.ar(osc, 0.5, 0.02, 1, 1, 0);
	osc = RLPF.ar(osc, 300, 0.125, 1, 0);
	env = EnvGen.kr(Env.adsr(atk, decay, sus, rel, 1, -4), gate, doneAction:2);
	osc = osc * env;
	osc = Pan2.ar(osc, 0, amp);
	Out.ar(out, osc);
}).store;
//11
SynthDef(\kick, {|out = 0, atk= 0, rel= 0.03125, amp= 1, pan = 0|
	var e= EnvGen.ar(Env.perc(atk, rel), doneAction:2);
	var z= SinOsc.ar(e * 100 +50, 0, amp);
	z = Pan2.ar(z, pan, 1.5).distort;
	Out.ar(out, z*e);
}).store;
//12
SynthDef(\click, {|out = 0, rel= 0.5, mix= 0.5, room= 0.25, amp= 1, damp= 0.9, pan= 0|
	var e= Line.kr(0, 1, rel);
	var z= Impulse.ar(0)+BrownNoise.ar(1)*Line.ar(1, 0, room*0.01,  doneAction:2);
	z = Pan2.ar(z, LFNoise2.kr(64), amp );
	Out.ar(out, z);
}).store;
//13
SynthDef(\click_2, {|out = 0,rel= 0.5, mix= 0.5, room= 0.25, amp= 1, damp= 0.9, pan= 0|
	var e= Line.kr(0, 1, rel);
	var z= Impulse.ar(0)+BrownNoise.ar(1)*Line.ar(1, 0, room*0.01,  doneAction:2);
	z = RHPF.ar(z, 10000, 0.25);
	z = Pan2.ar(z, LFNoise2.kr(64), amp );
	Out.ar(out, z);
}).store;
//14
SynthDef(\sine, {|out = 0,atk= 0.01, rel= 0.0125, amp= 1|
	var e= EnvGen.ar(Env.perc(atk, rel), doneAction:2);
	var z= SinOsc.ar(120.midicps, 0, amp);
	z = Pan2.ar(z*e, 0, 1);
	2.do({ z = AllpassL.ar(z, 0.1, LFNoise2.kr([rrand(0.01, 0.1),rrand(0.01, 0.1)],0.15,0.15), 2) });
	Out.ar(out, z);
}).store;
//15
SynthDef(\whiteNoise, {|atk= 0, rel= 0.125, gate = 1, amp= 1|
	var e= EnvGen.ar(Env.adsr(atk,0.2, 0.5, rel, curve: -8), gate, doneAction:2);
	var z= RHPF.ar(WhiteNoise.ar(1), 17500, 0.5) ;

	z = Pan2.ar(z*e, 0, amp);
	Out.ar(0, z);
}).store;

//16
SynthDef(\grayNoise, {|out = 0,atk= 0, rel= 0.125, gate = 1, amp= 1|
	var e= EnvGen.ar(Env.adsr(atk,0, 1, rel, curve: -8), gate, doneAction:2);
	var z= RLPF.ar(Dust2.ar(LFNoise2.kr([60, 50], TRand.kr(500, 20000, gate), 100), 0.5, 0) + GrayNoise.ar(0.125), LFNoise2.kr([3, 4], 1000, 3000), 0.5, 1, 0) ;

	z = Pan2.ar(z*e, 0, amp);
	Out.ar(out, z);
}).store;


//beatloop//

//17
~winenv = Env([0, 1, 0], [0.5, 0.5], [128, -128]);
z = Buffer.sendCollection(s, ~winenv.discretize, 1);


SynthDef(\grainSin, {arg out = 0, midiPitch = 48,pulseSpeed = 24,  freqMod = 0, amp = 0.005, envbuf;
	var pan, env, freqdev, grainSource;

	pan = WhiteNoise.kr(1);
	freqdev = WhiteNoise.kr(freqMod);
	~envbuf = z;
	env = EnvGen.kr(
		Env.perc( 0, 0.5, 0.5, -1, \welch ),
		levelScale: amp,
		doneAction: 2);
	grainSource = GrainSin.ar(2, Impulse.kr(pulseSpeed), 0.1, midiPitch.midicps + freqdev, pan, envbuf);
	Out.ar(out,
		grainSource * amp)
}).store;
//18
SynthDef(\grainSin_2, {arg out = 0, midiPitch = 48,pulseSpeed = 24, gate = 1, freqMod = 0, amp = 0.005, envbuf;
	var pan, env, freqdev, grainSource;

	pan = WhiteNoise.kr(1);
	freqdev = WhiteNoise.kr(freqMod);
	envbuf = z;
	env = EnvGen.kr(
		Env.adsr( 0, 0, 1,0, -4),
		gate,
		levelScale: amp,
		doneAction: 2);
	grainSource = GrainSin.ar(2, Impulse.kr(pulseSpeed), 0.1, midiPitch.midicps + freqdev, pan, ~envbuf);
	grainSource = RHPF.ar(grainSource, midiPitch.midicps, 0.75, 1, 0);
	Out.ar(out,
		grainSource * amp)
}).store;

//19
SynthDef(\amSine, {|out = 0, freq = 36, atk= 0, rel= 0, gate = 1, amp= 1, modRate = 0, modDepth = 0|
	var e= EnvGen.ar(Env.adsr(atk,0, 1, rel), gate, doneAction:2);
	var z= SinOsc.ar(freq, 0, amp) * (1.0 - SinOsc.kr(modRate, 0, modDepth, 0).abs) ;
	z = Pan2.ar(z, 0, 0.5);

	Out.ar(out, z*e);
}).store;

//20
SynthDef(\sinePulse, {|out = 0, midiPitch = 96, gate = 1, atk = 0.0001, decay = 0, sus = 1, rel = 0, amp= 1, pan = 0 |
	var e= EnvGen.ar(Env.adsr(atk, decay, sus, rel, curve: -2), gate, doneAction: 2);
	var z= SinOsc.ar(midiPitch.midicps + rrand(0.01, 0.1), 0, 1, 0);
	z = Pan2.ar(z*e, pan, amp/4);

	Out.ar(out, z );
}).store;

//21
SynthDef(\chord, {|out = 0, midiPitch = 84, gate = 1, atk = 0, decay = 0, sus = 1, rel = 0, amp = 1, pan = 0 |
	var e= EnvGen.kr(Env.adsr(atk, decay, sus, rel, curve: -2), gate, doneAction: 2);
	var osc= Saw.ar((midiPitch - 2).midicps + rrand(0.01, 0.1), 1, 0);
	z = RLPF.ar(osc, 1000, 0.5, 1);
	z = Pan2.ar(z*e, pan, amp);
	4.do({ a = AllpassL.ar(z, 0.2, LFNoise2.kr([rrand(0.01, 0.1),rrand(0.01, 0.1)],0.05,0.15)/2, 0.25) });

	Out.ar(out, z );
}).store;

///////////////////////////////////////////////

//22
SynthDef(\phasorNoise, {
	| out=0 , sampleRate =0.5, bitRate=8|

	var source, dsig, mixed;
	source = WhiteNoise.ar(0.5);

	dsig = AllpassL.ar(source, 2, SinOsc.ar(440, 0, 0.005, 0.005), 0);
	mixed = source + dsig;
	mixed = RHPF.ar(source, SinOsc.kr(3,0,1000,1000),0.8);
	mixed = Decimator.ar(mixed,LinLin.kr(sampleRate, 0, 1, 0, SampleRate.ir), bitRate);
	Out.ar(out, mixed);

}).store;

//23
SynthDef(\envelopeGen,{
	|amp =0.5, dur, pan=0, inBus = 37, outBus=0, gate = 1, atk = 0.002, decay = 0, sus = 1, rel = 0.001 |
	var env, mod, signal;
	env = Env.adsr(atk, decay, sus, rel, amp, -3);
	mod = EnvGen.ar(env, gate, doneAction:2);
	signal = In.ar(inBus,1);
	Out.ar(outBus,Pan2.ar(signal * mod, pan));
}).store;


//24
SynthDef(\pulseSnare,
	{|out = 0, freq =440, gate = 1, pan = 0, atk = 0.005, decay = 0, sus = 1, rel =0.01, amp = 1|
		var osc, env;
		osc = Pulse.ar(48, 0.25, amp);
		env = EnvGen.ar(Env.adsr(atk, decay, sus, rel), gate, doneAction:2);
		osc = osc + Mix.fill(4, {AllpassC.ar(osc, 0.1.rand +0.02, 0.012, 0.1)});
		osc = BBandPass.ar(osc, 90*128, 0.5, 1);
		osc = Pan2.ar(osc * env, pan);
		Out.ar(out, osc);
	}
).store;

//25
SynthDef(\sineWave,
	{|out = 0, freq =440, gate = 1, pan = 0, atk = 0.005, decay = 0, sus = 1, rel =0.01, amp = 1, sampleRate = 1, bitRate = 32|
		var osc, env;
		osc = (SinOsc.ar(freq, 0, amp))/4 * SinOsc.ar(freq/8, 0.5, amp);

		env = EnvGen.ar(Env.adsr(atk, decay, sus, rel), gate, doneAction:2);

		osc = Decimator.ar(osc,LinLin.kr(sampleRate, 0, 1, 0, SampleRate.ir), bitRate);
		osc = Pan2.ar(osc * env, pan);
		Out.ar(out, osc);
	}
).store;


//Synth

SynthDef(\reverb, {
	|in, out = 0, mix = 0.5, room = 0.5, dump = 0.5 |
	var input, fx, output;
	input = In.ar(in, 2);
	fx = FreeVerb.ar(input, mix, room, dump, 1);
	fx = Pan2.ar(fx,0);
	Out.ar(out, fx);
}).store;

SynthDef(\sawSynth, {
	|out = 0, freq = 440, phase = 0, atk = 0, decay = 0, sus = 1, rel = 0.25, gate = 1, pan = 0, amp = 0.25|
	var osc, env;

	//osc = Mix.fill((2.rand+1) * 2, {|i| SinOsc.ar(i + 1 * freq, phase, 1, 0)}); //fill number should be changed by power of 2; 2, 4, 8, , 16
	osc = Saw.ar(freq, 1, 0);
	env = EnvGen.ar(Env.adsr(atk, decay, sus, rel, curve: 0),gate, amp, doneAction: 2);
	osc = osc * env;
	osc = RLPF.ar(osc, freq/1.5, 0.75);
	osc = Pan2.ar(osc, pan);
	Out.ar(out, osc);
}).store;

SynthDef(\resNoise, {
	|out = 0, freq = 440, phase = 0, atk = 0, decay = 0, sus = 1, rel = 0.25, gate = 1, pan = 0, amp = 1|
	var osc, env;

	osc = SinOsc.ar(freq, phase,0.5) + PinkNoise.ar(0.25);
	env = EnvGen.ar(Env.adsr(atk, decay, sus, rel, curve: 0),gate, amp, doneAction: 2);
	osc = osc * env;
	osc = RLPF.ar(osc, freq*8, 0.03125/2);
	osc = Pan2.ar(osc, pan);
	Out.ar(out, osc);
}).store;

SynthDef(\loopBass, {
	|out = 0, freq = 440, phase = 0, atk = 0, decay = 0, sus = 1, rel = 0.25, gate = 1, pan = 0, amp = 1|
	var osc, env;

	osc = SinOsc.ar(freq, phase, 1);
	env = EnvGen.ar(Env.adsr(atk, decay, sus, rel, curve: -4),gate, amp, doneAction: 2);
	osc = osc * env;

	osc = Pan2.ar(osc, pan);
	Out.ar(out, osc);
}).store;

SynthDef(\revSaw, {
	|out = 0, freq, amp = 0.125, gate = 1, sampleRate = 0.5, bitRate = 32, panPos = 0|

	var osc, env;
	osc = Saw.ar(freq.midicps);

	env = EnvGen.kr(Env.adsr(0.0,0 ,1,0.0),gate,  doneAction:2);
	osc = osc * env * amp;
	//osc = Decimator.ar(osc,LinLin.kr(sampleRate, 0, 1, 0, SampleRate.ir), bitRate);
	osc = Pan2.ar(osc, panPos);
	out = Out.ar(out, osc);

}).store;

///////////   FX  /////////////////

SynthDef(\reverb, {
	|in, out = 0, mix = 0.5, room = 0.5, dump = 0.5 |
	var input, fx, output;
	input = In.ar(in, 2);
	fx = FreeVerb.ar(input, mix, room, dump, 1);
	fx = Pan2.ar(fx,0);
	Out.ar(out, fx);
}).store;


SynthDef(\logisticMap_FX, {
	|out = 0, in, amp =1, chaos= 3.9, logiFreq = 12800, init = 0.5|
	var input, fx, mod, output;
	mod = Logistic.kr(chaos, logiFreq, init, 1);
	input = In.ar(in, 1);
	fx = RLPF.ar(input, mod, 0.5);
	Out.ar(out, fx);
}).store;

SynthDef(\stutter,{
	| amp =0.5, dur, pan=0, inBus = #[39, 40], outBus=0, gate = 1, atk = 0, decay = 0, sus = 1, rel = 0 |
	var env, mod, signal;
	env = Env.adsr(atk, decay, sus, rel, amp, 0);
	mod = EnvGen.ar(env, gate, doneAction:2);
	signal = In.ar(inBus,1);

	Out.ar(outBus,Pan2.ar(signal *  mod * amp, pan));
}).store;

SynthDef(\henonC_FX, {
	|out =0, in =37, freq, amp = 0.125, gate = 1, param_a = 0.5, param_b = 0.5|

	var osc, env, mod;
	osc = In.ar(in, 2);
	mod = HenonC.ar(SampleRate.ir, LFNoise2.kr(0.125, 0.5, 1.8),LFNoise2.kr(0.25, 0.5, 0.5), 0.333, 1) ;
	osc = osc * mod;
	osc = Limiter.ar(osc, 0.5, 0.001);
	osc = Pan2.ar(osc);
	Out.ar(out, osc);

}).store;

SynthDef(\clean_reverb,
	{ arg in = 41, out=0, amp = 0.5;
		var a,z,y,x;
		a=InFeedback.ar(in,2);
		z=DelayN.ar(a,0.048);
		y=Mix.ar(Array.fill(7,{CombL.ar(z,0.1,LFNoise1.kr([0.1.rand,0.1.rand], 0.01,0.1),10)}));
		x=AllpassN.ar(y,0.050,[0.050.rand,0.050.rand],1);
		x = Pan2.ar(x, 0);
		Out.ar(out * amp,x);
	}
).store;