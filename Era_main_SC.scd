(//Set up
~currentDocPath = "/Users/koutarofukui/Dropbox/Application/SC related files/Piece/Era/";

)
(
~currentDocPath = thisProcess.nowExecutingPath.replace("Era_main_SC.scd", "");
(~currentDocPath++"Era_Instrument.scd").load;
(~currentDocPath++"Era_Setting.scd").load;
)

Server.internal.options.device =  "Soundflower (2ch)";
//Server.internal.options.device =  "Built-in Output";

(

//ProxySpace.push(s);

var totalCountNum, totalMeasureSelectNum, logisticFilterFx;
var set_1,set_2,set_3, set_4, set_5, set_6 ,set_7,set_8, set_9, set_10;
set_1 = 0.125;
set_2 = set_1 + set_1;
set_3 = set_1 + set_2;
set_4 = set_2;
set_5 = set_4+set_4;
set_6 = set_4+set_5;// set_6 = set_1 + set_2 + set_3

// init varc
totalMeasureSelectNum = 0;

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
~reverb.free;

~sourceOsc.free;
~stutterOSc.free;

~reverb = Synth.after(1, \reverb);
~reverb.set(\in, 33,\mix, 0.5, \room, 0.99, \dump, 0.5);

~logisticFilterFx = Synth.after(1, \logisticMap_FX);
~logisticFilterFx.set(\in, 35, \chaos, 3.99, \logiFreq, 2000);

~henonFx = Synth.after(1, \henonC_FX);
~henonFx.set(\in, 37);

totalMeasureSelectNum = 0;

///////
Task({
	inf.do({
		|i|
		//measureSelectNum = i;
		totalCountNum = i % 8; // time measure

		//Print"count"&"measure"
		if(totalCountNum == 0,
			{
				totalMeasureSelectNum = totalMeasureSelectNum  + 1;
				("Total Measure : "++ totalMeasureSelectNum).postln;

			}
		);

		if(totalMeasureSelectNum == 1 && totalCountNum == 0,{
			m.sendMsg("/event/modeType", 0);
			(~currentDocPath++"intro_section.scd").load;
		});

		if(totalMeasureSelectNum == 9 && totalCountNum == 0,{
			m.sendMsg("/event/modeType", 1);
			~intro_section_Task.stop;
			(~currentDocPath++"1st_section.scd").load;
		});

		if(totalMeasureSelectNum == 56 && totalCountNum == 0,{
			m.sendMsg("/event/modeType", 2);
			Pdef(\logisticMap_Synth).stop;
			~first_section_Task.stop;
			(~currentDocPath++"2nd_section.scd").load;
		});
		if(totalMeasureSelectNum == 128 && totalCountNum == 0,{
			m.sendMsg("/event/modeType", 5);
			Pdef(\henonC).stop;
			Pdef(\grayNoise).stop;
			Pdef(\kick).stop;
			Pdef(\snare_2).stop;
			Pdef(\sine).stop;
			~second_section_Task.stop;
			(~currentDocPath++"break_section.scd").load;
		});
		//128 - 193 - 238
		if(totalMeasureSelectNum == 188 && totalCountNum == 0,{
			m.sendMsg("/event/modeType", 3);
			Pdef(\loopBass).stop;
			Pdef(\revSaw).stop;
			~break_section_Task.stop;
			(~currentDocPath++"3rd_section.scd").load;
		});

		if(totalMeasureSelectNum == 253 && totalCountNum == 0,{
			m.sendMsg("/event/particle_rotateMode", 1);

			Pdef(\chord).stop;
			~third_section_Task.stop;
			(~currentDocPath++"4th_section.scd").load;
		});
		if(totalMeasureSelectNum == 298 && totalCountNum == 0,{
			m.sendMsg("/event/modeType", 4);


		});


		1.wait;
	})
}).play(~tempoClock)
)
