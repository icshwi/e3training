 # Chapter 1: Installing e3 

[Return to Table of Contents](README.md)

## Lesson overview

In this lesson, you'll learn how to do the following:

* Download e3 using git.
* Configure the e3 environment.
* Set up e3 EPICS base.
* Set up the e3 *require* module.
* Set up common e3 module packs.
* Test your installation.

---

## Downloading e3

*N.B.! ESS' EPICS environment e3 is developed primarily for CentOS, and it is thus recommended two use CentOS7 whilst exercising this tutorial.*

> As e3 heavily relies on git, it's recommended to first be familiar with especially git submodules.

If you're on a mostly blank CentOS7 machine, you can copy, paste, and run the following code segment before beginning:

```bash
sudo yum install -y git tree ipmitool autoconf libtool automake m4 re2c tclx \
coreutils graphviz patch readline-devel libXt-devel libXp-devel libXmu-devel \
libXpm-devel lesstif-devel gcc-c++ ncurses-devel perl-devel net-snmp net-snmp-utils \
net-snmp-devel libxml2-devel libpng12-devel libzip-devel libusb-devel \
python-devel darcs hdf5-devel boost-devel pcre-devel opencv-devel \
libcurl-devel blosc-devel libtiff-devel libjpeg-turbo-devel \
libusbx-devel systemd-devel libraw1394.x86_64 hg libtirpc-devel \
liberation-fonts-common liberation-narrow-fonts \
liberation-mono-fonts liberation-serif-fonts liberation-sans-fonts \
logrotate xorg-x11-fonts-misc cpan kernel-devel symlinks \
dkms procServ curl netcdf netcdf-devel telnet
```

---

Start by downloading e3 from GitHub:
```console
[iocuser@host:~]$ git clone https://github.com/icshwi/e3 
```

> As e3 by design can have multiple different configurations in a host, it is recommended to use self-explanatory source directory names. This will allow you to easily switch between e.g. EPICS base versions 3.15.5 and 7.0.3 during development. For example, if one would like to use EPICS base 3.15.5, it is preferred to clone like:

```console
[iocuser@host:~]$ git clone https://github.com/icshwi/e3 e3-3.15.5
```

The e3 root directory (`/home/iocuser/e3-3.15.5/` in the most recent example) will henceforth be referred to as **E3_TOP**.

> Typical paths for EPICS installations tend to be `/epics` or `/opt/epics`. For this tutorial series, e3 will be cloned to `$HOME` and EPICS will be installed at `/epics`.

## Configure e3

Configuring an e3 build with default settings can be done like:

```console
[iocuser@host:e3]$ ./e3_building_config.bash setup
```

> The utility can be launched with a number of arguments. To see these, simply run the script without any arguments, i.e. `./e3_building_config.bash`; you can modify the building path (e.g. `-t <where-you-want-to-install>`) as well as define versions.

As always with EPICS, versions are important. Especially pay attention to:

* The version of EPICS base
* The version of *require*

---

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

Configuring EPICS per above directions will generate the following three `*.local` files.

* `CONFIG_BASE.local`
  
  ```python
  E3_EPICS_PATH:=/epics
  EPICS_BASE_TAG:=tags/r3.15.5
  E3_BASE_VERSION:=3.15.5
  E3_CROSS_COMPILER_TOOLCHAIN_VER=current
  E3_CROSS_COMPILER_TOOLCHAIN_PATH=/opt/fsl-qoriq
  ```

* `RELEASE.local`
  
  ```python
  EPICS_BASE:=/epics/base-3.15.5
  E3_REQUIRE_VERSION:=3.0.5
  ```

* `REQUIRE_CONFIG_MODULE.local`
  
  ```python
  EPICS_MODULE_TAG:=tags/v3.0.5
  ```

These will help us to change base, require, and all modules' configuration without having to change any source files.

## Building and installing EPICS base and require

For EPICS base and *require*, it's as simple as running:

```console
[iocuser@host:e3]$ ./e3.bash base
```

```console
[iocuser@host:e3]$ ./e3.bash req
```

> Remember to run these with elevated status (`sudo`) if you want to install in `/opt`.

## Module packs

As with installing EPICS base and *require*, you can use the `e3.bash` utility to install common module groups. These are:

### Common group

