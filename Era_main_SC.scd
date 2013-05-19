(//Set up
~currentDocPath = "/Users/koutarofukui/Dropbox/Application/SC related files/Piece/Era/";

)
(
~currentDocPath = thisProcess.nowExecutingPath.replace("Era_main_SC.scd", "");
(~currentDocPath++"Era_Instrument.scd").load;
(~currentDocPath++"Era_Setting.scd").load;
)

Server.local.options.device =  "Soundflower (2ch)";
//Server.internal.options.device =  "Built-in Output";

(

var totalCountNum, totalMeasureSelectNum, logisticFilterFx;
var set_1,set_2,set_3, set_4, set_5, set_6 ,set_7,set_8, set_9, set_10;
set_1 = 0.125;
set_2 = set_1 + set_1;
set_3 = set_1 + set_2;
set_4 = set_2;
set_5 = set_4+set_4;
set_6 = set_4+set_5;// set_6 = set_1 + set_2 + set_3


~currentDocPath = thisProcess.nowExecutingPath.replace("Era_main_SC.scd", "");
(~currentDocPath++"Era_Instrument.scd").load;
(~currentDocPath++"Era_Setting.scd").load;

~tempoClock = TempoClock(90/60);

//FX setting`
~logisticFilterFx.free;
~henonFx.free;
~reverb.free;
~clean_Reverb.free;

~sourceOsc.free;
~stutterOsc.free;

~henonFx.free;

~reverb = Synth.after(1, \reverb);
~reverb.set(\in, 33,\mix, 0.5, \room, 0.99, \dump, 0.5);

~clean_Reverb = Synth.after(1, \clean_reverb);
~clean_Reverb.set(\in, 41);

~logisticFilterFx = Synth.after(1, \logisticMap_FX);
~logisticFilterFx.set(\in, 35, \chaos, 3.99, \logiFreq, 2000);

//~henonFx = Synth.after(1, \henonC_FX);
//~henonFx.set(\in, 37);


totalMeasureSelectNum = 0;

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

			~noteScoreIP.sendMsg("/event/mode", 0);
			~intro_section_Task.stop;
			(~currentDocPath++"1st_section.scd").load;
		});

		if(totalMeasureSelectNum == 56 && totalCountNum == 0,{
			m.sendMsg("/event/modeType", 2);
			~clean_Reverb = Synth.after(1, \clean_reverb);
			~clean_Reverb.set(\in, 41, \amp, 0.125/1.5);
			Pdef(\logisticMap_Synth).stop;
			~first_section_Task.stop;
			//~first_section_Task.clear;
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
			//~second_section_Task.clear;
			(~currentDocPath++"break_section.scd").load;
		});

		if(totalMeasureSelectNum == 188 && totalCountNum == 0,{
			m.sendMsg("/event/modeType", 3);
			Pdef(\loopBass).stop;
			Pdef(\revSaw).stop;
			~break_section_Task.stop;
			//~break_section_Task.clear;
			~clean_Reverb.set(\in, 63, \amp, 0.125/2);
			(~currentDocPath++"3rd_section.scd").load;
		});

		/*if(totalMeasureSelectNum == 253 && totalCountNum == 0,{
			~third_section_Task.stop;
			(~currentDocPath++"4th_section.scd").load;

		});

		if(totalMeasureSelectNum == 255 && totalCountNum == 0,{
			m.sendMsg("/event/particle_rotateMode", 1);

			Pdef(\chord).stop;

		});
*/
		if(totalMeasureSelectNum == 253 && totalCountNum == 0,{
			~third_section_Task.stop;


		});

		if(totalMeasureSelectNum == 255 && totalCountNum == 0,{

			(~currentDocPath++"4th_section.scd").load;

		});

		if(totalMeasureSelectNum == 255 && totalCountNum == 0,{
			m.sendMsg("/event/particle_rotateMode", 1);

			Pdef(\chord).stop;

		});

		if(totalMeasureSelectNum == 298 && totalCountNum == 0,{

			m.sendMsg("/event/modeType", 4);

		});

		1.wait;
	})
}).play(~tempoClock)
)
