# Chapter 3: Installing other versions of modules

[Return to Table of Contents](README.md)

## Lesson overview

In this lesson, you'll learn how to do the following:

* Print out, and understand some of, the various EPICS and e3 variables.
* Understand how different versions of the same module are mananaged in e3.
* Understand the difference between two important variables: `E3_MODULE_VERSION` and `EPICS_MODULE_TAG`.
* Install a different version of *StreamDevice* within e3.

---

## The version variables within e3

Various environment variables are used in EPICS and e3, and it is important to be aware of these and their difference(s). Please remember that e3 is a configuration tool around EPICS, and that we thus have some variables which are unique to e3.

0. Make sure you are in **E3_TOP**

> *We will reiterate starting directory a few last times, but please pay attention to the current working directory in the command prompt: [(user)@(hostname):(**current-working-directory**)]$ .*

1. Go to `e3-StreamDevice/`
2. Run the following rule:

   ```console
   [iocuser@host:e3-StreamDevice]$ make vars
   ```

The variables of interest here are:

* `E3_MODULE_VERSION`  is used as *Module/Application version* with require within an IOC startup script. We recommend using semantic versioning (also known as *semver*) for releases. 

* `EPICS_MODULE_TAG` is the *snapshot* of the source code repository, e.g. `tags/stream_2_7_14`, `tags/2.8.8`, `master`, `branch_name`, or `e0a24fe`.

These two variables are defined in `configure/CONFIG_MODULE` (and in `configure/CONFIG_MODULE_DEV`).

> Files with a `_DEV` suffix will be explained later when we go through the different modes of e3.

## List the installed version(s) of a module

0. Make sure you are in `e3-StreamDevice/`
1. Run the following rule:

   ```console
   [iocuser@host:e3-StreamDevice]$ make existent
   ```

2. Look at the output.
   The result show the installed version(s) of stream modules within e3:
   
   ```console
   /epics/base-3.15.5/require/3.0.5/siteMods/stream
   └── 2.8.8
       ├── dbd
       ├── include
       ├── lib
       └── SetSerialPort.iocsh
   ```

   > The default argument to `make existent` is LEVEL 2 - i.e. `make existent` is identical to `make LEVEL=2 existent`.

## Check the version of a module

Let's see what our current version of *StreamDevice* is:

```console
[iocuser@host:StreamDevice]$ git describe --tags
```

> Pay attention to the current working directory above!

We could here download *StreamDevice* directly from PSI's GitHub account, and switch `EPICS_MODULE_TAG` when `make init` is executed:

1. Go back to `e3-StreamDevice/`
2. Run `make init` to see what kind of output you get.

   Can you guess what kind of process that is happening behind scenes?

3. Check `EPICS_MODULE_TAG` with `make vars`
4. Have a look at the `configure/CONFIG_MODULE` file

> Running `make init` will download all source files within StreamDevice as a git submodule, and will in our case switch back to the `2.8.8` version of StreamDevice.
> 
> *N.B.! You may have different versions than the author of these instructions.*

## Change `EPICS_MODULE_TAG` and `E3_MODULE_VERSION`

* Use `master` instead of `tags/2.8.8`  

  > If you already have `master` as default, choose an arbitrary version and modify variables accordingly; available tags and branches can be found on the PSI StreamDevice release page: https://github.com/paulscherrerinstitute/StreamDevice/releases

* Change `E3_MODULE_VERSION` to a different tag (e.g. `e3training`).  

  > The convention here is to name the e3 module according to the module's version, but any name could technically be used during development.
  
* Your modified `configure/CONFIG_MODULE` may then look like:

  ```python
  # --- snip snip ---

  EPICS_MODULE_TAG:=master
  E3_MODULE_VERSION:=e3training
  
  # --- snip snip ---
  ```

  > You could instead create a local `CONFIG_MODULE` file, `CONFIG_MODULE.local`, like:

  > ```bash
  > [iocuser@host:e3-StreamDevice]$ echo "EPICS_MODULE_TAG:=master" > configure/CONFIG_MODULE.local
  > [iocuser@host:e3-StreamDevice]$ echo "E3_MODULE_VERSION:=e3training" >> configure/CONFIG_MODULE.local
  > ```

* Verify your configuration with `make vars`.

## Build and install *StreamDevice* `b84655e`

Time to try out some makefile rules. See if you can spot the difference between before now. From `e3-StreamDevice/`, run:

1. `make vars`
2. `make init`
3. `make build`
4. `make install`
5. `make existent`
6. `make dep`
7. `make vers`
8. `make dep | head -1`

---

## Assignments

* Try out `make existent` with `LEVEL=4`.
* Try `iocsh.bash -r stream,e3training`. Can you explain what is happening here?
* Do `make init` in **E3_TOP**. What do you see?
* Which kind of make rule allows us to uninstall the installed module?
* Can we combine the following two steps? 
  
  1. `make build`
  2. `make install`


---

[Next: Chapter 4 - Delve into e3 with startup scripts](chapter04.md)

[Previous chapter](chapter02.md)
[Return to Table of Contents](README.md)
