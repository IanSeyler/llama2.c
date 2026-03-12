#!/usr/bin/env bash

echo "Building llama2.c for BareMetal"

gcc -I include -c run.c -o run.o -DEMBED_MODEL -DBAREMETAL -O3 -D_POSIX_TIMERS=1 -D_POSIX_MONOTONIC_CLOCK=1
ld -T app.ld -o run lib/crt0.o run.o lib/libc.a lib/libm.a stories15M.o
objcopy -O binary run llama2.app
