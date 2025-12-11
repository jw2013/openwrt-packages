# FHEM @ OpenWrt

## Directory Structure

As most OpenWrt installations use read-only filesystems on flash memory, it is very important to restructure FHEM a bit, to have a clear separation between

- software and components in `/usr` ,
- configurations in `/etc/config/fhem` ,
- log files in `/var/log/fhem` and
- cache files in `/var/cache/fhem` .

FHEM causes some issues in that regard, especially when it comes to FHEM/FhemUtils: While this directory resides under a folder hosting program code, it is used as a cache by many modules. Additionally, it hosts the unqiueID file, which is also used to store persistant and sensitive data including passwords.

Unfortunately, the path for the cache and permanent storage cannot get modified in the config file.

While it was possible to implement a working solution involving a couple of symbolic links, it would be preferable to define the paths for cache and permanent storage within the main config file.

Similar issues are caused by some modules, e.g. the SVG module uses the path www/gplot, which is under the folder used for static web files, to store .gplot configuration files.

### /usr/bin/fhem

The actual FHEM service executable, can be used both as a client and as the service, depending on how it gets started.

### /usr/share/fhem

```attr global modpath /usr/share/fhem```

This path is used for all other installed files of FHEM, including modules, image, javascrips, documentation.


#### /usr/share/fhem/FHEM

Path for all FHEM modules, including

- /usr/share/fhem/FHEM/01_FHEMWEB.pm
- /usr/share/fhem/FHEM/99_Utils.pm
- /usr/share/fhem/FHEM/DevIo.pm

#### /usr/share/fhem/FHEM/FhemUtils -> /var/cache/fhem

This path is used by various modules for caching purposes (symlink)

#### /usr/share/fhem/FHEM/FhemUtils/uniqueID -> /etc/config/fhem/uniqueID

Unlike the other files in FhemUtils, this file is used to store persistent key-value entries, therefore it's symlinked to the actual file in the config directory

#### /usr/share/fhem/lib

Additional, FHEM related Perl packages

#### /usr/share/fhem/www

FHEMWEB related files, including themes

- /usr/share/fhem/www/images
- /usr/share/fhem/www/pgm2

#### /usr/share/fhem/www/gplot -> /etc/config/fhem/gplot

Used by the SVG module to store .gplot configuration files (symlink)

#### /usr/share/fhem/docs

Used by the HELP module and commandref.html

- /usr/share/fhem/docs/commandref_frame.html
- /usr/share/fhem/docs/commandref_frame_DE.html

### /var/log/fhem

```attr global logdir /var/log/fhem```

This path should be used for all logfiles created by FHEM. As OpenWrt creates the /var partition as a symlink to /tmp, it is advisable to mount an external block device on /var/log prior to filling it up.

#### /var/log/fhem/fhem.save

```attr global statefile /var/log/fhem/fhem.save```

FHEM creates a save file to store it's current state and readings on shutdown and restart

### /etc/config/fhem

This directory stores all configuration files related to FHEM

#### /etc/config/fhem/fhem.cfg

The main configuration file which is used when starting the service

#### /etc/config/fhem/mod.cfg

Included by the main config ``fhem.cfg``, this file is autocreated by the service on each start, to include all configs under ``/etc/config/mod.cfg.d``

Some measures are taken, to make sure it's only rewritten on flash, if it actually changed.

Will get deprecated, as soon as FHEM supports including directories instead of single files.

#### /etc/config/fhem/mod.cfg.d

This folder is used by different modules like FHEMWEB or TELNET, to create a 'singleton' instance on installation, that can later get modified by the user.

#### /etc/config/fhem/uniqueID

This file contains persistant configuration parameters, including passwords, and is therefore restricted to mode 0600 (```-rw-------```) on installation.

### /etc/init.d/fhem

The OpenWrt service script for FHEM.

### /var/run/fhem.pid

Stores the PID of the FHEM service instance, used by the service script

```attr global pidfilename /var/run/fhem.pid```


## FHEM Package definitions (Makefile)

## FHEM OpenWrt Integration (UBUS)


