 # Chapter 1: Installing e3 

## Lesson overview

In this lesson, you'll learn how to do the following:
* Download e3 using git
* Configure the e3 environment
* Set up e3 EPICS base
* Set up the e3 require module
* Set up common e3 module packs
* Test your installation

[Return to Table of Contents](README.md)

## Downloading e3

*ESS' EPICS environment e3 is developed primarily for CentOS, and it is thus recommended to use CentOS7 while exercising this tutorial. you may be prompted to add additional packages while trying things out.*

Start by downloading e3 from GitHub:
```bash
[iocuser@host:~]$ git clone https://github.com/icshwi/e3 
```

Note that by the design concept of e3 one can have multiple e3 configurations in a host, and it is therefore recommended to use self-explanatory source directory names. for example, if one would like to use EPICS base 3.15.5:

```bash
[iocuser@host:~]$ git clone https://github.com/icshwi/e3 e3-3.15.5
```

The e3 root directory (`e3-3.15.5/`) will henceforth be referred to as **E3_TOP**.

*Note: typical paths for EPICS installations tend to be `/epics` or `/opt/epics`. for this tutorial series, e3 will be cloned to `$HOME` and EPICS will be installed at `/epics`.*

## Configure e3

Configuring an e3 build with default settings can be done like:

```bash
[iocuser@host:e3]$ ./e3_building_config.bash setup
```

The utility can however be launched with a number of arguments (to see these, simply run the script without any arguments: `./e3_building_config.bash`); you can modify the building path (`-t <where-you-want-to-install>`) as well as define versions. And on that note, always pay close attention to especially:

* EPICS base version 
* require version

Examples:

```console
[iocuser@host:e3]$ ./e3_building_config.bash -b 7.0.1.1 setup
>> 
  The following configuration for e3 installation
  will be generated :

>> Set the global configuration as follows:
>>  
  EPICS TARGET                     : /epics
  EPICS_BASE                       : /epics/base-7.0.1.1
  EPICS_BASE VERSION               : 7.0.1.1
  EPICS_MODULE_TAG                 : 7.0.1.1
  E3_REQUIRE_VERSION               : 3.0.5
  E3_REQUIRE_LOCATION              : /epics/base-7.0.1.1/require/3.0.5
  E3_CROSS_COMPILER_TOOLCHAIN_PATH : /opt/fsl-qoriq
  E3_CROSS_COMPILER_TOOLCHAIN_VER  : current
```

```console
[iocuser@host:e3]$ ./e3_building_config.bash -b 3.15.5 -t /opt/epics setup
>> 
  The following configuration for e3 installation
  will be generated :

>> Set the global configuration as follows:
>>
  EPICS TARGET                     : /opt/epics
  EPICS_BASE                       : /opt/epics/base-3.15.5
  EPICS_BASE VERSION               : 3.15.5
  EPICS_MODULE_TAG                 : 3.15.5
  E3_REQUIRE_VERSION               : 3.0.5
  E3_REQUIRE_LOCATION              : /opt/epics/base-3.15.5/require/3.0.5
  E3_CROSS_COMPILER_TOOLCHAIN_PATH : /opt/fsl-qoriq
  E3_CROSS_COMPILER_TOOLCHAIN_VER  : current
```

## Global e3 environment settings

Configuring epics per above directions will generate the following three `*.local` files.

* `CONFIG_BASE.local`

  ```properties
  E3_EPICS_PATH:=/epics
  EPICS_BASE_TAG:=tags/r3.15.5
  E3_BASE_VERSION:=3.15.5
  E3_CROSS_COMPILER_TOOLCHAIN_VER=current
  E3_CROSS_COMPILER_TOOLCHAIN_PATH=/opt/fsl-qoriq
  ```

* `RELEASE.local`

  ```properties
  EPICS_BASE:=/epics/base-3.15.5
  E3_REQUIRE_VERSION:=3.0.5
  ```

* `REQUIRE_CONFIG_MODULE.local`

  ```properties
  EPICS_MODULE_TAG:=tags/v3.0.5
  ```

These will help us to change base, require, and all modules' configuration globally without having to change any source files.

## Building and installing EPICS base and require

```bash
[iocuser@host:e3]$ ./e3.bash base
```

```bash
[iocuser@host:e3]$ ./e3.bash req
```

## Module packs

In e3, there are module groups to aid with development. These are:

### Common group

This group contains the common EPICS modules. 

