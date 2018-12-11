 # Chapter 1 : e3 Installation 

## Lesson Overview

In this lesson, you'll learn how to do the following:
* Download the e3 repository by using git
* Configure the e3 environment settings according to what you want to do
* Set up the e3 EPICS base
* Set up the e3 REQUIRE
* Set up the e3 COMMON modules
* Test your installation to make sure all components are correct


## Get the developing repository for e3


One should use git in order to get the developing repository of e3.

```
$ git clone https://github.com/icshwi/e3 
```

However, by the design concept of e3, we can have multiple e3 configurations in a host, so it would be better to use the self-evidence source directories which can tell us where we are in. For example, if one would like to use the EPICS base 3.15.5

```
$ git clone https://github.com/icshwi/e3 e3-3.15.5
```
, where e3-3.15.5 is called now ***E3_TOP**. We will use it within next chapters also. 

## Configure the e3 environment settings

There are two golden VERSIONS which one should remember.

* EPICS Base version 
* REQUIRE version

In addition, the target path will define where you want to install your e3 environment. For example,
if one would like to use the default ones, one can run the following command without options.

```
e3-3.15.5 (master)$ ./e3_building_config.bash setup
>> 
  The following configuration for e3 installation
  will be generated :

>> Set the global configuration as follows:
>>
  EPICS TARGET        : /epics
  EPICS_BASE VERSION  : 3.15.5
  E3_REQUIRE_VERSION  : 3.0.4
  EPICS_MODULE_TAG    : 3.15.5
  EPICS_BASE          : /epics/base-3.15.5
  E3_REQUIRE_LOCATION : /epics/base-3.15.5/require/3.0.4
```

```
e3-7.0.1.1 (master)$ ./e3_building_config.bash -b 7.0.1.1 setup
>> 
  The following configuration for e3 installation
  will be generated :

>> Set the global configuration as follows:
>>
  EPICS TARGET        : /epics
  EPICS_BASE VERSION  : 7.0.1.1
  E3_REQUIRE_VERSION  : 3.0.4
  EPICS_MODULE_TAG    : 7.0.1.1
  EPICS_BASE          : /epics/base-7.0.1.1
  E3_REQUIRE_LOCATION : /epics/base-7.0.1.1/require/3.0.4
```

```
 e3-3.15.5 (master)$ ./e3_building_config.bash -b 3.15.5 -t /opt/epics setup
>> 
  The following configuration for e3 installation
  will be generated :

>> Set the global configuration as follows:
>>
  EPICS TARGET        : /opt/epics
  EPICS_BASE VERSION  : 3.15.5
  E3_REQUIRE_VERSION  : 3.0.4
  EPICS_MODULE_TAG    : 3.15.5
  EPICS_BASE          : /opt/epics/base-3.15.5
  E3_REQUIRE_LOCATION : /opt/epics/base-3.15.5/require/3.0.4
```

## Global e3 environment settings

The previous step will generate the following three *.local files.

* CONFIG_BASE.local
```
E3_EPICS_PATH:=/epics
EPICS_BASE_TAG:=tags/R3.15.5
E3_BASE_VERSION:=3.15.5
#E3_CROSS_COMPILER_TARGET_ARCHS =
```
* RELEASE.local
```
EPICS_BASE:=/epics/base-3.15.5
E3_REQUIRE_VERSION:=3.0.4
```
* REQUIRE_CONFIG_MODULE.local
```
EPICS_MODULE_TAG:=tags/v3.0.4
```

They will help us to change base, require, and all modules configuration globally without changing source files which are monitored by git. 

## Install base

```
$ ./e3.bash base
```

## Install require

```
$ ./e3.bash req
```

## Install a selected group of modules

There are module groups which help us to select necessary modules in terms of system requirements as follows:

### Common Group
This group contains the common EPICS modules such as 

