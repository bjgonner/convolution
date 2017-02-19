//find audio

//create dictionary

(
var filePath;
filePath = PathName("/Users/astewart/Google\ Drive/2016_Fall/Convolution/InterfaceCode/supercollider/sounds/SplitSounds");

d=Dictionary.new;
d.add(\l ->
	PathName(filePath.fullPath +/+ "/low").entries.collect({
		arg sf;
		Buffer.read(s, sf.fullPath);
	});
);
d.add(\m ->
	//PathName("/Users/astewart/Developer/SuperColliderTests/sounds/SplitSounds/mid").entries.collect({
	PathName(filePath.fullPath +/+ "/mid").entries.collect({
		arg sf;
		Buffer.read(s, sf.fullPath);
	});
);

d.add(\h ->
	PathName(filePath.fullPath +/+"/high").entries.collect({
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

y =Synth.new(\bufplay, [\buf, d[\m].choose.bufnum, \rate, 2]);
y.free;
y.set(\rate, 0.25);