#
# Makefile for helper utilities
#
CFLAGS += -Wall

PRODUCTS = check-utf8 xpatheval

all: $(PRODUCTS)

xpatheval: xpatheval.c
	$(CC) $(CFLAGS) `xml2-config --cflags` -o $@ $^ `xml2-config --libs`

clean:
	$(RM) $(PRODUCTS)

.PHONY: all clean
