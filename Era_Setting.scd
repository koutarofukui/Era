//Server setting
s.latency = 0.03;
//Interface Setting
Server.internal.options.device =  "Fireface UFX (23208981)";
Server.internal.options.sampleRate = 96000;

//OSC Setting

m = NetAddr("localhost", 7771); //Sender OSC POrt

//stop pattern

Pdef(\pulseSegment_inst).stop;
Pdef(\noise_inst).stop;
Pdef(\sineBass_inst).stop;

Pdef(\kick).stop;
Pdef(\sine).stop;
Pdef(\pulse).stop;
Pdef(\snare).stop;
Pdef(\henonC).stop;
Pdef(\logisticMapBass).stop;
Pdef(\sineBass).stop;
Pdef(\sine_2).stop;
Pdef(\snare_2).stop;
Pdef(\logisticMap_Synth).stop;
Pdef(\grayNoise).stop;
Pdef(\whiteNoise).stop;


Pdef(\beat).stop;
Pdef(\snare).stop;
Pdef(\grain).stop;
Pdef(\grain_2).stop;
Pdef(\sineHit).stop;
Pdef(\amSine).stop;
Pdef(\grayNoise).stop;
Pdef(\whiteNoise).stop;
Pdef(\sinePulse_L).stop;
Pdef(\sinePulse_R).stop;
Pdef(\amSineBass).stop;
Pdef(\chord).stop;
