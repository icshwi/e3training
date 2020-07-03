# Chapter 5: Deployment mode and Development mode

[Return to Table of Contents](README.md)

## Lesson Overview

In this lesson, you'll learn how to do the following:

* Understand why e3 doesn't hold any source code
* Understand the anatomy of an e3 module's directory
* Understand the Deployment mode
* Understand the Development mode
* Understand two repositories within e3 
* Patch files in EPICS and e3

---

## No source code - configuration files!

By design, e3 modules and applications have no source code in their repositories, but only configuration files and utilities. These files allow us consistent building of environments from source code, modules, applications, kernel drivers, etc., that are hosted elsewhere.

Thus, e3 is not concerned with each change in a source code repository, but rather focuses on specific *snapshots* (a particular release version) needed for a certain implementation. For example, at a certain point in time we select stream version 2.7.14 as the stable release within e3. Later, we select stream version 2.8.8 because a subsystem requires it. At this moment, we don't really care about versions 2.8.0, 2.8.1, 2.8.2, 2.8.3, 2.8.4, 2.8.5, 2.8.6, and 2.8.7. We don't need to sync their changes into a master branch of a local repository, which we would have to clone or fork. Simply put, we don't need to do any maintenance job. The concept is to add dependencies only when we need them.

> We will describe how to release a specific version of an e3 module in [Chapter 11](chapter11.md). <!-- is this really correct? -->

The intention is to reduce unecessary work for maintainers of the code base.

> An e3 module **can**, however, hold source code. This is known as *local mode*, and will be discussed more in-depth later.

## Directory anatomy

Let's have a look at `e3-iocStats/`:

```console
[iocuser@host:e3-iocStats]$ tree -L 1
.
├──  cmds
├──  configure
├──  docs
├──  iocsh
├──  iocStats
├──  iocStats.Makefile
├──  Makefile
├──  patch
└──  README.md
```

Although different e3 modules can have slightly different directory structure, but the majority of them have the following directories:

* `cmds/` Customized startup scripts.

* `configure/` Configuration files (for e3).

* `docs/` For documentation, log files, and similar material.

* `iocsh/` Modularized startup scripts should be located here. These will be added to the e3 installation path.

* `iocStats/` A git submodule link to iocStats source repository.

* `iocStats.Makefile` The (e3) makefile for iocStats.

* `Makefile` The global e3 module makefile.

* `patch/` For when we need to handle small changes of source codes. More on this later.

* `template/` For template and substitution files.

### Git submodule

