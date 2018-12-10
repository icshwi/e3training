Chapter 6 : Variables, Parameters and Environment Variables within e3
==

## Lesson Overview

In this lesson, you'll learn how to do the following:
* Understand variables, parameters and environment variables within an ioc 
* Run EPICS commands to access them within an ioc correctly
* Understand EPICS and e3 environment variable when a module is configured




## Running an IOC

The following variables are defined when an IOC is running within startup scripts and iocsh. 


### General iocsh.bash Variables

* ```REQUIRE_IOC```
This is the read-only variable which is defined within the iocsh.bash


* ```E3_CMD_TOP```
This is the absolute path where a startup script (cmd file) is. 


* ```E3_IOCSH_TOP```
This is the absolute path where the iocsh.bash is executed.


* ```IOCSH_PS1```
This is the IOC Prompt String.


### Require Internal Variables

It is very useful to access the absolute path when an ioc starts within startup scripts. 

The following variables are very powerful. For example, if one uses mrfioc2 as ```MODULE```

* *module_name*```_VERSION```

```
mrfioc2_VERSION
```

* *module_name*```_DIR```

```
mrfioc2_DIR
```

* *module_name*```_DB```

```
mrfioc2_DB
```

* *module_name*```_TEMPLATES```

```
mrfioc2_TEMPLATES
```

Please run the following startup script


0. Run

```
$ iocsh.bash ch6_supplementary_path/ch13.cmd
```
One may get the following output:
```
----- snip ----- snip -----
epicsEnvSet "EXECUTE_TOP"     /home/jhlee/playground/e3training/workbook
epicsEnvSet "STARTUP_TOP"     /home/jhlee/playground/e3training/workbook/ch13_supplementry_path
epicsEnvSet "TOP"             /home/jhlee/playground/e3training/workbook/ch13_supplementry_path/..
epicsEnvSet "IOCSTATS_MODULE_PATH"          /epics/base-3.15.5/require/3.0.4/siteMods/iocStats/ae5d083/
epicsEnvSet "IOCSTATS_MODULE_VERSION"       ae5d083
epicsEnvSet "IOCSTATS_MODULE_DB_PATH"       /epics/base-3.15.5/require/3.0.4/siteMods/iocStats/ae5d083/db
epicsEnvSet "IOCSTATS_MODULE_TEMPLATE_PATH" /epics/base-3.15.5/require/3.0.4/siteMods/iocStats/ae5d083/db
----- snip ----- snip -----

```

One can try to add recsync into ch13.cmd to create ch13-local.cmd. Please enable it through
```
recsync, 1.3.0
```
Please try to access four variables for recsync module. 


### EPICS Variables, Parameters, and Environment Variables


* Check EPICS functions to access EPICS with the command ```epicsParamShow``` and ```epicsEnvShow``` within an ioc :

```
# Set the IOC Prompt String One 
epicsEnvSet IOCSH_PS1 "58bef31.faiserv.18238 > "
#

58bef31.faiserv.18238 > epicsParamShow 
58bef31.faiserv.18238 > epicsEnvShow 
```

* How do we access only one variable? For example, ```TOP```? Please check epicsEnvShow and epicsParamShow in the reference [1]. Moreover, one might try to use ```echo```. Can one access ```TOP``` with ```echo```?


* What is the difference between ```$(TOP)``` and ```${TOP}```?

* In the shell, please try to run ```var```. What do you see? 

```
58bef31.faiserv.18238 > var
sandbag = 0
atExitDebug = 0
boHIGHlimit = 100000
boHIGHprecision = 2
calcoutODLYlimit = 100000
calcoutODLYprecision = 2
callbackParallelThreadsDefault = 4
dbBptNotMonotonic = 0
dbQuietMacroWarnings = 0
dbRecordsAbcSorted = 0
dbRecordsOnceOnly = 0
dbTemplateMaxVars = 100
dbThreadRealtimeLock = 1
exprDebug = 0
histogramSDELprecision = 2
requireDebug = 0
runScriptDebug = 0
seqDLYlimit = 100000
seqDLYprecision = 2
```

