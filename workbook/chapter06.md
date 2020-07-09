# Chapter 6 : Variables and parameters within e3

[Return to Table of Contents](README.md)

## Lesson Overview

In this lesson, you'll learn how to do the following:

* Understand variables and parameters within an IOC 
* Run commands to access access variables and parameters from within an IOC
* Understand EPICS and e3 environment variables used when a module is configured
* Combine variable commands to access path or files of any module within an IOC

---

## Running an IOC

The following variables are defined when an IOC is running within startup scripts and iocsh. 

### General `iocsh.bash` variables

* `REQUIRE_IOC`: A read-only variable which is defined within `iocsh.bash`. <!-- fixme: verify what it does -->

* `E3_CMD_TOP`: The absolute path to the startup script (cmd file).

* `E3_IOCSH_TOP`: The absolute path to where `iocsh.bash` is executed.

* `IOCSH_PS1`: The IOC Prompt String.

### Variables used by *require*

It is useful to access the absolute path when an IOC starts within startup scripts. <!-- fixme ??? -->

Require uses a few module specific variables, ending with `_VERSION`, `_DIR`, `_DB`, and `_TEMPLATES`. With `mrfioc2` as example, these would be:

* `mrfioc2_VERSION`
* `mrfioc2_DIR`
* `mrfioc2_DB`
* `mrfioc2_TEMPLATES`

Let's see these in action:

```console
$ iocsh.bash ch6_supplementary_path/ch6.cmd
# --- snip snip ---
epicsEnvSet "EXECUTE_TOP"     /home/jhlee/ics_gitsrc/e3training/workbook
epicsEnvSet "STARTUP_TOP"     /home/jhlee/ics_gitsrc/e3training/workbook/ch6_supplementary_path
epicsEnvSet "TOP"             /home/jhlee/ics_gitsrc/e3training/workbook/ch6_supplementary_path/..
epicsEnvSet "IOCSTATS_MODULE_PATH"          /epics/base-7.0.3/require/3.1.0/siteMods/iocStats/ae5d083/
epicsEnvSet "IOCSTATS_MODULE_VERSION"       ae5d083
epicsEnvSet "IOCSTATS_MODULE_DB_PATH"       /epics/base-7.0.3/require/3.1.0/siteMods/iocStats/ae5d083/db
epicsEnvSet "IOCSTATS_MODULE_TEMPLATE_PATH" /epics/base-7.0.3/require/3.1.0/siteMods/iocStats/ae5d083/db

# --- snip snip ---

## EPICS Base built Aug  5 2019
############################################################################
iocRun: All initialization complete
#
echo "E3_IOCSH_TOP       : /home/jhlee/ics_gitsrc/e3training/workbook"
E3_IOCSH_TOP       : /home/jhlee/ics_gitsrc/e3training/workbook
#
echo "E3_CMD_TOP         : /home/jhlee/ics_gitsrc/e3training/workbook/ch6_supplementary_path"
E3_CMD_TOP         : /home/jhlee/ics_gitsrc/e3training/workbook/ch6_supplementary_path
#
echo "iocStats_DIR       : /epics/base-7.0.3/require/3.1.0/siteMods/iocStats/ae5d083/"
iocStats_DIR       : /epics/base-7.0.3/require/3.1.0/siteMods/iocStats/ae5d083/
#
echo "iocStats_VERSION   : ae5d083"
iocStats_VERSION   : ae5d083
#
echo "iocStats_DB        : /epics/base-7.0.3/require/3.1.0/siteMods/iocStats/ae5d083/db"
iocStats_DB        : /epics/base-7.0.3/require/3.1.0/siteMods/iocStats/ae5d083/db
#
echo "iocStats_TEMPLATES : /epics/base-7.0.3/require/3.1.0/siteMods/iocStats/ae5d083/db"
iocStats_TEMPLATES : /epics/base-7.0.3/require/3.1.0/siteMods/iocStats/ae5d083/db
#
# --- snip snip ---
```

> It is important to remember these variables. Perhaps especially the `*_DB` variable, as one should use this variable as the `STREAM_PROTOCOL_PATH` within a startup script together with the `stream` module. For example:
>
> ```bash
> epicsEnvSet("STREAM_PROTOCOL_PATH", "$(AAAAAA_DIR)")
> ```

Test this out yourself. Copy `ch6.cmd` to `ch6-local.cmd` and add *recsync* 1.3.0, then access the four aforementioned variables for the recsync module.

