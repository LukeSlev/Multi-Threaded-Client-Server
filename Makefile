# ------------------------------------------------------------
# Makefile: Makefile for Lab 2
#   author: Luke Slevinsky, 1453199
#						Logan McDonald, 1401297
#
# Usage: make  // compiles the program server program
#				 make main1   // this compiles the single read-write lock version
#				 make main2    // this compiles the multiple mutex version
#				 make main3    // this compiles the single mutex version
#        make tar   	 // create a 'tar.gz' archive of 'allFiles'
#				 make client // compile client
#				 make attacker // compile attacker
#        make clean 	 // remove unneeded files
# ------------------------------------------------------------

target :=		a1
allFiles := Makefile  timer.h common.h server.c client.c attacker.c test.sh main1.c main2.c stats.py main3.c
objects :=
headers := timer.h common.h
CFLAGS :=  -Wall -lm
threadSan := -fsanitize=thread -g
LDFLAGS= -pthread -lpthread
DEBUGFLAG := -g
CC := gcc
# ------------------------------------------------------------

default: $(headers) server.o
	$(CC) $(LDFLAGS) $(DEBUGFLAG) $(CFLAGS) -o main server.o

main1: $(headers) main1.o
	$(CC) $(LDFLAGS) $(DEBUGFLAG) $(CFLAGS) -o main1 main1.o

main2: $(headers) main2.o
	$(CC) $(LDFLAGS) $(DEBUGFLAG) $(CFLAGS) -o main2 main2.o

main3: $(headers) main3.o
	$(CC) $(LDFLAGS) $(DEBUGFLAG) $(CFLAGS) -o main3 main3.o

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

main1.o: main1.c
	$(CC) $(CFLAGS) main1.c -c

main2.o: main2.c
	$(CC) $(CFLAGS) main2.c -c

main3.o: main3.c
	$(CC) $(CFLAGS) main3.c -c

tar:
	touch $(target).tar.gz
	mv $(target).tar.gz  x$(target).tar.gz
	tar -cvf $(target).tar $(allFiles)
	gzip $(target).tar

clean:
	rm *.o client main attacker main1 main2 main3
