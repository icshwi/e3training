# Appendix A : Build System Troubleshoting 

[Return to Table of Contents](README.md)

## Case 1

### Problem

When we run `make vars` or `make build`, we may see the following message:

```console
configure/CONFIG:20: /epics/base-7.0.1.1/require/3.0.4/configure/CONFIG: No such file or directory
/epics/base-7.0.1.1/require/3.0.4/configure/RULES_SITEAPPS: No such file or directory
make: *** No rule to make target `/epics/base-7.0.1.1/require/3.0.4/configure/RULES_SITEAPPS'.  Stop.
```

### Solution

Look up the declaration of `EPICS_BASE` in `configure/RELEASE` or `configure/RELEASE_DEV` file, and check the physical location of `EPICS_BASE`:

```console
[iocuser@host:~]$ ls -lta /epics/base-7.0.1.1/require/3.0.4/
```

In most cases when you have the above error, your system doesn't have the specified version of EPICS base and the require module. These are as we know defined in `configure/RELEASE` or `configure/RELEASE_DEV`.

A quick-fix to this is to use e3 in local mode and specify the version there:

```console
[iocuser@host:~]$ echo "EPICS_BASE=/home/root/epics/base-7.0.1.1" > configure/RELEASE_DEV.local
```

> Of course modify the path above to where you have EPICS installed.

---

## Case 2

### Problem

When we run `make install` or `make devinstall`, we may see the following message:

```console
rm: cannot remove '..../lib/linux-x86_ 64': Directory not empty

rm: cannot remove '..../lib/linux-x86_64/.nfs000000004c0de98d00000007': Device or resource busy
```

### Solution

An IOC may be running somewhere through NFS. We have to stop this IOC and exit any running process, then we can delete this directory if we would like to reinstall the application.

The meaning of `.nfsXXXX` can be found in http://nfs.sourceforge.net/#faq_d2.

## Case 3

### Problem

when we run `make init`, we may see the following conflict with the git submodule:

```
# --- snip snip ---
git submodule update --remote --merge opcua/
X11 forwarding request failed on channel 0
Auto-merging devOpcuaSup/linkParser.cpp
Auto-merging devOpcuaSup/devOpcua.cpp
CONFLICT (content): Merge conflict in devOpcuaSup/devOpcua.cpp
Auto-merging devOpcuaSup/UaSdk/SessionUaSdk.cpp
CONFLICT (content): Merge conflict in devOpcuaSup/UaSdk/SessionUaSdk.cpp
Auto-merging devOpcuaSup/UaSdk/ItemUaSdk.cpp
Auto-merging devOpcuaSup/UaSdk/DataElementUaSdk.cpp
CONFLICT (content): Merge conflict in devOpcuaSup/UaSdk/DataElementUaSdk.cpp
Auto-merging devOpcuaSup/RecordConnector.cpp
Auto-merging configure/CONFIG_OPCUA_VERSION
CONFLICT (content): Merge conflict in configure/CONFIG_OPCUA_VERSION
Automatic merge failed; fix conflicts and then commit the result.
Unable to merge 'a52002c31e6d5d32a21c130af42e579ae17b5b6f' in submodule path 'opcua'
make: *** [/epics/base-7.0.3/require/3.1.1/configure/RULES_E3:88: opcua] Error 2
```

* Reason: That is happened. The main module source repository `opcua` uses the complicated branch, and release rules. So, master codes are changed and doesn't have enough information about the release v0.5.2 exists in branch release/0.5. 

* Solution: Changed the default branch in .gitmodules from master (undefined) to release/0.5 such as 

  ```
  [submodule "opcua"]
	  path = opcua
	  url = https://github.com/ralphlange/opcua
	  branch = release/0.5
  ```


---

[Return to Table of Contents](README.md)
