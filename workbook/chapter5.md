Chapter 5 : Take the Deployment or the Development
==

## Lesson Overview
In this lesson, you'll learn how to do the following:
* Understand why e3 doesn't hold any source codes
* Understand the anatomy of e3 module directory
* Understand the Deployment Mode through git submodule
* Understand the Development Mode through git clone
* Understand two repositories within e3 
* Understand why there is a Patch path within e3
* Understand workflows within github


## No Source Codes, Yes Configuration Files!
By default, each e3 module and application has no source codes within e3-module repository, but it only has the e3 configuration files and additional files. These files allow us to build the consistent user environment and building rules in terms of source codes, modules, applications, kernel drivers, and so on, which we may get from anywhere in any forms. 

Therefore, e3 doesn't care each single change in a source code repository, but care much about a snapshot (an interesting release version) which will be selected by one of release versions, user requests, or both. For example, at t=t0, we select the stream 2.7.14 version as the stable release within e3. At t=t1, we will select the stream 2.8.8, because a subsystem needs it. At this moment, we don't care about 2.8.0, 2.8.1, 2.8.2, 2.8.3, 2.8.4, 2.8.5, 2.8.6, and 2.8.7. We don't need to sync their changes into a master branch of a local repository, which we have to clone or fork. Simply, we don't need to do any maintenance jobs. The concept is that to select what we would like to use when we need it. In Atomic Physics, it is the similar concept of an atomic electron transition [1], which is a change of an electron from one energy level to another, which is known as quantum jump or quantum leap. Once e3 has the absorption of energies from user requests, it will release **jumps** version of each module. This approach is called as *Quantized or Quantum Release**.

Currently, it actually reduces unnecessary maintenance works to sync source code repositories and allows one single maintainer to use his valuable time to focus e3 functionalities instead of them. 

However, an e3 module can hold source files also, is known as *local* mode, which will be discussed later. 



## Anatomy

Please go **E3_TOP**/e3-iocStats, and run the following command:

```
e3-iocStats (master)$ tree -L 1
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

Each module has the slightly difference directory structure and files, but most of them are the same. 

* cmds              : customized startup scripts should be located in
* docs              : documents, log fles or others should be located in
* iocsh             : modularized startup scripts should be located in. They will be installed into e3 installation path. 
* patch             : if we need to handle small changes of source codes, we can keep patch files within it. 
* Makefile          : global e3 module makefile 
* iocStats.Makefile : e3 makefile for iocStats
* configure         : e3 configuration files
* iocStats          : git submodule path to link to where iocStats source reposiotory is

0. Run
```
git submodule status
```
One may get the following output:
```
ae5d08388ca3d6c48ec0e37787c865c5db18dc8f iocStats (3.1.15-17-gae5d083)
```
Please spend some time to understand these three columns. The reference [2] may be useful. 

1. Visit https://github.com/icshwi/e3-iocStats
Through a web brower, please follow the iocStats link within that site. Note that the magic number is **ae5d083**. 

![Import Example](ch5_supplementry_path/fig1.png)


## Deployment Mode



With Deployment Mode, we uses the git submodules [1] to make a link with actual source files. Since e3 doesn't maintain One can build the entire structure by oneself. 





## Reference 
[1] Atomic electron transition : https://en.wikipedia.org/wiki/Atomic_electron_transition
[2] https://git-scm.com/docs/git-submodule
[3] Git Tools - Submodules : https://git-scm.com/book/en/v2/Git-Tools-Submodules
