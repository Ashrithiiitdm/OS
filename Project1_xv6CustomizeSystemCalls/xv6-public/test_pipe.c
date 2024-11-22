#include "types.h"
#include "stat.h"
#include "user.h"
#include "fcntl.h"

#define PIPESIZE 512

int memcmp(const void *s1, const void *s2, unsigned int  n) {
    const unsigned char *u1 = s1, *u2 = s2;
    for (unsigned int  i = 0; i < n; i++) {
        if (u1[i] != u2[i])
            return u1[i] - u2[i];
    }
    return 0;
}

void test_pipe_basic() {
  int fds[2];
  char write_data[] = "Hello, xv6 pipe!";
  char read_data[sizeof(write_data)];
  
  printf(1, "Starting basic pipe test...\n");

  if (pipe(fds) < 0) {
    printf(1, "pipe() failed\n");
    exit();
  }

  if (write(fds[1], write_data, sizeof(write_data)) != sizeof(write_data)) {
    printf(1, "write() failed\n");
    exit();
  }

  if (read(fds[0], read_data, sizeof(read_data)) != sizeof(read_data)) {
    printf(1, "read() failed\n");
    exit();
  }

  printf(1,"%s\n",read_data);

  if (strcmp(write_data, read_data) != 0) {
    printf(1, "Data mismatch: '%s' != '%s'\n", write_data, read_data);
    exit();
  }

  printf(1, "Basic pipe test passed!\n");

  close(fds[0]);
  close(fds[1]);
}

void test_pipe_full() {
  int fds[2];
  char write_data[PIPESIZE];
  char read_data[PIPESIZE];
  int i;

  printf(1, "Starting pipe full test...\n");

  if (pipe(fds) < 0) {
    printf(1, "pipe() failed\n");
    exit();
  }

  // Fill the pipe
  for (i = 0; i < 26; i++) {
    write_data[i] = 'A' + (i % 26);
  }

  if (write(fds[1], write_data, PIPESIZE) == PIPESIZE) {
    printf(1, "Failed to write full pipe\n");
    exit();
  }

  // Attempt to write beyond the limit (should block)
  if (write(fds[1], "X", 1) != -1) {
    printf(1, "Write to full pipe did not block\n");
    exit();
  }

  // Read from pipe to make space
  if (read(fds[0], read_data, PIPESIZE) != PIPESIZE) {
    printf(1, "Failed to read full pipe\n");
    exit();
  }

  if (memcmp(write_data, read_data, PIPESIZE) != 0) {
    printf(1, "Data mismatch in full pipe test\n");
    exit();
  }

  printf(1, "Pipe full test passed!\n");

  close(fds[0]);
  close(fds[1]);
}

void test_pipe_close() {
  int fds[2];
  char buf[16];

  printf(1, "Starting pipe close test...\n");

  if (pipe(fds) < 0) {
    printf(1, "pipe() failed\n");
    exit();
  }

  close(fds[1]); // Close write end

  if (read(fds[0], buf, sizeof(buf)) != 0) { // Reading from pipe after write end closed
    printf(1, "Read from closed pipe failed\n");
    exit();
  }

  close(fds[0]); // Close read end

  printf(1, "Pipe close test passed!\n");
}

int main(void) {
  test_pipe_basic();
  test_pipe_full();
  test_pipe_close();
  exit();
}
