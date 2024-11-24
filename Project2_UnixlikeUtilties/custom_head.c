#include <stdio.h>
#include <stdlib.h>

#define BUFFER_SIZE 1024

void custom_head(const char *file_name, int num_lines) {
    FILE *file = fopen(file_name, "r");

    if (!file) {
        perror("Error opening file");
        return;
    }

    char line[BUFFER_SIZE];
    int line_count = 0;

    while (fgets(line, BUFFER_SIZE, file)) {
        printf("%s", line);
        line_count++;

        // Stop after printing the specified number of lines
        if (line_count >= num_lines) {
            break;
        }
    }

    fclose(file);
}

// Example usage
int main(int argc, char *argv[]) {
    if (argc != 3) {
        printf("Usage: %s <filename> <number_of_lines>\n", argv[0]);
        return 1;
    }

    const char *file_name = argv[1];
    int num_lines = atoi(argv[2]);

    if (num_lines <= 0) {
        printf("Error: Number of lines must be a positive integer.\n");
        return 1;
    }

    custom_head(file_name, num_lines);
    return 0;
}