This group contains the common EPICS modules, and is more or less a standard install.

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

This group contains modules important for fast timestamping.

```console
[iocuser@host:e3]$ ./e3.bash -t vars
>> vertical display for the selected modules :

 modules list 
    0 : e3-devlib2
    1 : e3-mrfioc2
```

### EPICS V4 group

*N.B.! This group is not necessary for EPICS base 7 as they already are included.*

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

*N.B.! You will need an ESS' Bitbucket account to access some of the modules in this group.*

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

> While installing module groups, dependencies are added automatically. You can choose to exclude the dependency modules by adding an `-o` flag, like:
> 
> ```console
> [iocuser@host:e3]$ ./e3.bash -eo vars
> >> Vertical display for the selected modules :
> 
>  Modules List 
>     0 : e3-exprtk
>     1 : e3-motor
>     2 : e3-ecmc
>     3 : e3-ethercatmc
>     4 : e3-ecmctraining
> ```

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

*N.B.! You need an ESS Bitbucket account in order to access some of these modules.*

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

You download, build, and install a group by using the `mod` argument (as in **mod**ules). For example:

* To install the common group:

  ```console
  [iocuser@host:e3]$ ./e3.bash -c mod
  ```

* To install the Common, Timing, AreaDetector, and V4 groups:

  * for EPICS base 3:

    ```console
    [iocuser@host:e3]$ ./e3.bash -cta4 mod 
    ```

  * for EPICS base 7:

    ```console
    [iocuser@host:e3]$ ./e3.bash -ctao mod
    ```

### Options

The mod argument contain these---individually accessible---steps:
 
* `cmod` Clean  
* `gmod` Clone  
* `imod` Initiate  
* `bmod` Build and install  

And the *makefile* rules that can be used for a module are:

* `make clean`
* `make init`
* `make patch` 
* `make build`
* `make install`

### Test your installation

The following command will load all installed modules within a single `iocsh.bash`. If you after executing `e3.bash -c load` see a clear console prompt (`>`), you have succesfully installed e3 on the host.

