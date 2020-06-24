# Chapter 3: Installing a module with a different version number

[Return to Table of Contents](README.md)

## Lesson overview

In this lesson, you'll learn how to do the following:
* Print out, and understand some of, the various EPICS and e3 variables
* Understand how different versions of the same module are mananaged in e3
* Understand the difference between two important variables: `E3_MODULE_VERSION` and `EPICS_MODULE_TAG`
* Install a different StreamDevice version within e3

## The variables within e3

Various environment variables are used in EPICS and e3, so it is important to be aware of these and their difference(s). Please remember that e3 is a configuration tool around EPICS, and that we thus we have some variables which are unique to e3.

0. Make sure you are in **E3_TOP***
1. Go to `e3-StreamDevice/`
2. Run the following rule:

   ```bash
   [iocuser@host:e3-StreamDevice]$ make vars
   ```

The variables of interest here are:
* `E3_MODULE_VERSION`: This is used as *Module/Application version* with require within an IOC startup script. We recommend using X.X.X[^1] versioning for production releases. 
* `EPICS_MODULE_TAG` This is the *snapshot* of the source code repository, e.g. `tags/stream_2_7_14`, `tags/2.8.8`, `master`, `branch_name`, or `e0a24fe`.

These two variables are defined in `configure/CONFIG_MODULE` and `configure/CONFIG_MODULE_DEV`.

**We will reiterate starting directory a few more times, but please pay attention to the current working directory in the command prompt: [(user)@(hostname):(**current-working-directory**)]$*

[^1] Where X.X.X stands for MAJOR.MINOR.PATCH

## List the installed version(s) of a module

0. Make sure you are in `e3-StreamDevice/`
1. Run the following rule:

   ```bash
   [iocuser@host:e3-StreamDevice]$ make existent
   ```

2. Look at the output.
   The result shows the existing version(s) of stream modules within e3:
   
   ```bash
   /epics/base-3.15.5/require/3.0.5/siteMods/stream
   └── 2.8.8
       ├── dbd
       ├── include
       ├── lib
       └── SetSerialPort.iocsh
   ```

The default is LEVEL 2---i.e. `make existent` is identical to `make LEVEL=2 existent`.

## Check the version of a module

0. Go to the subdirectory `StreamDevice/`
1. Run:

   ```bash
   [iocuser@host:StreamDevice]$ git describe --tags
   ```

   And you can also try:

   ```
   [iocuser@host:x]$ git show --oneline 
   ```

We could here download StreamDevice from PSI's GitHub account directly, and switch `EPICS_MODULE_TAG` when `make init` is executed. If so:

0. Go back to `e3-StreamDevice/`
1. Run `make init` to see what kind of messages which you can see.  
   Can you guess what kind of process will happen behind scenes?
2. Check `EPICS_MODULE_TAG` with `make vars`
3. Check the `configure/CONFIG_MODULE` file

Running `make init` will download all source files within StreamDevice as a git submodule, and will switch back to the `2.8.8`* version of StreamDevice.

**You may have different versions than the author of these instructions.*

## Change `EPICS_MODULE_TAG` and `E3_MODULE_VERSION`

* Use `master` instead of `tags/2.8.8`  
  Available tags and branches can be found on the PSI StreamDevice release page: https://github.com/paulscherrerinstitute/StreamDevice/releases  
  If you already have `master` as default, choose an arbitrary version and modify variables accordingly.

* Change `E3_MODULE_VERSION` to a different tag (e.g. `e3training`).  
  Standard here is to name the e3 module according to the module's version, but any name could be used during e.g. development.
  
* Your modified `configure/CONFIG_MODULE` may then look like:

  ```properties
  # --- snip snip ---
  EPICS_MODULE_TAG:=master
  E3_MODULE_VERSION:=e3training
  # --- snip snip ---
  ```

  Alternatively, you can create a local `CONFIG_MODULE` file, `CONFIG_MODULE.local`, like:

  ```bash
  [iocuser@host:e3-StreamDevice]$ echo "EPICS_MODULE_TAG:=master" > configure/CONFIG_MODULE.local
  [iocuser@host:e3-StreamDevice]$ echo "E3_MODULE_VERSION:=e3training" >> configure/CONFIG_MODULE.local
  ```

* Verify your configuration with `make vars`.

## Build and install StreamDevice `master` (b84655e)

0. Go to `e3-StreamDevice/`.

1. Run `make vars`
   Can you see the difference between before and now?
   
2. Run `make init`
   Can you see the difference between before and now?

3. Run `make build`

4. Run `make install`

5. Run `make existent`

6. Run `make dep`

7. Run `make vers`

8. Run `make dep | head -1`

## Assignments

* Try out `make existent` with `LEVEL=4`
* Try `iocsh.bash -r stream,e3training`
* Do `make init` in **E3_TOP**. What do you see?
* Which kind of make rule allows us to uninstall the installed module?
* Can we combine the following two steps? 
  1. `make build`
  2. `make install`


------------------
[:arrow_backward:](chapter2.md)  | [:arrow_up_small:](chapter3.md)  | [:arrow_forward:](chapter4.md)
:--- | --- |---: 
[Chapter 2: Your first running e3 IOC](chapter2.md) | [Chapter 3](chapter3.md) | [Chapter 4: Delve into e3 with startup scripts](chapter4.md)
