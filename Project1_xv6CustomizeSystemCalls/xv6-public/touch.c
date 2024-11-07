#include "user.h"
#include "stat.h"
#include "types.h"
#include<stdio.h>

int main(int argc, char *argv[]){
	FILE *fptr;
	fptr = fopen(argv[1], "w");
	fclose(fptr);
	exit();
	return 0;
}

