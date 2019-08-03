
all : evenmorelua

evenmorelua : main.o cursedLua.o evenmore.lua
	gcc main.o cursedlua.o -lncurses -llua -lm -ldl -o evenmorelua

main.o : main.c cursedLua.h
	gcc -c main.c -o main.o

cursedLua.o : cursedLua.c cursedLua.h
	gcc -c cursedLua.c -o cursedlua.o

clean :
	rm -f *.o
	rm -f evenmorelua

test : clean evenmorelua
	./evenmorelua main.c

