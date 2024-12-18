#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define GREEN "\x1b[32m"
#define RESET "\x1b[0m"

void cat_show(const char *file) {
    FILE *fptr = fopen(file, "r");
    if (fptr == NULL) {
        printf("custom_cat: No such file or directory\n");
        exit(1);
    }

    char ch;
    int line_num = 1;

    // Printing the first line number.
    printf(GREEN "%d " RESET, line_num);

    // Read character by character and display it.
    while ((ch = fgetc(fptr)) != EOF) {
        putchar(ch);

        // For new line, printing the line number.
        if (ch == '\n') {
            line_num++;
            printf(GREEN "%d " RESET, line_num);
        }
    }

    printf("\n");
    // Close the file after displaying the contents.
    fclose(fptr);
}

void cat_append(const char *file1, const char *file2) {
    FILE *fptr1 = fopen(file1, "r");
    if (fptr1 == NULL) {
        printf("custom_cat: File %s does not exist.\n", file1);
        exit(1);
    }

    // Opening file2 in append mode.
    FILE *fptr2 = fopen(file2, "a");
    if (fptr2 == NULL) {
        printf("custom_cat: File %s does not exist.\n", file2);
        // Close the first file before exiting
        fclose(fptr1); 
        exit(1);
    }

    char ch;

    // Read character by character from file1 and append it to file2.
    while ((ch = fgetc(fptr1)) != EOF) {
        fputc(ch, fptr2);
    }

    // Close both files after appending.
    fclose(fptr1);
    fclose(fptr2);
}

int main(int argc, char *argv[]) {
    if (argc < 2) {
        printf("Usage:\n");
        printf("custom_cat <file>  -  Display contents\n");
        printf("custom_cat <file1> to <file2> -  Append contents of file1 to file2\n");
        return 1;
    }

    // Handle append case with to
    if (argc == 4 && strcmp(argv[2], "to") == 0) {
        cat_append(argv[1], argv[3]);
    }
    
    // Handle displaying file contents
    else if (argc == 2) {
        cat_show(argv[1]);
    }
    else {
        printf("Invalid arguments.\n");
        return 1;
    }

    return 0;
}
