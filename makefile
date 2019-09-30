
all : evenmorelua

evenmorelua : main.o cursedLua.o readSTDIN.o evenmore.lua evenmore.luac
	gcc main.o cursedlua.o readSTDIN.o -llua -lm -ldl -lncursesw -o evenmorelua

evenmore.luac : evenmore.lua
	luac -o evenmore.luac evenmore.lua

main.o : main.c cursedLua.h
	gcc -c main.c -Wall -o main.o

cursedLua.o : cursedLua.c cursedLua.h
	gcc -c cursedLua.c -Wall -o cursedlua.o

readSTDIN.o : readSTDIN.c readSTDIN.h
	gcc -c readSTDIN.c -Wall -o readSTDIN.o

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
	
