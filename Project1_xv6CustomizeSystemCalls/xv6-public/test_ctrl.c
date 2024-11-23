#include "types.h"
#include "stat.h"
#include "user.h"

void
infinite_loop()
{
    int i = 0;
    printf(1, "Infinite loop started. Press Ctrl+C to interrupt.\n");
    while (1) {
        printf(1, "Running... %d\n", i++);
        sleep(100);  // Sleep to make output visible
    }
}

int
main(int argc, char *argv[])
{
    // Start an infinite loop
    infinite_loop();

    // Should never reach here if Ctrl+C works correctly
    printf(1, "This should not print if Ctrl+C interrupts successfully.\n");
    exit();
}