* Now, can you describe differences among them? How they are different from each other? Where are they defined? Can you explain this? 


* In the running ioc, please require the recsync with the installed version through:

0. Run
```
58bef31.faiserv.18238 > require recsync,1.3.0
Module recsync version 1.3.0 found in /epics/base-3.15.5/require/3.0.4/siteMods/recsync/1.3.0/
Loading library /epics/base-3.15.5/require/3.0.4/siteMods/recsync/1.3.0/lib/linux-x86_64/librecsync.so
Loaded recsync version 1.3.0
Loading dbd file /epics/base-3.15.5/require/3.0.4/siteMods/recsync/1.3.0/dbd/recsync.dbd
Calling function recsync_registerRecordDeviceDriver

```

1. Redo require again
```
58bef31.faiserv.18238 > require recsync,1.3.0
Module recsync version 1.3.0 already loaded

```

2. Type the following:
```
58bef31.faiserv.18238 > var requireDebug 1
```

3. Redo require again
```
58bef31.faiserv.18238 > require recsync,1.3.0
require: versionstr = "-1.3.0"
require: module="recsync" version="1.3.0" args="(null)"
require: searchpath=/epics/base-3.15.5/require/3.0.4/siteMods:/epics/base-3.15.5/require/3.0.4/siteApps
require: compareVersions(found=1.3.0, request=1.3.0)
require: compareVersions: MATCH exactly
Module recsync version 1.3.0 already loaded
require: library found in /epics/base-3.15.5/require/3.0.4/siteMods/recsync/1.3.0/
require: putenv("MODULE=recsync")
require: looking for template directory
require: directory /epics/base-3.15.5/require/3.0.4/siteMods/recsync/1.3.0/db exists
require: found template directory /epics/base-3.15.5/require/3.0.4/siteMods/recsync/1.3.0/db
require: putenv("recsync_DB=/epics/base-3.15.5/require/3.0.4/siteMods/recsync/1.3.0/db")
require: putenv("recsync_TEMPLATES=/epics/base-3.15.5/require/3.0.4/siteMods/recsync/1.3.0/db")
require: putenv("TEMPLATES=/epics/base-3.15.5/require/3.0.4/siteMods/recsync/1.3.0/db")
```

Now, it is the self-evidence that ```var``` is defined as a variable within a require module. This is a very interesting variable that can be used to change your own EPICS module dynamically. Usually, this variable is used as a debug message control variable. 

4. Disable it
```
58bef31.faiserv.18238 > var requireDebug 0
58bef31.faiserv.18238 > require recsync,1.3.0
```
Note that the upper and lower keys can be used to catch the command list which were used before. 




## Building a Module or An Application 




