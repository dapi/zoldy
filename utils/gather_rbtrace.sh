#!/usr/bin/env sh

V=$1
rbtrace -p `cat ./tmp/pids/puma.pid` \
    -e "Thread.new{require 'objspace'; ObjectSpace.trace_object_allocations_start; \
    GC.start(); ObjectSpace.dump_all(output: ::File.open(\"./tmp/heap-$V.json\", 'w'))}.join"
# rbtrace -p `cat ./tmp/pids/puma.pid` -e 'puts ObjectSpace.count_objects[:TOTAL], GetProcessMem.new.bytes.to_i'