```
 e3-3.15.5 (master)$ ./e3.bash -c vars
>> Vertical display for the selected modules :

 Modules List 
    0 : e3-ess
    1 : e3-iocStats
    2 : e3-autosave
    3 : e3-caPutLog
    4 : e3-asyn
    5 : e3-busy
    6 : e3-modbus
    7 : e3-ipmiComm
    8 : e3-seq
    9 : e3-sscan
   10 : e3-std
   11 : e3-ip
   12 : e3-calc
   13 : e3-delaygen
   14 : e3-pcre
   15 : e3-StreamDevice
   16 : e3-s7plc
   17 : e3-recsync
   18 : e3-MCoreUtils
```

### Timing Group
```
 e3-3.15.5 (master)$ ./e3.bash -t vars
>> Vertical display for the selected modules :

 Modules List 
    0 : e3-devlib2
    1 : e3-mrfioc2
```
### EPICS V4 Group

Note that this group is not necessary for EPICS BASE 7

```
e3-3.15.5 (master)$ ./e3.bash -4 vars
>> Vertical display for the selected modules :

 Modules List 
    0 : e3-pvData
    1 : e3-pvAccess
    2 : e3-pva2pva
    3 : e3-pvDatabase
    4 : e3-normativeTypes
    5 : e3-pvaClient
```
### EtherCAT / Motion Group

If the group has the dependency upon others, it will add others automatically. 
```
e3-3.15.5 (master)$ ./e3.bash -e vars
>> Vertical display for the selected modules :

 Modules List 
    0 : e3-ess
    1 : e3-iocStats
    2 : e3-autosave
    3 : e3-caPutLog
    4 : e3-asyn
    5 : e3-busy
    6 : e3-modbus
    7 : e3-ipmiComm
    8 : e3-seq
    9 : e3-sscan
   10 : e3-std
   11 : e3-ip
   12 : e3-calc
   13 : e3-delaygen
   14 : e3-pcre
   15 : e3-StreamDevice
   16 : e3-s7plc
   17 : e3-recsync
   18 : e3-MCoreUtils
   19 : e3-exprtk
   20 : e3-motor
   21 : e3-ecmc
   22 : e3-ethercatmc
   23 : e3-ecmctraining
```
However, one can exclude the dependency modules via

```
e3-3.15.5 (master)$ ./e3.bash -eo vars
>> Vertical display for the selected modules :

 Modules List 
    0 : e3-exprtk
    1 : e3-motor
    2 : e3-ecmc
    3 : e3-ethercatmc
    4 : e3-ecmctraining
```
Note that one needs the ESS bitbucket account in order to access this.

### PSI Module Group

```
e3-3.15.5 (master)$ ./e3.bash -io vars
>> Vertical display for the selected modules :

 Modules List 
    0 : e3-keypress
    1 : e3-sysfs
    2 : e3-symbolname
    3 : e3-memDisplay
    4 : e3-regdev
    5 : e3-i2cDev
```

### IFC Module Group

One needs the ESS bitbucket account in order to access this.

```
 e3-3.15.5 (master)$ ./e3.bash -fo vars
>> Vertical display for the selected modules :

 Modules List 
    0 : e3-tsclib
    1 : e3-ifcdaqdrv2
    2 : e3-nds3
    3 : e3-nds3epics
    4 : e3-ifc14edrv
    5 : e3-ifcfastint
```
### AreaDetector Group

```
e3-3.15.5 (master)$ ./e3.bash -ao vars
>> Vertical display for the selected modules :

 Modules List 
    0 : e3-ADSupport
    1 : e3-ADCore
    2 : e3-ADSimDetector
    3 : e3-NDDriverStdArrays
    4 : e3-ADAndor
    5 : e3-ADAndor3
    6 : e3-ADPointGrey
    7 : e3-ADProsilica
    8 : e3-ADPluginEdge
    9 : e3-ADPluginCalib
```


### LLRF Group

```
 e3-3.15.5 (master)$ ./e3.bash -lo vars
>> Vertical display for the selected modules :

 Modules List 
    0 : e3-loki
    1 : e3-nds
    2 : e3-sis8300drv
    3 : e3-sis8300
    4 : e3-sis8300llrfdrv
    5 : e3-sis8300llrf
```


