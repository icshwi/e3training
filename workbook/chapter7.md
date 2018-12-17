Chapter 7 : Understand A Module Dependence
==

## Lesson Overview

In this lesson, you'll learn how to do the following:
* Understand which e3 enviornment variables should be defined.
* Understand the building dependency when a module is built. 
* Change its dependency version when the module is needed to recompile.
* Decide whether to keep old version or to keep new version of the module.


## Dependent Environment Variables


* Find variables `*_DEP_VERSION`

Please go **E3_TOP**/e3-StreamDevice and run the following:

```
$ make vars
```

And try to find `*_DEP_VERSION` in its output. They are defined in `configure/CONFIG_MODULE` and `StreamDevice.Makefile`. 

```
$ more configure/CONFIG_MODULE | grep "DEP"
ASYN_DEP_VERSION:=4.33.0
PCRE_DEP_VERSION:=8.41.0

$ more StreamDevice.Makefile | grep "DEP_VERSION"
ifneq ($(strip $(ASYN_DEP_VERSION)),)
asyn_VERSION=$(ASYN_DEP_VERSION)
ifneq ($(strip $(PCRE_DEP_VERSION)),)
pcre_VERSION=$(PCRE_DEP_VERSION)
```

Now one can see these variables, but where they are used is in the compiling process `make build`, and try to find the following line:

```
/usr/bin/gcc  -D_GNU_SOURCE -D_DEFAULT_SOURCE         -DUSE_TYPED_RSET               -DUSE_TYPED_RSET   -D_X86_64_  -DUNIX  -Dlinux                 -MD   -O3 -g   -Wall                    -mtune=generic     -m64 -fPIC                -I. -I../src/ -I.././src/    -I/epics/base-3.15.5/require/3.0.4/siteMods/asyn/4.33.0/include                        -I/epics/base-3.15.5/require/3.0.4/siteMods/pcre/8.41.0/include         -I/epics/base-3.15.5/include  -I/epics/base-3.15.5/include/compiler/gcc -I/epics/base-3.15.5/include/os/Linux                                    -c .././src/StreamVersion.c
/usr/bin/g++  -D_GNU_SOURCE -D_DEFAULT_SOURCE         -DUSE_TYPED_RSET               -DUSE_TYPED_RSET   -D_X86_64_  -DUNIX  -Dlinux                 -MD   -O3 -g   -Wall                    -mtune=generic                   -m64 -fPIC               -I. -I../src/ -I.././src/    -I/epics/base-3.15.5/require/3.0.4/siteMods/asyn/4.33.0/include                        -I/epics/base-3.15.5/require/3.0.4/siteMods/pcre/8.41.0/include         -I/epics/base-3.15.5/include  -I/epics/base-3.15.5/include/compiler/gcc -I/epics/base-3.15.5/include/os/Linux                                    -c ../src/AsynDriverInterface.cc
/usr/bin/g++  -D_GNU_SOURCE -D_DEFAULT_SOURCE         -DUSE_TYPED_RSET               -DUSE_TYPED_RSET   -D_X86_64_  -DUNIX  -Dlinux                 -MD   -O3 -g   -Wall                    -mtune=generic                   -m64 -fPIC               -I. -I../src/ -I.././src/    -I/epics/base-3.15.5/require/3.0.4/siteMods/asyn/4.33.0/include                        -I/epics/base-3.15.5/require/3.0.4/siteMods/pcre/8.41.0/include         -I/epics/base-3.15.5/include  -I/epics/base-3.15.5/include/compiler/gcc -I/epics/base-3.15.5/include/os/Linux                                    -c ../src/RegexpConverter.cc
........................
........................

```

One should check the following information 

```
-I/epics/base-3.15.5/require/3.0.4/siteMods/asyn/4.33.0/include
-I/epics/base-3.15.5/require/3.0.4/siteMods/pcre/8.41.0/include
```


* Change a variable to set `NULL`

```
$ echo "ASYN_DEP_VERSION:=" > configure/CONFIG_MODULE.local
```

* Rebuild it

```
$ make rebuild
```


Can you compile this? No you cannot compile them, because of the following error:
```
......
Expanding stream.dbd
/epics/base-3.15.5/require/3.0.4/tools/expandDBD.tcl -3.15 -I ./ -I /epics/base-3.15.5/dbd streamSup.dbd > stream.dbd
/usr/bin/g++  -D_GNU_SOURCE -D_DEFAULT_SOURCE         -DUSE_TYPED_RSET               -DUSE_TYPED_RSET   -D_X86_64_  -DUNIX  -Dlinux                 -MD   -O3 -g   -Wall                    -mtune=generic                   -m64 -fPIC               -I. -I../src/ -I.././src/                            -I/epics/base-3.15.5/require/3.0.4/siteMods/pcre/8.41.0/include         -I/epics/base-3.15.5/include  -I/epics/base-3.15.5/include/compiler/gcc -I/epics/base-3.15.5/include/os/Linux                                    -c ../src/AsynDriverInterface.cc
../src/AsynDriverInterface.cc:38:24: fatal error: asynDriver.h: No such file or directory
 #include <asynDriver.h>
                        ^
compilation terminated.
```

Can you see `-I/epics/base-3.15.5/require/3.0.4/siteMods/asyn/4.33.0/include`? At this point, the building system cannot find where `asynDriver.h` is.  That header file is usded in `src/AsynDriverInterface.cc`. 


* Roll back to the asyn version, and set `NULL` in `PCRE_DEP_VERSION` by overwriting `CONFIG_MODULE.local`.

```
$ echo "PCRE_DEP_VERSION:=" > configure/CONFIG_MODULE.local
```

* Check these variables through

```
$ make vars |grep "DEP_VERSION ="
ASYN_DEP_VERSION = 4.33.0
PCRE_DEP_VERSION = 
```



```
 
 src/RegexpConverter.cc
```
 
 
 
------------------
[:arrow_backward:](chapter6.md)  | [:arrow_up_small:](chapter7.md)  | [:arrow_forward:](chapter8.md)
:--- | --- |---: 
[Chapter 6 : Variables, Parameters and Environment Variables within e3](chapter6.md) | [Chapter 7](chapter7.md) | [Chapter 8](chapter8.md)
