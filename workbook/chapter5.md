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

Therefore, e3 doesn't care each single change in a source code repository, but care much about a snapshot (an interesting release version) which will be selected by one of release versions, user requests, or both. For example, at t=t0, we select the stream 2.7.14 version as the stable release within e3. At t=t1, we will select the stream 2.8.8, because a subsystem needs it. At this moment, we don't care about 2.8.0, 2.8.1, 2.8.2, 2.8.3, 2.8.4, 2.8.5, 2.8.6, and 2.8.7. We don't need to sync their changes into a master branch of a local repository, which we have to clone or fork. Simply, we don't need to do any maintenance jobs. The concept is that to select what we would like to use when we need it. In Atomic Physics, it is the similar concept of an atomic electron transition [1], which is a change of an electron from one energy level to another, which is known as quantum jump or quantum leap. Once e3 has the absorption of energies from user requests, it will release **jumps** version of each module. This approach is called as **Quantized or Quantum Release**.

Currently, it actually reduces unnecessary maintenance works to sync source code repositories and allows one single maintainer to use his valuable time to focus e3 functionalities instead of them. However, an e3 module can hold source files also, is known as *local* mode, which will be discussed later. 



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

### Git submodule

In order to explain how e3 uses git submodules, we have to do the following execise:

0. Run

```
$ git submodule status
```
One may get the following output:
```
ae5d08388ca3d6c48ec0e37787c865c5db18dc8f iocStats (3.1.15-17-gae5d083)
```
Please spend some time to understand these three columns. The reference [2] may be useful. 

1. Check a github site

Please visit https://github.com/icshwi/e3-iocStats, which is shown in **Figure 1**.
The magic number is **ae5d083**. Please try to find where that number exists. After finding it, please check that number in the output of `git submodule status` also. 

|![Import Example](ch5_supplementry_path/fig1.png)|
| :---: |
|**Figure 1** The screenshot for the iocStats github site. |


2. Check its submodule configuration

```
$ more .gitmodules
[submodule "iocStats"]
        path = iocStats
        url = https://github.com/epics-modules/iocStats
        ignore = dirty
```

## Deployment Mode

As one sees now, `git  submodule` guides us to a new place where we can work and a new way to handle many different source files which are scattered over many difference facilities. However, in order to use it fully, one should have the proper permission and learn how it works precisely. With the current implementation and limited resources, we cannot use this rich features fully. Thus, e3 will use its minimal feature, which is related with the **magic** number that is the short version of the SHA-1 checksum by git [4]. 

Therefore, we only use a specific commit version of iocStats within e3-iocStats in order to identify which version currently links to. And if source code repositories are stable enough, we can use `git submodule update --init` to download its specific version of source codes within e3 modules. By that means, we can pick a specific version of a module, which we would like to use for stable e3 system. 

However, when source code repositories are changed very frequently, it also create an additional maintenance work which one has to update the SHA-A checksum in order to match a selected version of a module. Thus, with `make init`, it will download latest version of a module, and switch to a specific version defined in `configure/CONFIG_MODULE` through several git and other commands behind its building system. 

The following commands are used for the deployment mode of each module. They will use `git submodule` path to do their jobs properly. 

```
$ make vars
$ make init
$ make patch
$ make build
$ make install
$ make existent
$ make clean
```


## Development Mode

The deployment mode is nice if one has enough domain knowledge on `git submodule` and proper permission on a source repository. As one knows, it is not always the case where we work on Earth. Thus, the e3 has the development mode, which resolve these conflicts by using `git clone`. Please look at `configure` path. One can find few files have the suffix `_DEV`.

```
$ ls configure/*_DEV
```

Two files (`CONFIG_MODULE_DEV` and `RELEASE_DEV`) are the counterpart of files (`CONFIG_MODULE` and `RELEASE`) in the deployment mode. Both files are almost identifical except the suffix `_DEV` and following things in the development mode :

* `E3_MODULE_DEV_GITURL` : This shows the repository which one would like to download into an e3 module
* `E3_MODULE_SRC_PATH` : This shows the source codes path for the deployment mode. It has the suffix `-dev`. For example, e3-iocStats has `iocStats` source path in the deployment, and `iocStats-dev` one in the development mode. 

With `E3_MODULE_DEV_GITURL` variable in `configure/CONFIG_MODULE_DEV` with the most poweful feature of `git`, we may have a plenty of degree of freedom to develop an module without worrying about other system which may use this module. 


The following commands are used for the development mode of each module. They will use `git clone` path to do their jobs properly. There is one extra command which one can see `make devdistclean` will remove the clone source directory, for example, iocStats-dev when one would like to clone from scratch. And `make existent` and `make devexistent` are the same output, because it relys on **installed** module versions. 

```
$ make devvars
$ make devinit
$ make devpatch
$ make devbuild
$ make devinstall
$ make devexistent
$ make devclean
$ make devdistclean
```

### Git clone

0. Fork your own copy from the community iocStats [5]

1. Update the `E3_MODULE_DEV_GITURL` in order to use your own repository. For example, the default one is `https://github.com/icshwi/iocStats`

2. Check https://github.com/icshwi/iocStats whether it is the same as the original one or not. One can see the following line `This branch is 1 commit ahead, 1 commit behind epics-modules:master. ` in **Figure 2**.

|![Import Example](ch5_supplementry_path/fig2.png)|
| :---: |
|**Figure 2** The screenshot for the forked and modified icshwi iocStats github site. |






## Reference 
[1] Atomic electron transition : https://en.wikipedia.org/wiki/Atomic_electron_transition

[2] https://git-scm.com/docs/git-submodule

[3] Git Tools - Submodules : https://git-scm.com/book/en/v2/Git-Tools-Submodules

[4] https://git-scm.com/book/en/v2/Git-Internals-Git-Objects

[5] https://github.com/epics-modules/iocStats
