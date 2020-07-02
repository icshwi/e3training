Chapter 7 : Understand A Module Dependence
==

## Lesson Overview

In this lesson, you'll learn how to do the following:
* Understand which e3 environment variables should be defined.
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
$ make clean
$ make build
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

Can you see `-I/epics/base-3.15.5/require/3.0.4/siteMods/asyn/4.33.0/include`? At this point, the building system cannot find where `asynDriver.h` is.  That header file is used in `src/AsynDriverInterface.cc`. 


* Roll back to the asyn version and rebuild
```
$ rm configure/CONFIG_MODULE.local
$ make clean
$ make build
```

## New Dependent Module (Asyn) 

There are many scenarios when the new dependent module is introduced as follows:

* **scenario 1** : The same version of StreamDevice with non-existent version of Asyn (We assume that the asyn version is new one) 
* **scenario 2** : The old version of StreamDevice with non-existent version of Asyn (We assume that the asyn version is new one) 
* **scenario 3** : The new version of StreamDevice with non-existent version of Asyn (We assume that the asyn version is new one)
* **scenario 4** : The same version of StreamDevice with existent but different version of Asyn 
* **scenario 5** : The old version of StreamDevice with existent but different version of Asyn 
* **scenario 6** : The new version of StreamDevice with existent but different version of Asyn

We can think more scenarios as much as we can theoretically. However, if we limit these scenarios according to user requests. In most case, few scenarios will be applied. In this chapter, we consider the most frequent scenarios such as **scenario 3** and **scenario 6**. 

### Scenario 3 and 6
According to new requirements or critical bugs in an existent IOC, which is using StreamDevice 2.7.14p, we will need the StreamDevice 2.8.4. In that case, we have to consider about two dependent modules (Asyn and pcre). Here we consider the asyn dependence. We have to answer the question **Is the existent Asyn version enough for the StreamDevice 2.8.4?**

* If yes, please check [Chapter 3](chapter3.md). Note that this step has the strong assumption that the list of all source files in 2.7.14p and 2.8.4 are the same with in both version. If some files are added or removed between the versions, we have to modify the StreamDevice.Makefile properly. However, if this is the case, please contact the maintainer of e3. 

* If no, we have to install new Asyn version with the existent e3 environment. The procedure is the same as StreamDevice in [Chapter 3](chapter3.md). One should be in **E3_TOP**. In this case, there are no new files and no deleted files between Asyn 4.33 and 4.34. Thus, we can build the new version of asyn with the same `asyn.Makefile`. 

```
$ cd e3-asyn
$ make vars
$ make existent
/epics/base-3.15.5/require/3.0.4/siteMods/asyn
└── 4.33.0
    ├── db
    ├── dbd
    ├── include
    └── lib
```
```
$ echo "EPICS_MODULE_TAG:=tags/R4-34" > configure/CONFIG_MODULE.local
$ echo "E3_MODULE_VERSION:=4.34.0" >> configure/CONFIG_MODULE.local
$ make vars
$ make init
$ make rebuild
```

```
$ make existent
/epics/base-3.15.5/require/3.0.4/siteMods/asyn
├── 4.33.0
│   ├── db
│   ├── dbd
│   ├── include
│   └── lib
└── 4.34.0
    ├── db
    ├── dbd
    ├── include
    └── lib

```

The next step is to install the StreamDevice 2.8.4 according to the asyn 4.34.0. This step is the exactly same as the step described in [Chapter 3](chapter3.md). One should be in **E3_TOP**. Now, we execute all commands in **E3_TOP** instead of `e3-StreamDevice`. 


```
$ make -C e3-StreamDevice/ existent
make: Entering directory '/home/jhlee/e3-3.15.5/e3-StreamDevice'
/epics/base-3.15.5/require/3.0.4/siteMods/stream
└── 2.7.14p
    ├── dbd
    ├── include
    ├── lib
    └── SetSerialPort.iocsh

4 directories, 1 file
make: Leaving directory '/home/jhlee/e3-3.15.5/e3-StreamDevice'

```

```
$ make -C e3-StreamDevice/ vars
$ echo "EPICS_MODULE_TAG:=tags/2.8.4" > e3-StreamDevice/configure/CONFIG_MODULE.local
$ echo "E3_MODULE_VERSION:=2.8.4" >> e3-StreamDevice/configure/CONFIG_MODULE.local
$ echo "ASYN_DEP_VERSION:=4.34.0" >> e3-StreamDevice/configure/CONFIG_MODULE.local
$ make -C e3-StreamDevice  vars 
$ make -C e3-StreamDevice/ init
$ make -C e3-StreamDevice/ rebuild
```
```
$ make -C e3-StreamDevice/ existent
make: Entering directory '/home/jhlee/e3-3.15.5/e3-StreamDevice'
/epics/base-3.15.5/require/3.0.4/siteMods/stream
├── 2.7.14p
│   ├── dbd
│   ├── include
│   ├── lib
│   └── SetSerialPort.iocsh
└── 2.8.4
    ├── dbd
    ├── include
    ├── lib
    └── SetSerialPort.iocsh

``` 

