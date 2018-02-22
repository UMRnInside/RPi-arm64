#!/bin/bash
uptime
sysbench --version
# CPU Performance
sysbench --test=cpu --num-threads=1 --max-requests=10000 run
sysbench --test=cpu --num-threads=4 --max-requests=100000 run
sysbench --test=cpu --num-threads=8 --max-requests=100000 run
 
# Memory performance
sysbench --test=memory --memory-block-size=1K --memory-total-size=1G --memory-access-mode=rnd  run
sysbench --test=memory --memory-block-size=1K --memory-total-size=1G --memory-access-mode=seq  run
# Network 
#iperf3 -c 192.168.1.2
sysbench --test=threads --num-threads=1000 --thread-yields=1000 --thread-locks=8 run
 
sysbench --test=mutex --mutex-num=4096 --mutex-locks=50000 --mutex-loops=10000  run

# Disk I/O
sysbench --test=fileio --file-num=2 --file-total-size=64M --file-test-mode=seqrewr run
sysbench --test=fileio --file-num=2 --file-total-size=64M --file-test-mode=rndwr run
 
uname -a
df -Th