### Install a selected group

* Install the COMMON group
```
$ ./e3.bash -c mod
```

* Install the common, timing, areadetector, V4 groups
For EPICS base 3,
```
$ ./e3.bash -cta4 mod 
```
Or for EPICS base 7,
```
$ ./e3.bash -ctao mod
```

### Option : mod

The mod option has the following steps :
 
* Clean             : cmod
* Clone             : gmod
* Initiate          : imod
* Build and Install : bmod

These commands actually call the MAKEFILE rules each modules as

* make clean
* make init
* make patch 
* make build
* make install


### Check your installation

```
$ ./e3.bash -c load

......
drvStreamInit: Warning! STREAM_PROTOCOL_PATH not set. Defaults to "."
require: fillModuleListRecord
require: REQMOD-C5C2FA8:KAFFEE-9737:MODULES[0] = "require"
require: REQMOD-C5C2FA8:KAFFEE-9737:VERSIONS[0] = "3.0.4"
require: REQMOD-C5C2FA8:KAFFEE-9737:MOD_VER+="require    3.0.4"
require: REQMOD-C5C2FA8:KAFFEE-9737:MODULES[1] = "ess"
require: REQMOD-C5C2FA8:KAFFEE-9737:VERSIONS[1] = "0.0.1"
require: REQMOD-C5C2FA8:KAFFEE-9737:MOD_VER+="ess        0.0.1"
require: REQMOD-C5C2FA8:KAFFEE-9737:MODULES[2] = "iocStats"
require: REQMOD-C5C2FA8:KAFFEE-9737:VERSIONS[2] = "ae5d083"
require: REQMOD-C5C2FA8:KAFFEE-9737:MOD_VER+="iocStats   ae5d083"
require: REQMOD-C5C2FA8:KAFFEE-9737:MODULES[3] = "autosave"
require: REQMOD-C5C2FA8:KAFFEE-9737:VERSIONS[3] = "5.9.0"
require: REQMOD-C5C2FA8:KAFFEE-9737:MOD_VER+="autosave   5.9.0"
require: REQMOD-C5C2FA8:KAFFEE-9737:MODULES[4] = "caPutLog"
require: REQMOD-C5C2FA8:KAFFEE-9737:VERSIONS[4] = "3.6.0"
require: REQMOD-C5C2FA8:KAFFEE-9737:MOD_VER+="caPutLog   3.6.0"
require: REQMOD-C5C2FA8:KAFFEE-9737:MODULES[5] = "asyn"
require: REQMOD-C5C2FA8:KAFFEE-9737:VERSIONS[5] = "4.33.0"
require: REQMOD-C5C2FA8:KAFFEE-9737:MOD_VER+="asyn       4.33.0"
require: REQMOD-C5C2FA8:KAFFEE-9737:MODULES[6] = "busy"
require: REQMOD-C5C2FA8:KAFFEE-9737:VERSIONS[6] = "1.7.0"
require: REQMOD-C5C2FA8:KAFFEE-9737:MOD_VER+="busy       1.7.0"
require: REQMOD-C5C2FA8:KAFFEE-9737:MODULES[7] = "modbus"
require: REQMOD-C5C2FA8:KAFFEE-9737:VERSIONS[7] = "2.11.0p"
require: REQMOD-C5C2FA8:KAFFEE-9737:MOD_VER+="modbus     2.11.0p"
require: REQMOD-C5C2FA8:KAFFEE-9737:MODULES[8] = "ipmiComm"
require: REQMOD-C5C2FA8:KAFFEE-9737:VERSIONS[8] = "4.0.2"
require: REQMOD-C5C2FA8:KAFFEE-9737:MOD_VER+="ipmiComm   4.0.2"
require: REQMOD-C5C2FA8:KAFFEE-9737:MODULES[9] = "sequencer"
require: REQMOD-C5C2FA8:KAFFEE-9737:VERSIONS[9] = "2.2.6"
require: REQMOD-C5C2FA8:KAFFEE-9737:MOD_VER+="sequencer  2.2.6"
require: REQMOD-C5C2FA8:KAFFEE-9737:MODULES[10] = "sscan"
require: REQMOD-C5C2FA8:KAFFEE-9737:VERSIONS[10] = "1339922"
require: REQMOD-C5C2FA8:KAFFEE-9737:MOD_VER+="sscan      1339922"
require: REQMOD-C5C2FA8:KAFFEE-9737:MODULES[11] = "std"
require: REQMOD-C5C2FA8:KAFFEE-9737:VERSIONS[11] = "3.5.0"
require: REQMOD-C5C2FA8:KAFFEE-9737:MOD_VER+="std        3.5.0"
require: REQMOD-C5C2FA8:KAFFEE-9737:MODULES[12] = "ip"
require: REQMOD-C5C2FA8:KAFFEE-9737:VERSIONS[12] = "2.19.1"
require: REQMOD-C5C2FA8:KAFFEE-9737:MOD_VER+="ip         2.19.1"
require: REQMOD-C5C2FA8:KAFFEE-9737:MODULES[13] = "calc"
require: REQMOD-C5C2FA8:KAFFEE-9737:VERSIONS[13] = "3.7.1"
require: REQMOD-C5C2FA8:KAFFEE-9737:MOD_VER+="calc       3.7.1"
require: REQMOD-C5C2FA8:KAFFEE-9737:MODULES[14] = "delaygen"
require: REQMOD-C5C2FA8:KAFFEE-9737:VERSIONS[14] = "1.2.0"
require: REQMOD-C5C2FA8:KAFFEE-9737:MOD_VER+="delaygen   1.2.0"
require: REQMOD-C5C2FA8:KAFFEE-9737:MODULES[15] = "pcre"
require: REQMOD-C5C2FA8:KAFFEE-9737:VERSIONS[15] = "8.41.0"
require: REQMOD-C5C2FA8:KAFFEE-9737:MOD_VER+="pcre       8.41.0"
require: REQMOD-C5C2FA8:KAFFEE-9737:MODULES[16] = "stream"
require: REQMOD-C5C2FA8:KAFFEE-9737:VERSIONS[16] = "2.7.14p"
require: REQMOD-C5C2FA8:KAFFEE-9737:MOD_VER+="stream     2.7.14p"
require: REQMOD-C5C2FA8:KAFFEE-9737:MODULES[17] = "s7plc"
require: REQMOD-C5C2FA8:KAFFEE-9737:VERSIONS[17] = "1.4.0p"
require: REQMOD-C5C2FA8:KAFFEE-9737:MOD_VER+="s7plc      1.4.0p"
require: REQMOD-C5C2FA8:KAFFEE-9737:MODULES[18] = "recsync"
require: REQMOD-C5C2FA8:KAFFEE-9737:VERSIONS[18] = "1.3.0"
require: REQMOD-C5C2FA8:KAFFEE-9737:MOD_VER+="recsync    1.3.0"
require: REQMOD-C5C2FA8:KAFFEE-9737:MODULES[19] = "MCoreUtils"
require: REQMOD-C5C2FA8:KAFFEE-9737:VERSIONS[19] = "1.2.1"
require: REQMOD-C5C2FA8:KAFFEE-9737:MOD_VER+="MCoreUtils 1.2.1"
iocRun: All initialization complete
c5c2fa8.kaffee.9733 > 
c5c2fa8.kaffee.9733 > 
c5c2fa8.kaffee.9733 > 
```
The command will load all installed modules within a single iocsh.bash. If one see the clear console prompt >, one has the e3 installation done in the local host.




------------------
[:arrow_backward:](README.md)  | [:arrow_up_small:](chapter1.md)  | [:arrow_forward:](chapter2.md)
:--- | --- |---: 
[README](README.md) | [Chapter 1](chapter1.md) | [Chapter 2 : Your First Running IOC](chapter2.md)
