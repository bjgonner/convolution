(
SynthDef(\beeu, { |freq = 1000|
	var sig, env;
	sig  = LFNoise2.ar(XLine.kr(10000, 20, 0.5), 0.25);
	sig = sig * SinOsc.ar(XLine.kr(50,freq, 0.3),0,1,0.5) +SinOsc.ar(100,0,1,0.5);// + LFNoise1.kr([50,50], 0.05);
	env = EnvGen.kr(Env.perc(curve: -6), doneAction: 2);
	Out.ar(0, 0.1*sig*env!2);
}).add;
)

(
SynthDef(\ueeb, { |freq=300, degree=1|
	var sig, env, test;

	sig  = LFNoise2.ar(XLine.kr(freq*10, freq*100, 0.2), 0.25);
	sig = sig + SinOsc.ar(freq,0,1,0.25) + LFNoise1.kr([50,50], 0.05);
	sig = sig * CombN.ar(SinOsc.ar(freq, 0, 0.2), 0.01, XLine.kr(0.0001, 0.001, 0.25), -1);
	env = EnvGen.kr(Env.perc(0.1, 0.4, 1, -8), doneAction: 2);
	Out.ar(0, 0.2*sig*env!2);
}).add;
)

(
SynthDef(\help_sinegrain,
    { arg out=0, freq=440, sustain=0.05;
        var env;
        env = EnvGen.kr(Env.perc(0.001, sustain, 0.05), doneAction:2);
        Out.ar(out, SinOsc.ar(freq, 0, env))
    }).add;
)

(
SynthDef(\help_sawgrain,
    { arg out=0, freq=440, ssustain=0.1;
        var env;
        env = EnvGen.kr(Env.perc(0.001, ssustain, 0.05), doneAction:2);
		Out.ar(out, SawDPW.ar(freq, 0, env))
    }).add;
)


(
// get elapsed time, round up to next second
v = Main.elapsedTime.ceil;
~mainTempo = 1;
(1000/125*60).postln;
// create two clocks, starting at time v.
t = TempoClock(1, 0, v);
u = TempoClock(t.tempo*8, 0, v);

// start two functions at beat zero in each clock.
// t controls u's tempo. They should stay in sync.
t.schedAbs(0, { arg beat, sec; /* [\t, beat, sec].postln;*/ 1 });
u.schedAbs(0, { arg beat, sec;/* [\u, beat, sec].postln;*/b.sendMsg("/tick", beat%32, "hrlp","more");  1 });
)
u
~degree = PatternProxy(Pn(Pseries(0, 1, 12), inf));
~dur = PatternProxy(Pn(0.125, inf));

~degree.source = Pseq([11,12,13, Rest,1,Rest,24, Rest,Rest,1,Rest, 1, Rest,1,1,Rest], inf);
~dur.source = Pn(1, inf);//PatternProxy(Pn(1, inf));

~degrees = PatternProxy(Pn(Pseries(0, 1, 12), inf));

~degrees2 = PatternProxy(Pn(Pseries(0, 1, 12), inf));

(




p = Pbind(
	\instrument, \beeu,
    \degree, ~degree,
	\scale, Pfunc{~scale},
    \dur, ~dur,
	\strum, 10

).play(u, quant: 1);


)
a = [1,1,1, Rest,1,Rest,1, Rest];
~degrees.source = Pseq([11,12,13, Rest,1,Rest,12, Rest,Rest,1,Rest, 1, Rest,1,1,Rest], inf);
~degrees2.source = Pseq([11,12,13, Rest,1,Rest,24, Rest,Rest,1,Rest, 1, Rest,1,1,Rest], inf);
~dur.source = Pn(1, inf);//PatternProxy(Pn(1, inf));
~degree.source = Pseq(Array.fill(16, {rrand(-3,7)}), inf);
(
//~degrees = PatternProxy(Pn(Pseries(12,-1, 12), inf));

~durs = PatternProxy(Pn(1, inf));

g = Pbind(
	\instrument, \ueeb,
    \degree, ~degrees,
	\scale, Pfunc{~scales},
    \dur, 0.125,
	\strum, 0.1
).play(t, quant: 1);

q = Pbind(
	\instrument, \beeu,
    \degree, ~degrees2,
	\scale, Pfunc{~scales},
    \dur, 0.125,
	\strum, 0.1
).play(t, quant: 1);
)

q.stop;
g.stop;
p.stop;
q.play