```
E3_MODULES_INSTALL_LOCATION = /epics/base-3.15.5/require/3.0.4/siteMods/iocStats/ae5d083
E3_MODULES_INSTALL_LOCATION_BIN = /epics/base-3.15.5/require/3.0.4/siteMods/iocStats/ae5d083/bin
E3_MODULES_INSTALL_LOCATION_BIN_LINK = /epics/base-3.15.5/require/3.0.4/siteLibs/iocStats_ae5d083_bin
E3_MODULES_INSTALL_LOCATION_DB = /epics/base-3.15.5/require/3.0.4/siteMods/iocStats/ae5d083/db
E3_MODULES_INSTALL_LOCATION_DBD_LINK = /epics/base-3.15.5/require/3.0.4/siteLibs/iocStats.dbd.ae5d083
E3_MODULES_INSTALL_LOCATION_DB_LINK = /epics/base-3.15.5/require/3.0.4/siteLibs/iocStats_ae5d083_db
E3_MODULES_INSTALL_LOCATION_INC = /epics/base-3.15.5/require/3.0.4/siteMods/iocStats/ae5d083/include
E3_MODULES_INSTALL_LOCATION_INC_LINK = /epics/base-3.15.5/require/3.0.4/siteLibs/iocStats_ae5d083_include
E3_MODULES_INSTALL_LOCATION_LIB = /epics/base-3.15.5/require/3.0.4/siteMods/iocStats/ae5d083/lib
E3_MODULES_INSTALL_LOCATION_LIB_LINK = /epics/base-3.15.5/require/3.0.4/siteLibs/iocStats_ae5d083_lib
E3_MODULES_LIBLINKNAME = libiocStats.so.ae5d083
E3_MODULES_LIBNAME = libiocStats.so
E3_MODULES_PATH = /epics/base-3.15.5/require/3.0.4/siteMods
E3_MODULES_VENDOR_LIBS_LOCATION = /epics/base-3.15.5/require/3.0.4/siteLibs/vendor/iocStats/ae5d083
E3_MODULE_MAKEFILE = iocStats.Makefile
E3_MODULE_MAKE_CMDS = make -C iocStats -f iocStats.Makefile LIBVERSION="ae5d083" PROJECT="iocStats" EPICS_MODULES="/epics/base-3.15.5/require/3.0.4/siteMods" EPICS_LOCATION="/epics/base-3.15.5" BUILDCLASSES="Linux" E3_SITEMODS_PATH="/epics/base-3.15.5/require/3.0.4/siteMods" E3_SITEAPPS_PATH="/epics/base-3.15.5/require/3.0.4/siteApps" E3_SITELIBS_PATH="/epics/base-3.15.5/require/3.0.4/siteLibs"
E3_MODULE_NAME = iocStats
E3_MODULE_SRC_PATH = iocStats
E3_MODULE_VERSION = ae5d083
E3_REQUIRE_BIN = /epics/base-3.15.5/require/3.0.4/bin
E3_REQUIRE_CONFIG = /epics/base-3.15.5/require/3.0.4/configure
E3_REQUIRE_DB = /epics/base-3.15.5/require/3.0.4/db
E3_REQUIRE_INC = /epics/base-3.15.5/require/3.0.4/include
E3_REQUIRE_LIB = /epics/base-3.15.5/require/3.0.4/lib
E3_REQUIRE_LOCATION = /epics/base-3.15.5/require/3.0.4
E3_REQUIRE_NAME = require
E3_REQUIRE_TOOLS = /epics/base-3.15.5/require/3.0.4/tools
E3_REQUIRE_VERSION = 3.0.4
E3_SITEAPPS_PATH = /epics/base-3.15.5/require/3.0.4/siteApps
E3_SITELIBS_PATH = /epics/base-3.15.5/require/3.0.4/siteLibs
E3_SITEMODS_PATH = /epics/base-3.15.5/require/3.0.4/siteMods
EPICS_BASE = /epics/base-3.15.5
EPICS_HOST_ARCH = linux-x86_64
EPICS_MODULE_NAME = iocStats
EPICS_MODULE_TAG = ae5d083
EXPORT_VARS = E3_MODULES_VENDOR_LIBS_LOCATION E3_MODULES_INSTALL_LOCATION_LIB_LINK EPICS_HOST_ARCH EPICS_BASE MSI E3_MODULE_VERSION E3_SITEMODS_PATH E3_SITEAPPS_PATH E3_SITELIBS_PATH E3_REQUIRE_MAKEFILE_INPUT_OPTIONS E3_REQUIRE_LIB E3_REQUIRE_NAME E3_REQUIRE_DB E3_REQUIRE_CONFIG E3_REQUIRE_LOCATION E3_REQUIRE_DBD E3_REQUIRE_VERSION E3_REQUIRE_TOOLS E3_REQUIRE_INC E3_REQUIRE_BIN QUIET   SUDO_INFO SUDO2 SUDOBASH SUDO
INSTALLED_EPICS_BASE_ARCHS = linux-ppc64e6500 linux-x86_64
MSI = /epics/base-3.15.5/bin/linux-x86_64/msi
PROD_BIN_PATH = /epics/base-3.15.5/require/3.0.4/siteLibs/iocStats_ae5d083_bin/linux-x86_64
REQUIRE_CONFIG = /epics/base-3.15.5/require/3.0.4/configure
```


## Reference

[1] https://epics.anl.gov/base/R3-15/6-docs/AppDevGuide/IOCShell.html#x19-73300018
