# Sourcing this as root will modify Mac OS X's kernel parameters, increasing
# shared memory limits so that PostgreSQL can start. You can place these lines
# in /etc/sysctl.conf to have these settings implemented at boot time on
# Leopard.

sysctl -w kern.sysv.shmall=65536
sysctl -w kern.sysv.shmmax=16777216