* Please check the stream 2.8.4 within iocsh.

```
$ iocsh.bash -r stream,2.8.4
```
Can you seed the asyn version which you define? Can you check the old version within iocsh such as

```
$ iocsh.bash -r stream,2.7.14p
```

The loading dependency module was selected as the exact version which we define when we compile the stream module. 


## Aggressive Tests

More technical pitfalls are existent when we are building or writing startup scripts. Here I would like to show which kind of combinations which the current `require` module  cannot handle properly. If one find more, please let me know. 

* How `stream` can be loaded

Now we would like to uninstall the stream 2.8.4 version

```
$ make -C e3-StreamDevice/ uninstall
$ make -C e3-StreamDevice/ existent
```

Please try to run the following command
```
$ iocsh.bash -r stream,2.7.14p
```
Can you see the same as before? What if we don't define the specific version number of `stream` module? 

```
$ iocsh.bash -r stream
```
That is the exactly what we expect. However, there is one more thing, which one should consider. 

```
$ make -C e3-StreamDevice/ install
$ make -C e3-StreamDevice/ vars
```

```
$ iocsh.bash -r stream
```

Can you see that the iocsh is running without any issue? This is the default behavior when the specific module version number is not defined. However, it only is valid **ONLY** when the system has the numeric `X.Y.Z` version number module. In this example, the system has the `stream 2.8.4`.  Note that `2.7.14p` is not the numeric version number. However, in any case, the stream module will use the exact version of asyn which we decide to use when we build the stream module. 


* How we require dependency modules within startup scripts

Can you identify the difference among startup scripts in `ch7_supplementary_path`?

 
```
$ iocsh.bash ch7_supplementary_path/7-1.cmd
$ iocsh.bash ch7_supplementary_path/7-2.cmd
```


```
$ iocsh.bash ch7_supplementary_path/7-3.cmd 
$ iocsh.bash ch7_supplementary_path/7-4.cmd
```

```
$ iocsh.bash ch7_supplementary_path/7-5.cmd 
$ iocsh.bash ch7_supplementary_path/7-6.cmd 
```

```
$ iocsh.bash ch7_supplementary_path/7-7.cmd 
$ iocsh.bash ch7_supplementary_path/7-8.cmd
$ iocsh.bash ch7_supplementary_path/7-9.cmd
```

## Identify potential risks before it fails

As you see many failures scenarios in `Aggressive Tests`, it would be better to understand how this work all together before writing startup scripts. The current implementation within e3 (technically `require` version) cannot handle these all scenarios  properly, however, I think, it is good enough to accept this current limitation as it is, because we can reduce these risks if we follow the best practice to write a startup script.  At least, one should follow the first rule strictly and write at least a running IOC startup script one time, we don't have any further problems in future. 

* Use the specific version number of `modules`. If there is something wrong, you cannot start an IOC properly. Once you can start an IOC, then your IOC is restarted without any issues. 
* Use the last dependent module name and version if one know its dependencies. In this example, use only `stream` and do not use `asyn` and `stream`. 


## Dependence, dependence, and dependence
In this chapter, we only discuss the dependence when we compile a module. It is so-called **module header files** dependency. What does that means? It means the `stream` module uses several functions are defined in the `asyn` header files. That dependency file `*.d` is generated by the system compiler. For example, one can check that file as follows:

```
e3-StreamDevice/StreamDevice/O.3.15.5_linux-x86_64/AsynDriverInterface.d: 
/epics/base-3.15.5/require/3.0.4/siteMods/asyn/4.34.0/include/asynDriver.h \
/epics/base-3.15.5/require/3.0.4/siteMods/asyn/4.34.0/include/asynOctet.h \
/epics/base-3.15.5/require/3.0.4/siteMods/asyn/4.34.0/include/asynInt32.h \
/epics/base-3.15.5/require/3.0.4/siteMods/asyn/4.34.0/include/asynUInt32Digital.h \
/epics/base-3.15.5/require/3.0.4/siteMods/asyn/4.34.0/include/asynGpibDriver.h \
/epics/base-3.15.5/require/3.0.4/siteMods/asyn/4.34.0/include/asynDriver.h \
/epics/base-3.15.5/require/3.0.4/siteMods/asyn/4.34.0/include/asynInt32.h \
```

Note that `Dependent Environment Variables` in this chapter, without `ASYN_DEP_VERSION`, that `cflag` will not be shown in the compiling procedure. This is **one** of many dependence which one should understand in order to build an IOC properly. We will come back this subject later. 


---

[Next: Chapter 7 - Building an e3 application](chapter08.md)

[Return to Table of Contents](README.md)
