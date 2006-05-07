#
# Makefile for helper utilities
#

CFLAGS += -Wall

all: check-utf8 xpatheval

xpatheval: xpatheval.c
	$(CC) $(CFLAGS) `xml2-config --cflags` -o xpatheval xpatheval.c `xml2-config --libs`
