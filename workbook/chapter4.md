# Chapter 4: Delve into e3 with startup scripts

[Return to Table of Contents](README.md)

## Lesson overview

In this lesson, you'll learn how to do the following:
* Build the startup script for an IOC in e3
* Understand different methods of using EPICS functions within startup scripts
* Understand the local setup for `.db` and `.protocol` files
* Add common (global) modules to the IOC

## A simulated serial device

We will use a simple simulator based on *[Kameleon](https://bitbucket.org/europeanspallationsource/kameleon)* to simulate a serial device, accessible by use of e.g. telnet. This chapter will use [this](https://github.com/jeonghanlee/kameleon) fork of the original repository. The device that the simulator is based on as well as an EPICS IOC to go with it can be found at https://github.com/jeonghanlee/gconpi. <!-- verify this, to see exactly what needs to be cloned -->

*N.B.! Kameleon was written for Python2 (tested on 2.7), so make sure you have that installed.*

> Before continuing, you should clone this very tutorial's repository if you haven't already:
> 
> ```console
> [iocuser@host:~]$ git clone https://github.com/icshwi/e3training
> ```

0. Open a new terminal and go to `~/e3training/ch4_supplementary_path`.

1. Run:

   ```console
   [iocuser@host:ch4_supplementary_training]$ ./simulator.bash
   ```

2. Open another terminal, and connect to the simulator using telnet:

   ```console
   [iocuser@host:ch4_supplementary_training]$ telnet 127.0.0.1 9999
   ```

3. You should be able to interact with the simulator. <!-- try out first -->

4. End the telnet connection 

   ```console
   ^]
   telnet> quit
   Connection closed.
   ```

   (, where ^ is the Ctrl key.)

## Startup scripts

In `ch4_supplementary_path/cmds`, you will find a number of startup scripts that will be used for the following steps.

> For each of these scripts, you should attempt to first figure out what is happening before continuing reading this tutorial. And whenever a question is asked, attempt to answer it before reading the next sentence.

> Before the running `iocsh.bash`, don't forget to load your e3 environment:
> 
> ```console
> [iocuser@host:ch4_supplementary_training]$ source ~/e3-3.15.5/tools/setenv
> ```

### 0.cmd

> For all subsequent steps, ensure that the simulator is running.

Execute the first script:

```console
[iocuser@host:ch4_supplementary_training]$ iocsh.bash cmds/0.cmd
```

* Did it work?
* Can you explain why?
* Could you fix this startup script?

#### Variables

* Can you see the two variables `E3_IOCSH_TOP` and `E3_CMD_TOP`?
* How are these two variables changed if you instead execute `iocsh.bash` from within `cmds/`?:

```console
[iocuser@host:cmds]$ iocsh.bash 0.cmd 
```

* What is `0.cmd` in this context?

  `0.cmd` is used as an argument for `iocshLoad` internally. Inspect the following line:

  ```bash
  iocshLoad '0.cmd',''
  ```

### 1.cmd

Execute the next script.

* How many dependency modules of stream are loaded? Look carefully at the output:

  ```console
  [iocuser@host:ch4_supplementary_training]$ iocsh.bash cmds/1.cmd
  iocshLoad 'cmds/1.cmd',''
  require stream,2.8.8
  Module stream version 2.8.8 found in /epics/base-3.15.5/require/3.0.5/siteMods/stream/2.8.8/
  Module stream depends on asyn 4.33.0
  Module asyn version 4.33.0 found in /epics/base-3.15.5/require/3.0.5/siteMods/asyn/4.33.0/
  Loading library /epics/base-3.15.5/require/3.0.5/siteMods/asyn/4.33.0/lib/linux-x86_64/libasyn.so
  Loaded asyn version 4.33.0
  Loading dbd file /epics/base-3.15.5/require/3.0.5/siteMods/asyn/4.33.0/dbd/asyn.dbd
  Calling function asyn_registerRecordDeviceDriver
  Loading module info records for asyn
  Module stream depends on calc 3.7.1
  Module calc version 3.7.1 found in /epics/base-3.15.5/require/3.0.5/siteMods/calc/3.7.1/
  Module calc depends on sequencer 2.2.6
  Module sequencer version 2.2.6 found in /epics/base-3.15.5/require/3.0.5/siteMods/sequencer/2.2.6/
  Loading library /epics/base-3.15.5/require/3.0.5/siteMods/sequencer/2.2.6/lib/linux-x86_64/libsequencer.so
  Loaded sequencer version 2.2.6
  sequencer has no dbd file
  Loading module info records for sequencer
  Module calc depends on sscan 1339922
  Module sscan version 1339922 found in /epics/base-3.15.5/require/3.0.5/siteMods/sscan/1339922/
  Module sscan depends on sequencer 2.2.6
  Module sequencer version 2.2.6 already loaded
  Loading library /epics/base-3.15.5/require/3.0.5/siteMods/sscan/1339922/lib/linux-x86_64/libsscan.so
  Loaded sscan version 1339922
  Loading dbd file /epics/base-3.15.5/require/3.0.5/siteMods/sscan/1339922/dbd/sscan.dbd
  Calling function sscan_registerRecordDeviceDriver
  Loading module info records for sscan
  Loading library /epics/base-3.15.5/require/3.0.5/siteMods/calc/3.7.1/lib/linux-x86_64/libcalc.so
  Loaded calc version 3.7.1
  Loading dbd file /epics/base-3.15.5/require/3.0.5/siteMods/calc/3.7.1/dbd/calc.dbd
  Calling function calc_registerRecordDeviceDriver
  Loading module info records for calc
  Module stream depends on pcre 8.41.0
  Module pcre version 8.41.0 found in /epics/base-3.15.5/require/3.0.5/siteMods/pcre/8.41.0/
  Loading library /epics/base-3.15.5/require/3.0.5/siteMods/pcre/8.41.0/lib/linux-x86_64/libpcre.so
  Loaded pcre version 8.41.0
  pcre has no dbd file
  Loading module info records for pcre
  Loading library /epics/base-3.15.5/require/3.0.5/siteMods/stream/2.8.8/lib/linux-x86_64/libstream.so
  Loaded stream version 2.8.8
  Loading dbd file /epics/base-3.15.5/require/3.0.5/siteMods/stream/2.8.8/dbd/stream.dbd
  Calling function stream_registerRecordDeviceDriver
  Loading module info records for stream
  ```

* Is it what we defined? How would we check that?

  ```console
  [iocuser@host:e3-StreamDevice]$ make vars
  ```

  Look at `ASYN_DEP_VERSION` and `PCRE_DEP_VERSION`. These dependencies will be described in more detail later on.

  > We can print these variables more easily with `make dep`.

### 2.cmd

Execute the next script:

```console
[iocuser@host:ch4_supplementary_training]$ iocsh.bash cmds/2.cmd
```

* What is `iocInit`?

> If you do not know, you might want to spend some time with the [EPICS Application Developer's Guide](https://epics.anl.gov/base/R3-15/5-docs/AppDevGuide/IOCInitialization.html#x8-2750007.4).

* What is the difference between `1.cmd` and `2.cmd`?

  > e3's `iocsh.bash` will check if `iocInit` is defined within a startup script. If it isn't, it will be added automatically You should however always specify `iocInit` clearly as some functions should be executed after `iocInit`. 

* Can you spot the warning? And can you explain what kind of warning it is?

*N.B.! Each line in the output of the IOC is important. You should always be careful to ensure that everything looks correct.*

### 3-1.cmd

Execute the next command:

```console
[iocuser@host:ch4_supplementary_training]$ iocsh.bash cmds/3-1.cmd 
```

* The IOC is running, but it doesn't connect to anything. Can you see the message which represents this situation?

  > Beware that the application launches regardless of if it finds hardware or not. In `3-1.cmd` there are no `.db.`-files to specify records and fields, which is why no errors appear.

This script contains the correct asyn configuration for the simulated device:

```bash
drvAsynIPPortConfigure("CGONPI", "127.0.0.1:9999", 0, 0, 0)
```

### 3-2.cmd

This script contains a fully working IOC---inspect it thouroughly.

* Can you find the warning? 
* How does this script use `E3_CMD_TOP`? Is it useful to define where other files are? 
* What is the stream protocol file? 

### 4.cmd

Since `3-2.cmd` we have a functioning IOC which can communicate with our simulated device. We would, however, generally want to tie more EPICS modules into that IOC, such as `iocStats`, `autosave`, and `recsync`. For this, we will need the specific module's name, its' version, as well as its' corresponding configuration files (`.db` files and so forth).

Execute the next script:

```console
[iocuser@host:ch4_supplementary_path]$ iocsh.bash cmds/4.cmd
```

1. Type `dbl` to see the IOC's PVs.
2. Get the heartbeat of your IOC:

   ```
   350b5cb.kaffee.4355 > dbpr IOC-80159276:IocStat:HEARTBEAT
   ```

   > The number `80159276` is here random. If you see the same number on your machine, today is your lucky day!

3. Get the heartbeat again. Is it the same? Why not?

Spend some time thinking about the following:

* `epicsEnvSet` Can you see two different ways for it to be used? 

* `dbLoadRecords` Can you see two different ways for it to be used?

* Could you rewrite startup scripts using only one method? 

### 5.cmd

Here we add `iocStats` in a slightly different way, and have furthermore added more default e3 modules.

0. Go to **E3_TOP** and run the following commands:

    ```bash
   [iocuser@host:e3-3.15.5]$ make -C e3-iocStats/ existent
   [iocuser@host:e3-3.15.5]$ make -C e3-recsync/  existent
   [iocuser@host:e3-3.15.5]$ make -C e3-autosave/ existent
   ```

   * Can we see the `*.iocsh` files with the installation path of e3?

   The e3 function `loadIocsh` is a function similar to EPICS' function `iocshLoad`. It supplies us with a reusable modularized startup script to simplify development.

   > `loadIocsh` can of course still be used, but `iocshLoad` is highly recommended. 

1. Run the following command to print your PVs, and inspect the output file:

   ```console
   [iocuser@home:ch4_supplementary_path]$ bash ../tools/caget_pvs.bash -l IOC-NNNNNNNN_PVs.list 
   ```

   (, where `NNNNNNNN` is your IOC's random number.) 


------------------
[:arrow_backward:](chapter3.md)  | [:arrow_up_small:](chapter4.md)  | [:arrow_forward:](chapter5.md)
:--- | --- |---: 
[Chapter 3: Installing modules with different version number](chapter3.md) | [Chapter 4](chapter4.md) | [Chapter 5: Take the deployment or the development](chapter5.md)
