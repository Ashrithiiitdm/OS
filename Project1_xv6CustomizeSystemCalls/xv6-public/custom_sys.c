#include "types.h"
#include "user.h"
#include "fcntl.h"

int main(int argc, char *argv[]){
    printf(1, "Total no of system calls is %d", calls());
    exit();
}