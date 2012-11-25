(//Set up
~currentDocPath = "/Users/koutarofukui/Dropbox/Application/SC related files/Piece/Era/";
(~currentDocPath++"Era_Instrument.scd").load;
(~currentDocPath++"Era_Setting.scd").load;
)

(

//ProxySpace.push(s);
var countNum, measureSelectNum;
var set_1,set_2,set_3, set_4, set_5, set_6 ,set_7,set_8, set_9, set_10;
			set_1 = 0.125;
			set_2 = set_1 + set_1;
			set_3 = set_1 + set_2;
			set_4 = set_2;
			set_5 = set_4+set_4;
			set_6 = set_4+set_5;// set_6 = set_1 + set_2 + set_3
// init var
measureSelectNum = 37;

//loading files

~currentDocPath = "/Users/koutarofukui/Dropbox/Application/SC related files/Piece/Era/";
(~currentDocPath++"Era_Instrument.scd").load;
(~currentDocPath++"Era_Setting.scd").load;


~tempoClock = TempoClock(100/60);

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



Pdef(\sine, Pbind(
				\instrument, \sin,
				\freq, Pfunc({~sine_freqData = ~sine_freqSeqStream.next; }),
				\dur, Pfunc({~sine_durData = ~sine_durSeqStream.next; }),
				\sustain, Pkey(\dur)/1.125,
				\OSC_Sender, Pfunc({m.sendMsg("/event", ~sine_freqData , ~sine_durData);})
			));


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

		("count : "++ countNum).postln;

		if(measureSelectNum ==1 && countNum == 0, {
			//Pdef(\pulse).play(~tempoClock);
			Pdef(\sine).play(~tempoClock);
		});

		if(measureSelectNum ==3 && countNum == 0, {

			~sine_durSeqStream = Pseq([4],1).asStream;
			Pdef(\sine, Pbind(
				\instrument, \sin,
				\freq, Pfunc({~sine_freqData = ~sine_freqSeqStream.next; }),
				\dur, Pfunc({~sine_durData = ~sine_durSeqStream.next; }),
				\sustain, Pkey(\dur)/1.125,
				\OSC_Sender, Pfunc({m.sendMsg("/event", ~sine_freqData , ~sine_durData);})
			)).play(~tempoClock);

			}
		);

		if(measureSelectNum ==3 && countNum == 4, {

			~sine_durSeqStream = Pxrand([Pn(0.125, 6), Pseq([0.125, 0.25, 0.5, 0.125], 1),Pseq([0.125, 0.25, 0.25, 0.125], 1)], inf).asStream;
			Pdef(\sine, Pbind(
				\instrument, \sin,
				\freq, Pfunc({~sine_freqData = ~sine_freqSeqStream.next; }),
				\dur, Pfunc({~sine_durData = ~sine_durSeqStream.next; }),
				\sustain, Pkey(\dur)/1.5,
				\OSC_Sender, Pfunc({m.sendMsg("/event", ~sine_freqData , ~sine_durData);})
			)).play(~tempoClock);
			//Click Start
			Pdef(\snare,
				Pbind(\instrument,\click,
					\room,0.125,
					\dur,Pfunc({~click_durData = ~click_durSeqStream.next /2; }),
					\gate,1,
					\amp,Prand([0.75,0.5,0.25],inf)/2,
					\sustain,Pkey(\dur)-(Pkey(\dur)/1.5)
			)).play(~tempoClock);

		});

		if(measureSelectNum ==4 && countNum == 0, {
			Pdef(\kick, Pbind(\instrument, \kick, \amp, 1,\dur,Pseq([set_1, 8 - set_1],inf))).play(~tempoClock);
		});
		if(measureSelectNum ==6 && countNum == 0, {
			Pdef(\kick, Pbind(\instrument, \kick, \amp, 1,\dur,Pseq([set_1, set_2, 8 - set_1 - set_2],inf)))
		});
		if(measureSelectNum ==8 && countNum == 0, {
			Pdef(\kick, Pbind(\instrument, \kick, \amp, 1,\dur,Pseq([set_1, set_2, set_3, 8 - set_1 - set_2 - set_3],inf)))
		});
		if(measureSelectNum ==10 && countNum == 0, {
			Pdef(\kick, Pbind(\instrument, \kick, \amp, 1,\dur,Pseq([set_1, set_2, set_3, set_4, 8 - set_1 - set_2 - set_3 - set_4],inf)))
		});
		if(measureSelectNum ==12 && countNum == 0, {
			Pdef(\kick, Pbind(\instrument, \kick, \amp, 1,\dur,Pseq([set_1, set_2, set_3, set_4, set_5, 8 - set_1 - set_2 - set_3 - set_4 - set_5],inf)))
		});
		if(measureSelectNum ==14 && countNum == 0, {
			Pdef(\kick, Pbind(\instrument, \kick, \amp, 1,\dur,Pseq([set_1, set_2, set_3, set_4, set_5, set_1, set_2, set_3, 8 - set_1 - set_2 - set_3 - set_4 - set_5 - set_6 ],inf)))
		});

		if(measureSelectNum ==16 && countNum == 4, {
			Pdef(\kick).stop;
			Pdef(\snare).stop;

			~sine_durSeqStream = Pseq([4],1).asStream;
			Pdef(\sine, Pbind(
				\instrument, \sin,
				\freq, Pfunc({~sine_freqData = ~sine_freqSeqStream.next; }),
				\dur, Pfunc({~sine_durData = ~sine_durSeqStream.next; }),
				\sustain, Pkey(\dur)/1.125,
				\OSC_Sender, Pfunc({m.sendMsg("/event", ~sine_freqData , ~sine_durData);})
			));
		});


		if(measureSelectNum ==17 && countNum == 0, {

			~sine_durSeqStream = Pxrand([Pn(0.125, 6), Pseq([0.125, 0.25, 0.5, 0.125], 1),Pseq([0.125, 0.25, 0.25, 0.125], 1)], inf).asStream;
			Pdef(\sine, Pbind(
				\instrument, \sin,
				\freq, Pfunc({~sine_freqData = ~sine_freqSeqStream.next; }),
				\dur, Pfunc({~sine_durData = ~sine_durSeqStream.next; }),
				\sustain, Pkey(\dur)/1.5,
				\OSC_Sender, Pfunc({m.sendMsg("/event", ~sine_freqData , ~sine_durData);})
			)).play(~tempoClock);

			Pdef(\kick,
				Pbind(\instrument, \kick,
					\dur,Pfunc({
						~sine_durData;
					}),
					\amp,Pfunc({if(~sine_durData >= 0.25, 0, 1)}),
					//\dur,Pfunc({~kick_durData = ~kick_freqSeqStream.next}),
					\OSC_Sender, Pfunc({m.sendMsg("/event/kick", ~kick_durData);})
				)
			).play(~tempoClock);
		});

		if(measureSelectNum ==20 && countNum == 4, {
			Pdef(\sine).stop;
			Pdef(\kick).stop;
			~sine_durSeqStream = Pseq([4],1).asStream;
			Pdef(\sine, Pbind(
				\instrument, \sin,
				\freq, 36,
				\dur, Pfunc({~sine_durData = ~sine_durSeqStream.next; }),
				\sustain, Pkey(\dur)/1.125,
				\OSC_Sender, Pfunc({m.sendMsg("/event", ~sine_freqData , ~sine_durData);})
			)).play(~tempoClock);
		});

		if(measureSelectNum ==21 && countNum == 0, {

			~sine_durSeqStream = Pxrand([Pn(0.125, 6), Pseq([0.125, 0.25, 0.5, 0.125], 1),Pseq([0.125, 0.25, 0.25, 0.125], 1)], inf).asStream;
			Pdef(\sine, Pbind(
				\instrument, \sin,
				\freq, Pfunc({~sine_freqData = ~sine_freqSeqStream.next; }),
				\dur, Pfunc({~sine_durData = ~sine_durSeqStream.next; }),
				\sustain, Pkey(\dur)/1.5,
				\OSC_Sender, Pfunc({m.sendMsg("/event", ~sine_freqData , ~sine_durData);})
			)).play(~tempoClock);

			Pdef(\snare,
				Pbind(\instrument,\click,
					\room,Pxrand([0.125,0.25, 0.5, 0.75],inf),
					\dur,Pfunc({~click_durData = ~click_durSeqStream.next /2; }),
					\gate,1,
					\amp,Prand([0.75,0.5,0.25],inf)/2,
					\sustain,Pkey(\dur)-(Pkey(\dur)/1.5)
			)).play(~tempoClock);

			Pdef(\kick,
				Pbind(\instrument, \kick,
					\dur,Pfunc({
						~sine_durData;
					}),
					\amp,Pfunc({if(~sine_durData >= 0.5, 0, 1)}),
					//\dur,Pfunc({~kick_durData = ~kick_freqSeqStream.next}),
					\OSC_Sender, Pfunc({m.sendMsg("/event/kick", ~kick_durData);})
				)
			).play(~tempoClock);

			Pdef(\logisticMapBass,
				Pbind(\instrument, \logisticMap,

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

		});
/*
		if(measureSelectNum ==27 && countNum == 4, {
			Pdef(\sine).stop;
			Pdef(\kick).stop;
			Pdef(\logisticMapBass).stop;
			Pdef(\snare).stop;
			~sine_durSeqStream = Pseq([4],1).asStream;
			Pdef(\sine, Pbind(
				\instrument, \sin,
				\freq, 72,
				\dur, Pfunc({~sine_durData = ~sine_durSeqStream.next; }),
				\sustain, Pkey(\dur)/1.125,
				\OSC_Sender, Pfunc({m.sendMsg("/event", ~sine_freqData , ~sine_durData);})
			)).play(~tempoClock);
		});
*/
		if(measureSelectNum ==28 && countNum == 0, {
			var break = 2.5;
			~sine_durSeqStream = Pxrand([Pn(0.125, 6), Pseq([0.125, 0.25, Pwrand([0.5, break],[2,3].normalizeSum, 1), 0.125], 1),Pseq([0.125, 0.25, 0.25, 0.125], 1)], inf).asStream;
			Pdef(\sine, Pbind(
				\instrument, \sin,
				\freq, Pfunc({~sine_freqData = ~sine_freqSeqStream.next; }),
				\dur, Pfunc({~sine_durData = ~sine_durSeqStream.next; }),
				\sustain, Pkey(\dur)/1.5,
				\OSC_Sender, Pfunc({m.sendMsg("/event", ~sine_freqData , ~sine_durData);})
			)).play(~tempoClock);

			Pdef(\snare,
				Pbind(\instrument,\click,
					\room,Pxrand([0.125,0.25, 0.5, 0.75],inf),
					\dur,Pfunc({~click_durData = ~click_durSeqStream.next /2; }),
					\gate,1,
					\amp,Pfunc({if( ~sine_durData == break, 0,Prand([0.75,0.5,0.25],inf)/2) }),
					\sustain,Pkey(\dur)-(Pkey(\dur)/1.5)
			)).play(~tempoClock);

			Pdef(\kick,
				Pbind(\instrument, \kick,
					\dur,Pfunc({
						~sine_durData;
					}),
					\amp,Pfunc({
						if(~sine_durData >= 0.5, 0, 1);
					}),
					//\dur,Pfunc({~kick_durData = ~kick_freqSeqStream.next}),
					\OSC_Sender, Pfunc({m.sendMsg("/event/kick", ~kick_durData);})
				)
			).play(~tempoClock);

			Pdef(\logisticMapBass,
				Pbind(\instrument, \logisticMap,

					\rel, 0,
					\chaos, Pfunc({(0.99).rand + 3}),
					\width, Pfunc({(0.125).rand + 0.5}),

					\dur,Pfunc({
						~sine_durData;
					}),
					\amp,Pfunc({
						if(~sine_durData == break, 0, 0.125/2);
						//if(~sine_durData == 0.25 || ~sine_durData == 0.125, 0.125/2);
						//if(~sine_durData == 2, 0);
					}),
					\freq,Pfunc({if(~sine_durData == 0.5, 33, 48)}),
					\logiFreq, Pkey(\freq)*Pseq([8, 16, 32],inf),
					\sustain,Pkey(\dur)-(Pkey(\dur)*0.25),
					//\dur,Pfunc({~kick_durData = ~kick_freqSeqStream.next}),
					\OSC_Sender, Pfunc({m.sendMsg("/event/logisticMap", ~logisticMapBass_durData);})
				)
			).play(~tempoClock);
		});
		if(measureSelectNum ==35 && countNum == 4, {

			Pdef(\sine).stop;
			Pdef(\kick).stop;
			Pdef(\logisticMapBass).stop;
			Pdef(\snare).stop;
			~sine_durSeqStream = Pseq([20],1).asStream;
			Pdef(\sine, Pbind(
				\instrument, \sin,
				\freq, 60,
				\dur, Pfunc({~sine_durData = ~sine_durSeqStream.next; }),
				\sustain, Pkey(\dur),
				\OSC_Sender, Pfunc({m.sendMsg("/event", ~sine_freqData , ~sine_durData);})
			)).play(~tempoClock);
		});


		if(measureSelectNum == 38 && countNum == 0, {

            Pdef(\kick,
                Pbind(\instrument, \kick,
                    \dur, Pfunc({~kick_durData = ~kick_durSeqStream.next}),
                    \amp,0.5,

                    \OSC_Sender, Pfunc({m.sendMsg("/event/kick", ~kick_durData);})
                )
            ).play(~tempoClock);
            //henonC Start
			Pdef(\henonC,
				Pbind(
					\instrument, \henonC,
					\freq, Pfunc({24}),
					\param_a, Pxrand([0.5, 0.125, 0.25, 0.0625],inf),
					\param_b, Pxrand([0.25, 0.125, 0.5, 0.0625],inf),
					\amp, Prand([0.75,0.5,0.25],inf)/4,
					\dur, Pfunc({~kick_durData }),
					\sustain, Pkey(\dur)-(Pkey(\dur)*0.25),
					\OSC_Sender, Pfunc({m.sendMsg("/event", ~sine_freqData , ~sine_durData);})
				)
			).play(~tempoClock);

		});


		/*
		if(measureSelectNum ==5 && countNum == 0, {

		//henonC Start
		Pdef(\henonC, Pbind(
		\instrument, \henonC,
		\freq, Pfunc({24}),
		\amp, Prand([0.75,0.5,0.25],inf)/4,
		\dur, Pfunc({~sine_durData = ~sine_durSeqStream.next*0.75; }),
		\sustain, Pkey(\dur)/1.5,
		\OSC_Sender, Pfunc({m.sendMsg("/event", ~sine_freqData , ~sine_durData);})
		)).play(~tempoClock);


		});
		*/


		1.wait;
	})
}).play(~tempoClock)

)



