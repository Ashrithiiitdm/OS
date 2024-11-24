#include "types.h"
#include "stat.h"
#include "user.h"

int main() {
    int pid = getpid();
    int priority = get_priority(pid);
    
    printf(1, "Process: PID = %d, Priority = %d\n", pid, priority);

    printf(1,"Setting the priority\n");    
    set_priority(pid, 20);

    priority = get_priority(pid);
    
    printf(1, "Process: PID = %d, Priority = %d\n", pid, priority);
    
    exit();
}