```console
[iocuser@host:e3]$ ./e3.bash -c vars
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

### Timing group

```console
 e3-3.15.5 (master)$ ./e3.bash -t vars
>> vertical display for the selected modules :

 modules list 
    0 : e3-devlib2
    1 : e3-mrfioc2
```

### EPICS V4 group

*Note that this group is not necessary for EPICS base 7 as they already are included.*

```console
[iocuser@host:e3]$ ./e3.bash -4 vars
>> Vertical display for the selected modules :

 Modules List 
    0 : e3-pvData
    1 : e3-pvAccess
    2 : e3-pva2pva
    3 : e3-pvDatabase
    4 : e3-normativeTypes
    5 : e3-pvaClient
```

### EtherCAT / Motion group

This group contains modules commonly used with motion contol. Note here that if a group has depencies upon other modules, these will be added automatically:

```console
[iocuser@host:e3]$ ./e3.bash -e vars
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

You can however exclude the dependency modules by adding an `-o` flag, like:

```console
[iocuser@host:e3]$ ./e3.bash -eo vars
>> Vertical display for the selected modules :

 Modules List 
    0 : e3-exprtk
    1 : e3-motor
    2 : e3-ecmc
    3 : e3-ethercatmc
    4 : e3-ecmctraining
```

*Note that you need an ESS Bitbucket account in order to access these.*

### PSI module group

```console
[iocuser@host:e3]$ ./e3.bash -io vars
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

*Note: You need an ESS bitbucket account in order to access these.*

```console
[iocuser@host:e3]$ ./e3.bash -fo vars
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

```console
[iocuser@host:e3]$ ./e3.bash -ao vars
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

```console
[iocuser@host:e3]$ ./e3.bash -lo vars
>> Vertical display for the selected modules :

 Modules List 
    0 : e3-loki
    1 : e3-nds
    2 : e3-sis8300drv
    3 : e3-sis8300
    4 : e3-sis8300llrfdrv
    5 : e3-sis8300llrf
```

### Downloading and installing a group

You download, build, and install a group by using the `mod` argument. For example:

* To install the common group:

  ```bash
  [iocuser@host:e3]$ ./e3.bash -c mod
  ```

* To install the common, timing, areadetector, and v4 groups:

  * for EPICS base 3:

    ```bash
    [iocuser@host:e3]$ ./e3.bash -cta4 mod 
    ```

  * for EPICS base 7:

    ```bash
    [iocuser@host:e3]$ ./e3.bash -ctao mod
    ```

### Options

The mod argument contain these---individually accessible---steps:
 
* Clean
  `cmod`
* Clone
  `gmod`
* Initiate
  `imod`
* Build and install
  `bmod`

The MAKEFILE rules that can be used for a module are:

* `make clean`
* `make init`
* `make patch` 
* `make build`
* `make install`

### Test your installation

The following command will load all installed modules within a single iocsh.bash. If you after executing `e3.bash -c load` see a clear console prompt (`>`), you have succesfully installed e3 on the host.

```console
[iocuser@host:e3]$ ./e3.bash -c load

