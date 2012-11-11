SynthDef(\sin, {
	|freq, amp = 0.125, gate = 1|

var osc, env, out = 0;

	osc = SinOsc.ar(freq.midicps, 0, amp/4);
	env = EnvGen.kr(Env.adsr(0.0,0 ,1,0.0),gate,  doneAction:2);
	osc = osc * env;
	osc = Pan2.ar(osc);
	out = Out.ar(0, osc);

}).store;

SynthDef(\puls, {
	|out = 0, freq, gate = 1, atk = 0, decay= 0.25, sus = 0, rel = 0.00001 , amp = 1|
	var osc, env;
	osc = Pulse.ar(freq, 0.01, 1);
	//osc = osc + AllpassN.ar(osc, 0.5, 0.02, 1, 1, 0);
	osc = RLPF.ar(osc, 300, 0.25, 1, 0);
	env = EnvGen.kr(Env.adsr(atk, decay, sus, rel, 1, -4), gate, doneAction:2);
	osc = osc * env;
	osc = Pan2.ar(osc, 0, amp);
	Out.ar(out, osc);
	}).store;
