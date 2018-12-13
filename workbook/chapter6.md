Chapter 6 : Variables, Parameters and Environment Variables within e3
==

## Lesson Overview

In this lesson, you'll learn how to do the following:
* Understand variables, parameters and environment variables within an IOC 
* Run EPICS commands to access them within an IOC correctly
* Understand EPICS and e3 environment variable when a module is configured
* Combine variable commands to access path or files of any module within an IOC



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

It is very useful to access the absolute path when an IOC starts within startup scripts. 

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
$ iocsh.bash ch6_supplementary_path/ch6.cmd
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

One can try to add recsync into ch6.cmd to create ch6-local.cmd. Please enable it through
```
recsync, 1.3.0
```
Please try to access four variables for recsync module. 


### EPICS Variables, Parameters, and Environment Variables


* Check EPICS functions to access EPICS with the command ```epicsParamShow``` and ```epicsEnvShow``` within an IOC :

```
# Set the IOC Prompt String One 
epicsEnvSet IOCSH_PS1 "58bef31.faiserv.18238 > "
#
58bef31.faiserv.18238 > epicsParamShow 
58bef31.faiserv.18238 > epicsEnvShow 
```

* Run ```epicsPrtEnvParams```. Which command returns the same result?



* How do we access only one variable? For example, ```TOP```? Please check epicsEnvShow and epicsParamShow in the reference [1]. Moreover, one might try to use ```echo```. Can one access ```TOP``` with ```echo```? There are four commands (```date```, ```pwd```, ```cd```, and ```echo```) which one can use in the similar way in Linux shell environment.



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

* Can you explain answers of the following questions to others? 1) Difference among them and 2) Where are they defined. 




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

In [Chapter3](chapter3.md), we already discussed two e3 variables : ```E3_MODULE_VERSION``` and  ```EPICS_MODULE_TAG```. In addition, there are many environment variables for e3 when we configure and install a module. 

### e3 environment variables

Once you print out all environment variables of each module via ```make vars``` as follows:

```
e3-caPutLog$ make vars

------------------------------------------------------------
>>>>     Current EPICS and E3 Envrionment Variables     <<<<
------------------------------------------------------------

E3_MODULES_INSTALL_LOCATION = /epics/base-3.15.5/require/3.0.4/siteMods/caPutLog/3.6.0
E3_MODULES_INSTALL_LOCATION_BIN = /epics/base-3.15.5/require/3.0.4/siteMods/caPutLog/3.6.0/bin
E3_MODULES_INSTALL_LOCATION_BIN_LINK = /epics/base-3.15.5/require/3.0.4/siteLibs/caPutLog_3.6.0_bin
E3_MODULES_INSTALL_LOCATION_DB = /epics/base-3.15.5/require/3.0.4/siteMods/caPutLog/3.6.0/db
E3_MODULES_INSTALL_LOCATION_DBD_LINK = /epics/base-3.15.5/require/3.0.4/siteLibs/caPutLog.dbd.3.6.0
E3_MODULES_INSTALL_LOCATION_DB_LINK = /epics/base-3.15.5/require/3.0.4/siteLibs/caPutLog_3.6.0_db
E3_MODULES_INSTALL_LOCATION_INC = /epics/base-3.15.5/require/3.0.4/siteMods/caPutLog/3.6.0/include
E3_MODULES_INSTALL_LOCATION_INC_LINK = /epics/base-3.15.5/require/3.0.4/siteLibs/caPutLog_3.6.0_include
E3_MODULES_INSTALL_LOCATION_LIB = /epics/base-3.15.5/require/3.0.4/siteMods/caPutLog/3.6.0/lib
E3_MODULES_INSTALL_LOCATION_LIB_LINK = /epics/base-3.15.5/require/3.0.4/siteLibs/caPutLog_3.6.0_lib
E3_MODULES_LIBLINKNAME = libcaPutLog.so.3.6.0
E3_MODULES_LIBNAME = libcaPutLog.so
E3_MODULES_PATH = /epics/base-3.15.5/require/3.0.4/siteMods
E3_MODULES_VENDOR_LIBS_LOCATION = /epics/base-3.15.5/require/3.0.4/siteLibs/vendor/caPutLog/3.6.0
E3_MODULE_MAKEFILE = caPutLog.Makefile
E3_MODULE_MAKE_CMDS = make -C caPutLog -f caPutLog.Makefile LIBVERSION="3.6.0" PROJECT="caPutLog" EPICS_MODULES="/epics/base-3.15.5/require/3.0.4/siteMods" EPICS_LOCATION="/epics/base-3.15.5" BUILDCLASSES="Linux" E3_SITEMODS_PATH="/epics/base-3.15.5/require/3.0.4/siteMods" E3_SITEAPPS_PATH="/epics/base-3.15.5/require/3.0.4/siteApps" E3_SITELIBS_PATH="/epics/base-3.15.5/require/3.0.4/siteLibs"
E3_MODULE_NAME = caPutLog
E3_MODULE_SRC_PATH = caPutLog
E3_MODULE_VERSION = 3.6.0
E3_REQUIRE_CONFIG = /epics/base-3.15.5/require/3.0.4/configure
E3_REQUIRE_TOOLS = /epics/base-3.15.5/require/3.0.4/tools
EPICS_MODULE_NAME = caPutLog
EPICS_MODULE_TAG = tags/R3.6
EXPORT_VARS = E3_MODULES_VENDOR_LIBS_LOCATION E3_MODULES_INSTALL_LOCATION_LIB_LINK EPICS_HOST_ARCH EPICS_BASE MSI E3_MODULE_VERSION E3_SITEMODS_PATH E3_SITEAPPS_PATH E3_SITELIBS_PATH E3_REQUIRE_MAKEFILE_INPUT_OPTIONS E3_REQUIRE_NAME E3_REQUIRE_DB E3_REQUIRE_CONFIG E3_REQUIRE_LOCATION E3_REQUIRE_DBD E3_REQUIRE_VERSION E3_REQUIRE_TOOLS E3_REQUIRE_INC E3_REQUIRE_LIB E3_REQUIRE_BIN QUIET   SUDO2 SUDO_INFO SUDOBASH SUDO
INSTALLED_EPICS_BASE_ARCHS = linux-ppc64e6500 linux-x86_64
MSI = /epics/base-3.15.5/bin/linux-x86_64/msi
PROD_BIN_PATH = /epics/base-3.15.5/require/3.0.4/siteLibs/caPutLog_3.6.0_bin/linux-x86_64
REQUIRE_CONFIG = /epics/base-3.15.5/require/3.0.4/configure
```


