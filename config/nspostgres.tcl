# NaviServer Configuration for nspostres

set pgstring $env(PGHOST):$env(PGPORT):$env(PGDBNAME)

# What driver to load
ns_section "ns/db/drivers"
#	ns_param nspostgres plpgsql.so
	ns_param nspostgres nspostgres.so

# XXX 2005-03-04 ssg -- try this out
#ns_section "ns/db/drivers/postgres"
#	ns_param datestyle         "iso"

	ns_section "ns/db/pools"
	ns_param main               "Main DB Pool"
	ns_param subquery           "Subquery DB Pool"
	ns_param log                "Logging DB Pool"

	ns_section "ns/db/pool/main"
	ns_param Driver             nspostgres
	ns_param Datasource         $pgstring
	ns_param Connection         10
	# XXX 2005-03-04 ssg -- try this out
	# XXX which is it? ns_param Connections        10
#	ns_param User              nobody
#	ns_param Password          "nobody"
#	ns_param Verbose           On
# XXX 2005-03-04 ssg -- try this out
#	ns_param MaxOpen           1000000000
# XXX 2005-03-04 ssg -- try this out
#	ns_param MaxIdle           1000000000
	ns_param LogSQLErrors       On
	ns_param ExtendedTableInfo  On

ns_section "ns/db/pool/subquery"
	ns_param Driver             nspostgres
	ns_param Connection         8
	ns_param Datasource         $pgstring
#	ns_param User              nobody
#	ns_param Password          "nobody"
	ns_param Verbose            Off
	ns_param LogSQLErrors       On
	ns_param ExtendedTableInfo  On

ns_section "ns/db/pool/log"
	ns_param Driver             nspostgres
	ns_param Connection         4
	ns_param Datasource         $pgstring
#	ns_param User              nobody
#	ns_param Password          "nobody"
	ns_param Verbose            Off
	ns_param LogSQLErrors       On
	ns_param ExtendedTableInfo  On

ns_section "ns/server/${servername}/db"
	ns_param Pools *
	ns_param defaultpool main


