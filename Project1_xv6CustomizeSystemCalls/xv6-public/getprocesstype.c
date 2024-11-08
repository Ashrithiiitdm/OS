#include "types.h"
#include "stat.h"
#include "user.h"
#include "fcntl.h"

int main(int argc, char *argv[]){
	int type = get_process_type();
	if(type == -1){
		printf(1, "Error: Invalid PID\n");
		exit();
	}
    printf(1, "Process type: %d\n", type);
	exit();
}
