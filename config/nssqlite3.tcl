#
 # SQLite v3 -- nssqlite3
 #
 ns_section  "ns/server/${servername}/modules"
 ns_param    nsdb            nsdb.so

 ns_section  "ns/server/${servername}/db"
 ns_param    defaultpool     sqlite3
 ns_param    pools           *

 ns_section  "ns/db/drivers"
 ns_param    sqlite3         nssqlite3.so

 ns_section  "ns/db/pools"
 ns_param    sqlite3         "sqlite3"

 ns_section  "ns/db/pool/sqlite3"
 ns_param    driver          sqlite3
 ns_param    connections     1
 ns_param    datasource      /tmp/sqlite3.db
 ns_param    verbose         off

