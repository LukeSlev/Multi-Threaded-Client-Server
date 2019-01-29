# ------------------------------------------------------------
# Makefile: Makefile for Lab 2
#   author: Luke Slevinsky, 1453199
#						Logan McDonald, 1401297
#
# Usage: make  // compiles the program
#				 make sanitize // compiles the program with thread sanitization flags
#        make tar   	 // create a 'tar.gz' archive of 'allFiles'
#				 make matrixgen // compile matrixgen
#				 make serialtester // compile serialtester
#        make clean 	 // remove unneeded files
# ------------------------------------------------------------

target :=		a1
allFiles := Makefile  timer.h common.h server.c client.c attacker.c
objects :=
headers := timer.h common.h
CFLAGS :=  -Wall
threadSan := -fsanitize=thread -g
LDFLAGS= -pthread -lpthread
DEBUGFLAG := -g
CC := gcc
# ------------------------------------------------------------

server: $(headers) server.o
	$(CC) $(LDFLAGS) $(DEBUGFLAG) $(CFLAGS) -o server server.o

client: $(headers)  client.o
	$(CC) $(LDFLAGS) $(CFLAGS) -o client client.o

attacker: $(headers) attacker.o
	$(CC) $(LDFLAGS) $(CFLAGS) -o attacker attacker.o

client.o: client.c
	$(CC) $(CFLAGS) client.c -c

server.o: server.c
	$(CC) $(CFLAGS)  server.c -c

attacker.o: attacker.c
	$(CC) $(CFLAGS) attacker.c -c

tar:
	touch $(target).tar.gz
	mv $(target).tar.gz  x$(target).tar.gz
	tar -cvf $(target).tar $(allFiles)
	gzip $(target).tar

clean:
	rm *.o client server attacker
