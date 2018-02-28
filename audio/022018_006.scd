(SynthDef(\deep,{ |detune=0,amp=0.5,rate=0.1,lag=0.1,buf|
	var f,sig,oscA,sub,freqMod,filCut,lfo,filter,pitch,offset,oscB;
	pitch=\pitch.kr(val:50,lag:lag);
	filCut = EnvGen.kr(Env.adsr(0.001,0.01,0.25,0.01,curve:-5),doneAction:2);
	freqMod = EnvGen.kr(Env.linen(0.01,0.15,0.01)).range(1,3);
	lfo=LFTri.kr(rate);
	//stepper = Stepper.kr(trig:Impulse.kr(rate*8),reset:0,min:1,max:12,step:3);
	f=(pitch+detune).midicps;
	oscA=Pulse.ar((f/2)*freqMod); //-1 octave
	sub = SinOsc.ar(f/4,mul:2);
	offset=freqMod;
	oscB = VOsc.ar(bufpos:buf,freq:f/2,mul:2);

	sig = Splay.ar([oscA/2,oscB]);
	//filter=SVF.ar(signal:sig,cutoff:filCut.range(100,1500),res:0.75);
	 // filter = BLowPass4.ar(sig,freq:filCut.range(100,2000),rq:0.75);
	filter = MoogFF.ar(in:sig,freq:filCut.range(100,1000));
	//filter = DFM1.ar(in:filter,freq:filCut.range(100,3000)+LFNoise0.kr(rate),res:0.8);
	//filter = DelayC.ar(in:filter,maxdelaytime:1,delaytime:0.1);
	filter = JPverb.ar(filter,t60:1);
	Out.ar(0,filter*amp!2);

}).send(s);)


(SynthDef(\deep,{ |detune=0,amp=0.5,rate=0.1,lag=0.1,buf|
	var f,sig,oscA,sub,freqMod,filCut,lfo,filter,pitch,offset,oscB;
	pitch=\pitch.kr(val:50,lag:lag);
	filCut = EnvGen.kr(Env.adsr(0.001,0.01,0.25,0.01,curve:-5),doneAction:2);
	freqMod = EnvGen.kr(Env.linen(0.01,0.15,0.01)).range(1,3);
	lfo=LFTri.kr(rate);
	//stepper = Stepper.kr(trig:Impulse.kr(rate*8),reset:0,min:1,max:12,step:3);
	f=(pitch+detune).midicps;
	oscA=Pulse.ar((f/2)*freqMod); //-1 octave
	sub = SinOsc.ar(f/4,mul:2);
	offset=freqMod;
	oscB = VOsc.ar(bufpos:buf,freq:f/2,mul:2);

	sig = Splay.ar([oscA/2,oscB]);
	//filter=SVF.ar(signal:sig,cutoff:filCut.range(100,1500),res:0.75);
	 filter = BLowPass4.ar(sig,freq:filCut.range(100,2000),rq:0.75);
	filter = MoogFF.ar(in:sig,freq:filCut.range(100,2000));
	filter = DFM1.ar(in:filter,freq:filCut.range(100,3000)+LFNoise0.kr(rate),res:0.8);
	filter = DelayC.ar(in:filter,maxdelaytime:1,delaytime:0.1);
	//filter = JPverb.ar(filter,t60:1);
	Out.ar(0,filter*amp!2);

}).send(s);)





~buffs

//64 60 77 72 76

a=Synth(\deep,[pitch:57,\buf,~buffs[3]])
a.set(\pitch,50)
a.set(\lag,0.6)
//43 45 47 48
a.set(\amp,0.3)

a.set(\rate,0)

a.set(\amp,0.6)
43/100
MIDIClient.init;
MIDIIn.connectAll;

(MIDIdef.noteOn(\t,{ arg vel, nn, chan, src;
	[vel,nn].postln;
	a.set(\pitch,nn);
	//~single.set(\cf,nn.midicps*2);
	a.set(\lag,nn/100+0.1)
};))