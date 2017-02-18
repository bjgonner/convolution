//find audio

//create dictionary

(
d=Dictionary.new;
d.add(\l ->
	PathName("/Users/astewart/Developer/SuperColliderTests/sounds/SplitSounds/low").entries.collect({
		arg sf;
		Buffer.read(s, sf.fullPath);
	});
);
d.add(\m ->
	PathName("/Users/astewart/Developer/SuperColliderTests/sounds/SplitSounds/mid").entries.collect({
		arg sf;
		Buffer.read(s, sf.fullPath);
	});
);

d.add(\h ->
	PathName("/Users/astewart/Developer/SuperColliderTests/sounds/SplitSounds/high").entries.collect({
		arg sf;
		Buffer.read(s, sf.fullPath);
	});
);
)
d[\m].choose;

(
SynthDef.new(\bufplay, {
	arg buf=0, rate=1, loop=0, t_trig = 1, amp=1, da=2;
	var sig;
	sig = PlayBuf.ar(2, buf, BufRateScale.ir(buf) * rate, loop: loop, doneAction:da);
	sig = sig * amp;
	Out.ar(0, sig);
}).add;
)

y =Synth.new(\bufplay, [\buf, d[\m].choose.bufnum]);
y.free;
y.set(\rate, 1);