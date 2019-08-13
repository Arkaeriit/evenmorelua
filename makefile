
all : evenmorelua

evenmorelua : main.o cursedLua.o evenmore.lua evenmore.luac
	gcc main.o cursedlua.o -llua -lm -ldl -lncursesw -o evenmorelua

evenmore.luac : evenmore.lua
	luac -o evenmore.luac evenmore.lua

main.o : main.c cursedLua.h
	gcc -c main.c -o main.o

cursedLua.o : cursedLua.c cursedLua.h
	gcc -c cursedLua.c -o cursedlua.o

clean :
	rm -f *.o
	rm -f *.luac
	rm -f evenmorelua

test : clean evenmorelua
	./evenmorelua main.c

install : evenmorelua evenmore.luac
	mkdir /usr/local/share/evenmorelua
	cp evenmorelua /usr/local/bin
	cp evenmore.luac /usr/local/share/evenmorelua
	
uninstall : clean
	rm -fR /usr/local/share/evenmorelua
	rm -f /usr/local/bin/evenmorelua
	
