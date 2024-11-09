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
    
	if(type == 3){
		printf(1, "Process type: init\n");
	}
	else if(type == 1){
		printf(1, "Process type: zombie\n");
	}
	else if(type == 0){
		printf(1, "Process type: orphan\n");
	}
	else if(type == 2){
		printf(1, "Process type: general\n");
	}

	exit();
}
