MD's epics-doc example
===

This folder contains the Michael's example at https://github.com/mdavidsaver/epics-doc

## Notice

I think it is very simple, and powerful example when we start it with E3. I modified commands in order to use E3 instead of the generic EPICS environment. In this example, we can start an IOC quietly quickly. Enjoy it!


## sum.db
```
iocsh.bash sum.db "INST=calc"
```

## sum.cmd
```
iocsh.bash sum.cmd
```

## sum-alarm.db
```
iocsh.bash sum-alarm.db "INST=calc"
```

## PV Access from a Shell by default (EPICS 7)

```
md_epics-doc (master)$ caget calc:a calc:b calc:sum
calc:a                         0
calc:b                         0
calc:sum                       0

md_epics-doc (master)$  caput calc:a 2
Old : calc:a                         0
New : calc:a                         2

md_epics-doc (master)$ caget calc:a calc:b calc:sum
calc:a                         2
calc:b                         0
calc:sum                       2

 md_epics-doc (master)$ caput calc:b 3
Old : calc:b                         0
New : calc:b                         3


md_epics-doc (master)$ caget calc:a calc:b calc:sum
calc:a                         2
calc:b                         3
calc:sum                       5
```

```
pvlist
pvget calc:a
pvget -r "" calc:a
```


In order to use QSRV (V4 Modules) in iocsh.bash with EPICS 3.15.x, please use the following:

```
iocsh.bash sumV4.cmd
```

```
pvasr 
VERSION : pvAccess Server v6.0.0
PROVIDER_NAMES : QSRV, 
BEACON_ADDR_LIST : 
AUTO_BEACON_ADDR_LIST : 1
BEACON_PERIOD : 15
BROADCAST_PORT : 5076
SERVER_PORT : 5075
RCV_BUFFER_SIZE : 16384
IGNORE_ADDR_LIST: 
INTF_ADDR_LIST : 0.0.0.0
```
