<b>Working Notes</b>

These will be streamlined into documentation of the project in the months to come.  
Currently, they are just a place to paste configuration settings.

<b>Jack Audio Settings</b>

Massive XRuns cause supercollider server to crash/quit after about 1 minute without these settings:

`jackd -r48000 -P70 -dalsa -dhw:1 -p128 -n3 -s`

Values may change as I tweak to the best possible settings.

Settings are based on this site: http://wiki.linuxaudio.org/wiki/raspberrypi

Need to test: setting cpu_scaling to performance and turning off certain unneeded services, or running without desktop once interface is completed.


<b>Supercollider</b>

Running ide with `scide -style=gtkrc` makes tooltips legible which is crucial for training beginners.  
Hopefully his will be fixed in future version of SC and will not need change.

