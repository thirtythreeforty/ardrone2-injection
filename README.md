This code is intended to be loaded as a shared library before libc, probably using
the LD_PRELOAD environment variable.  It intercepts calls to open() and redirects
any that attempt to open any file with the string "ttyUSB" in its name.

The expected use case is on the AR Drone 2.0's program.elf, which assumes that a
serial USB device must be a debugging tool intended for its use and immediately
hijacks the device, leaving it useless for other programs.  As far as I can tell,
there is no command-line flag to disable this rude behavior.  Hence this hack.

If you just want to intercept open()s of ttyUSBs, you can use the precompiled inject.so
library.  Copy it to the quadrotor's /lib directory.  Then, modify the initscript that
loads program.elf.  It's somewhere in /etc, although I don't remember exactly where.
Prepend the following to the line that actually invokes program.elf:

    LD_PRELOAD=/lib/inject.so

Note: I left the emergency restart command alone, thinking that if the drone needs to be
in emergency mode, I probably want the flight control firmware to revert to the factory
state.  It seems to handle the I/O error it gets correctly though, so I don't think it
would hurt to inject the library there as well if you need it in emergency mode.

If there are other annoying things that program.elf does that you would rather it not,
you can always modify the source code.  Essentially, any function that you define that
has the same name as a libc function will be called instead of the libc function.  You
very likely don't want to block all calls to whatever function it is you're overriding,
so look up the address of the original function (using the dlsym() function) and call it
if you decide not to intercept the call.

Once you decide to build your modifications, you can use the build.sh script.  (Yes, I
know, it really should be a Makefile.)  It assumes you have used crosstool-ng to set up a
arm-cortex_a8-linux-gnueabi target in the default ~/x-tools directory.  If you have
crosstool-ng installed, you can set this up with

    ct-ng build arm-cortex_a8-linux-gnueabi

This will take a long time to compile a version of GCC for you to use.  After it's done,
you can just do

    ./build.sh

and it should regenerate your new inject.so for you.  If you don't want to deal with
crosstool, you may be able to coax vanilla GCC into building for ARM, but I find that it's
entirely too much trouble.

Happy hacking!

 -- George Hilliard
	("thirtythreeforty")
