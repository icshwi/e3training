# Chapter 4 : Delve into e3 with startup scripts

## Lesson Overview

In this lesson, you'll learn how to do the following:
* Build the startup script for an IOC
* Understand the local setup for DB and protocol files
* Add the common (global) module into the IOC




## A Simulated Serial Device by Kameleon 

We will use  the simple simulator based on Kameleon [1] which simulates the simple serial device, which one can access through telnet. This chapter will use the forked version [2] of the original one. The original device and its EPICS IOC can be found at https://github.com/jeonghanlee/gconpi.

0. Open a new terminal or a new tab

1. Move into ```ch4_supplementry_path```

2. Run
   ```
   ./simulator.bash
   ```

3. Open yet another terminal, connect that simulator through telnet
   ```
   telnet 127.0.0.1 9999
   ```
4. One can see many messages within the telnet session and the running IOC

5. End the telnet connection 
   ```
   ^]
   telnet> quit
   Connection closed.
   ```
   , where ^ is the Ctrl key. 



## Startup Scripts

In ```ch4_supplementry_path/cmds```, there are several startup scripts according to its step from scratch to final configuration.
Before the running iocsh.bash, don't forget to set the e3 dynamic environment if you are in **E3_TOP** as ~/e3-3.15.5 via

```
$ source ~/e3-3.15.5/tools/setenv
```



### 0.cmd

```
 ch4_supplementry_path (master)$ iocsh.bash cmds/0.cmd
```
#### Does it work?
* Check it whether it works or not
* If not, explain why?
* Can you fix this startup script?

#### E3_IOCSH_TOP and E3_CMD_TOP 
* Can you see the two VARIABLES such as ```E3_IOCSH_TOP``` and ```E3_CMD_TOP``` ?
* How two variables are changed if one can execute iocsh.bash witin cmds? 
```
$ cmds (master)$ iocsh.bash 0.cmd 
```

#### How 0.cmd can be handle within this command?

The ```0.cmd``` is used as "arguments" of iocshLoad internally. One can see the following line:

```
iocshLoad '0.cmd',''

```

### 1.cmd

```
 ch4_supplementry_path (master)$ iocsh.bash cmds/1.cmd
```

* How many dependency modules of stream are loaded? Please carefully look at few lines outputs similar with the following
```
require stream,2.7.14p
Module stream version 2.7.14p found in /epics/base-3.15.5/require/3.0.4/siteMods/stream/2.7.14p/
Module stream depends on asyn 4.33.0
Module asyn version 4.33.0 found in /epics/base-3.15.5/require/3.0.4/siteMods/asyn/4.33.0/
Loading library /epics/base-3.15.5/require/3.0.4/siteMods/asyn/4.33.0/lib/linux-x86_64/libasyn.so
Loaded asyn version 4.33.0
Loading dbd file /epics/base-3.15.5/require/3.0.4/siteMods/asyn/4.33.0/dbd/asyn.dbd
Calling function asyn_registerRecordDeviceDriver
Loading module info records for asyn
Module stream depends on pcre 8.41.0
Module pcre version 8.41.0 found in /epics/base-3.15.5/require/3.0.4/siteMods/pcre/8.41.0/
Loading library /epics/base-3.15.5/require/3.0.4/siteMods/pcre/8.41.0/lib/linux-x86_64/libpcre.so
Loaded pcre version 8.41.0
pcre has no dbd file
Loading module info records for pcre
Loading library /epics/base-3.15.5/require/3.0.4/siteMods/stream/2.7.14p/lib/linux-x86_64/libstream.so
Loaded stream version 2.7.14p
Loading dbd file /epics/base-3.15.5/require/3.0.4/siteMods/stream/2.7.14p/dbd/stream.dbd
Calling function stream_registerRecordDeviceDriver
Loading module info records for stream
```

