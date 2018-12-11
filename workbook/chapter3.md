# Chapter 3 : Install a Module with the different version number

## Lesson Overview

In this lesson, you'll learn how to do the following:
* Print out and understand the various EPICS and E3 variables
* Check the current installed StreamDevice (stream) version with different level information
* Understand two important variables such as E3_MODULE_VERSION and EPICS_MODULE_TAG
* Install the difference StreamDevice version within e3


## Check the VARIABLES within the e3

Various Environment variables are used in EPICS and E3, so it is really important to understand what they are. Please remember, our environment is e3 with EPICS, so we have some variables which are unique within e3.


0. Make sure you are in **E3_TOP**

1. Move in e3-StreamDevice

```
e3-3.15.5 (master)$ cd e3-StreamDevice/
e3-StreamDevice (master)$ 
```

2. Run the following rule:

```
e3-StreamDevice (master)$ make vars
```

The most interesting VARIABLES are

* ```E3_MODULE_VERSION``` : This is used as **Module/Application Version** with require within an IOC startup script. We recommend to use the X.X.X version number as the stable production release, but any combination can be possible. 

* ```EPICS_MODULE_TAG``` : This is the **snapshot** of the source code repository, i.e., tags/stream_2_7_14, master, branch_name, or e0a24fe.

Two VARIABLES are defined within configure/CONFIG_MODULE and configure/CONFIG_MODULE_DEV.


## Check the installed version of each module

0. Make sure you are in **E3_TOP**/e3-StreamDevice

1. Run the following rule:

```
e3-StreamDevice (master)$ make existent
```

2. Check the result :

The result shows the existent version of stream modules within e3 :
   
```
/epics/base-3.15.5/require/3.0.4/siteMods/stream
└── 2.7.14p
    ├── dbd
    ├── include
    ├── lib
    └── SetSerialPort.iocsh
```

The default is the tree LEVEL 2, i.e., ``` make existent``` is the same as
``` make LEVEL=2 existent```


## Check the initiated StreamDevice version

* Move into StreamDevice

```
e3-StreamDevice (master)$ cd StreamDevice/
StreamDevice ((stream_2_7_14))$ 
```
If one has no git-prompt setup, please check it via

```
git describe --tags
```

And the following command also is useful to check where you are:

```
git show --oneline 
```

We download the StreamDevice from the PSI github directly, and switch to EPICS_MODULE_TAG when ```make init``` is executed.

0. Move to e3-StreamDevice again

1. Run ```make init``` to see what kind of messages which you can see. Can you guess what kind of process will be done behind scenes. 

2. Check  EPICS_MODULE_TAG with ```make vars```

3. Check the configure/CONFIG_MODULE file

```make init```will download all source files within StreamDevice as git submodule, and switch to the stream_2_7_14 version of StreamDevice.



## Change EPICS_MODULE_TAG and E3_MODULE_VERSION

* Use tags/2.8.3 instead of tags/stream_2_7_14

  That version can be found within the PSI StreamDevice release :
  https://github.com/paulscherrerinstitute/StreamDevice/releases

* Change E3_MODULE_VERSION to match tags/2.8.3

  Here one can select whatever meaningful version number, the basic and
  relevant selection will be 2.8.3. However, if one would like to evaluate
  this version or to do some integration tests with your IOC, one could select
  0.0.0, testing, 20181010, or whatever strings and numbers.
  
* Your changed configure/CONFIG_MODULE may be such as
```
  --- snip snip ---
  EPICS_MODULE_TAG:=tags/2.8.3 
  E3_MODULE_VERSION:=2.8.3
  --- snip snip ---
```

* Check them with ```make vars```


## Switch 2.8.4 StreamDevice Source

0. Make sure to be in e3-StreamDevice
1. ```make vars```
   Can you see the difference between before and now?
   
2. ```make init```
   Can you see the difference between before and now?
   
3. ```make build```

4. ```make install```

5. ```make existent```



## Assignments

### Check the LEVEL=4 existent

### Do ```make init``` in **E3_TOP**

### Which kind of make rule allows us to uninstall the installed module?

### Can we combine the following two steps together? 
    1. make build
    2. make install
	
### Do the different version of StreamDevice in **E3_TOP**
    For example, commit hash is 493dc19
	
	


------------------
:arrow_backward:  | :arrow_up_small:  | :arrow_forward:
:--- | --- |---: 
[Chapter2](chapter2.md) | [Chapter3](chapter3.md) | [Chapter4](chapter4.md)