### EPICS variables, parameters, and environment variables

You can see EPICS parameters and environment variables from within an IOC using `epicsParamShow` and `epicsEnvShow`.

```console
# Set the IOC Prompt String One 
epicsEnvSet IOCSH_PS1 "58bef31.faiserv.18238 > "
#
58bef31.faiserv.18238 > epicsParamShow 
58bef31.faiserv.18238 > epicsEnvShow 
```
 <!-- fixme: clean up above -->

* Run `epicsPrtEnvParams`. Which other command returns the same result?

* How do we access only one variable---for example `TOP`?

  > For questions on EPICS functions, the [App Developers Guide](https://epics.anl.gov/base/R3-15/6-docs/AppDevGuide/IOCShell.html#x19-73300018) will usually have your answers.

  > There are four UNIX commands that can be used from within the IOC shell: `date`, `pwd`, `cd`, and `echo`.

* What is the difference between `$(TOP)` and `${TOP}`? Is it the same inside of the IOC shell as in UNIX?

* In the shell, please try to run `var`. What do you see? 

  ```console
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

In the running IOC, let's require the recsync module.

0. Run:

   ```console
   58bef31.faiserv.18238 > require recsync,1.3.0
   Module recsync version 1.3.0 found in /epics/base-3.15.5/require/3.0.4/siteMods/recsync/1.3.0/
   Loading library /epics/base-3.15.5/require/3.0.4/siteMods/recsync/1.3.0/lib/linux-x86_64/librecsync.so
   Loaded recsync version 1.3.0
   Loading dbd file /epics/base-3.15.5/require/3.0.4/siteMods/recsync/1.3.0/dbd/recsync.dbd
   Calling function recsync_registerRecordDeviceDriver
   ```

1. Redo require:

   ```console
   58bef31.faiserv.18238 > require recsync,1.3.0
   Module recsync version 1.3.0 already loaded
   ```

2. Type in the command `var requireDebug 1`:

   ```console
   58bef31.faiserv.18238 > var requireDebug 1
   ```

3. Redo require again:

   ```console
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

As you can see, `var` is defined as a variable within the *require* module. This variable is usually used as a debug message control variable, but can be used for more. 

4. Make sure to disable the debugging output again:

   ```console
   58bef31.faiserv.18238 > var requireDebug 0
   58bef31.faiserv.18238 > require recsync,1.3.0
   ```

> Note that the UP and DOWN keys can be used to navigate between historical commands.

## Building a module or an application 

Back in [Chapter 3](chapter03.md) we looked at the two e3 variables `E3_MODULE_VERSION` and  `EPICS_MODULE_TAG`. As you will see, there are many more environment variables that we can use together with e3 when configuring and installing modules.

### e3 environment variables

You can print out all environment variables of a module with the rule `make vars`:

```console
[iocuser@host:e3-caPutLog]$ make vars

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

### Customized EPICS environment variables

* `EPICS_BASE` is where EPICS base is installed (EPICS environment variable).

* `EPICS_HOST_ARCH` is the host system architecture (EPICS environment variable).

* `EPICS_MODULE_NAME` is the module name used by *require* and e3 (e3 environment variable). See also `E3_MODULE_NAME`. 

  *N.B.! This name should only consist of letters (upper and lower case) and digits. Underscore is also allowed.*
  
  > Technically, this name is coverted into a `char` in a C program, and much thus follow C programming rules.

* `EPICS_MODULE_TAG` is a point release information of the remote source code repository; i.e. what you would use together with `git checkout`, like: `master`, `tags/R3.6`, or `ae5d083`.

* `INSTALLED_EPICS_BASE_ARCHS` shows the EPICS base architecture installed in the local system.

  > At ESS, this will almost always be `linux-x86_64`.

### e3 environment variables

* `E3_SITEMODS_PATH`: e3 site module installation path. 

* `E3_SITEAPPS_PATH`: e3 site application installation path. 

* `E3_SITELIBS_PATH`: e3 site library path.

* `E3_REQUIRE_NAME`: unique e3 module name used by *require*. This variable should not be changed. 

* `E3_REQUIRE_VERSION`: *require* version number. 

* `E3_REQUIRE_BIN`: *require* binary path. 

* `E3_REQUIRE_CONFIG`: *require* configure path.

* `E3_REQUIRE_DB`: *require* database path. 

* `E3_REQUIRE_INC`: *require* include path. 

* `E3_REQUIRE_LIB`: *require* lib path.

* `E3_REQUIRE_LOCATION`: *require* root directory path. 

* `E3_REQUIRE_TOOLS`: *require* tools path. 

* `REQUIRE_CONFIG`: *require* configuration path used for by module configurations. It is typically the same as `E3_REQUIRE_CONFIG`, but is defined before `E3_REQUIRE_CONFIG`. 

### e3 module/application core environment variables

* `E3_MODULE_NAME`: Module name used by the command `require` within an IOC startup script, i.e. `require E3_MODULE_NAME, E3_MODULE_VERSION`. This is usually the same as `EPICS_MODULE_NAME`. 

* `E3_MODULE_SRC_PATH`: Where your source code is downloaded. Note that the location and usage depends on which mode you use (deployment, development, or local).

* `E3_MODULE_VERSION`: Module version used for `require E3_MODULE_NAME, E3_MODULE_VERSION`.

* `E3_MODULE_MAKEFILE`: Name of the module/application makefile. 

* `E3_MODULES_PATH`: Parent path of the installation location. This can be `E3_SITEMODS_PATH` or `E3_SITEAPPS_PATH`. 

* `E3_MODULES_LIBNAME`: Name of shared libraries.

* `E3_MODULES_INSTALL_LOCATION`: Parent path to installation directoriess.

* `E3_MODULES_INSTALL_LOCATION_BIN`: Binary installation path. 

* `E3_MODULES_INSTALL_LOCATION_DB`: Database installation path. 

* `E3_MODULES_INSTALL_LOCATION_INC`: Include installation path.

* `E3_MODULES_INSTALL_LOCATION_LIB`: Library installation path.

### e3 module/application auxilliary environment variables

The following variables are defined within a module or application by default.

> These are only used when necessitated by an applicaton.

* `E3_MODULES_LIBLINKNAME`: Symbolic link name to library files for a module. 

* `E3_MODULES_INSTALL_LOCATION_BIN_LINK`: Symbolic link name of the module binary path located in `E3_SITELIBS_PATH`, in the following form: `${E3_MODULE_NAME}_${E3_MODULE_VERSION}_bin`. 

* `E3_MODULES_INSTALL_LOCATION_DB_LINK`: Symbolic link name of the module database path located in `E3_SITELIBS_PATH`, in the following form: `${E3_MODULE_NAME}_${E3_MODULE_VERSION}_db`. 

* `E3_MODULES_INSTALL_LOCATION_INC_LINK`: Symbolic link name of the module include path located in `E3_SITELIBS_PATH`, in the following form: `${E3_MODULE_NAME}_${E3_MODULE_VERSION}_include`.

* `E3_MODULES_INSTALL_LOCATION_LIB_LINK`: Symbolic link name of the module library path located in `E3_SITELIBS_PATH`, in the following form: `${E3_MODULE_NAME}_${E3_MODULE_VERSION}_lib`. 

* `E3_MODULES_INSTALL_LOCATION_DBD_LINK`: Symbolic link name of the module database definition file located in `E3_SITELIBS_PATH`, in the following form: `${E3_MODULE_NAME}_dbd_${E3_MODULE_VERSION}`. 

* `E3_MODULES_VENDOR_LIBS_LOCATION`: Vendor or 3rd party library path located in `E3_SITELIBS_PATH`, in the following form: `vendor/E3_MODULE_NAME/E3_MODULE_VERSION`. 

* `PROD_BIN_PATH`: Short binary path to be used if users want to access module-specific executable commands. 

* `E3_MODULE_MAKE_CMDS`: Command to execute to build/install. 

* `EXPORT_VARS`: Collection of exported environment variables within e3's building system which are used by makefiles.

---

##  Assignments

* Access DB files of a module within a running IOC

  Using the startup script in `ch6_supplementary_paht/ch6.cmd`, print out all database files of the *asyn* module within an IOC, using commands.

  > If you get stuck, remember that there's a command to use any UNIX command from within an IOC shell. Can you remember what it is?

* Vendor libraries

  Which module is used for a specific vendor library? Why do we keep these files within the e3 structure? 

* `Makefile` rules

  Can you find out which file it is that allow us to run `make vars` or `make env` within the e3 building system? It is the same for all modules and applications, so where could be located?


---

[Next: Chapter 7 - Understanding module dependence](chapter07.md)

[Return to Table of Contents](README.md)
