#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define BUFFER_SIZE 1024

void custom_diff(const char *file1_name, const char *file2_name) {
    FILE *file1 = fopen(file1_name, "r");
    FILE *file2 = fopen(file2_name, "r");

    if (!file1 || !file2) {
        perror("Error opening files");
        if (file1) fclose(file1);
        if (file2) fclose(file2);
        return;
    }

    char line1[BUFFER_SIZE], line2[BUFFER_SIZE];
    int line_number = 1;
    int differences_found = 0;

    while (fgets(line1, BUFFER_SIZE, file1) || fgets(line2, BUFFER_SIZE, file2)) {
        if (!fgets(line1, BUFFER_SIZE, file1)) strcpy(line1, "");
        if (!fgets(line2, BUFFER_SIZE, file2)) strcpy(line2, "");

        if (strcmp(line1, line2) != 0) {
            printf("Difference at line %d:\n", line_number);
            printf("File 1: %s", line1[0] ? line1 : "(empty line)\n");
            printf("File 2: %s", line2[0] ? line2 : "(empty line)\n");
            differences_found++;
        }

        line_number++;
    }

    if (!differences_found) {
        printf("Files are identical.\n");
    }

    fclose(file1);
    fclose(file2);
}

// Example usage
int main(int argc, char *argv[]) {
    if (argc != 3) {
        printf("Usage: %s <file1> <file2>\n", argv[0]);
        return 1;
    }

    custom_diff(argv[1], argv[2]);
    return 0;
}
