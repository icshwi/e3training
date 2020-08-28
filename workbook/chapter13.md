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

> If you want to easily connect to a UDS, you can use *socat*: `socat - UNIX-CONNECT:/var/run/procServ/my-ioc`.

## Letting the system manage our processes

One of systemd's primary components is a system and service manager. We want to let our system manage our IOCs as services. We do this by creating *unit files* (more on those [here](https://www.freedesktop.org/software/systemd/man/systemd.unit.html)) that encode information about our service.

We will now set up a simplistic system daemon to run an IOC.

1. Create a text file and save it as `/etc/systemd/system/test-ioc.service`, with the following contents:

   ```cs
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

   ```cs
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

   ```bash
   require stream,2.8.4

   iocInit()

   dbl > PV.list
   ```

3. Start an instantiated system daemon:

   ```console
   [iocuser@host:~]$ systemctl start ioc@test-ioc.service
   ```

   > Here you could also *enable* the service so that it autostarts on boot.

4. Check the status of the process:

   ```console
   [iocuser@host:~]$ systemctl status ioc@test-ioc.service
   ```
   <!-- todo: add output from status -->

As you saw, we added no specifics to our templated unit file, but instead used essentially macros. By having a template, we can instantiate as many IOCs as we want and have them appear and behave consistently.

## Managing your IOCs with conserver

[Conserver](https//www.conserver.com) is an application that allows multiple users to watch and interact with a serial console at the same time. We will thus use conserver instead of telnet or netcat to attach to our consoles. Conserver consists of a server and a client. The server will run as a system daemon on our IOC machine, but the client could be either local to that machine or remote.

Conserver requires a bit of boilerplate code for its setup. We will first have a quick look at the two programs and the main configuration files necessary for setup.

```console
[iocuser@host:~]$ conserver -V
conserver: conserver.com version 8.2.1
conserver: default access type `r'
conserver: default escape sequence `^Ec'
conserver: default configuration in `/etc/conserver.cf'
conserver: default password in `/etc/conserver.passwd'
conserver: default logfile is `/var/log/conserver'
conserver: default pidfile is `/var/run/conserver.pid'
conserver: default limit is 16 members per group
conserver: default primary port referenced as `782'
conserver: default secondary base port referenced as `0'
conserver: options: freeipmi, libwrap, openssl, pam
conserver: freeipmi version: 1.2.2
conserver: openssl version: OpenSSL 1.0.1e-fips 11 Feb 2013
conserver: built with `./configure --build=x86_64-redhat-linux-gnu --host=x86_64-redhat-linux-gnu --program-prefix= --disable-dependency-tracking --prefix=/usr --exec-prefix=/usr --bindir=/usr/bin --sbindir=/usr/sbin --sysconfdir=/etc --datadir=/usr/share --includedir=/usr/include --libdir=/usr/lib64 --libexecdir=/usr/libexec --localstatedir=/var --sharedstatedir=/var/lib --mandir=/usr/share/man --infodir=/usr/share/info --with-libwrap --with-openssl --with-pam --with-freeipmi --with-gssapi --with-striprealm --with-port=782'
```

The main two things to notice above is the location of the default configuration file and the default password file (`/etc/conserver.cf` and `/etc/conserver.passwd` respectively). If you were to look at these two files on your machine, you will find that they already contain some (commented out) example settings.

We will now modify these two files for our setup. As we do not need access control, we will simply allow all users to access conserver without any password. Modify your `conserver.passwd` to look like this:

```cs
*any*:
```

For the configuration file, we will set up some default values, and then we will use an include directive (`#include`) to be able to inventorize our consoles in a separate file. Modify your `conserver.cf` to look like this:

```cs
config * {
}

default full { rw *; }
default * {
        timestamp "";
        include full;
        master localhost;
}

#include /etc/conserver/procs.cf

access * {
        trusted 127.0.0.1;
        allowed 127.0.0.1;
}
```

Thus we are allowing only local access, and we are specifying to include the file `/etc/conserver/procs.cf` into this configuration file (we could otherwise just take whatever contents we soon will put in `procs.cf` and instead have them in `conserver.cf` - but we will modularize this a bit).

Now create the above included `procs.cf`, and populate it with data to describe one of our already-running IOCs:

```cs
console test-ioc {
    type uds;
    uds /var/run/procServ/test-ioc/control;
}
```

> We could have inventorized also a console on a TCP port, in which we would set type to `host`, and port to `2000`.

As we are making changes to the configuration of an already-running system daemon (conserver), we will need to do a soft restart of the systemd manager:

```console
[iocuser@host:~]$ systemctl daemon-reload
[iocuser@host:~]$ systemctl status conserver.service
```

> Should conserver not already be running on your machine, make sure to start and enable the service: `systemctl start conserver.service`, `systemctl enable conserver.service`.

We now have conserver running, managing a console on a UDS at `/var/run/procServ/test-ioc/control`. To test, we can attach to this using socat again:

```console
[iocuser@host:~]$ socat - UNIX-CONNET:/var/run/procServ/test-ioc/control
```

As we will want to use conserver client, also known as *console*, to attach to IOCs, we will need to set it up too. Let's first look at its' settings:

```console
[iocuser@host:~]$ console -V
console: conserver.com version 8.2.1
console: default initial master server `console'
console: default port referenced as `782'
console: default escape sequence `^Ec'
console: default site-wide configuration in `/etc/console.cf'
console: default per-user configuration in `$HOME/.consolerc'
console: options: libwrap, openssl, gssapi
console: openssl version: OpenSSL 1.0.1e-fips 11 Feb 2013
console: built with `./configure --build=x86_64-redhat-linux-gnu --host=x86_64-redhat-linux-gnu --program-prefix= --disable-dependency-tracking --prefix=/usr --exec-prefix=/usr --bindir=/usr/bin --sbindir=/usr/sbin --sysconfdir=/etc --datadir=/usr/share --includedir=/usr/include --libdir=/usr/lib64 --libexecdir=/usr/libexec --localstatedir=/var --sharedstatedir=/var/lib --mandir=/usr/share/man --infodir=/usr/share/info --with-libwrap --with-openssl --with-pam --with-freeipmi --with-gssapi --with-striprealm --with-port=782'
```

As you can see, site-wide configurations are kept in `/etc/console.cf`. All we will need to do now to use the service is to define where console should look for consoles:

```cs
config * {
        master localhost;
}
```

And voilá ! If we just do a soft reload of the systemd manager again, we should be able to both see and attach to our IOC.

```console
[iocuser@host:~]$ systemctl daemon-reload
[iocuser@host:~]$ console -u  # to list available consoles
[iocuser@host:~]$ console test-ioc
```

> You can detach from a console by pressing `^E c .` (note the dot at the end).

---

## Assignments

* Something on procServ
* Something on systemd
* Something on conserver


---

[Return to Table of Contents](README.md)
