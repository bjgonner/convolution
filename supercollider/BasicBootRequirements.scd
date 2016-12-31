s.boot;
s.reboot
(
s.startAliveThread;
ServerBoot.add { s.initTree };
)

s.plotTree;
s.meter(2,8);

{SinOsc.ar(440)}.play
s.killAll
s.quit