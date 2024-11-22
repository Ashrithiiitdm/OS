# Question-1 Adding/Modfying System Calls in xv6 operating system
The documentation for this question is present in docs.pdf in the main repository.
# Question-2 Unix like utilities from scratch
The repository Project2_UnixlikeUtilities contains  Unix-like commands implemented from scratch. Each utility is written in C and can be compiled and run on Linux-based operating systems.

## Getting Started

Follow these instructions to compile and run the utilities.

### Prerequisites

- Linux-based operating system (e.g., Ubuntu, Fedora)
- GCC (GNU Compiler Collection)
- `make` utility

To verify if the required tools are installed, run:

```bash
gcc --version
make --version
```

If they are not installed, you can install them (on Ubuntu) using:

```bash
sudo apt update
sudo apt install build-essential
```

## Compilation Instructions
Clone this repository to your local machine and navigate to the Project2_UnixlikeUtilities directory.

```bash
git clone https://github.com/Ashrithiiitdm/OS.git
cd Project2_UnixlikeUtilities
```

Build all the utilities using the provided Makefile by running:
```bash
make
```
This command will compile all the source files and create executive binaries for the utilities in the folder.

To install the utilities into your local system:
```bash
make install
```
This will install the unix-like commands into your local system
