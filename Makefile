
SYS := $(shell gcc -dumpmachine)


ifneq (, $(findstring linux, $(SYS)))
LIBS = -lpcap -lm -lrt
endif

ifneq (, $(findstring darwin, $(SYS)))
LIBS = -lpcap -lm
endif

ifneq (, $(findstring mingw, $(SYS)))
LIBS = -lwpcap
endif

ifneq (, $(findstring cygwin, $(SYS)))
LIBS = -lwpcap
endif


INCLUDES = -I.
DEFINES = 
CC = gcc
CFLAGS = -g $(INCLUDES) $(DEFINES) -Wall -O3 -rdynamic -Wno-format
.SUFFIXES: .c .cpp

tmp/%.o: src/%.c
	$(CC) $(CFLAGS) -c $< -o $@

SRC = $(wildcard src/*.c)
OBJ = $(addprefix tmp/, $(notdir $(addsuffix .o, $(basename $(SRC))))) 

bin/masscan: $(OBJ)
	$(CC) $(CFLAGS) -o $@ $(OBJ) $(LIBS)

clean:
	rm tmp/*.o
	rm bin/masscan

regress: bin/masscan
	bin/masscan --selftest

install: bin/masscan
	echo "No install, binary is bin/masscan"
	
default: bin/masscan