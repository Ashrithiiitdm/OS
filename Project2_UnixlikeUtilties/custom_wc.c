#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#define N 4096

char buff[N];

void words_characters(FILE *fptr, int arr[]){
    int words = 0;
    int characters = 0;
    int lines = 0;

    while(fgets(buff, N, fptr) != NULL){
        lines++;
        characters += strlen(buff);
        for(int i = 0; i < strlen(buff); i++){
            if (buff[i] == ' ' || buff[i] == '\n' || buff[i] == '\t'){
                words++;
            }
        }
    }
    arr[0] = lines;
    arr[1] = words;
    arr[2] = characters;
}

int main(int argc, char *argv[]){
    FILE *fptr;
    int count_arr[3];
    int total_words = 0;
    int total_characters = 0;
    int total_lines = 0;

    if(argc == 1){
        //Help instructions.
        printf("Usage: custom_wc <filename> [<filename2> ...]\n");
        return 1;
    }

    printf("+-------------------+--------+--------+------------+\n");
    printf("| File              | Lines  | Words  | Characters |\n");
    printf("+-------------------+--------+--------+------------+\n");

    for(int i = 1; i < argc; i++){
        fptr = fopen(argv[i], "r");
        if(fptr == NULL){
            printf("| %-17s | %6s | %6s | %10s |\n", argv[i], "Error", "Error", "Error");
            continue;
        }

        words_characters(fptr, count_arr);
        
        total_lines += count_arr[0];
        total_words += count_arr[1];
        total_characters += count_arr[2];

        // Printing words, characters and lines for each file
        printf("| %-17s | %6d | %6d | %10d |\n", argv[i], count_arr[0], count_arr[1], count_arr[2]);
        
        fclose(fptr);
    }

    //Printing total words, characters and lines at the end.
    printf("+-------------------+--------+--------+------------+\n");
    printf("| %-17s | %6d | %6d | %10d |\n", "Total", total_lines, total_words, total_characters);
    printf("+-------------------+--------+--------+------------+\n");

    return 0;
}
