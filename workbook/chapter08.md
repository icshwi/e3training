# Chapter 8: Building an e3 application

[Return to Table of Contents](README.md)

## Lesson Overview

In this lesson, you'll learn how to do the following:

* Understand the difference between modules and applications.
* Understand the e3 wrapper directory structure.
* Create an e3 wrapper using the e3TemplateGenerator.
* Edit a module makefile in order to build and install it into e3.

---

## Modules, Applications, and IOCs

*Note that as there is no clear boundary between modules, applications, and IOCs in EPICS, usage of these terms tend to vary between facilities.*

Modules within e3 are essentially the core component that enables building of an application, and consist of source code for e.g. specific communication protocols. Modules will often be collected from the EPICS community (and sometimes modified), but are also developed in-house. Typically, modules and applications are both needed to build an IOC. Applications are, however, not strongly defined at ESS at this point in time, so language will be a bit mixed in this chapter. We will, however, often use the term EPICS application, by which we typically refer to both applications and modules.

> Applications are otherwise often modules with customized features, e.g. unique sequencer files, or database files for specific software.

### Modules 

Most e3 modules originate from the EPICS community, like [iocStats](https://github.com/epics-modules/iocStats), [mrfioc2](https://github.com/epics-modules/mrfioc2), [asyn](https://github.com/epics-modules/asyn), and [autosave](https://github.com/epics-modules/autosave). In e3, the installation location for modules is defined in `E3_SITEMODS_PATH`, as discussed earlier in [Chapter 6](chapter06.md). Corresponding symbolic links are created and defined in `E3_SITELIBS_PATH`.

> You should have a look at these aforementioned variables:
>
> ```console
> [iocuser@host:e3-3.15.5]$ source tools/setenv
> [iocuser@host:e3-3.15.5]$ echo ${E3_SITEMODS_PATH}
> [iocuser@host:e3-3.15.5]$ tree -L 2 ${E3_SITEMODS_PATH}
> [iocuser@host:e3-3.15.5]$ echo ${E3_SITELIBS_PATH}
> [iocuser@host:e3-3.15.5]$ tree -L 4 ${E3_SITELIBS_PATH}
> ```

So - as you've seen previously - e3's design is based on having *wrappers* as a common front-end for modules and applications. These wrappers essentially contain our site specific modifications to "standard" EPICS components; in part to support collaboration with the EPICS community while still suporting novel functionality.

### Applications

Although ESS "doesn't have applications", there is still built-in support into e3 for differentiation of modules and applications, available upon need. Praxis is to name e3 applications with the same notation as modules (*e3-applicationName*), and there is a `E3_SITEAPPS_PATH` available for possible future needs. Applications can then be loaded just as modules in the IOC shell (`require application,version`).

### IOCs

In e3, IOCs are primarily just startup scripts. You therefore don't need to use a utilities for this, but can just create a directory with a standardised structure (with some variation as per your requirements). This will commonly look like:

```console
[iocuser@host:iocs]$ tree e3-ioc-<iocname>
e3-ioc-<iocname>
├── iocsh
│   └── .keep
├── env
│   └── .keep
├── .gitignore
├── README.me
└── st.cmd

2 directories, 5 files
```

> If you have no need for `iocsh/` or `env/` you can of course skip these, just as you can add directories (e.g. `docs/` or `gui/`).

## How to build a module/application

> For convenience, we will henceforth refer to the e3 module or application as an e3 wrapper.

How you build your e3 wrapper will depend on how your application's (or module's) code is arranged. You can have the wrapper contain the application, you can source control the wrapper separately, and if there is an existing application already available in git (see e.g. [epics-modules](https://github.com/epics-modules)), you can simply point towards this. We will now go through how to create wrappers for these cases.

> The purpose of e3 wrappers is to have a standardised interface to modules and applications using the standard EPICS structure. Our wrapper is essentially a front-end for the module/application.

To create an e3 wrapper (`e3-moduleName`), we will use a utility called the *e3TemplateGenerator* (which is part of the [e3-tools](https://github.com/icshwi/e3-tools) repository). Clone e3-tools and inspect it (especially the README.md as always) before continuing.

### Module/application already on git

In `e3-tools/e3TemplateGenerator`, there is a `modules_conf/` directory. If we look at the file `genesysnGEN5kWPS.conf`, we will see:

```pythong
EPICS_MODULE_NAME:=genesysGEN5kWPS
EPICS_MODULE_URL:=https://github.com/icshwi
E3_TARGET_URL:=https://github.com/icshwi
E3_MODULE_SRC_PATH:=genesysGEN5kWPS
```

> You may here recognize the variables `EPICS_MODULE_NAME` and `E3_MODULE_SRC_PATH` from [Chapter 6](chapter06.md).

* `EPICS_MODULE_NAME`: The module name.

* `EPICS_MODULE_URL`: The git project where the module is hosted; the URI to the repository with the module name stripped.

* `E3_TARGET_URL`: The git project that the e3 wrapper should be hosted under.

* `E3_MODULE_SRC_PATH`: The name of the e3 wrapper.

Our config file above thus specifies that we (already) have a standard EPICS module at https://github.com/icshwi/genesysGEN5kWPS, and that we want to create a wrapper for this at https://github.com/icshwi/e3-genesysGEN5kWPS.

Let's now try to run the e3TemplateGenerator with this configuration.

* Run the following command (press `N` when asked if you want to push the local `e3-genesysGEN5kWPS` to the remote repository)):

  > To create the structure elsewhere than `$HOME`, replace `~` with your target destination of choice.

  ```console
  [iocuser@host:e3TemplateGenerator]$ ./e3TemplateGenerator.bash -m modules_conf/genesysGEN5kWPS.conf -d ~
  ```

* Look at the file structure of the new wrapper directory:

  ```console
  [iocuser@host:e3TemplateGenerator]$ tree -L 1 ~/e3-genesysGEN5kWPS
  .
  |-- cmds
  |-- configure
  |-- docs
  |-- genesysGEN5kWPS                     # ---> E3_MODULE_SRC_PATH
  |-- iocsh
  |-- opi
  |-- patch
  |-- template
  |-- genesysGEN5kWPS.Makefile            # ---> EPICS_MODULE_NAME.Makefile
  |-- Makefile
  `-- README.md
  ```

Ensure that you understand how the four environment variables mentioned earlier (in the configuration file) are used here.

Let's now build an e3 wrapper with a remote repository. The repository we will be using in this tutorial is https://github.com/icshwi/fimscb.

1. Open `fimscb.conf` and modify the `E3_TARGET_URL` to point towards your personal GitHub account.

2. Open GitHub in a browser and create a new repository called `e3-fimscb`.

3. Run e3TemplateGenerator using the `fimscb.conf` configuration file. This time, press `Y` at the first prompt to push all changes to `E3_TARGET_URL`/e3-`EPICS_MODULE_NAME`.

4. Inspect (and initialize) your new e3-wrapper:

   ```console
   [iocuser@host:e3TemplateGenerator]$ tree -L 1 ~/e3-fimscb
   ```

   > Of course modify the path if you chose a different target destination (`-d path/to/dir`).

   *N.B.! Before initializing, modify your `configure/RELEASE` and `configure/CONFIG_MODULE` as we've gone through in previous chapters.*

   ```console
   [iocuser@host:e3-fimscb]$ make init
   [iocuser@host:e3-fimscb]$ make vars
   ```

You should now have the e3 wrapper set up. Next is to modify the `*.Makefile` (in this case, `fimscb.Makefile`). The e3TemplateGenerator initiates the wrapper with a boilerplate makefile, that contains default values and commented out code segments (for your convenience). For now, set it up as follows:

```console
[iocuser@host:e3-fimscb]$ cat fimscb.Makefile
where_am_I := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
include $(E3_REQUIRE_TOOLS)/driver.makefile
include $(E3_REQUIRE_CONFIG)/DECOUPLE_FLAGS

APP:=fimscbApp
APPDB:=$(APP)/Db

TEMPLATES += $(APPDB)/fimscb.db
TEMPLATES += $(APPDB)/fimscb.proto

db:

.PHONY: db 

vlibs:

.PHONY: vlibs
```

After this, we will be able to build the wrapper:

```console
[iocuser@host:e3-fimscb]$ make build
[iocuser@host:e3-fimscb]$ make install
[iocuser@host:e3-fimscb]$ make existent LEVEL=3
/epics/base-3.15.5/require/3.0.4/siteApps/fimscb
└── master
    ├── db
    │   ├── fimscb.db
    │   └── fimscb.proto
    └── lib
        └── linux-x86_64

4 directories, 2 files
```

And to finish off, let's explore it in `iocsh.bash`:

> Don't forget to source your EPICS environment, or else launch `iocsh.bash` directly (`/path/to/epics/require/require-version/bin/iocsh.bash`).

```console
[iocuser@host:e3-fimscb] iocsh.bash
effbc10.kaffee.4837 > require fimscb,master
Module fimscb version master found in /epics/base-3.15.5/require/3.0.4/siteApps/fimscb/master/
Module fimscb has no library
effbc10.kaffee.4837 > require fimscb,master
Module fimscb version master already loaded
effbc10.kaffee.4837 > cd $(fimscb_DB)
effbc10.kaffee.4837 > system (ls)
effbc10.kaffee.4837 > pwd
```

> If working on a real module, don't forget proper version control here:
>
> ```console
> [iocuser@host:e3-fimscb]$ git commit -am "update makefile"
> [iocuser@host:e3-fimscb]$ git push
> ```

### Module/application with local source code

Let's assume that we have found an EPICS application that we would like to integrate into e3, where the source is an archive (e.g. `.tar.gz`) that we received from a collaborator or that we downloaded from a (non-git) internet source.

> We will be using an example from http://www-linac.kek.jp/cont/epics/second.

1. Create a new configuration file:

   ```console
   [iocuser@host:e3TemplateGenerator]$ cat modules_conf/Clock.conf
   EPICS_MODULE_NAME:=Clock
   E3_TARGET_URL:=https://github.com/jeonghanlee
   E3_MODULE_SRC_PATH:=Clock
   ```

   > Change `E3_TARGET_URL` to point to your own account.

2. Create a repository called *e3-Clock* on your GitHub (or GitLab or whatever else you prefer and use) account.

3. Run e3TemplateGenerator just as earlier:

   ```console
   [iocuser@host:e3TemplateGenerator]$ bash e3TemplateGenerator -m modules_conf/Clock.conf -d ~
   ```

4. Inspect your application:

   ```console
   [iocuser@host:e3TemplateGenerator]$ tree -L 1 ~/e3-Clock
   .
   |-- Clock-loc
   |-- cmds
   |-- configure
   |-- docs
   |-- iocsh
   |-- opi
   |-- patch
   |-- template
   |-- Clock.Makefile
   |-- Makefile
   `-- README.md
   ```

As you may notice, we now have a directory called `Clock-loc/` in the wrapper (which contains a standard EPICS structure with `ClockApp/`,  `ClockApp/Db/` and `ClockApp/src/`). In this directory, you can place your source code. For our example:

```console
[iocuser@host:e3TemplateGenerator] cd ~/e3-Clock/Clock-loc
[iocuser@host:Clock-loc]$ wget -c http://www-linac.kek.jp/cont/epics/second/second-devsup.tar.gz
[iocuser@host:Clock-loc]$ tar xvzf second-devsup.tar.gz
```

> This example application we are using contains a `Clock1App` instead of `ClockApp`. To make things easy, we can just delete `ClockApp` and leave `Clock1App`; `rm -rf ClockApp/`.

Modify configuration files as earlier. If you were to try to `make init` here, you would find that it does nothing:

```console
[iocuser@host:e3-Clock]$ make init
>> You are in the local source mode.
>> Nothing happens
```

> As we now have all of our source code locally, we can choose `E3_MODULE_VERSION` and `EPICS_MODULE_TAG` rather freely.

Now we will set up, build, and install our application.

1. Edit the makefile as follows:

   ```console
   [iocuser@host:e3-Clock]$ cat Clock.Makefile
   where_am_I := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
   include $(E3_REQUIRE_TOOLS)/driver.makefile
   include $(E3_REQUIRE_CONFIG)/DECOUPLE_FLAGS

   APP:=Clock1App
   APPDB:=$(APP)/Db
   APPSRC:=$(APP)/src

   USR_INCLUDES += -I$(where_am_I)$(APPSRC)

   TEMPLATES += $(wildcard $(APPDB)/*.db)
   SOURCES += $(APPSRC)/devAiSecond.c

   DBDS += $(APPSRC)/aiSecond.dbd

   db:

   .PHONY: db

   vlibs:

   .PHONY: vlibs
   ```

2. Build and install the app:

   ```console
   [iocuser@host:e3-Clock]$ make build
   [iocuser@host:e3-Clock]$ make install
   ```

3. Inspect with `iocsh.bash`:

   ```console
   effbc10.kaffee.10034 > require Clock,master
   Module Clock version master found in /epics/base-3.15.5/require/3.0.4/siteApps/Clock/master/
   Loading library /epics/base-3.15.5/require/3.0.4/siteApps/Clock/master/lib/linux-x86_64/libClock.so
   Loaded Clock version master
   Loading dbd file /epics/base-3.15.5/require/3.0.4/siteApps/Clock/master/dbd/Clock.dbd
   Calling function Clock_registerRecordDeviceDriver
   ```

### Module/application created in the standard way (using `makeBaseApp`)

> This is basically the same as with the local source code example above, so the steps will be shortened.

1. Create a configuration file:

   ```console
   [iocuser@host:e3TemplateGenerator]$ cat modules_conf/epicsExample.conf
   E3_TARGET_URL:=https://github.com/icshwi
   EPICS_MODULE_NAME:=epicsExample
   E3_MODULE_SRC_PATH:=epicsExample
   ```

2. Create repository in your target URL.

3. Run e3TemplateGenerator.

4. Create application:

   ```console
   [iocuser@host:epicsExample-loc]$ rm -rf epicsExampleApp/
   [iocuser@host:epicsExample-loc]$ makeBaseApp.pl -t ioc epicsExample
   [iocuser@host:epicsExample-loc]$ makeBaseApp.pl -i -p epicsExample -t ioc epicsExample
   ```

5. Copy your source, sequencer, etc. files to `epicsExampleApp/src/`, and your database (and protocol) files to `episcExampleApp/Db/`.

6. Modify `configure/RELEASE`, `configure/MODULE_RELEASE`, and `epicsExample.Makefile`.

7. Commit and push.

---

##  Assignments

* Write startup scripts for `e3-Clock` and for `e3-fimscb`.
* Build an e3 application with a remote repository:
  
  1. Can you build [e3-ch8](https://github.com/icswi/ch8) as an application?
  2. Try to create a startup script for it.

* Build [e3-myexample](https://github.com/icshwi/myexample) and an associated IOC. 
  
  > Note that this is a challenging task.


---

[Next: Chapter 9 - Building an e3 module](chapter09.md)

[Return to Table of Contents](README.md)
