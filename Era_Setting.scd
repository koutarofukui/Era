//Server setting
s.latency = 0.0001;
//Interface Setting
Server.internal.options.device =  "Fireface UFX (23208981)";
Server.internal.options.sampleRate = 96000;

//OSC Setting

m = NetAddr("localhost", 7771); //Sender OSC POrt

//stop pattern
Pdef(\kick).stop;
Pdef(\sine).stop;
Pdef(\pulse).stop;
Pdef(\snare).stop;
Pdef(\henonC).stop;
Pdef(\logisticMapBass).stop;
Pdef(\sineBass).stop;
Pdef(\sine_2).stop;
Pdef(\snare_2).stop;