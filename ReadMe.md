Florida Man
===========

Live the life of adventure. Play your favorite Flordia Man adventures as seen in the internet. You want to jump into the crocodile pit? Sure, go for it. You want to cook some meth and then ask a cop if it is okay? Nothing is off limits for Florida Man.

This is the Commodore 64 version. Maybe more platforms will come in the future.

Developer Tools
===============
Instructions for getting the source code to compile.

- Kick Assembler v5.5: http://www.theweb.dk/KickAssembler This requires java in order to work
    You can configure KickAssembler to automatically start Vice after a compile, and it will start the program immediately. This is helpful.
        - First, locate the file: KickAss.cfg in the KickAss folder
        - Edit the KickAss.cfg and make sure it looks like this:

            -showmem
            -symbolfile
            -execute "X:\Your\Path\To\WinVICE-3.0-x64\x64.exe"

        - That's it! Now it will load the compiled program into vice and run it once it is finished compiling.


Optional tools:
- Vice v3.0+: http://vice-emu.sourceforge.net/ 
- Sprite Pad v1.8.1: https://csdb.dk/release/?id=100657 Homepage: http://www.subchristsoftware.com/spritepad.htm
    Note: Export as PRG file, the location doesn't matter as KickAss reassigns the start memory
- VChar64 v0.2.4: https://csdb.dk/release/?id=154949
    Note: Export as ASM. In order to get this file to work with KickAss you must edit the file it creates and 
          change all of the ; (for ASM comments) to // (for KickAss comments)
          You may also wish to change the file extension from .s to .asm (not sure if that matters or not)
- droiD64 v0.15b: https://csdb.dk/release/?id=172082
    This will allow you to construct .D64 images
    
More to come, standby
  /\
-Deadline-
     \/