```console
[iocuser@host:e3]$ ./e3.bash -c load
# --- snip snip ---
require: fillModuleListRecord
require: REQMOD-791F5F3:FAISERV-21664:MODULES[0] = "require"
require: REQMOD-791F5F3:FAISERV-21664:VERSIONS[0] = "3.0.5"
require: REQMOD-791F5F3:FAISERV-21664:MOD_VER+="require    3.0.5"
require: REQMOD-791F5F3:FAISERV-21664:MODULES[1] = "ess"
require: REQMOD-791F5F3:FAISERV-21664:VERSIONS[1] = "0.0.1"
require: REQMOD-791F5F3:FAISERV-21664:MOD_VER+="ess        0.0.1"
require: REQMOD-791F5F3:FAISERV-21664:MODULES[2] = "iocStats"
require: REQMOD-791F5F3:FAISERV-21664:VERSIONS[2] = "ae5d083"
require: REQMOD-791F5F3:FAISERV-21664:MOD_VER+="iocStats   ae5d083"
require: REQMOD-791F5F3:FAISERV-21664:MODULES[3] = "autosave"
require: REQMOD-791F5F3:FAISERV-21664:VERSIONS[3] = "5.9.0"
require: REQMOD-791F5F3:FAISERV-21664:MOD_VER+="autosave   5.9.0"
require: REQMOD-791F5F3:FAISERV-21664:MODULES[4] = "caPutLog"
require: REQMOD-791F5F3:FAISERV-21664:VERSIONS[4] = "3.6.0"
require: REQMOD-791F5F3:FAISERV-21664:MOD_VER+="caPutLog   3.6.0"
require: REQMOD-791F5F3:FAISERV-21664:MODULES[5] = "asyn"
require: REQMOD-791F5F3:FAISERV-21664:VERSIONS[5] = "4.33.0"
require: REQMOD-791F5F3:FAISERV-21664:MOD_VER+="asyn       4.33.0"
require: REQMOD-791F5F3:FAISERV-21664:MODULES[6] = "busy"
require: REQMOD-791F5F3:FAISERV-21664:VERSIONS[6] = "1.7.0"
require: REQMOD-791F5F3:FAISERV-21664:MOD_VER+="busy       1.7.0"
require: REQMOD-791F5F3:FAISERV-21664:MODULES[7] = "modbus"
require: REQMOD-791F5F3:FAISERV-21664:VERSIONS[7] = "2.11.0p"
require: REQMOD-791F5F3:FAISERV-21664:MOD_VER+="modbus     2.11.0p"
require: REQMOD-791F5F3:FAISERV-21664:MODULES[8] = "ipmiComm"
require: REQMOD-791F5F3:FAISERV-21664:VERSIONS[8] = "4.2.0"
require: REQMOD-791F5F3:FAISERV-21664:MOD_VER+="ipmiComm   4.2.0"
require: REQMOD-791F5F3:FAISERV-21664:MODULES[9] = "sequencer"
require: REQMOD-791F5F3:FAISERV-21664:VERSIONS[9] = "2.2.6"
require: REQMOD-791F5F3:FAISERV-21664:MOD_VER+="sequencer  2.2.6"
require: REQMOD-791F5F3:FAISERV-21664:MODULES[10] = "sscan"
require: REQMOD-791F5F3:FAISERV-21664:VERSIONS[10] = "1339922"
require: REQMOD-791F5F3:FAISERV-21664:MOD_VER+="sscan      1339922"
require: REQMOD-791F5F3:FAISERV-21664:MODULES[11] = "std"
require: REQMOD-791F5F3:FAISERV-21664:VERSIONS[11] = "3.5.0"
require: REQMOD-791F5F3:FAISERV-21664:MOD_VER+="std        3.5.0"
require: REQMOD-791F5F3:FAISERV-21664:MODULES[12] = "ip"
require: REQMOD-791F5F3:FAISERV-21664:VERSIONS[12] = "2.19.1"
require: REQMOD-791F5F3:FAISERV-21664:MOD_VER+="ip         2.19.1"
require: REQMOD-791F5F3:FAISERV-21664:MODULES[13] = "calc"
require: REQMOD-791F5F3:FAISERV-21664:VERSIONS[13] = "3.7.1"
require: REQMOD-791F5F3:FAISERV-21664:MOD_VER+="calc       3.7.1"
require: REQMOD-791F5F3:FAISERV-21664:MODULES[14] = "delaygen"
require: REQMOD-791F5F3:FAISERV-21664:VERSIONS[14] = "1.2.0"
require: REQMOD-791F5F3:FAISERV-21664:MOD_VER+="delaygen   1.2.0"
require: REQMOD-791F5F3:FAISERV-21664:MODULES[15] = "pcre"
require: REQMOD-791F5F3:FAISERV-21664:VERSIONS[15] = "8.41.0"
require: REQMOD-791F5F3:FAISERV-21664:MOD_VER+="pcre       8.41.0"
require: REQMOD-791F5F3:FAISERV-21664:MODULES[16] = "stream"
require: REQMOD-791F5F3:FAISERV-21664:VERSIONS[16] = "2.8.8"
require: REQMOD-791F5F3:FAISERV-21664:MOD_VER+="stream     2.8.8"
require: REQMOD-791F5F3:FAISERV-21664:MODULES[17] = "s7plc"
require: REQMOD-791F5F3:FAISERV-21664:VERSIONS[17] = "1.4.0p"
require: REQMOD-791F5F3:FAISERV-21664:MOD_VER+="s7plc      1.4.0p"
require: REQMOD-791F5F3:FAISERV-21664:MODULES[18] = "recsync"
require: REQMOD-791F5F3:FAISERV-21664:VERSIONS[18] = "1.3.0"
require: REQMOD-791F5F3:FAISERV-21664:MOD_VER+="recsync    1.3.0"
require: REQMOD-791F5F3:FAISERV-21664:MODULES[19] = "MCoreUtils"
require: REQMOD-791F5F3:FAISERV-21664:VERSIONS[19] = "1.2.1"
require: REQMOD-791F5F3:FAISERV-21664:MOD_VER+="MCoreUtils 1.2.1"
iocRun: All initialization complete
791f5f3.faiserv.21660 > 
```

---

## Assignments

Please make sure you understand:

- How GNU Make and Makefiles work.
- How git submodules work.


---

[Next: Chapter 2 - Your first running e3 IOC](chapter02.md)

[Return to Table of Contents](README.md)