* Is it the same as what we defined? How do we check this? One can check it through
```
e3-StreamDevice (master)$ make vars
```
to look at ```ASYN_DEP_VERSION``` and ```PCRE_DEP_VERSION```. Anyway, the dependency will be described later on in more detail. 


### 2.cmd

* Run the following command
```
 ch4_supplementry_path (master)$ iocsh.bash cmds/2.cmd
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
ch4_supplementry_path (master)$ iocsh.bash cmds/3-1.cmd 
```

* IOC is running, however, it doesn't connect to anywhere. Can you see the message which repesents this situation? 
Please remember, it runs at the end of your startup script whether it finds a hardware or not. In 3-1.cmd, we doesn't have db files which actually talk to the hardware. Thus, we don't see any error messages at all. I would like to emphasize the following one more time. Note that each single line output of the ioc is important. One should make sure that each line is correct, and one should understand each line correctly. 


This script has the asyn configuration for the simulated device such as 
```
drvAsynIPPortConfigure("CGONPI", "127.0.0.1:9999", 0, 0, 0)
```

* One should the run the Kameleon simulator in the different terminal, then run the above command. 

* The following log is a snippet of the IOC output
```
ch4_supplementry_path (master)$ iocsh.bash cmds/3-1.cmd

......

iocshLoad 'cmds/3-1.cmd',''
require stream,2.7.14p
Module stream version 2.7.14p found in /epics/base-3.15.5/require/3.0.4/siteMods/stream/2.7.14p/
Module stream depends on asyn 4.33.0
Module asyn version 4.33.0 found in /epics/base-3.15.5/require/3.0.4/siteMods/asyn/4.33.0/
Loading library /epics/base-3.15.5/require/3.0.4/siteMods/asyn/4.33.0/lib/linux-x86_64/libasyn.so
Loaded asyn version 4.33.0
Loading dbd file /epics/base-3.15.5/require/3.0.4/siteMods/asyn/4.33.0/dbd/asyn.dbd
Calling function asyn_registerRecordDeviceDriver
Loading module info records for asyn
Module stream depends on pcre 8.41.0
Module pcre version 8.41.0 found in /epics/base-3.15.5/require/3.0.4/siteMods/pcre/8.41.0/
Loading library /epics/base-3.15.5/require/3.0.4/siteMods/pcre/8.41.0/lib/linux-x86_64/libpcre.so
Loaded pcre version 8.41.0
pcre has no dbd file
Loading module info records for pcre
Loading library /epics/base-3.15.5/require/3.0.4/siteMods/stream/2.7.14p/lib/linux-x86_64/libstream.so
Loaded stream version 2.7.14p
Loading dbd file /epics/base-3.15.5/require/3.0.4/siteMods/stream/2.7.14p/dbd/stream.dbd
Calling function stream_registerRecordDeviceDriver
Loading module info records for stream
drvAsynIPPortConfigure("CGONPI", "127.0.0.1:9999", 0, 0, 0)
iocInit()
Starting iocInit
############################################################################
## EPICS R3.15.5-E3-3.15.5-patch
## EPICS Base built Nov 20 2018
############################################################################
drvStreamInit: Warning! STREAM_PROTOCOL_PATH not set. Defaults to "."
iocRun: All initialization complete
# Set the IOC Prompt String One 
epicsEnvSet IOCSH_PS1 "350b5cb.kaffee.9985 > "
#
350b5cb.kaffee.9985 > 

```

* The following log is a snippet of Kameleon :

