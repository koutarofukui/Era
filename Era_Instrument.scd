SynthDef(\sin, {
	|freq, amp = 0.125, gate = 1|

	var osc, env, out = 0;

	osc = SinOsc.ar(freq.midicps, 0, amp);
	env = EnvGen.kr(Env.adsr(0.0,0 ,1,0.0),gate,  doneAction:2);
	osc = osc * env;
	osc = Pan2.ar(osc);
	out = Out.ar(0, osc);

}).store;

SynthDef(\logisticMap, {
	|out = 0, amp =1, gate=1, atk=0 ,decay=0, sus=1, rel=0, width=0.25, chaos=3, freq, logiFreq = 100, init = 0.125|
	var osc, mod, env;
	mod = Logistic.kr(chaos, logiFreq, init, 1);
	osc = Pulse.ar(freq, width);
	osc = RLPF.ar(osc, mod * 5000, 0.75);
	env = EnvGen.kr(Env.adsr(atk, decay, sus, rel), gate, doneAction:2);
	osc = osc * env * amp;
	osc = Pan2.ar(osc);
	Out.ar(out, osc);
}).store;

SynthDef(\henonC, {
	|freq, amp = 0.125, gate = 1, param_a = 0.5, param_b = 0.5|

	var osc, env, mod, out = 0;
	osc = SinOsc.ar(freq.midicps, 0, amp);
	//mod = HenonC.ar(SampleRate.ir, LFNoise2.kr(0.125/64, 0.5, 1.8),LFNoise2.kr(0.25, 0.5, 0.5), 0.333, 1) ;
	mod = HenonC.ar(SampleRate.ir/8, param_a, param_b, 0.5, 0.5) ;
	osc = osc * mod;
	osc = Limiter.ar(osc, 0.5, 0.001);
	env = EnvGen.kr(Env.adsr(0.0,0,1,0.0),gate,  doneAction:2);
	osc = osc * env;
	osc = Pan2.ar(osc);
	Out.ar(out, osc);

}).store;

SynthDef(\allpassPulse, {
	|out = 0, freq, gate = 1, atk = 0.0001, decay= 0, sus = 0, rel = 0.00001 , amp = 1|
	var osc, env;
	osc = Pulse.ar(freq, 0.01, 1);
	osc = osc + AllpassN.ar(osc, 0.5, 0.02, 1, 1, 0);
	osc = RHPF.ar(osc, 10000, 1, 1, 0);
	env = EnvGen.ar(Env.adsr(atk, decay, sus, rel, 1, -4));
	osc = osc * env;
	osc = Pan2.ar(osc, 0, amp);
	Out.ar(0, osc);
	}).store;

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


SynthDef(\kick, {|atk= 0, rel= 0.03125, amp= 1, pan = 0|
	var e= EnvGen.ar(Env.perc(atk, rel), doneAction:2);
	var z= SinOsc.ar(e * 150 +50, 0, amp).clip(0.95);
	z = Pan2.ar(z, pan, 1.5).distort;
	Out.ar(0, z*e);
}).store;

SynthDef(\click, {|rel= 0.5, mix= 0.5, room= 0.25, amp= 1, damp= 0.9, pan= 0|
	var e= Line.kr(0, 1, rel, doneAction:2);
	var z= Impulse.ar(0)+BrownNoise.ar(1)*Line.ar(1, 0, room*0.01);
	z = Pan2.ar(z, LFNoise2.kr(64), amp );
	Out.ar(0, z);
}).store;

SynthDef(\sine, {|atk= 0.01, rel= 0.0125, amp= 1|
	var e= EnvGen.ar(Env.perc(atk, rel), doneAction:2);
	var z= SinOsc.ar(120.midicps, 0, amp);

	z = Pan2.ar(z*e, 0, 1);
	2.do({ z = AllpassL.ar(z, 0.1, LFNoise2.kr([rrand(0.01, 0.1),rrand(0.01, 0.1)],0.15,0.15), 2) });


	Out.ar(0, z);
}).store;

SynthDef(\amSine, {|freq = 36, atk= 0, rel= 0, gate = 1, amp= 1, modRate = 0, modDepth = 0|
	var e= EnvGen.ar(Env.adsr(atk,0, 1, rel), gate, doneAction:2);
	var z= SinOsc.ar(freq, 0, amp) * (1.0 - SinOsc.kr(modRate, 0, modDepth, 0).abs) ;
	z = Pan2.ar(z, 0, 0.5);

	Out.ar(0, z*e);
}).store;

SynthDef(\whiteNoise, {|atk= 0, rel= 0.125, gate = 1, amp= 1|
	var e= EnvGen.ar(Env.adsr(atk,0.2, 0.5, rel, curve: -8), gate, doneAction:2);
	var z= RHPF.ar(WhiteNoise.ar(1), 17500, 0.5) ;

	z = Pan2.ar(z*e, 0, amp);
	//2.do({ z = AllpassL.ar(z, 0.3, LFNoise2.kr([rrand(0.01, 0.1),rrand(0.01, 0.1)],0.05,0.15), 2) });
	Out.ar(0, z);
}).store;


SynthDef(\grayNoise, {|atk= 0, rel= 0.125, gate = 1, amp= 1|
	var e= EnvGen.ar(Env.adsr(atk,0, 1, rel, curve: -8), gate, doneAction:2);
	var z= RLPF.ar(Dust2.ar(LFNoise2.kr([60, 50], TRand.kr(500, 20000, gate), 100), 0.5, 0) + GrayNoise.ar(0.125), LFNoise2.kr([3, 4], 1000, 3000), 0.5, 1, 0) ;

	z = Pan2.ar(z*e, 0, amp);
	//2.do({ z = AllpassL.ar(z, 0.3, LFNoise2.kr([rrand(0.01, 0.1),rrand(0.01, 0.1)],0.05,0.15), 2) });
	Out.ar(0, z);
}).store;


SynthDef(\sinePulse, {| midiPitch = 96, gate = 1, atk = 0, decay = 0, sus = 1, rel = 0, amp= 1, pan = 0 |
	var e= EnvGen.ar(Env.adsr(atk, decay, sus, rel, curve: -2), gate, doneAction: 2);
	var z= SinOsc.ar(midiPitch.midicps + rrand(0.01, 0.1), 0, 1, 0);
	z = Pan2.ar(z*e, pan, amp/4);
	4.do({ a = AllpassL.ar(z, 0.2, LFNoise2.kr([rrand(0.01, 0.1),rrand(0.01, 0.1)],0.05,0.15)/2, 0.25) });

	Out.ar(0, z );
}).store;
