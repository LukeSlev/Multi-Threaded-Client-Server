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
allFiles := Makefile  timer.h common.h
objects :=
headers := timer.h common.h
CFLAGS :=  -Wall -lm
threadSan := -fsanitize=thread -g
LDFLAGS= -pthread -lpthread
DEBUGFLAG := -g
CC := gcc
# ------------------------------------------------------------

server: $(headers) server.o
	$(CC) $(LDFLAGS) $(DEBUGFLAG) $(CFLAGS) -o server

client: $(headers)  client.o
	$(CC) $(LDFLAGS) $(CFLAGS) -o client

attacker: $(headers) attacker.o
	$(CC) $(LDFLAGS) $(CFLAGS) -o attacker

client.o: client.c
	$(CC) $(CFLAGS) -c client.c

server.o: server.c
	$(CC) $(CFLAGS) -c server.c

attacker.o: attacker.c
	$(CC) $(CFLAGS) -c attacker.c

tar:
	touch $(target).tar.gz
	mv $(target).tar.gz  x$(target).tar.gz
	tar -cvf $(target).tar $(allFiles)
	gzip $(target).tar

clean:
	rm *.o client server attacker