### Customized EPICS Environment Variables

* ```EPICS_BASE``` is where the epics base is installed (EPICS Environment Variable).

* ```EPICS_HOST_ARCH``` is what the system host architecture is (EPICS Environment Variable).

* ```EPICS_MODULE_NAME``` is a module name which we would like to use within e3 (e3 Environment variable). Please see ```E3_MODULE_NAME```. **Note that this name should be letters (upper and lower case) and digits.**

* ```EPICS_MODULE_TAG``` is a point release information of the remote source code repository. For example, it will be one of the following: ```master```, ```tags/R3.6```, ```ae5d083```, and any arguments which can be used with ```git checkout```. 


* ```INSTALLED_EPICS_BASE_ARCHS``` shows the EPICS base archtecture installed within local system. Mostly, it is only ```linux-x86_64``` in our environment. 


### e3 Environment Variables
 

* ```E3_SITEMODS_PATH``` is the e3 site module installation path. 
* ```E3_SITEAPPS_PATH``` is the e3 site application installation path. 
* ```E3_SITELIBS_PATH``` is the e3 site library path.
* ```E3_REQUIRE_NAME``` is the unique e3 module name **require**. Mostly, it is the static string. No one should change this variable. 
* ```E3_REQUIRE_VERSION``` is the require version number. 
* ```E3_REQUIRE_BIN``` is the require bin path. 
* ```E3_REQUIRE_CONFIG``` is the require configure path, which is used for the require module. 
* ```E3_REQUIRE_DB``` is the require db path. 
* ```E3_REQUIRE_INC``` is the require include path. 
* ```E3_REQUIRE_LIB``` is the require lib path.
* ```E3_REQUIRE_LOCATION``` is the require path. 
* ```E3_REQUIRE_TOOLS``` is the require tools path. 
* ```REQUIRE_CONFIG``` is the require configuration path, which is used for each module configuration. It is the same as ```E3_REQUIRE_CONFIG```, however, it is defined before ```E3_REQUIRE_CONFIG```. 


### e3 Module Core Environment Variables