> For a primer on submodules, see [here](https://git-scm.com/book/en/v2/Git-Tools-Submodules).

In order to explain how e3 uses git submodules, we will do the following exercise.

1. Run:

   ```console
   [iocuser@host:e3-iocStats]$ git submodule status
   ```

   You should be seeing something like `ae5d08388ca3d6c48ec0e37787c865c5db18dc8f iocStats (3.1.15-17-gae5d083)`.

> Please spend some time to understand this output. Git's pages on [submodules](https://git-scm.com/docs/git-submodule) should be useful.

2. Look at the repository on GitHub.

   Visit https://github.com/icshwi/e3-iocStats, which is shown in **Figure 1**.

   The magic number is **ae5d083**---can you see what it refers to? After finding it, verify this number in the output of `git submodule status`. 

   |![Import Example](ch5_supplementary_path/fig1.png)|
   | :---: |
   |**Figure 1 -** A screenshot from iocStats' GitHub page. |

3. Check its submodule configuration:

   ```console
   [iocuser@host:e3-iocStats]$ more .gitmodules
   [submodule "iocStats"]
           path = iocStats
           url = https://github.com/epics-modules/iocStats
           ignore = dirty
   ```

## Deployment mode

As you just saw, `git submodule` imports one repository into another, which will allow us to handle source files scattered between different facilities. To make full use of this functionality however, we would need full permission for all repositories. Thus, e3 will use its minimal feature, which relates to the so-called *magic number*---the short version of the SHA-1 checksum used by git to track commits [4]. 

So, we use a specific commit version of iocStats within e3-iocStats. And if new versions are stable enough, we can use `git submodule update --init` to update the link within an e3 module. We can thus pick which specific version of a module we would like to use for our release. 

However, when source code repositories are changed very often, it also create additional maintenance work where one has to update the SHA-1 checksum in order to match a selected version of a module. Thus, with `make init`, we download the latest version of a module, or switch to a specific version (defined in `configure/CONFIG_MODULE` or in the corresponding `.local` file).. <!-- rewrite this -->

The following commands utilize `git submodule` and are used for the deployment mode of a module. <!-- rewrite this -->

```
$ make vars
$ make init
$ make patch
$ make build
$ make install
$ make existent
$ make clean
```

## Development mode

The development mode is primarily intended to deal with cases where source code is hosted on repositories one lacks proper permissions to manipulate.

Inside of `configure/`, you will find two files with the suffix `_DEV`. `CONFIG_MODULE_DEV` and `RELEASE_DEV` are the counterparts of `CONFIG_MODULE` and `RELEASE` used in the deployment mode. These counterpart files are nearly identical, except for:

* `E3_MODULE_DEV_GITURL`: The remote path to the repository which one would like to download into an e3 module.

* `E3_MODULE_SRC_PATH`: The local path used for the deployment mode, which with default settings is the module's name with the added suffix `-dev`; for example, `e3-iocStats` has `iocStats` source path in the deployment, and `iocStats-dev` one in the development mode. Note that since `-dev` will be added, you can use the same module name as in development mode.

Using development mode thus allows us to develop a module without having to worry about other systems which may be making use of the same module.

---

The following commands are the development mode equivalents of the commands listed above. There is one extra command `make devdistclean` which will remove the cloned source directory (e.g. `iocStats-dev`). 

> `make existent` and `make devexistent` are identical as they relie on **installed** module versions. 

```
$ make devvars
$ make devinit
$ make devpatch
$ make devbuild
$ make devinstall
$ make devexistent
$ make devclean
$ make devdistclean
```

### Git clone

1. Fork your own copy from the community [iocStats](https://github.com/epics-modules/iocStats)

2. Update the `E3_MODULE_DEV_GITURL` to point towards your fork.

3. Run `make devvars`. This will show the e3 module variables with the development mode:

   This example uses the icshwi fork and compares it against the community module. Your output will be different.

   ```console
   [iocuser@host:e3-iocStats]$ make devvars

   ------------------------------------------------------------
   >>>>     Current EPICS and E3 Environment Variables     <<<<
   ------------------------------------------------------------

   E3_MODULES_INSTALL_LOCATION = /epics/base-3.15.5/require/3.0.4/siteMods/iocStats/jhlee
   E3_MODULES_INSTALL_LOCATION_BIN = /epics/base-3.15.5/require/3.0.4/siteMods/iocStats/jhlee/bin
   E3_MODULES_INSTALL_LOCATION_BIN_LINK = /epics/base-3.15.5/require/3.0.4/siteLibs/iocStats_jhlee_bin
   E3_MODULES_INSTALL_LOCATION_DB = /epics/base-3.15.5/require/3.0.4/siteMods/iocStats/jhlee/db
   E3_MODULES_INSTALL_LOCATION_DBD_LINK = /epics/base-3.15.5/require/3.0.4/siteLibs/iocStats.dbd.jhlee
   E3_MODULES_INSTALL_LOCATION_DB_LINK = /epics/base-3.15.5/require/3.0.4/siteLibs/iocStats_jhlee_db
   E3_MODULES_INSTALL_LOCATION_INC = /epics/base-3.15.5/require/3.0.4/siteMods/iocStats/jhlee/include
   E3_MODULES_INSTALL_LOCATION_INC_LINK = /epics/base-3.15.5/require/3.0.4/siteLibs/iocStats_jhlee_include
   E3_MODULES_INSTALL_LOCATION_LIB = /epics/base-3.15.5/require/3.0.4/siteMods/iocStats/jhlee/lib
   E3_MODULES_INSTALL_LOCATION_LIB_LINK = /epics/base-3.15.5/require/3.0.4/siteLibs/iocStats_jhlee_lib
   E3_MODULES_LIBLINKNAME = libiocStats.so.jhlee
   E3_MODULES_LIBNAME = libiocStats.so
   E3_MODULES_PATH = /epics/base-3.15.5/require/3.0.4/siteMods
   E3_MODULES_VENDOR_LIBS_LOCATION = /epics/base-3.15.5/require/3.0.4/siteLibs/vendor/iocStats/jhlee
   E3_MODULE_DEV_GITURL = "https://github.com/icshwi/iocStats"
   E3_MODULE_MAKEFILE = iocStats.Makefile
   E3_MODULE_MAKE_CMDS = make -C iocStats-dev -f iocStats.Makefile LIBVERSION="jhlee" PROJECT="iocStats" EPICS_MODULES="/epics/base-3.15.5/require/3.0.4/siteMods" EPICS_LOCATION="/epics/base-3.15.5" BUILDCLASSES="Linux" E3_SITEMODS_PATH="/epics/base-3.15.5/require/3.0.4/siteMods" E3_SITEAPPS_PATH="/epics/base-3.15.5/require/3.0.4/siteApps" E3_SITELIBS_PATH="/epics/base-3.15.5/require/3.0.4/siteLibs"
   E3_MODULE_NAME = iocStats
   E3_MODULE_SRC_PATH = iocStats-dev
   E3_MODULE_VERSION = jhlee
   E3_REQUIRE_CONFIG = /epics/base-3.15.5/require/3.0.4/configure
   E3_REQUIRE_TOOLS = /epics/base-3.15.5/require/3.0.4/tools
   EPICS_MODULE_NAME = iocStats
   EPICS_MODULE_TAG = master
   EXPORT_VARS = E3_MODULES_VENDOR_LIBS_LOCATION E3_MODULES_INSTALL_LOCATION_LIB_LINK EPICS_HOST_ARCH EPICS_BASE MSI E3_MODULE_VERSION E3_SITEMODS_PATH E3_SITEAPPS_PATH E3_SITELIBS_PATH E3_REQUIRE_MAKEFILE_INPUT_OPTIONS E3_REQUIRE_NAME E3_REQUIRE_DB E3_REQUIRE_CONFIG E3_REQUIRE_LOCATION E3_REQUIRE_DBD E3_REQUIRE_VERSION E3_REQUIRE_TOOLS E3_REQUIRE_INC E3_REQUIRE_LIB E3_REQUIRE_BIN QUIET   SUDO2 SUDO_INFO SUDOBASH SUDO
   INIT_E3_MODULE_SRC = 1
   INSTALLED_EPICS_BASE_ARCHS = linux-ppc64e6500 linux-x86_64
   MSI = /epics/base-3.15.5/bin/linux-x86_64/msi
   PROD_BIN_PATH = /epics/base-3.15.5/require/3.0.4/siteLibs/iocStats_jhlee_bin/linux-x86_64
   REQUIRE_CONFIG = /epics/base-3.15.5/require/3.0.4/configure
   ```

4. Run `make devinit`. This will clone your fork into a directory with the name of `iocStats-dev`. This is what the file tree will look like after:

   ```console
   [iocuser@host:e3-iocStats]$ tree -L 1
   .
   ├── cmds
   ├── configure
   ├── docs
   ├── iocsh
   ├── iocStats
   ├── iocStats-dev
   ├── iocStats.Makefile
   ├── Makefile
   ├── patch
   └── README.md
   ```

5. Execute `git status`. Can you see the difference? 

6. Have a look at both of the iocStats directories to see where they're pointing.

   ```console
   [iocuser@host:iocStats]$ git remote -v
   ```

   ```console
   [iocuser@host:iocStats-dev]$ git remote -v 
   ```

   > By default, the `*-dev` path within an e3-module is ignored (which you can see in the `.gitignore`). With this workflow, we can expand our repository up to any number of use cases.

### Consistent build environment

Remember that e3 strives to provide user with a consistent interface for downloading, configuring, building, and installing modules and applications. Thus, the difference between the deployment mode and the development mode is only valid while configuring a module. We build and install modules in the exact same way. During building, we use the same `module.Makefile` and the same variables that we have defined in configuration files, and while installing, we install a module based on the variables defined in the same configuration files.

## Patch files

> If you are not have not been introduced to patch files, it is advised to have a look at [this](https://en.wikipedia.org/wiki/Patch_(Unix)) wikipedia page. In short, differences between two versions of a file can be saved separate from the file and applied when necessary.

There are a number of patch files in EPICS; in EPICS base, in e3, as well as in modules. To deal with these, as well as to deal with the generic issue of straying away from a code base managed by others, we have some utilities to work with patches in e3. Let's have a look at some patch files, as well as what tools we have for what cases.

### Patch files in EPICS (e3) base

```console
$ find e3-base/* -name *.patch | grep 3.15.5
e3-base/patch/R3.15.5/fix-ipAddrToAscii_p0.patch
e3-base/patch/R3.15.5/fix-1699445_p0.patch
e3-base/patch/R3.15.5/fix-1678494_p0.patch
e3-base/patch/R3.15.5/osiSockOptMcastLoop_p0.patch
e3-base/patch/R3.15.5/dbCa-warning_p0.patch
e3-base/patch/Site/R3.15.5/enable_new_dtags.p0.patch
e3-base/patch/Site/R3.15.5/ppc64e6500_epics_host_arch.p0.patch
e3-base/patch/Site/R3.15.5/os_class.p0.patch
# --- snip snip ---
```

Files in `e3-base/patch/R3.15.5` are EPICS community patch files, those in `e3-base/patch/Site/R3.15.5` are for ESS site-specific patches.

*N.B.! While the EPICS community use `p0` files for base 3.15.5, and `p1` files for base 3.16.x, e3 only supports use of `p0` files for compatability reasons.*

#### Patch functions for EPICS base

There are four functions defined in `configure/E3/DEFINES_FT` for e3-base: 

* `patch_base`
* `patch_revert_base`
* `patch_site`
* `patch_revert_site`

### Patch files in e3 modules

```console
[iocuser@host:e3]$ find . -name *.p0.patch | grep -v base | sort -n
./e3-ADAndor3/patch/Site/2.2.0-include-stdlin.h.p0.patch
./e3-ADSupport/patch/Site/1.4.0-tiff_extern_rename.p0.patch
./e3-calc/patch/Site/3.7.1-cc_linking_release_local.p0.patch
./e3-modbus/patch/Site/2.11.0p-enable-ft-code16-in-writeUInt32d.p0.patch
./e3-NDDriverStdArrays/patch/Site/1.2.0-inflating-template.p0.patch
./e3-nds3/patch/Site/3.0.0-wrong_override_operator_not_error_either.p0.patch
./e3-nds/patch/Site/2.3.3-suppress-destructor-msg.p0.patch
./e3-require/patch/Site/3.0.4-tclsh-path-for-readOnlyFS.p0.patch
./e3-s7plc/patch/Site/1.4.0p-fixed-unsigned-int-array-types.p0.patch
./e3-s7plc/patch/Site/a713a78-epics7-support.p0.patch
./e3-StreamDevice/patch/Site/2.7.14p-add_only_communication_debug.p0.patch
./e3-StreamDevice/patch/Site/2.7.14p-extend_char_length_to_256.p0.patch
./e3-StreamDevice/patch/Site/2.7.14p-fix_new_delete_mismatch.p0.patch
./e3-tsclib/patch/Site/2.3.1-include-headers-driver-makefile.p0.patch
```

As you can see, every patch file begins with `E3_MODULE_VERSION`, followed by a description of the change, and ending with a level.

The purpose of these e3-module patch files is essentially to minimize maintenance work whenever we switch to a new module version. Two good examples would be `e3-mrfioc2` and `e3-StreamDevice`, where there is plenty of community usage. (`p#`)

> A rule of thumb is to fork and attempt to merge into the community version wherever feasible, and to patch if the changes are very specific to us or if we are unsure if the community want these changes.

#### Patch functions for e3 modules

There are four functions defined in `e3-require/configure/modules/DEFINES_FT` which are used for all e3 modules. This file will be located in
`${EPICS_BASE}/require/${E3_REQUIRE_VERSION}/configure/modules` after the require module has been installed.

* `patch_site`
* `patch_revert_site`

> Although these function names are the same as the e3-base ones, but they are actually slightly different. Can you find out which parts are different from each other?

### How to apply and revert patches

You apply patches with `make patch`, and you revert them with `make patchrevert`.

If you see the following messages, your module already has all patch files applied:

```
Reversed (or previously applied) patch detected!  Assume -R? [n] 
```

### How to create a patch file

If you want to create a patch file for an e3 module, run `git diff --no-prefix > ../patch/Site/` from the root directory of the module, e.g.:

```console
[iocuser@host:e3-iocStats]$ git diff --no-prefix > ../patch/Site/2.7.14p-add_more_stats.p0.patch
```

---

## Assignments

* Can you override the default `E3_MODULE_DEV_GITURL` with your own forked repository without any `git status` changes in `e3-iocStats`? Try it.

   ```console
   [iocuser@host:e3-iocstats]$ git status
   On branch master
   Your branch is up-to-date with 'origin/master'.
   nothing to commit, working directory clean
   ```

* Do we need `make devdistclean`? Is there any other way to clean or remove a cloned repository `iocStats-dev`? 

* What's the difference between `make existent` and `make devexistent`?

* Can we overwrite the same version of a module from the Deployment mode with one from the Development mode?

* What is the difference between a `p0` patch and `p1` patch? Is it the same in EPICS as generally with UNIX patch files?

* We have an `1.0.0-awesome.p0.patch` file. How would we apply it to Development mode source files?


---

[Next: Chapter 6 - Variables and parameters within e3](chapter06.md)

[Return to Table of Contents](README.md)
