# AOLserver configuration file for Tcl/Tk conference 2008
#
################################################################################
# Variables for Use in Rest of Configuration
# (was variables.tcl)

set os                 [exec uname]
set httpport           $env(NS_HTTPPORT)
set httpsport          $env(NS_HTTPSPORT)
set httpsport_pki      $env(NS_HTTPSPORT_PKI)
set address            $env(NS_ADDRESS)
set hostname           $env(NS_HOSTNAME)
set mailhost           $env(NS_MAILHOST)
set serverlog          $env(NS_SERVERLOG)
set accesslog          $env(NS_ACCESSLOG)
set pgstring           $env(PGHOST):$env(PGPORT):$env(PGDBNAME)
#set hostname          [exec /bin/hostname --long]
#set address           [string trim [exec /bin/hostname --ip-address]]
set servername         $env(SITENAME)
ns_log notice "Server Name: $servername"
set serverdesc         $env(SITEDESC)
set bindir             [file dirname [ns_info nsd]]
ns_log   notice   "bindir == $bindir"
set homedir            [file dirname $bindir]
#set homedir            [file dirname [ns_info config]]
ns_log   notice   "homedir == $homedir"
#set homedir  $bindir
# XXX axe -> set top                ${homedir}/../..
#set pageroot           $env(NS_PAGES)
set pageroot           ${homedir}/servers/${servername}/pages
#set moduleroot         $env(NS_MODULES)
set moduleroot         ${homedir}/servers/${servername}/modules
set configdir		   $env(SITEROOT)/$env(SITENAME)
set directoryfile      index.adp,index.htm

#set ext [info sharedlibextension]
# We force this instead of doing above line because Mac OS X doesn't like it
set ext .so

################################################################################
# Global Server Configuration
# Applies to all Virtual Servers

ns_section "ns/parameters"
ns_param   home              $homedir
ns_param   debug             true
ns_param   keepalivetimeout  300     ;# set to 0 to disable keepalive
ns_param   mailhost          $mailhost
#ns_param   smtphost          smtp.hq.nasa.gov
ns_param   maxinput          0       ; # Maximum POST request
ns_param   maxtime           0       ; # Timeout for connection
ns_param   serverlog         $serverlog

ns_param OutputCharset utf-8         ; #hopefully this works as planned
ns_param URLCharset    utf-8         ; #bleh

# Thread library (nsthread) parameters
ns_section "ns/threads"
ns_param   mutexmeter      true            ;# measure lock contention
ns_param   stacksize       [expr 1024*1024] ;# Per-thread stack size.

# MIME types. AOLserver already has an exhaustive list of MIME types, but in
# case something is missing you can add it here.
ns_section "ns/mimetypes"
ns_param   default         "*/*"     ;# MIME type for unknown extension.
ns_param   noextension     "*/*"     ;# MIME type for missing extension.
#ns_param    ".jar"         "application/java-archive"
ns_param   ".doc"          "application/msword"
ns_param   ".ppt"          "application/vnd.ms-powerpoint"
ns_param   ".xls"          "application/vnd.ms-excel"
ns_param   ".csv"          "application/vnd.ms-excel" ; # so csvs that are really adps work
ns_param   ".cab"          "application/mscabinet"
ns_param   ".frl"          "application/x-perfpro"
ns_param   ".max"          "application/vviewer"
ns_param   ".mif"          "application/x-mif"
ns_param   ".frz"          "application/x-dffill"
ns_param   ".asvg"         "image/svg-xml"
ns_param   ".asvgz"        "image/svg-xml"
ns_param   ".svg"          "image/svg-xml"
ns_param   ".svgz"         "image/svg-xml"
ns_param   ".p7b"          "application/pkix-cert"
ns_param   ".cer"          "application/pkix-cert"
ns_param   ".adp_jk"       "text/html; charset=cp1252"
ns_param   ".adp_ut"       "text/html; charset=utf-8"
ns_param   ".adp"          "text/html; charset=utf-8"

################################################################################
# Virtual Server Configurations (was server.tcl).
# There is only one server, onemis, for our configuration, but it's handled
# like any other virtual server would be.

ns_section "ns/servers"
ns_param   $servername     $serverdesc

# Server parameters
ns_section "ns/server/${servername}"
ns_param   minthreads      5
ns_param   maxthreads      40
#ns_param   connsperthread  20        ;# ???
ns_param   threadtimeout   300          ;# ???

ns_param   directoryfile   $directoryfile
ns_param   pageroot        $pageroot
ns_param   globalstats     false     ;# Enable built-in statistics.
ns_param   urlstats        false     ;# Enable URL statistics.
ns_param   maxurlstats     1000      ;# Max number of URL's to do stats on.

#ns_param   maxheaders      8192 * 2  ;# ???
ns_param   maxpost         [expr {50 * 1024000}]   ;# Maximum POST size, 50MB
#ns_param   maxline         ???       ;# ???