```
****************************************************
*                                                  *
*  Kameleon v1.5.0 (2017/SEP/14 - Production)      *
*                                                  *
*                                                  *
*  (C) 2015-2017 European Spallation Source (ESS)  *
*                                                  *
****************************************************

[16:53:38.687] Using file '/home/jhlee/gitsrc/e3training/workbook/ch4_supplementry_path/kameleon/simulators/gconpi/gconpi.kam' (contains 0 commands and 1 statuses).
[16:53:38.687] Start serving from hostname '127.0.0.1' on port '9999'.
[16:53:40.405] Client connection opened.
[16:53:40.734] Status 'CPS, 3, CPM, 15, uSv/hr, 0.053, SLOW<0x0d><0x0a>' (Get Data) sent to client.
[16:53:41.244] Status 'CPS, 2, CPM, 17, uSv/hr, 0.076, SLOW<0x0d><0x0a>' (Get Data) sent to client.
[16:53:41.756] Status 'CPS, 3, CPM, 8, uSv/hr, 0.064, SLOW<0x0d><0x0a>' (Get Data) sent to client.
[16:53:42.266] Status 'CPS, 4, CPM, 4, uSv/hr, 0.014, SLOW<0x0d><0x0a>' (Get Data) sent to client.
[16:53:42.779] Status 'CPS, 3, CPM, 10, uSv/hr, 0.099, SLOW<0x0d><0x0a>' (Get Data) sent to client.
[16:53:43.291] Status 'CPS, 3, CPM, 3, uSv/hr, 0.072, SLOW<0x0d><0x0a>' (Get Data) sent to client.
[16:53:43.803] Status 'CPS, 2, CPM, 9, uSv/hr, 0.092, SLOW<0x0d><0x0a>' (Get Data) sent to client.
[16:53:44.314] Status 'CPS, 2, CPM, 16, uSv/hr, 0.003, SLOW<0x0d><0x0a>' (Get Data) sent to client.
[16:53:44.826] Status 'CPS, 2, CPM, 12, uSv/hr, 0.069, SLOW<0x0d><0x0a>' (Get Data) sent to client.
[16:53:45.337] Status 'CPS, 3, CPM, 10, uSv/hr, 0.094, SLOW<0x0d><0x0a>' (Get Data) sent to client.
[16:53:45.849] Status 'CPS, 1, CPM, 10, uSv/hr, 0.038, SLOW<0x0d><0x0a>' (Get Data) sent to client.

```

### 3-2.cmd
This script has the full information on the single IOC running. Please evaluate all components in 
```
require stream,2.7.14p

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
Type 'help <command>' to see the arguments of <command>.
#               ClockTime_Report                ClockTime_Shutdown
E2050Reboot     E5810Reboot     TDS3000Reboot   afterInit       asDumpHash
asInit          asSetFilename   asSetSubstitutions              ascar


```

* dbl
```
350b5cb.kaffee.12199 > dbl
IOC-10585032:KAM-RAD1:CPS_clean1
REQMOD-350B5CB:KAFFEE-12203:MODULES
REQMOD-350B5CB:KAFFEE-12203:VERSIONS
REQMOD-350B5CB:KAFFEE-12203:MOD_VER
IOC-10585032:KAM-RAD1:CPS
IOC-10585032:KAM-RAD1:CPM
IOC-10585032:KAM-RAD1:uSv
IOC-10585032:KAM-RAD1:CPS_clean2
REQMOD-350B5CB:KAFFEE-12203:require_VER
REQMOD-350B5CB:KAFFEE-12203:asyn_VER
REQMOD-350B5CB:KAFFEE-12203:pcre_VER
REQMOD-350B5CB:KAFFEE-12203:stream_VER
IOC-10585032:KAM-RAD1:CPS_MSG
IOC-10585032:KAM-RAD1:AvgMode

```

* date
```
350b5cb.kaffee.12199 > date
2018/11/23 17:07:53.042777
```


### 4.cmd
From ```3.cmd```, we have the running IOC which can communicate with the simulated device. Moreover, generally, we will add more generic EPICS modules into 


### 5.cmd



## Reference 
[1] Kameleon Simulator https://bitbucket.org/europeanspallationsource/kameleon
[2] Forked Kameleon  https://github.com/jeonghanlee/kameleon 
[3] EPICS Application Developer's Guide, IOC Initialization https://epics.anl.gov/base/R3-15/5-docs/AppDevGuide/IOCInitialization.html#x8-2750007.4
