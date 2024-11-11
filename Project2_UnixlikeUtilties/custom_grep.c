#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

void print_usage() {
    printf("Usage: cgrep [-i] [-n] <search_term> <filename>\n");
    printf("  -i : Case-insensitive search\n");
    printf("  -n : Show line numbers\n");
}

// Convert both strings to lowercase for case-insensitive comparison
int case_insensitive_search(const char *line, const char *search_term) {
    char *line_lower = strdup(line);
    char *search_term_lower = strdup(search_term);
    
    if (!line_lower || !search_term_lower) {
        perror("Memory allocation failed");
        exit(1);
    }
    
    for (int i = 0; line_lower[i]; i++) line_lower[i] = tolower(line_lower[i]);
    for (int i = 0; search_term_lower[i]; i++) search_term_lower[i] = tolower(search_term_lower[i]);

    int result = strstr(line_lower, search_term_lower) != NULL;

    free(line_lower);
    free(search_term_lower);
    return result;
}

int contains(const char *line, const char *search_term, int case_insensitive) {
    if (case_insensitive) {
        return case_insensitive_search(line, search_term);
    } else {
        return strstr(line, search_term) != NULL;
    }
}

int main(int argc, char *argv[]) {
    if (argc < 3) {
        print_usage();
        return 1;
    }

    int case_insensitive = 0;
    int show_line_numbers = 0;
    char *search_term;
    char *filename;

    int arg_index = 1;

    // Parse flags
    while (argv[arg_index][0] == '-') {
        if (strcmp(argv[arg_index], "-i") == 0) {
            case_insensitive = 1;
        } else if (strcmp(argv[arg_index], "-n") == 0) {
            show_line_numbers = 1;
        } else {
            print_usage();
            return 1;
        }
        arg_index++;
    }

    // Check if we have enough arguments left for search_term and filename
    if (argc - arg_index != 2) {
        print_usage();
        return 1;
    }

    search_term = argv[arg_index];
    filename = argv[arg_index + 1];

    FILE *file = fopen(filename, "r");
    if (!file) {
        perror("Error opening file");
        return 1;
    }

    char line[1024];
    int line_number = 1;
    int match_found = 0;
    while (fgets(line, sizeof(line), file)) {
        if (contains(line, search_term, case_insensitive)) {
            match_found = 1;
            if (show_line_numbers) {
                printf("%d:", line_number);
            }
            printf("%s", line);
        }
        line_number++;
    }

    if (!match_found) {
        printf("No matches found.\n");
    }else{
        printf("\n");
    }

    fclose(file);
    return 0;
}