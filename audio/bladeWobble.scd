(
SynthDef(\sawFilt, { |out = 0, freq = 440, amp = 0.1, gate = 1, cf = 100, lag=0.05, wobble = 3, t_bd, t_sd, pw = 0.4, rel=3|
	var base,env,sig,bd,sd,pan;
     base = Splay.ar(RLPF.ar(Pulse.ar(freq * [0.99,0.5,1.01],pw),cf.lag(lag),0.3).madd(SinOsc.ar(wobble).range(2,4)).sin * 0.5) ;
    env = Linen.kr(gate, attackTime: 0.5, releaseTime: rel, doneAction: 2);
    sig = base;
    sd = HPF.ar(sig,60);
	sd = MoogFF.ar(in:sig,freq:freq*[0.5,0.5],gain:1.1);
    sig = tanh(GVerb.ar(HPF.ar(base * env,30), 70, 11, 0.15)*0.5 + sig + sd);
	//pan=Pan2.ar(in:sig,pos:SinOsc.kr(pw).range(-1,1));
    Out.ar(out, sig*amp*env);
}).add;
)

(
~v =Pdef(
	\wobblePlay,
	Pbind(
		\instrument, \sawFilt,
		\tempo, 120/60,
		\ctranspose, -22,
		\degree,
		Pseq( [Pseq([1,1,3,5],2),
			Pseq([7,3,2],1)]
			,inf).trace,
		\dur, Pseq([
			Pseq([8,4,4,4],2),
			Pseq([8,4,4],1)
			],

			inf),
		//\amp, Pkey(\degree)*0.1,
		\amp, Pseq([
			Pseq([0.1,0.1,0.3,0.4],2),
			Pseq([0.3,0.3,0.5],1)
		],inf),
		\wobble,1,
		\pw,Pseq([0.4],inf),
		\cf,Pseq([

		Pseq([300,300,200,100],2),
			Pseq([100,200,300],1)
		],inf)
	);
)
)

s.meter
~v.play
~v.stop
