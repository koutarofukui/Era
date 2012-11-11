(
//p = ProxySpace.push(s);

var countNum, measureSelectNum, desireMeasure;
// init var
measureSelectNum = 0;
desireMeasure = 0;

//loading files
~currentDocPath="/Users/koutarofukui/Dropbox/Application/SC related files/Piece/Era/";
(~currentDocPath++"Era_Instrument.scd").load;
(~currentDocPath++"Era_Setting.scd").load;

~tempoClock = TempoClock(70/60);

~freq_seq = Pxrand([108,115,108], inf);
~dur_seq = Pxrand([Pn(0.125, 6), Pseq([0.125, 0.25, 0.5, 0.125], 1),Pseq([0.125, 0.25, 0.25, 0.125], 1)], inf);
~freq_seqStream = ~freq_seq.asStream;
~dur_seqStream = ~dur_seq.asStream;

~sine_Sep_1 = Pdef(\sine, Pbind(
	\instrument, \sin,
	\freq, Pfunc({~freqData = ~freq_seqStream.next; }),
	\dur, Pfunc({~durData = ~dur_seqStream.next; }),
	\sustain, Pkey(\dur)/1.5,
	\OSC_Sender, Pfunc({m.sendMsg("/event", ~freqData , ~durData);})
));

~pulse_Sep_1 = Pdef(\pulse, Pbind(
	\instrument, \puls,
	\freq, Pfunc({~freqData}),
	\dur, Pfunc({~durData}),
	\sustain, Pkey(\dur)/1.5,
	//\OSC_Sender, Pfunc({m.sendMsg("/event", ~freqData , ~durData);})
));

Task({
	inf.do({
	|i|
		measureSelectNum = i;
		countNum = i % 16; // time measure
		//countNum.postln;
		("count : "++ countNum).postln;

		if(countNum ==0, {
			if(measureSelectNum == 0,
				{
					~sine_Sep_1.play(~tempoClock);
					~pulse_Sep_1.play(~tempoClock);
				}
			);
		});


		//Print"count"&"measure"
		if(countNum == 0,
			{
				("measure : "++ measureSelectNum).postln;
				measureSelectNum = measureSelectNum  + 1;
			}
		);
		1.wait;
	})
}).play(~tempoClock)

)



