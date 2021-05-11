OPTIONS = -Wall -Wextra -shared -fPIC -o 
LIBFLAGS = -I/usr/include/lua5.1 
OUTPUT   = regexlib.so
SRC      = regexlib.c
CC       = gcc

all:
	$(CC) $(OPTIONS)$(OUTPUT) $(LIBFLAGS) $(SRC)
