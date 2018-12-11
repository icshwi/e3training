# Chapter 2 : Your first running e3 IOC

## Lesson Overview

In this lesson, you'll learn how to do the following:
* Set up the e3 configuration dynamically
* Switch different versions of e3 within the environment tool
* Run a simple IOC with the existent start-up script


## E3 (EPICS) environment


In order to help each developer, e3 supports multiple EPICS environment dynamically. In that means, one can set it in any EPICS environment terminal via sourcing the ***setE3Env.bash** as follows:

```
source setE3Env.bash
```

The full path is ```/epics/base-3.15.5/require/3.0.4/bin/setE3Env.bash```

To make a short cut, the e3 building system, at the end of installation procedure of require or modules, creates an alias within tools path as follows:
```
tools/setenv
```
If the file exists, the existent file will be renamed to
```
setenv_YYMMDDHHMM
```

Thus, one can still switch to old environment within the source path.


### Set up the e3 environment

0. Open the new terminal
1. Try to run one of the following commands : caget or iocsh.bash
2. Go ***E3_TOP***
3. source tools/setenv
```
e3-3.15.5 (master)$ source tools/setenv

Set the ESS EPICS Environment as follows:
THIS Source NAME    : setE3Env.bash
THIS Source PATH    : /epics/base-3.15.5/require/3.0.4/bin
EPICS_BASE          : /epics/base-3.15.5
EPICS_HOST_ARCH     : linux-x86_64
E3_REQUIRE_LOCATION : /epics/base-3.15.5/require/3.0.4
PATH                : /epics/base-3.15.5/require/3.0.4/bin:/epics/base-3.15.5/bin/linux-x86_64:/home/jhlee/bin:/usr/local/bin:/usr/bin:/bin:/usr/local/games:/usr/games
LD_LIBRARY_PATH     : /epics/base-3.15.5/lib/linux-x86_64:/epics/base-3.15.5/require/3.0.4/lib/linux-x86_64:/epics/base-3.15.5/require/3.0.4/siteLibs/linux-x86_64

Enjoy E3!
```
4. Check whether your setup is what you want to do or not
5. Run the previous commands again.


## Run the first predefined IOC

0. One should be in ***E3_TOP***
1. Run
``` 
e3-3.15.5 (master)$ iocsh.bash cmds/iocStats.cmd 
```
2. Open another terminal with the corresponding e3 setup
```
e3-3.15.5 (master)$ source tools/setenv
```
3. Check the all PV list
```
e3-3.15.5 (master)$ bash caget_pvs.bash IOC-09606738_PVs.list
```
4. Check the HEARTBEAT of your IOC

```
e3-3.15.5 (master)$ bash caget_pvs.bash IOC-09606738_PVs.list "HEARTBEAT"
```

```
e3-3.15.5 (master)$ camonitor IOC-09606738-IocStats:HEARTBEAT
```


## Spend sometime with iocStats.cmd 

```
require iocStats,ae5d083

epicsEnvSet("TOP", "$(E3_CMD_TOP)")

system "bash $(TOP)/random.bash"

iocshLoad "$(TOP)/random.cmd"

epicsEnvSet("P", "IOC-$(NUM)")
epicsEnvSet("IOCNAME", "$(P)")

loadIocsh("iocStats.iocsh", "IOCNAME=$(IOCNAME)")

iocInit()

dbl > "$(TOP)/../${IOCNAME}_PVs.list"
```

## Assignments

Please explain the following jargon by yourself, they are mixed within EPICS and e3 commands.

### require

### E3_CMD_TOP

### epicsEnvSet

### system

### iocshLoad

### loadIocsh

### iocInit

### dbl

### > 



------------------
[:arrow_backward:](chapter1.md)  | [:arrow_up_small:](chapter2.md)  | [:arrow_forward:](chapter3.md)
:--- | --- |---: 
[Chapter 1](chapter1.md) | [Chapter 2](chapter2.md) | [Chapter 3](chapter3.md)

