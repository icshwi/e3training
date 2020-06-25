# Chapter 4: Delve into e3 with startup scripts

## Lesson overview

In this lesson, you'll learn how to do the following:
* Build the startup script for an IOC in e3
* Understand the different method to use the EPICS function within a startup script  <!-- fixme -->
* Understand the local setup for DB and protocol files
* Add the common (global) module into the IOC

## A Simulated Serial Device by Kameleon 

We will use a simple simulator based on [Kameleon](https://bitbucket.org/europeanspallationsource/kameleo) to simulate a simple serial device, accessible by use of telnet. This chapter will use [this](https://github.com/jeonghanlee/kameleon) fork of the original repository. The device that the simulator is based on as well as an EPICS IOC to go with it can be found at https://github.com/jeonghanlee/gconpi.

Before commencing, you should clone this tutorial repository if you haven't already:

```console
[iocuser@host:~]$ git clone https://github.com/icshwi/e3training
```

0. Open a new terminal and go to `~/e3training/ch4_supplementary_path`.

1. Run:

   ```console
   [iocuser@host:ch4_supplementary_training]$ ./simulator.bash
   ```

2. Open another terminal, and connect to the simulator using telnet.*

   ```
   [iocuser@host:ch4_supplementary_training]$ telnet 127.0.0.1 9999
   ```

3. You should be able to interact with the simulator. <!-- try out first -->

4. End the telnet connection 

   ```telnet
   ^]
   telnet> quit
   Connection closed.
   ```

   (, where ^ is the Ctrl key.)

*You may have to install telnet.

## Startup scripts

In ```ch4_supplementary_path/cmds```, there are several startup scripts according to its step from scratch to final configuration.
Before the running iocsh.bash, don't forget to set the e3 dynamic environment if you are in **E3_TOP** as ~/e3-3.15.5 via

```console
[iocuser@host:ch4_supplementary_training]$ source ~/e3-3.15.5/tools/setenv
```

### 0.cmd

For all subsequent steps, ensure that the simulator is running. <!-- move this -->

```console
[iocuser@host:ch4_supplementary_training]$ iocsh.bash cmds/0.cmd
```

Does it work?

* Check it whether it works or not
* If not, explain why?
* Can you fix this startup script?

#### E3_IOCSH_TOP and E3_CMD_TOP 

* Can you see the two VARIABLES such as ```E3_IOCSH_TOP``` and ```E3_CMD_TOP``` ?
* How two variables are changed if one can execute iocsh.bash within cmds? 

```
$ cmds (master)$ iocsh.bash 0.cmd 
```

#### How 0.cmd can be handle within this command?

The ```0.cmd``` is used as "arguments" of iocshLoad internally. One can see the following line:

```
iocshLoad '0.cmd',''

```

### 1.cmd
Please make sure that the simulator is running.

```
 ch4_supplementary_path (master)$ iocsh.bash cmds/1.cmd
```

* How many dependency modules of stream are loaded? Please carefully look at few lines outputs similar with the following

```
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

* Is it the same as what we defined? How do we check this? One can check it through

```
e3-StreamDevice (master)$ make vars
```

to look at `ASYN_DEP_VERSION` and `PCRE_DEP_VERSION`. Anyway, the dependency will be described later on in more detail. We can check these variables more easily with `make dep`.

### 2.cmd

Please make sure that the simulator is running.

* Run the following command
```
 ch4_supplementary_path (master)$ iocsh.bash cmds/2.cmd
```
* What is the iocInit ?

Please spend some time to read the EPICS Application Developer's Guide [3]. 

* What is the difference between 1.cmd and 2.cmd?
e3 iocsh.bash will check whether iocInit is defined or not within a startup script. If not, it will add it automatically. However, please specify iocInit clearly, because some functions should be executed after iocInit. 

* Can you see the Warning? And can you explain what kind of Warning do you have? 
Note that each single line output of the ioc is important. One should make sure that each line is correct, and one should understand each line correctly. 

### 3-1.cmd

* Run the following command

```
ch4_supplementary_path (master)$ iocsh.bash cmds/3-1.cmd 
```

* IOC is running, however, it doesn't connect to anywhere. Can you see the message which represents this situation? 
Please remember, it runs at the end of your startup script whether it finds a hardware or not. In 3-1.cmd, we doesn't have db files which actually talk to the hardware. Thus, we don't see any error messages at all. I would like to emphasize the following one more time. Note that each single line output of the ioc is important. One should make sure that each line is correct, and one should understand each line correctly. 

This script has the asyn configuration for the simulated device such as

```
drvAsynIPPortConfigure("CGONPI", "127.0.0.1:9999", 0, 0, 0)
```

* One should the run the Kameleon simulator in the different terminal, then run the above command. 

* The following log is a snippet of the IOC output

```
ch4_supplementary_path (master)$ iocsh.bash cmds/3-1.cmd

# --- snip snip ---

iocshLoad 'cmds/3-1.cmd',''
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
drvAsynIPPortConfigure("CGONPI", "127.0.0.1:9999", 0, 0, 0)
iocInit()
Starting iocInit
############################################################################
## EPICS R3.15.5-E3-3.15.5-patch
## EPICS Base built Mar 13 2019
############################################################################
drvStreamInit: Warning! STREAM_PROTOCOL_PATH not set. Defaults to "."
iocRun: All initialization complete
# Set the IOC Prompt String One 
epicsEnvSet IOCSH_PS1 "791f5f3.faiserv.24402 > "
```

* The following log is a snippet of Kameleon :

```
jhlee@faiserver: ch4_supplementary_path (master)$ bash simulator.bash 

****************************************************
*                                                  *
*  Kameleon v1.5.0 (2017/SEP/14 - Production)      *
*                                                  *
*                                                  *
*  (C) 2015-2017 European Spallation Source (ESS)  *
*                                                  *
****************************************************

[21:30:40.314] Using file '/home/jhlee/ics_gitsrc/e3training/workbook/ch4_supplementary_path/kameleon/simulators/gconpi/gconpi.kam' (contains 0 commands and 1 statuses).
[21:30:40.314] Start serving from hostname '127.0.0.1' on port '9999'.
[21:30:45.461] Client connection opened.
[21:30:45.896] Status 'CPS, 1, CPM, 7, uSv/hr, 0.044, SLOW<0x0d><0x0a>' (Get Data) sent to client.
[21:30:46.404] Status 'CPS, 4, CPM, 17, uSv/hr, 0.009, SLOW<0x0d><0x0a>' (Get Data) sent to client.
[21:30:46.911] Status 'CPS, 4, CPM, 13, uSv/hr, 0.039, SLOW<0x0d><0x0a>' (Get Data) sent to client.
[21:30:47.418] Status 'CPS, 3, CPM, 15, uSv/hr, 0.017, SLOW<0x0d><0x0a>' (Get Data) sent to client.
```

### 3-2.cmd

Please make sure that the simulator is running.
This script has the full information on the single IOC running. Please evaluate all components in 

```
require stream,2.8.8

epicsEnvSet("TOP","$(E3_CMD_TOP)/..")

system "bash $(TOP)/tools/random.bash"

iocshLoad "$(TOP)/tools/random.cmd"

epicsEnvSet("P", "IOC-$(NUM)")
epicsEnvSet("IOCNAME", "$(P)")
epicsEnvSet("PORT", "CGONPI")

epicsEnvSet("STREAM_PROTOCOL_PATH", ".:$(TOP)/db")

drvAsynIPPortConfigure("$(PORT)", "127.0.0.1:9999", 0, 0, 0)

dbLoadRecords("$(TOP)/db/gconpi-stream.db", "SYSDEV=$(IOCNAME):KAM-RAD1:,PORT=$(PORT)")

iocInit()
```

* Can you see the Warning? 
* How does this script use ```E3_CMD_TOP```? Is it useful to define where other files are? 
* What is the stream protocol file? 

#### Few commands within IOC

If you would like to play few commands within IOC, feel free to try them out. 


* help

```
350b5cb.kaffee.12199 > help

```

* dbl

```
350b5cb.kaffee.12199 > dbl

```

* date

```
350b5cb.kaffee.12199 > date
```

### 4.cmd

Please make sure that the simulator is running.

From ```3.cmd```, we have the running IOC which can communicate with the simulated device. Moreover, generally, we will add more generic EPICS modules into that IOC, such as iocStats, autosave, recsync, and so on. 

In this case, we do require the individual module name, and its version, and its corresponding configuration files (EPICS db files, etc).

0. Run the 4.cmd

```
 ch4_supplementary_path$ iocsh.bash cmds/4.cmd
```

1. Type dbl to check which PVs can be found.

```
350b5cb.kaffee.4355 > dbl
```

1. Get the HEARTBEAT of your IOC

```
350b5cb.kaffee.4355 > dbpr IOC-80159276:IocStat:HEARTBEAT
```

, where the number 80159276 is the random number. One should see the different number in your IOC. If you have the same number, you have a good luck today!

3. Run one more times, the same command to see that the HEARTBEAT is increasing.

```
350b5cb.kaffee.4355 > dbpr IOC-80159276:IocStat:HEARTBEAT
```

1. Please spend some time to look at the following:

* epicsEnvSet : can you see two different ways to be used? 

* dbLoadRecords : can you see two different ways to be used?

Can you rewrite all startup script with only one method? 

### 5.cmd
Please make sure that the simulator is running.

Here we add the IocStats in the slightly different way, and add more modules exist within e3 by default. 

0. Please go **E3_TOP**, and run the following commands:
```
e3-3.15.5$ make -C e3-iocStats/ existent
e3-3.15.5$ make -C e3-recsync/  existent
e3-3.15.5$ make -C e3-autosave/ existent
```
Can we see the *.iocsh files with the installation path of e3?

The e3 function **loadIocsh** is a similar function which EPICS function **iocshLoad**, but it acts differently. However, it gives us a modularized startup script which we can reuse in order to build up a startup script without considering technical details a lot. Even if we can use **loadIocsh**, **iocshLoad** is highly recommended. 

1. Please run the following commands to see which PVs exist in your IOC

```
ch4_supplementary_path$ bash ../tools/caget_pvs.bash -l IOC-NNNNNNNN_PVs.list 
```

, where NNNNNNNN is the random number. 

## Reference 
[3] EPICS Application Developer's Guide, IOC Initialization https://epics.anl.gov/base/R3-15/5-docs/AppDevGuide/IOCInitialization.html#x8-2750007.4

[4] EPICS iocStats module http://www.slac.stanford.edu/comp/unix/package/epics/site/devIocStats/

[5] EPICS autosave module http://htmlpreview.github.io/?https://github.com/epics-modules/autosave/blob/R5-7-1/documentation/autoSaveRestore.html

[6] EPICS recsync module https://github.com/ChannelFinder/recsync


------------------
[:arrow_backward:](chapter3.md)  | [:arrow_up_small:](chapter4.md)  | [:arrow_forward:](chapter5.md)
:--- | --- |---: 
[Chapter 3: Installing modules with different version number](chapter3.md) | [Chapter 4](chapter4.md) | [Chapter 5: Take the deployment or the development](chapter5.md)
