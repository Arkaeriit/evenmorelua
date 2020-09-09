FLAGS = -Wall -Werror
CL = -lcursedLua
LUA = -llua -lm -ldl

all : evenmorelua

evenmorelua : main.o readSTDIN.o evenmore.lua evenmore.luac
	gcc main.o readSTDIN.o $(CL) $(LUA) -o evenmorelua

evenmore.luac : evenmore.lua
	luac -o evenmore.luac evenmore.lua

main.o : main.c
	gcc -c main.c $(FLAGS) -o main.o

readSTDIN.o : readSTDIN.c readSTDIN.h
	gcc -c readSTDIN.c $(FLAGS) -o readSTDIN.o

clean :
	rm -f *.o
	rm -f *.luac
	rm -f evenmorelua

test : clean evenmorelua
	./evenmorelua main.c

install : evenmorelua evenmore.luac
	mkdir -p /usr/local/share/evenmorelua
	cp -f evenmorelua /usr/local/bin
	cp -f evenmore.luac /usr/local/share/evenmorelua
	
uninstall : clean
	rm -fR /usr/local/share/evenmorelua
	rm -f /usr/local/bin/evenmorelua
	
