# Chapter 13: Supplementary tools

[Return to Table of Contents](README.md)

## Lesson Overview

In this lesson, you'll learn how to do the following:

* Run IOCs in procServ containers.
* Run processes as system daemons.
* Use conserver to manage procServ containers.

---

## Utilities

Typically, IOCs will be running on a dedicated (virtual or physical) machine that you remote (SSH) into. A single machine may host a number of IOCs, which should be running regardless of if you are attached to a session or not. Thus we want to be able to allow the system to run and take care of the IOC itself, we need to be able to easily attach to the IOC if necessary, to access logs, as well as to find IOCs currently running. Historically, common user accounts with screen or tmux sessions have been used towards this purpose, but they come with issues; there are output overflow issues, and what happens if multiple users are attempting to latch on to the same IOC at the same time?

At ESS, IOCs will run as (templated) instantiated system daemons in procServ containers, which all are managed by conserver.

> Note that these deployments, including set up of these utilities, typically is automated with remote execution and configuration management by use of utilities like *ansible*, *salt* or *puppet*. It is, however, still useful to understand how they work.

## Starting an IOC in a procServ container

Per its [documentation](https://linux.die.net/man/1/procserv), procServ "creates a run time environment for a command (e.g. a soft IOC). It forks a server run as a daemon into the background, creates a child process running *command* with all remaining *args* from the command line. The server provides console access (stdin/stdout) to the child process by offering a telnet connection at the specified port."

We will now create a procServ container for an "empty" `iocsh.bash` session listening on port 2000, and will then attach to it using telnet.

1. Start a procServ container:

   > Ensure that you have sourced your e3 environment by e.g. `setenv`, otherwise provide the full path to your `iocsh.bash` executable.

   ```console
   [iocuser@host:~]$ procServ -n "iocsh" 2000 $(which iocsh.bash)
   ```

2. Attach using telnet:

   ```console
   [iocuser@host:~]$ telnet localhost 2000
   Trying ::1...
   telnet: connect to address ::1: Connection refused
   Trying 127.0.0.1...
   Connected to localhost.
   Escape character is '^]'.
   @@@ Welcome to procServ (procServ Process Server 2.7.0)
   @@@ Use ^X to kill the child, auto restart is ON, use ^T to toggle auto restart
   @@@ procServ server PID: 1653
   @@@ Server startup directory: /home/iocuser
   @@@ Child startup directory: /home/iocuser
   @@@ Child "testing" started as: /opt/epics/base-7.0.3.1/require/3.1.2/bin/iocsh.bash
   @@@ Child "testing" PID: 1654
   @@@ procServ server started at: Mon Aug 24 15:48:56 2020
   @@@ Child "testing" started at: Mon Aug 24 15:48:56 2020
   @@@ 0 user(s) and 0 logger(s) connected (plus you)
   ```

   If you press enter here, you should be seeing the iocsh PS1 (something like `04d5808-ics-alo-1654 >`). If you try to type `exit` (or send a `SIGINT` with `^C`), you will notice that the IOC simply restarts.

   > As this is a telnet session, you can of course leave it as per usual by pressing `^]`, where `^` is your Ctrl key.

3. Kill the container by pressing first `^X` and then `^Q`.

What we just did was thus to start a procServ server, set it to listen to TCP port 2000, and to run `iocsh.bash` with no arguments. A more proper way of starting the server would be to do something like:

```console
[iocuser@host:~] procServ -n "Test IOC" -i ^D^C -L procServ.log unix:/var/run/procServ/my-ioc $(which iocsh.bash) /path/to/st.cmd
```

, where we specify to ignore end of file (`^D`) and SIGINT (`^C`), to log all output to a file `procServ.log`, to use a UNIX domain socket (UDS) at `/var/run/procServ/my-ioc`, and to use a startup script at `/path/to/st.cmd`.

> If you want to easily connect to a UDS, you can use *socat*: `socat - UNIX-CONNET:/var/run/procServ/my-ioc`.

## Letting the system manage our processes

One of systemd's primary components is a system and service manager. We want to let our system manage our IOCs as services. We do this by creating *unit files* (more on those [here](https://www.freedesktop.org/software/systemd/man/systemd.unit.html)) that encode information about our service.

We will now set up a simplistic system daemon to run an IOC.

1. Create a text file and save it as `/etc/systemd/system/test-ioc.service`, with the following contents:

   ```console
   [iocuser@host:~]$ cat /etc/systemd/system/test-ioc.service
   [Unit]
   Description=procServ container for test IOC
   After=network.target remote-fs.target
  
   [Service]
   User=iocuser
   ExecStart=/usr/bin/procServ \
                       --foreground \
                       --name=test-ioc \
                       --logfile=/home/iocuser/test-ioc.log \
                       --ignore=^C^D \
                       --port=2000 \
                       /opt/epics/base-7.0.3.1/require/3.1.2/bin/iocsh.bash
  
   [Install]
   WantedBy=multi-user.target
   ```

   > Note that you need to provide the full path to `iocsh.bash` as command substitution doesn't work in unit files. Instead, systemd offers its own minimalistic shell-style command line parsing - if interested, see more [here](https://www.freedesktop.org/software/systemd/man/systemd.service.html#Command%20lines).

2. Start up and inspect your service:

   ```console
   [iocuser@host:~]$ systemctl start test-ioc.service
   [iocuser@host:~]$ systemctl status test-ioc.service
   ```

   > If you want the system to keep the process alive and start it on boot, enable it: `systemctl enable test-ioc.service`.

3. Stop (and disable) your service.

   ```console
   [iocuser@host:~]$ systemctl stop test-ioc.service
   ```

As you can see from the unit file, most of the parameters are fairly generic, and can be used for all IOCs. This allows us to use *template* unit files, and to instantiate daemons for our IOCs. We can thus create a single file called `ioc@.service`, and start any number of processes of the format `ioc@<instance_name>.service`. As we will want to be able to have different processes listen at different ports, we can use a few different specifiers supported by systemd.

1. Create a template file called `ioc@.service`:

   ```console
   [iocuser@host:~]$ cat /etc/systemd/system/ioc@.service
   [Unit]
   Description=procServ container for IOC %i
   Documentation=file:/opt/iocs/e3-ioc-%i/README.md
   Before=conserver.service
   After=network.target remote-fs.target
   AssertPathExists=/opt/iocs/e3-ioc-%i
  
   [Service]
   User=iocuser
   Group=iocgroup
   PermissionsStartOnly=true
 
   ExecStartPre=/bin/mkdir -p /var/log/procServ/%i
   ExecStartPre=/bin/chown -R iocuser:iocgroup /var/log/procServ/%i
   ExecStartPre=/bin/mkdir -p /var/run/procServ/%i
   ExecStartPre=/bin/chown -R iocuser:iocgroup /var/run/procServ/%i
 
   ExecStart=/usr/bin/procServ \
                       --foreground \
                       --name=%i \
                       --logfile=/var/log/procServ/%i/out.log \
                       --info-file=/var/run/procServ/%i/info \
                       --ignore=^C^D \
                       --logoutcmd=^Q \
                       --chdir=/var/run/procServ/%i \
                       --port=unix:/var/run/procServ/%i/control \
                       /opt/epics/base-7.0.3.1/require/3.1.2/bin/iocsh.bash \
                       /opt/iocs/e3-ioc-%i/st.cmd
  
   [Install]
   WantedBy=multi-user.target
   ```

   In this file, `%i` is the instance name (character escaped; `%I` is verbatim), and you can also see that we've added some requirements for where the startup script shall be located, etc.

   > Note that we now are using UDS instead of TCP ports, which allows us to name the socket.

2. Create a simple startup script at `/opt/iocs/` with the format `e3-ioc-<iocname>/st.cmd`:


## Managing your IOCs with conserver

To be written.


---

[Return to Table of Contents](README.md)
