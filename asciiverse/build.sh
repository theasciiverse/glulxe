#!/bin/sh
# Builds glulxe against GlkTerm's wide-character edition (glkterm/), so
# Unicode text, status lines and other Glk windows work in the terminal.
# Linux: run inside alpine:3.22 for a fully static binary with ncurses
# linked in. macOS: run on the runner with CC_ARCH set to x86_64 or arm64;
# it links the system's own ncurses (wide-character capable), so the binary
# needs nothing beyond macOS, and the script fails if it links anything else.
#   docker run --rm -v "$PWD":/src -w /src alpine:3.22 sh asciiverse/build.sh
# Leaves ./glulxe. asciiverse/build-glulxe.sh is the same build from pinned
# upstream sources, for story repos that bundle the interpreter.
#
# -fno-strict-aliasing: glulxe's float.c type-puns floats through pointers,
# which GCC warns may break at -O2 (upstream's own Makefile does not
# optimise at all).
set -eu
if [ -f /etc/alpine-release ]; then
  apk add --no-cache build-base ncurses-dev ncurses-static >/dev/null
  cc="cc"; os="-DOS_UNIX -DUNIX_RAND_GETRANDOM"; ld="-static"; curses="-lncursesw"
else
  cc="cc -arch $CC_ARCH"; os="-DOS_MAC"; ld=""; curses="-lncurses"
fi
opt="-O2 -fno-strict-aliasing"
make -C glkterm clean >/dev/null
make -C glkterm CC="$cc" OPTIONS="$opt" LIBS="$curses"
rm -f ./*.o glulxe
make CC="$cc" OPTIONS="$opt -Wall -Wno-unused $os $ld" \
  GLKINCLUDEDIR=glkterm GLKLIBDIR=glkterm GLKMAKEFILE=Make.glktermw glulxe
if [ ! -f /etc/alpine-release ]; then
  otool -L glulxe
  if otool -L glulxe | tail -n +2 | grep -v -E "^\s*/(usr/lib|System/Library)/"; then
    echo "glulxe links a library outside the system" >&2; exit 1
  fi
fi
strip glulxe
