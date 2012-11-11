//Server setting
//s.latency;
//Interface Setting
Server.internal.options.device =  "Fireface UFX (23208981)";
Server.internal.options.sampleRate = 96000;

//OSC Setting

m = NetAddr("localhost", 7771); //Sender OSC POrt

//stop pattern

Pdef(\sine).stop;
Pdef(\pulse).stop;
Pdef(\snare).stop;