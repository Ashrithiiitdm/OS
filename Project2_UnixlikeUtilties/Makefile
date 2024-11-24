# Makefile for custom_ls

CC = gcc
CFLAGS = -Wall
TARGETS = custom_ls custom_wc custom_cp custom_rm empty myshell custom_cat custom_mv custom_grep custom_tail custom_diff custom_head custom_cleaner custom_find custom_find_in_given_folder custom_hwatch custom_log custom_tree
INSTALL_DIR = /usr/local/bin

all: $(TARGETS)

custom_ls: custom_ls.c
	$(CC) $(CFLAGS) -o custom_ls custom_ls.c 

custom_wc: custom_wc.c
	$(CC) $(CFLAGS) -o custom_wc custom_wc.c

custom_cp: custom_cp.c
	$(CC) $(CFLAGS) -o custom_cp custom_cp.c

custom_cat: custom_cat.c
	$(CC) $(CFLAGS) -o custom_cat custom_cat.c

custom_rm: custom_rm.c
	$(CC) $(CFLAGS) -o custom_rm custom_rm.c

custom_mv: custom_mv.c
	$(CC) $(CFLAGS) -o custom_mv custom_mv.c

empty: empty.c
	$(CC) $(CFLAGS) -o empty empty.c

myshell: shell.c
	$(CC) $(CFLAGS) -o myshell shell.c

custom_grep: custom_grep.c
	$(CC) $(CFLAGS) -o custom_grep custom_grep.c

custom_tail: custom_tail.c
	$(CC) $(CFLAGS) -o custom_tail custom_tail.c

custom_head: custom_head.c
	$(CC) $(CFLAGS) -o custom_head custom_head.c

custom_diff: custom_diff.c
	$(CC) $(CFLAGS) -o custom_diff custom_diff.c

custom_cleaner: custom_cleaner.c
	$(CC) $(CFLAGS) -o custom_cleaner custom_cleaner.c

custom_find: custom_find.c
	$(CC) $(CFLAGS) -o custom_find custom_find.c	

custom_find_in_given_folder: custom_find_in_given_folder.c
	$(CC) $(CFLAGS) -o custom_find_in_given_folder custom_find_in_given_folder.c 

custom_hwatch: custom_hwatch.c
	$(CC) $(CFLAGS) -o custom_hwatch custom_hwatch.c

custom_log: custom_log.c
	$(CC) $(CFLAGS) -o custom_log custom_log.c

custom_tree: custom_tree.c
	$(CC) $(CFLAGS) -o custom_tree custom_tree.c				

# Rule to install the custom_ls program to /usr/local/bin
install: $(TARGETS)
	sudo mv $(TARGETS) $(INSTALL_DIR)

# Rule to clean up compiled files
clean:
	rm -f $(TARGETS)