* `E3_MODULE_NAME` is the module name used for `require E3_MODULE_NAME` within an IOC startup script. Usually, it is the same as ```EPICS_MODULE_NAME```. **Note that this name should be letters (upper and lower case) and digits.** The underscore character `_` is also permitted. Technically, this name is coverted into char variable within c program. Thus, it should follow the c programming variable rule. 
* ```E3_MODULE_SRC_PATH``` is the where your source codes are downloaded according to difference configurations such as the deployment mode, the development mode, the local mode, and the repository source directory name. 
* ```E3_MODULE_VERSION``` is the module version used for ```require E3_MODULE_NAME E3_MODULE_VERSION```. There is no limitation to select this version number.
* ```E3_MODULE_MAKEFILE``` is the name of a module or an application makefile. 
* ```E3_MODULES_PATH``` is the parent path of a final installation location of each module or each application.  It can be ```E3_SITEMODS_PATH``` or ```E3_SITEAPPS_PATH```. 
* ```E3_MODULES_LIBNAME``` is the name of the shared library of each module or each application.
* ```E3_MODULES_INSTALL_LOCATION``` is the installation parent path of a module or an application.
* ```E3_MODULES_INSTALL_LOCATION_BIN``` is the installation bin path of a module or an application. 
* ```E3_MODULES_INSTALL_LOCATION_DB```  is the installation db path of a module or an application. 
* ```E3_MODULES_INSTALL_LOCATION_INC``` is the installation include path of a module or an application.
* ```E3_MODULES_INSTALL_LOCATION_LIB``` is the installation lib path of a module or an application.

### e3 Module Aux Environment Variables

The following variables are defined within a module or an application by default. However, they are not used for an application or if is not necessary to be used. 

* ```E3_MODULES_LIBLINKNAME```  is the symbolic link name of a module with a module version. 
* ```E3_MODULES_INSTALL_LOCATION_BIN_LINK``` is the symbolic link name of the module bin path located in ```E3_SITELIBS_PATH``` as the following form : ```E3_MODULE_NAME_E3_MODULE_VERSION_bin```. 
* ```E3_MODULES_INSTALL_LOCATION_DB_LINK``` is the symbolic link name of the module db path located in ```E3_SITELIBS_PATH``` as the following form : ```E3_MODULE_NAME_E3_MODULE_VERSION_db```. 
* ```E3_MODULES_INSTALL_LOCATION_INC_LINK``` is the symbolic link name of the module include path located in ```E3_SITELIBS_PATH``` as the following form : ```E3_MODULE_NAME_E3_MODULE_VERSION_include```.
* ```E3_MODULES_INSTALL_LOCATION_LIB_LINK``` is the symbolic link name of the module lib path located in ```E3_SITELIBS_PATH``` as the following form : ```E3_MODULE_NAME_E3_MODULE_VERSION_lib```. 
* ```E3_MODULES_INSTALL_LOCATION_DBD_LINK``` is the symbolic link name of the module dbd file located in ```E3_SITELIBS_PATH``` as the following form : ```E3_MODULE_NAME_dbd_E3_MODULE_VERSION```. 

* ```E3_MODULES_VENDOR_LIBS_LOCATION``` is the vendor or 3rd party lib path located in ```E3_SITELIBS_PATH``` as the following form : ```vendor/E3_MODULE_NAME/E3_MODULE_VERSION```. 
* ```PROD_BIN_PATH``` is the short bin path in case users would like to access module specific executable commands. 

* ```E3_MODULE_MAKE_CMDS``` is the command to execute to build / install each module. 

* ```EXPORT_VARS``` is the collection of exported environment variables within e3 building system in order to transfer them through different makefiles. 



##  Assignments

### Access DB files of a module within a running IOC

With the following IOC,
```
$ iocsh.bash ch6_supplementary_path/ch6.cmd
```
print out all db files of the asyn module within an IOC with two command lines. Note that an IOC supports only few similar commands (date, exit, help, cd, pwd, and echo). Please remember a unique command to run Linux any commands within an IOC. 

### Vendor Libraries
Which Module is used for a specific vendor library? Why do we keep these files within e3 structure? 

### Makefile Rules

Can you find out which file allow us to run ```make vars``` or ```make env``` within e3 building system? It is the same for all modules and applications, so where could be located?



## Reference

[1] https://epics.anl.gov/base/R3-15/6-docs/AppDevGuide/IOCShell.html#x19-73300018



------------------
[:arrow_backward:](chapter5.md)  | [:arrow_up_small:](chapter6.md)  | [:arrow_forward:](chapter7.md)
:--- | --- |---: 
[Chapter 5 : Take the Deployment or the Development](chapter5.md) | [Chapter 6](chapter6.md) |[Chapter 7 : Understand A Module Dependence](chapter7.md)
