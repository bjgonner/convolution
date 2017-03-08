s.boot;
s.reboot
(
s.startAliveThread;
ServerBoot.add { s.initTree };
)

s.plotTree;
s.meter(2,8);

x = {SinOsc.ar(440)}.play
x.free;
s.killAll
s.quit
(
var foo = "defsTest.scd";
var bar  = "defsTest2.scd";
var files = #["defsTest.scd", "defsTest2.scd"];
Server.default.waitForBoot {
        var dir = thisProcess.nowExecutingPath.dirname;
	files.do { |f| (dir +/+ f).load; s.sync; };
}
)

	thisProcess.nowExecutingPath.dirname.postln;

x =Synth(\funSynth, [pitch:50.rrand(600)]);
x =Synth(\beeu, [freq:50.rrand(6000)]);
x =Synth(\Moog, [freq:200.rrand(800), gate:1]);
x.free;