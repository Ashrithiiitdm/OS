# Makefile for custom_ls

CC = gcc
CFLAGS = -Wall
TARGETS = custom_ls custom_wc custom_cp
INSTALL_DIR = /usr/local/bin

all: $(TARGETS)

custom_ls: custom_ls.c
	$(CC) $(CFLAGS) -o custom_ls custom_ls.c 

custom_wc: custom_wc.c
	$(CC) $(CFLAGS) -o custom_wc custom_wc.c

custom_cp: custom_cp.c
	$(CC) $(CFLAGS) -o custom_cp custom_cp.c

# Rule to install the custom_ls program to /usr/local/bin
install: $(TARGETS)
	sudo cp $(TARGETS) $(INSTALL_DIR)

# Rule to clean up compiled files
clean:
	rm -f $(TARGETS)
