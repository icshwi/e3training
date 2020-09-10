# Chapter 2: Your first running e3 IOC

[Return to Table of Contents](README.md)

## Lesson overview

In this lesson, you'll learn how to do the following:

* Load e3 using utility scripts.
* Switch between different versions of e3.
* Run a simple IOC with an example startup script.

---

## The e3 environment

In order to facilitate the development process, e3 supports using multiple EPICS environments. In other words, you can set the environment for a specific terminal by sourcing the relevant `setE3Env.bash`.

> Using a default configuration (presently base 3.15.5 with require 3.0.5 installed at `/epics`) the full path for this script would then be `/epics/base-3.15.5/require/3.0.5/bin/setE3Env.bash`.

For your convenience, the e3 building system - at the end of installation procedure of require and modules - creates a utility script within the `tools/` directory called `setenv`:

```console
[iocuser@host:e3]$ source tools/setenv
```

*N.B.! If such a file already exists, the old file will be renamed to `setenv_YYMMDDHHMM`.*

Thus, one can easily switch between environments. For example:

```console
[iocuser@host:~]$ cd e3-7.0.3.1
[iocuser@host:e3-7.0.3.1]$ source tools/setenv
```

## Run an example IOC

0. Go to **E3_TOP**
1. Run:

   ```console
   [iocuser@host:e3-3.15.5]$ iocsh.bash cmds/iocStats.cmd 
   ```

2. Check the IOC name:

   ```console
   localhost-31462> echo ${IOCNAME}
   ```

   (Which should output IOC-9999.)

3. Open another terminal and source the same e3 configuration.

   ```console
   [iocuser@host:e3-3.15.5]$ source tools/setenv
   ```

4. Print all of the PVs to a file and skim through it:

   ```console
   [iocuser@host:e3-3.15.5]$ bash caget_pvs.bash -l IOC-9999_PVs.list
   ```

5. Check the heartbeat of your IOC.

   ```console
   [iocuser@host:e3-3.15.5]$ camonitor ${IOCNAME}-IocStats:HEARTBEAT
   ```

## Play around with the example IOC

* Have a look at the contents of `cmds/iocStats.cmd` and make sure you understand all of it:

  ```bash
  require iocStats,ae5d083

  epicsEnvSet("TOP", "$(E3_CMD_TOP)")

  system "bash $(TOP)/random.bash"

  iocshLoad "$(TOP)/random.cmd"

  epicsEnvSet("P", "IOC-$(NUM)")
  epicsEnvSet("IOCNAME", "$(P)")

  iocshLoad("$(iocStats_DIR)/iocStats.iocsh", "IOCNAME=$(IOCNAME)")

  iocInit()

  dbl > "$(TOP)/../${IOCNAME}_PVs.list"
  ```

* Try the following commands in the IOC shell:

  - `help`
  - `var`
  - `dbl`
  - `dbsr`
  - `echo ${IOCNAME}`
  - `epicsEnvShow`

---

## Assignments

Please explain the following jargon to yourself:

* `require`
* `E3_CMD_TOP`
* `system`
* `iocshLoad`
* `iocInit`
* `>`
* `<` 


---

[Next: Chapter 3 - Installing other versions of modules](chapter03.md)

[Return to Table of Contents](README.md)
