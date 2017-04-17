~seqAmp.postln;
~seqAmp.source = Pseq([0.1, 0.5, 1.5], inf);
~stepSequence.stop;
~stepSequenceRoot.stop;
 ~stepSequenceRoot.stop;
~seqAmp.source.postln;
p = Pmono(\default, \dur, 0.125, \freq, Pwhite(1,8) * 100 ).play(t, quant:1);
p.stop;

(
SynthDef(\sawpulse, { |out, freq = 440, gate = 0.5, plfofreq = 6, mw = 0, ffreq = 2000, rq = 0.3, freqlag = 0.05, amp = 1|
    var sig, plfo, fcurve;
    plfo = SinOsc.kr(plfofreq, mul:mw, add:1);
    freq = Lag.kr(freq, freqlag) * plfo;
    fcurve = EnvGen.kr(Env.adsr(0, 0.3, 0.1, 20), gate);
    fcurve = (fcurve - 1).madd(0.7, 1) * ffreq;
    sig = Mix.ar([Pulse.ar(freq, 0.9), Saw.ar(freq*1.007)]);
    sig = RLPF.ar(sig, fcurve, rq)
        * EnvGen.kr(Env.adsr(0.04, 0.2, 0.6, 0.1), gate, doneAction:2)
        * amp;
    Out.ar(out, sig ! 2)
}).add;
)

p = PmonoArtic(\sawpulse, \dur, 0.125, \degree, ~stepSeqDegrees, \legato, 1.0 ).play;
~stepstep =  PmonoArtic(\sawpulse, \dur, 0.125, \degree, ~stepSeqDegrees, \root, ~rootNotesDegrees, \legato, 1.0, \amp, Pfunc{~testSeqAmp} ).play(t, quant: 1);
p.stop;
~stepstep.pause;
~stepstep.stop;
x=Synth(\sawpulse).play;

x.stop;

