#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define BUFFER_SIZE 1024

void custom_tail(const char *file_name, int num_lines) {
    FILE *file = fopen(file_name, "r");
    if (!file) {
        perror("Error opening file");
        return;
    }

    // Allocate memory for storing lines
    char **buffer = (char **)malloc(num_lines * sizeof(char *));
    if (!buffer) {
        perror("Error allocating buffer");
        fclose(file);
        return;
    }

    for (int i = 0; i < num_lines; i++) {
        buffer[i] = (char *)malloc(BUFFER_SIZE);
        if (!buffer[i]) {
            perror("Error allocating buffer line");
            for (int j = 0; j < i; j++) {
                free(buffer[j]);
            }
            free(buffer);
            fclose(file);
            return;
        }
        buffer[i][0] = '\0'; // Initialize empty lines
    }

    // Read the file line by line
    int count = 0, index = 0;
    while (fgets(buffer[index], BUFFER_SIZE, file)) {
        index = (index + 1) % num_lines; // Circular buffer logic
        count++;
    }
    fclose(file);

    // Determine starting point and number of lines to print
    int start = count < num_lines ? 0 : index;
    int lines_to_print = count < num_lines ? count : num_lines;

    for (int i = 0; i < lines_to_print; i++) {
        printf("%s", buffer[(start + i) % num_lines]);
    }

    printf("\n");

    // Free allocated memory
    for (int i = 0; i < num_lines; i++) {
        free(buffer[i]);
    }
    free(buffer);
}

int main(int argc, char *argv[]) {
    if (argc != 3) {
        printf("Usage: %s <file_name> <number_of_lines>\n", argv[0]);
        return 1;
    }

    int num_lines = atoi(argv[2]);
    if (num_lines <= 0) {
        printf("Error: Number of lines must be greater than 0.\n");
        return 1;
    }

    custom_tail(argv[1], num_lines);
    return 0;
}