......
require: fillmodulelistrecord
require: reqmod-791f5f3:faiserv-21664:modules[0] = "require"
require: reqmod-791f5f3:faiserv-21664:versions[0] = "3.0.5"
require: reqmod-791f5f3:faiserv-21664:mod_ver+="require    3.0.5"
require: reqmod-791f5f3:faiserv-21664:modules[1] = "ess"
require: reqmod-791f5f3:faiserv-21664:versions[1] = "0.0.1"
require: reqmod-791f5f3:faiserv-21664:mod_ver+="ess        0.0.1"
require: reqmod-791f5f3:faiserv-21664:modules[2] = "iocstats"
require: reqmod-791f5f3:faiserv-21664:versions[2] = "ae5d083"
require: reqmod-791f5f3:faiserv-21664:mod_ver+="iocstats   ae5d083"
require: reqmod-791f5f3:faiserv-21664:modules[3] = "autosave"
require: reqmod-791f5f3:faiserv-21664:versions[3] = "5.9.0"
require: reqmod-791f5f3:faiserv-21664:mod_ver+="autosave   5.9.0"
require: reqmod-791f5f3:faiserv-21664:modules[4] = "caputlog"
require: reqmod-791f5f3:faiserv-21664:versions[4] = "3.6.0"
require: reqmod-791f5f3:faiserv-21664:mod_ver+="caputlog   3.6.0"
require: reqmod-791f5f3:faiserv-21664:modules[5] = "asyn"
require: reqmod-791f5f3:faiserv-21664:versions[5] = "4.33.0"
require: reqmod-791f5f3:faiserv-21664:mod_ver+="asyn       4.33.0"
require: reqmod-791f5f3:faiserv-21664:modules[6] = "busy"
require: reqmod-791f5f3:faiserv-21664:versions[6] = "1.7.0"
require: reqmod-791f5f3:faiserv-21664:mod_ver+="busy       1.7.0"
require: reqmod-791f5f3:faiserv-21664:modules[7] = "modbus"
require: reqmod-791f5f3:faiserv-21664:versions[7] = "2.11.0p"
require: reqmod-791f5f3:faiserv-21664:mod_ver+="modbus     2.11.0p"
require: reqmod-791f5f3:faiserv-21664:modules[8] = "ipmicomm"
require: reqmod-791f5f3:faiserv-21664:versions[8] = "4.2.0"
require: reqmod-791f5f3:faiserv-21664:mod_ver+="ipmicomm   4.2.0"
require: reqmod-791f5f3:faiserv-21664:modules[9] = "sequencer"
require: reqmod-791f5f3:faiserv-21664:versions[9] = "2.2.6"
require: reqmod-791f5f3:faiserv-21664:mod_ver+="sequencer  2.2.6"
require: reqmod-791f5f3:faiserv-21664:modules[10] = "sscan"
require: reqmod-791f5f3:faiserv-21664:versions[10] = "1339922"
require: reqmod-791f5f3:faiserv-21664:mod_ver+="sscan      1339922"
require: reqmod-791f5f3:faiserv-21664:modules[11] = "std"
require: reqmod-791f5f3:faiserv-21664:versions[11] = "3.5.0"
require: reqmod-791f5f3:faiserv-21664:mod_ver+="std        3.5.0"
require: reqmod-791f5f3:faiserv-21664:modules[12] = "ip"
require: reqmod-791f5f3:faiserv-21664:versions[12] = "2.19.1"
require: reqmod-791f5f3:faiserv-21664:mod_ver+="ip         2.19.1"
require: reqmod-791f5f3:faiserv-21664:modules[13] = "calc"
require: reqmod-791f5f3:faiserv-21664:versions[13] = "3.7.1"
require: reqmod-791f5f3:faiserv-21664:mod_ver+="calc       3.7.1"
require: reqmod-791f5f3:faiserv-21664:modules[14] = "delaygen"
require: reqmod-791f5f3:faiserv-21664:versions[14] = "1.2.0"
require: reqmod-791f5f3:faiserv-21664:mod_ver+="delaygen   1.2.0"
require: reqmod-791f5f3:faiserv-21664:modules[15] = "pcre"
require: reqmod-791f5f3:faiserv-21664:versions[15] = "8.41.0"
require: reqmod-791f5f3:faiserv-21664:mod_ver+="pcre       8.41.0"
require: reqmod-791f5f3:faiserv-21664:modules[16] = "stream"
require: reqmod-791f5f3:faiserv-21664:versions[16] = "2.8.8"
require: reqmod-791f5f3:faiserv-21664:mod_ver+="stream     2.8.8"
require: reqmod-791f5f3:faiserv-21664:modules[17] = "s7plc"
require: reqmod-791f5f3:faiserv-21664:versions[17] = "1.4.0p"
require: reqmod-791f5f3:faiserv-21664:mod_ver+="s7plc      1.4.0p"
require: reqmod-791f5f3:faiserv-21664:modules[18] = "recsync"
require: reqmod-791f5f3:faiserv-21664:versions[18] = "1.3.0"
require: reqmod-791f5f3:faiserv-21664:mod_ver+="recsync    1.3.0"
require: reqmod-791f5f3:faiserv-21664:modules[19] = "mcoreutils"
require: reqmod-791f5f3:faiserv-21664:versions[19] = "1.2.1"
require: reqmod-791f5f3:faiserv-21664:mod_ver+="mcoreutils 1.2.1"
iocrun: all initialization complete
791f5f3.faiserv.21660 > 
```


[:arrow_backward:](README.md)  | [:arrow_up_small:](chapter1.md)  | [:arrow_forward:](chapter2.md)
:--- | --- |---: 
[README](README.md) | [Chapter 1](chapter1.md) | [Chapter 2 : Your First Running IOC](chapter2.md)
