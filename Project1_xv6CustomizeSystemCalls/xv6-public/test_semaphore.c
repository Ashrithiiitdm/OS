#include "types.h"
#include "user.h"

#define SEM_MUTEX1 0
#define SEM_MUTEX2 1

void thread_func1() {
    printf(1, "Statement A1\n");
    sem_wait(SEM_MUTEX1, 1);
    printf(1, "Statement A2\n");
    sem_signal(SEM_MUTEX2, 1);
}

void thread_func2() {
    printf(1, "Statement B1\n");
    sem_signal(SEM_MUTEX1, 1);
    sem_wait(SEM_MUTEX2, 1);
    printf(1, "Statement B2\n");
}

int
main(void)
{
    // Initialize semaphores to 0
    sem_init(SEM_MUTEX1, 0);
    sem_init(SEM_MUTEX2, 0);

    // Fork first thread
    if (fork() == 0) {
        thread_func1();
        exit();
    }

    // Fork second thread
    if (fork() == 0) {
        thread_func2();
        exit();
    }

    // Wait for both child processes
    wait();
    wait();

    sem_destroy(SEM_MUTEX1);
    sem_destroy(SEM_MUTEX2);

    exit();
}