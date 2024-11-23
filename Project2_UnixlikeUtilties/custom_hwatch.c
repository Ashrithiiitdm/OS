#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/sysinfo.h>
#include <sys/statvfs.h>
#include <time.h>

// Function to get CPU usage
void get_cpu_usage(float *cpu_usage) {
    static long prev_idle = 0, prev_total = 0;
    long idle, total, diff_idle, diff_total;

    FILE *fp = fopen("/proc/stat", "r");
    if (!fp) {
        perror("fopen");
        *cpu_usage = -1; // Error indicator
        return;
    }

    char buffer[128];
    fgets(buffer, sizeof(buffer), fp); // Read the first line
    fclose(fp);

    long user, nice, system, idle_time, iowait, irq, softirq, steal;
    sscanf(buffer, "cpu %ld %ld %ld %ld %ld %ld %ld %ld",
           &user, &nice, &system, &idle_time, &iowait, &irq, &softirq, &steal);

    idle = idle_time + iowait;
    total = user + nice + system + idle + iowait + irq + softirq + steal;

    diff_idle = idle - prev_idle;
    diff_total = total - prev_total;

    *cpu_usage = (100.0 * (diff_total - diff_idle)) / diff_total;

    prev_idle = idle;
    prev_total = total;
}

// Function to get memory usage
void get_memory_usage(long *total_mem, long *free_mem) {
    struct sysinfo info;
    if (sysinfo(&info) == -1) {
        perror("sysinfo");
        *total_mem = -1;
        *free_mem = -1;
        return;
    }

    *total_mem = info.totalram / 1024 / 1024; // Convert to MB
    *free_mem = info.freeram / 1024 / 1024;   // Convert to MB
}

// Function to get disk usage
void get_disk_usage(const char *path, long *total_disk, long *free_disk) {
    struct statvfs stat;
    if (statvfs(path, &stat) == -1) {
        perror("statvfs");
        *total_disk = -1;
        *free_disk = -1;
        return;
    }

    *total_disk = (stat.f_blocks * stat.f_frsize) / 1024 / 1024; // Convert to MB
    *free_disk = (stat.f_bfree * stat.f_frsize) / 1024 / 1024;   // Convert to MB
}

// Main hardware monitoring function
void monitor_hardware(int interval) {
    while (1) {
        float cpu_usage = 0.0;
        long total_mem = 0, free_mem = 0;
        long total_disk = 0, free_disk = 0;

        // Get CPU usage
        get_cpu_usage(&cpu_usage);

        // Get memory usage
        get_memory_usage(&total_mem, &free_mem);

        // Get disk usage (root partition "/")
        get_disk_usage("/", &total_disk, &free_disk);

        // Clear screen
        printf("\033[H\033[J");

        // Print hardware usage
        printf("===== Hardware Resource Monitor =====\n");
        if (cpu_usage >= 0)
            printf("CPU Usage: %.2f%%\n", cpu_usage);
        else
            printf("CPU Usage: Error fetching data.\n");

        if (total_mem > 0 && free_mem > 0)
            printf("Memory Usage: %ld MB used / %ld MB total\n", total_mem - free_mem, total_mem);
        else
            printf("Memory Usage: Error fetching data.\n");

        if (total_disk > 0 && free_disk > 0)
            printf("Disk Usage: %ld MB used / %ld MB total (Root Partition)\n",
                   total_disk - free_disk, total_disk);
        else
            printf("Disk Usage: Error fetching data.\n");

        printf("=====================================\n");

        // Sleep for the specified interval
        sleep(interval);
    }
}

int main(int argc, char *argv[]) {
    int interval = 1; // Default update interval: 1 second

    // Parse command-line arguments
    if (argc > 1) {
        interval = atoi(argv[1]);
        if (interval <= 0) {
            fprintf(stderr, "Invalid interval. Using default: 1 second.\n");
            interval = 1;
        }
    }

    printf("Starting hardware monitor with %d-second interval...\n", interval);
    monitor_hardware(interval);

    return 0;
}
