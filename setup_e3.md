This script, e3.bash, is not the proper tool to deploy the E3 properly, but it is the system which I can design, develop, and debug E3 in many different scenarios. 


## Install base 

```
$ ./e3.bash base
```

## Install require
```
$ ./e3.base req
```


## Install common modulese3 

```
$ ./e3.bash -c env

>> Vertical display for the selected modules :

    0 : e3-iocStats
    1 : e3-autosave
    2 : e3-asyn
    3 : e3-busy
    4 : e3-modbus
    5 : e3-ipmiComm
    6 : e3-sequencer
    7 : e3-sscan
    8 : e3-std
    9 : e3-ip
   10 : e3-calc
   11 : e3-pcre
   12 : e3-StreamDevice
   13 : e3-s7plc
   14 : e3-recsync

$ ./e3.bash -c mod

$ ./e3.bash -c load

```