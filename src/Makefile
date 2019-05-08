#
#		Copyright (C)  Dialogic Corporation. 2001-2012.  All Rights Reserved.
#
#       File:	makdefs.mak
#
#		Common makefile for use with Linux Development Package
#       Assumes GCC is the C compiler and GNU Make is the make utility.
#		
#   -------+---------+------+------------------------------------------
#   Issue     Date      By    Description
#   -------+---------+------+------------------------------------------
#     A     11-Dec-18  elmir    - New file.


DPK_BASE=/opt/DSI

COMPILER = gcc
LIBRARIAN = ar
LINKER = gcc

JAVAC = javac
JAR = jar

# Default to 32bit builds
ARCH=64

#DPROD = define PROD, production
DEFINES = -DLINT_ARGS -DIN_LMSGS
CFLAGS = -c $(INCPATH) $(DEFINES)

ifeq ($(ARCH),64)
DEFINES+=-DDSI_64BIT
CFLAGS+=-m64
LIBPATH=$(DPK_BASE)/64
LFLAGS=-m64
endif

ifeq ($(ARCH),32)
CFLAGS+=-m32
LIBPATH=$(DPK_BASE)/32
LFLAGS=-m32
endif

INCPATH = -I$(DPK_BASE)/INC -I. -I/usr/include/ss7dpk -I/usr/local/lib/erlang/lib/erl_interface-3.10.4/include
BINPATH = /opt

LIBS = -L$(LIBPATH) -lgctlib -L/usr/local/lib/erlang/lib/erl_interface-3.10.4/lib -lerl_interface -lei -lpthread

SYSLIBS =

.c.o :
	$(COMPILER) $(CFLAGS) $(DEFINES) $<

.cpp.o :
	$(COMPILER) $(CFLAGS) $(DEFINES) $<


TARGET = $(BINPATH)/map_user

all :   $(TARGET)

clean:
	rm -rf *.o
	rm -rf $(TARGET)

OBJS = map_user.o


#map_user.o: map_user.c
#	gcc -c -I/opt/DSI/INC -I/usr/local/lib/erlang/lib/erl_interface-3.10.4/include

map_user: map_user.c
	gcc map_user.c $(DEFINES) $(LFLAGS) -I/opt/DSI/INC -I/usr/local/lib/erlang/lib/erl_interface-3.10.4/include -L$(LIBPATH) -lgctlib -L/usr/local/lib/erlang/lib/erl_interface-3.10.4/lib -lerl_interface -lei -lpthread -o map_user -Wall -Wextra


