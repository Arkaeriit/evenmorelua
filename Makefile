# Flags
FLAGS := -Wall -Werror
NC := -lncursesw
LUA := -llua -lm -ldl  

# Files lists
C_SRC := main.c cursedLua.c readSTDIN.c
C_OBJS := $(C_SRC:%.c=%.o)
LUA_SRC := evenmore.lua
LUA_OBJS := $(LUA_SRC:%.lua=%.luac)

# Install targets
TARGET_DIR := /usr/local/share/evenmorelua
TARGET_DIR_BIN := /usr/local/bin
TARGET_BIN := $(TARGET_DIR_BIN)/evenmorelua

# Commands
CC := gcc
CP := cp -f
RM := rm -rf

all : evenmorelua.bin

%.luac : %.lua
	luac -o $@ $<

%.o : %.c
	$(CC) -c $< $(FLAGS) -o $@

evenmorelua.bin : $(C_OBJS) $(LUA_OBJS)
	$(CC) $(C_OBJS) $(FLAGS) $(NC) $(LUA) -o $@

install :
	mkdir -p $(TARGET_DIR) $(TARGET_DIR_BIN)
	$(CP) $(LUA_OBJS) $(TARGET_DIR)
	$(CP) evenmorelua.bin $(TARGET_BIN)

uninstall :
	$(RM) $(TARGET_DIR)
	$(RM) $(TARGET_BIN)

clean : 
	$(RM) *.bin
	$(RM) *.o
	$(RM) *.luac

