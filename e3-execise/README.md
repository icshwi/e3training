Very Simple E3 Training Execise
==

## Requirements

* E3 


## Simulator

This is the simple simulator which simulates the simple serial device through telnet. The original device and its EPICS IOC can be found at https://github.com/jeonghanlee/gconpi

Please open a new termianl, and run the following command.

```
e3-execise (master)$ ./simulator.sh 
```


## E3 IOC 

* Set your E3 envrionment in the new termial

```
source /epics/base-3.15.5/require/3.0.0/bin/setE3Env.bash 
```
One can add it in ones' .bashrc or others


* Check whether caget or iocsh.bash exist

```
e3-execise (master)$ caget
No pv name specified. ('caget -h' for help.)

```

* Run startup scripts, in cmds directory


### Example 0

Use Require and one module name

```
 e3-execise (master)$ iocsh.bash cmds/0.cmd
```

### Example 1

User Require and one module name with the specific version number

```
e3-execise (master)$ iocsh.bash cmds/1.cmd
```

### Example 2

Use iocInit

```
e3-execise (master)$ iocsh.bash cmds/2.cmd
```


### Example 3

```
e3-execise (master)$ iocsh.bash cmds/3.cmd "TOP=."
```

### Example 4

We add the iocStats into 3.cmd

```
e3-execise (master)$ iocsh.bash cmds/4.cmd "TOP=."
```


### Example 5

We add the autosave into 4.cmd

```
e3-execise (master)$ iocsh.bash cmds/5.cmd "TOP=."
```

### Notice
* Simulator will be ended when we close the iocsh.bash from time to time. In that case, the simulator should be restarted before IOC will be started. 
