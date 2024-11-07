# Makefile for custom_ls

CC = gcc
CFLAGS = -Wall
TARGET = custom_ls
INSTALL_DIR = /usr/local/bin

# Rule to build the custom_ls program
$(TARGET): custom_ls.c
	$(CC) $(CFLAGS) -o $(TARGET) custom_ls.c 

# Rule to install the custom_ls program to /usr/local/bin
install: $(TARGET)
	sudo cp $(TARGET) $(INSTALL_DIR)

# Rule to clean up compiled files
clean:
	rm -rf ./custom_ls
	rm -f $(TARGET)
