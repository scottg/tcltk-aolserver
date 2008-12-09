# nsopenssl (HTTPS) 

# Global settings for nsopenssl (was global.tcl)
ns_section "ns/server/module/nsopenssl"
	ns_param RandomFile /some/file
	ns_param SeedBytes  1024

# XXX Global nsopenssl settings are in main nsd.tcl file

# Virtual Server specific nsopenssl configurations

# SSL contexts. Each SSL context is a template that SSL connections are created
# from.  A single SSL context may be used by multiple drivers, sockservers and
# sockclients. If you don't define any sslcontexts, why are you running
# nsopenssl?

ns_section "ns/server/${servername}/module/nsopenssl/sslcontexts"
	ns_param vs1_users_ctx        "SSL context used for regular user access"
	ns_param vs1_admins_ctx       "SSL context used for administrator access"
	ns_param vs1_ctx_client       "SSL context used for outgoing script socket connections"

# We explicitly tell the server which SSL contexts to use as defaults when an
# SSL context is not specified for a particular client or server SSL
# connection. (Driver connections do not use defaults; they must be explicitly
# specificied in the driver section).
ns_section "ns/server/${servername}/module/nsopenssl/defaults"
	ns_param server               vs1_users_ctx
	ns_param client               vs1_ctx_client

ns_section "ns/server/${servername}/module/nsopenssl/sslcontext/vs1_users_ctx"
	ns_param Role                  server
#	ns_param ModuleDir             /path/to/dir
	ns_param CertFile              certificate.pem
	ns_param KeyFile               key.pem
#	ns_param CADir                 ca-client/dir
#	ns_param CAFile                ca-client/ca-client.crt
#	ns_param Protocols             "SSLv3, TLSv1"
	ns_param Protocols             "All"
	ns_param CipherSuite           "ALL:!ADH:RC4+RSA:+HIGH:+MEDIUM:+LOW:+SSLv2:+EXP"
	ns_param PeerVerify            false
	ns_param PeerVerifyDepth       3
	ns_param Trace                 false

ns_section "ns/server/${servername}/module/nsopenssl/sslcontext/vs1_admins_ctx"
	ns_param Role                  server
#	ns_param ModuleDir             /path/to/dir
	ns_param CertFile              certificate.pem
	ns_param KeyFile               key.pem
#	ns_param CADir                 ca-client/dir
#	ns_param CAFile                ca-client/ca-client.crt
	ns_param Protocols             "All"
#	ns_param Protocols             "SSLv3, TLSv1"
	ns_param CipherSuite           "ALL:!ADH:RC4+RSA:+HIGH:+MEDIUM:+LOW:+SSLv2:+EXP"
	ns_param PeerVerify            false
	ns_param PeerVerifyDepth       3
	ns_param Trace                 false

ns_section "ns/server/${servername}/module/nsopenssl/sslcontext/vs1_ctx_client"
	ns_param Role                  client
#	ns_param ModuleDir             /path/to/dir
#	ns_param CertFile              client/client.crt 
#	ns_param KeyFile               client/client.key 
	ns_param CADir                 ca-server/dir
	ns_param CAFile                ca-server/ca-server.crt
	ns_param Protocols             "All"
#	ns_param Protocols             "SSLv3, TLSv1"
	ns_param CipherSuite           "ALL:!ADH:RC4+RSA:+HIGH:+MEDIUM:+LOW:+SSLv2:+EXP"
	ns_param PeerVerify            false
	ns_param PeerVerifyDepth       3
	ns_param Trace                 false

# SSL drivers. Each driver defines a port to listen on and an explitictly named
# SSL context to associate with it. Note that you can now have multiple driver
# connections within a single virtual server, which can be tied to different
# SSL contexts. Isn't that cool?
ns_section "ns/server/${servername}/module/nsopenssl/ssldrivers"
	ns_param vs1_users_drv         "Driver for vs1 regular user access"
	ns_param vs1_admins_drv        "Driver for vs1 administrator access"

ns_section "ns/server/${servername}/module/nsopenssl/ssldriver/vs1_users_drv"
	ns_param sslcontext            vs1_users_ctx
	ns_param port                  $httpsport
	ns_param hostname              $hostname
	ns_param address               $address
	ns_param maxinput              [expr {1024 * 1000 * 70}] ;# 70 MB upload limit

ns_section "ns/server/${servername}/module/nsopenssl/ssldriver/vs1_admins_drv"
	ns_param sslcontext            vs1_admins_ctx
	ns_param port                  $httpsport_pki
	ns_param hostname              $hostname
	ns_param address               $address
	ns_param maxinput              [expr {1024 * 1000 * 70}] ;# 70 MB upload limit