ns_param   enabletclpages  false     ;# Parse *.tcl files in pageroot.
#ns_param   flushcontent    true      ;# ???
#ns_param   modsince        true;     ;# Check modified-since

# XXX This section seems to have no effect -- see fastpath
# Directory listings -- use an ADP or a Tcl proc to generate them.
#ns_param   directoryadp    $pageroot/dirlist.adp ;# Choose one or the other.
#ns_param   directoryproc   _ns_dirlist           ;#  ...but not both!
#ns_param   directoryproc   no_dirlist           ;#  ...but not both!
#ns_param   directorylisting fancy               ;# Can be simple or fancy.

# Fastpath serves HTML
ns_section "ns/server/${servername}/fastpath"
ns_param   cache           false     ;# Enable cache for normal URLs
ns_param   cachemaxentry   8192      ;# Largest file size allowable in cache
ns_param   cachemaxsize    [expr 5000*1024] ;# Size of fastpath cache
ns_param   mmap            false     ;# Use mmap() for cache
# This turns on dirlistings. We want them off for security reasons
#ns_param   directorylisting fancy

# ADP (AOLserver Dynamic Page) configuration
ns_section "ns/server/${servername}/adp"
# We parse everything?
#ns_param   map             "*"  ;# Extensions to parse as ADP's.
ns_param   map             "/*.adp"  ;# Extensions to parse as ADP's.
ns_param   map             "/*.svg"  ;# Extensions to parse as ADP's.
ns_param   map             "/*.htm"  ;# Any extension can be mapped.
ns_param   map             "/*.csv"  ;# Any extension can be mapped.
ns_param   enableexpire    false     ;# Set "Expires: now" on all ADP's.
ns_param   enabledebug     false     ;# Allow Tclpro debugging with "?debug".

# ADP special pages
#ns_param   errorpage      ${pageroot}/errorpage.adp ;# ADP error page.

# ADP custom parsers -- see adp.c
ns_section "ns/server/${servername}/adp/parsers"
ns_param   adp             ".adp"    ;# adp is the default parser.

################################################################################
# Access log -- nslog (was nslog.tcl)

ns_section "ns/server/${servername}/module/nslog"
ns_param   file            $accesslog
ns_param   rolllog         true      ;# Should we roll log?
ns_param   rollonsignal    true      ;# Roll log on SIGHUP.
ns_param   rollhour        0         ;# Time to roll log.
# XXX error in AOLserver 4.0.5: maxbackup nslog call states it's rollfile instead of maxbackup
ns_param   maxbackup       999       ;# Max number to keep around when rolling.
ns_param   formattedtime   true      ;# false=seconds since epoch, true=dd/mmm/yyyy:hh:mm:ss -0400
ns_param   logcombined     true     ;# false=common log format, true=extended common log format


################################################################################
# Socket driver module (HTTP)  -- nssock (was nssock.tcl)

ns_section "ns/server/${servername}/module/nssock"
ns_param   port            $httpport
ns_param   hostname        $hostname
ns_param   address         $address
ns_param   maxinput        [expr {1024 * 1000 * 70}] ;# 70 MB upload limit


################################################################################
# CGI interface -- nscgi (was nscgi.tcl)

ns_section "ns/server/${servername}/module/nscgi"
ns_param debug             false
ns_param gethostbyaddr     false; # Whether to do reverse DNS lookups 
ns_param limit             0; # Max number of concurrent CGI processes 
ns_param maxoutput         10240; # Max bytes allowed from external process
ns_param buffersize        8192; # Buffer output from external process
ns_param map               "GET /*.cgi /"; # Where your CGI executables live (GET)
ns_param map               "POST /*.cgi /"; # Where your CGI executables live (POST)
ns_param systemenvironment false; # Copies environment from nsd start shell

#
# Load Other Module Configurations
#

ns_log notice "Loading nsopenssl configuration"
source $configdir/nsopenssl.tcl

ns_log notice "Loading nspostgres configuration"
source $configdir/nspostgres.tcl

ns_log notice "Loading nssqlite3 configuration"
source $configdir/nssqlite3.tcl

################################################################################
# Modules to load (was modules.tcl)

ns_section "ns/server/${servername}/modules"
ns_param   nsdb            ${bindir}/nsdb${ext}
ns_param   nssock          ${bindir}/nssock${ext}
ns_param   nslog           ${bindir}/nslog${ext}
#ns_param   nsperm          ${bindir}/nsperm${ext}
#ns_param   nscgi           ${bindir}/nscgi${ext}
#ns_param   nsldap          ${bindir}/nsldap${ext}
ns_param   nsopenssl       ${bindir}/nsopenssl${ext}
#ns_param   nexpat          ${bindir}/nsexpat${ext}

