
_getprocesstype:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "types.h"
#include "stat.h"
#include "user.h"
#include "fcntl.h"

int main() {
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	push   -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	53                   	push   %ebx
   e:	51                   	push   %ecx
    int zombie_pid, orphan_pid;

    // Create a zombie process
    zombie_pid = fork();
   f:	e8 37 03 00 00       	call   34b <fork>
    if (zombie_pid == 0) {
  14:	85 c0                	test   %eax,%eax
  16:	74 5d                	je     75 <main+0x75>
  18:	89 c3                	mov    %eax,%ebx
        // Child process immediately exits
        printf(1, "Child (Zombie PID: %d) exiting\n", getpid());
        exit();
    } else if (zombie_pid > 0) {
  1a:	7e 0d                	jle    29 <main+0x29>
        // Parent does NOT call wait() to retrieve the child's status
        sleep(50); // Allow time for the child to become a zombie
  1c:	83 ec 0c             	sub    $0xc,%esp
  1f:	6a 32                	push   $0x32
  21:	e8 bd 03 00 00       	call   3e3 <sleep>
  26:	83 c4 10             	add    $0x10,%esp
    }

    // Check if the child process is a zombie
    int type = get_process_type(zombie_pid);
  29:	83 ec 0c             	sub    $0xc,%esp
  2c:	53                   	push   %ebx
  2d:	e8 d1 03 00 00       	call   403 <get_process_type>
    if (type == 1) {
  32:	83 c4 10             	add    $0x10,%esp
  35:	83 f8 01             	cmp    $0x1,%eax
  38:	74 28                	je     62 <main+0x62>
        printf(1, "Process %d is a zombie\n", zombie_pid);
    } else {
        printf(1, "Process %d is NOT a zombie (Type: %d)\n", zombie_pid, type);
  3a:	50                   	push   %eax
  3b:	53                   	push   %ebx
  3c:	68 48 08 00 00       	push   $0x848
  41:	6a 01                	push   $0x1
  43:	e8 b8 04 00 00       	call   500 <printf>
  48:	83 c4 10             	add    $0x10,%esp
    }

    // Create an orphan process
    orphan_pid = fork();
  4b:	e8 fb 02 00 00       	call   34b <fork>
    if (orphan_pid == 0) {
  50:	85 c0                	test   %eax,%eax
  52:	74 51                	je     a5 <main+0xa5>
        type = get_process_type(getpid());
        if (type == 0) {
            printf(1, "Child (PID: %d) is now an orphan\n", getpid());
        }
        exit();
    } else if (orphan_pid > 0) {
  54:	7f 37                	jg     8d <main+0x8d>
        printf(1, "Parent process (PID: %d) exiting, making child an orphan\n", getpid());
        exit();
    }

    return 0;
}
  56:	8d 65 f8             	lea    -0x8(%ebp),%esp
  59:	31 c0                	xor    %eax,%eax
  5b:	59                   	pop    %ecx
  5c:	5b                   	pop    %ebx
  5d:	5d                   	pop    %ebp
  5e:	8d 61 fc             	lea    -0x4(%ecx),%esp
  61:	c3                   	ret    
        printf(1, "Process %d is a zombie\n", zombie_pid);
  62:	50                   	push   %eax
  63:	53                   	push   %ebx
  64:	68 ee 08 00 00       	push   $0x8ee
  69:	6a 01                	push   $0x1
  6b:	e8 90 04 00 00       	call   500 <printf>
  70:	83 c4 10             	add    $0x10,%esp
  73:	eb d6                	jmp    4b <main+0x4b>
        printf(1, "Child (Zombie PID: %d) exiting\n", getpid());
  75:	e8 59 03 00 00       	call   3d3 <getpid>
  7a:	52                   	push   %edx
  7b:	50                   	push   %eax
  7c:	68 28 08 00 00       	push   $0x828
  81:	6a 01                	push   $0x1
  83:	e8 78 04 00 00       	call   500 <printf>
        exit();
  88:	e8 c6 02 00 00       	call   353 <exit>
        printf(1, "Parent process (PID: %d) exiting, making child an orphan\n", getpid());
  8d:	e8 41 03 00 00       	call   3d3 <getpid>
  92:	52                   	push   %edx
  93:	50                   	push   %eax
  94:	68 b4 08 00 00       	push   $0x8b4
  99:	6a 01                	push   $0x1
  9b:	e8 60 04 00 00       	call   500 <printf>
        exit();
  a0:	e8 ae 02 00 00       	call   353 <exit>
        printf(1, "Child (Orphan PID: %d) created\n", getpid());
  a5:	e8 29 03 00 00       	call   3d3 <getpid>
  aa:	53                   	push   %ebx
  ab:	50                   	push   %eax
  ac:	68 70 08 00 00       	push   $0x870
  b1:	6a 01                	push   $0x1
  b3:	e8 48 04 00 00       	call   500 <printf>
        sleep(100); // Simulate some work
  b8:	c7 04 24 64 00 00 00 	movl   $0x64,(%esp)
  bf:	e8 1f 03 00 00       	call   3e3 <sleep>
        type = get_process_type(getpid());
  c4:	e8 0a 03 00 00       	call   3d3 <getpid>
  c9:	89 04 24             	mov    %eax,(%esp)
  cc:	e8 32 03 00 00       	call   403 <get_process_type>
        if (type == 0) {
  d1:	83 c4 10             	add    $0x10,%esp
  d4:	85 c0                	test   %eax,%eax
  d6:	74 05                	je     dd <main+0xdd>
        exit();
  d8:	e8 76 02 00 00       	call   353 <exit>
            printf(1, "Child (PID: %d) is now an orphan\n", getpid());
  dd:	e8 f1 02 00 00       	call   3d3 <getpid>
  e2:	51                   	push   %ecx
  e3:	50                   	push   %eax
  e4:	68 90 08 00 00       	push   $0x890
  e9:	6a 01                	push   $0x1
  eb:	e8 10 04 00 00       	call   500 <printf>
  f0:	83 c4 10             	add    $0x10,%esp
  f3:	eb e3                	jmp    d8 <main+0xd8>
  f5:	66 90                	xchg   %ax,%ax
  f7:	66 90                	xchg   %ax,%ax
  f9:	66 90                	xchg   %ax,%ax
  fb:	66 90                	xchg   %ax,%ax
  fd:	66 90                	xchg   %ax,%ax
  ff:	90                   	nop

00000100 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 100:	55                   	push   %ebp
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 101:	31 c0                	xor    %eax,%eax
{
 103:	89 e5                	mov    %esp,%ebp
 105:	53                   	push   %ebx
 106:	8b 4d 08             	mov    0x8(%ebp),%ecx
 109:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 10c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while((*s++ = *t++) != 0)
 110:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
 114:	88 14 01             	mov    %dl,(%ecx,%eax,1)
 117:	83 c0 01             	add    $0x1,%eax
 11a:	84 d2                	test   %dl,%dl
 11c:	75 f2                	jne    110 <strcpy+0x10>
    ;
  return os;
}
 11e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 121:	89 c8                	mov    %ecx,%eax
 123:	c9                   	leave  
 124:	c3                   	ret    
 125:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 12c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000130 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 130:	55                   	push   %ebp
 131:	89 e5                	mov    %esp,%ebp
 133:	53                   	push   %ebx
 134:	8b 55 08             	mov    0x8(%ebp),%edx
 137:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
 13a:	0f b6 02             	movzbl (%edx),%eax
 13d:	84 c0                	test   %al,%al
 13f:	75 17                	jne    158 <strcmp+0x28>
 141:	eb 3a                	jmp    17d <strcmp+0x4d>
 143:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 147:	90                   	nop
 148:	0f b6 42 01          	movzbl 0x1(%edx),%eax
    p++, q++;
 14c:	83 c2 01             	add    $0x1,%edx
 14f:	8d 59 01             	lea    0x1(%ecx),%ebx
  while(*p && *p == *q)
 152:	84 c0                	test   %al,%al
 154:	74 1a                	je     170 <strcmp+0x40>
    p++, q++;
 156:	89 d9                	mov    %ebx,%ecx
  while(*p && *p == *q)
 158:	0f b6 19             	movzbl (%ecx),%ebx
 15b:	38 c3                	cmp    %al,%bl
 15d:	74 e9                	je     148 <strcmp+0x18>
  return (uchar)*p - (uchar)*q;
 15f:	29 d8                	sub    %ebx,%eax
}
 161:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 164:	c9                   	leave  
 165:	c3                   	ret    
 166:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 16d:	8d 76 00             	lea    0x0(%esi),%esi
  return (uchar)*p - (uchar)*q;
 170:	0f b6 59 01          	movzbl 0x1(%ecx),%ebx
 174:	31 c0                	xor    %eax,%eax
 176:	29 d8                	sub    %ebx,%eax
}
 178:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 17b:	c9                   	leave  
 17c:	c3                   	ret    
  return (uchar)*p - (uchar)*q;
 17d:	0f b6 19             	movzbl (%ecx),%ebx
 180:	31 c0                	xor    %eax,%eax
 182:	eb db                	jmp    15f <strcmp+0x2f>
 184:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 18b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 18f:	90                   	nop

00000190 <strlen>:

uint
strlen(const char *s)
{
 190:	55                   	push   %ebp
 191:	89 e5                	mov    %esp,%ebp
 193:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
 196:	80 3a 00             	cmpb   $0x0,(%edx)
 199:	74 15                	je     1b0 <strlen+0x20>
 19b:	31 c0                	xor    %eax,%eax
 19d:	8d 76 00             	lea    0x0(%esi),%esi
 1a0:	83 c0 01             	add    $0x1,%eax
 1a3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
 1a7:	89 c1                	mov    %eax,%ecx
 1a9:	75 f5                	jne    1a0 <strlen+0x10>
    ;
  return n;
}
 1ab:	89 c8                	mov    %ecx,%eax
 1ad:	5d                   	pop    %ebp
 1ae:	c3                   	ret    
 1af:	90                   	nop
  for(n = 0; s[n]; n++)
 1b0:	31 c9                	xor    %ecx,%ecx
}
 1b2:	5d                   	pop    %ebp
 1b3:	89 c8                	mov    %ecx,%eax
 1b5:	c3                   	ret    
 1b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 1bd:	8d 76 00             	lea    0x0(%esi),%esi

000001c0 <memset>:

void*
memset(void *dst, int c, uint n)
{
 1c0:	55                   	push   %ebp
 1c1:	89 e5                	mov    %esp,%ebp
 1c3:	57                   	push   %edi
 1c4:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 1c7:	8b 4d 10             	mov    0x10(%ebp),%ecx
 1ca:	8b 45 0c             	mov    0xc(%ebp),%eax
 1cd:	89 d7                	mov    %edx,%edi
 1cf:	fc                   	cld    
 1d0:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 1d2:	8b 7d fc             	mov    -0x4(%ebp),%edi
 1d5:	89 d0                	mov    %edx,%eax
 1d7:	c9                   	leave  
 1d8:	c3                   	ret    
 1d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

000001e0 <strchr>:

char*
strchr(const char *s, char c)
{
 1e0:	55                   	push   %ebp
 1e1:	89 e5                	mov    %esp,%ebp
 1e3:	8b 45 08             	mov    0x8(%ebp),%eax
 1e6:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 1ea:	0f b6 10             	movzbl (%eax),%edx
 1ed:	84 d2                	test   %dl,%dl
 1ef:	75 12                	jne    203 <strchr+0x23>
 1f1:	eb 1d                	jmp    210 <strchr+0x30>
 1f3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 1f7:	90                   	nop
 1f8:	0f b6 50 01          	movzbl 0x1(%eax),%edx
 1fc:	83 c0 01             	add    $0x1,%eax
 1ff:	84 d2                	test   %dl,%dl
 201:	74 0d                	je     210 <strchr+0x30>
    if(*s == c)
 203:	38 d1                	cmp    %dl,%cl
 205:	75 f1                	jne    1f8 <strchr+0x18>
      return (char*)s;
  return 0;
}
 207:	5d                   	pop    %ebp
 208:	c3                   	ret    
 209:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return 0;
 210:	31 c0                	xor    %eax,%eax
}
 212:	5d                   	pop    %ebp
 213:	c3                   	ret    
 214:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 21b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 21f:	90                   	nop

00000220 <gets>:

char*
gets(char *buf, int max)
{
 220:	55                   	push   %ebp
 221:	89 e5                	mov    %esp,%ebp
 223:	57                   	push   %edi
 224:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
 225:	8d 7d e7             	lea    -0x19(%ebp),%edi
{
 228:	53                   	push   %ebx
  for(i=0; i+1 < max; ){
 229:	31 db                	xor    %ebx,%ebx
{
 22b:	83 ec 1c             	sub    $0x1c,%esp
  for(i=0; i+1 < max; ){
 22e:	eb 27                	jmp    257 <gets+0x37>
    cc = read(0, &c, 1);
 230:	83 ec 04             	sub    $0x4,%esp
 233:	6a 01                	push   $0x1
 235:	57                   	push   %edi
 236:	6a 00                	push   $0x0
 238:	e8 2e 01 00 00       	call   36b <read>
    if(cc < 1)
 23d:	83 c4 10             	add    $0x10,%esp
 240:	85 c0                	test   %eax,%eax
 242:	7e 1d                	jle    261 <gets+0x41>
      break;
    buf[i++] = c;
 244:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 248:	8b 55 08             	mov    0x8(%ebp),%edx
 24b:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
    if(c == '\n' || c == '\r')
 24f:	3c 0a                	cmp    $0xa,%al
 251:	74 1d                	je     270 <gets+0x50>
 253:	3c 0d                	cmp    $0xd,%al
 255:	74 19                	je     270 <gets+0x50>
  for(i=0; i+1 < max; ){
 257:	89 de                	mov    %ebx,%esi
 259:	83 c3 01             	add    $0x1,%ebx
 25c:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 25f:	7c cf                	jl     230 <gets+0x10>
      break;
  }
  buf[i] = '\0';
 261:	8b 45 08             	mov    0x8(%ebp),%eax
 264:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
 268:	8d 65 f4             	lea    -0xc(%ebp),%esp
 26b:	5b                   	pop    %ebx
 26c:	5e                   	pop    %esi
 26d:	5f                   	pop    %edi
 26e:	5d                   	pop    %ebp
 26f:	c3                   	ret    
  buf[i] = '\0';
 270:	8b 45 08             	mov    0x8(%ebp),%eax
 273:	89 de                	mov    %ebx,%esi
 275:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
}
 279:	8d 65 f4             	lea    -0xc(%ebp),%esp
 27c:	5b                   	pop    %ebx
 27d:	5e                   	pop    %esi
 27e:	5f                   	pop    %edi
 27f:	5d                   	pop    %ebp
 280:	c3                   	ret    
 281:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 288:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 28f:	90                   	nop

00000290 <stat>:

int
stat(const char *n, struct stat *st)
{
 290:	55                   	push   %ebp
 291:	89 e5                	mov    %esp,%ebp
 293:	56                   	push   %esi
 294:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 295:	83 ec 08             	sub    $0x8,%esp
 298:	6a 00                	push   $0x0
 29a:	ff 75 08             	push   0x8(%ebp)
 29d:	e8 f1 00 00 00       	call   393 <open>
  if(fd < 0)
 2a2:	83 c4 10             	add    $0x10,%esp
 2a5:	85 c0                	test   %eax,%eax
 2a7:	78 27                	js     2d0 <stat+0x40>
    return -1;
  r = fstat(fd, st);
 2a9:	83 ec 08             	sub    $0x8,%esp
 2ac:	ff 75 0c             	push   0xc(%ebp)
 2af:	89 c3                	mov    %eax,%ebx
 2b1:	50                   	push   %eax
 2b2:	e8 f4 00 00 00       	call   3ab <fstat>
  close(fd);
 2b7:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 2ba:	89 c6                	mov    %eax,%esi
  close(fd);
 2bc:	e8 ba 00 00 00       	call   37b <close>
  return r;
 2c1:	83 c4 10             	add    $0x10,%esp
}
 2c4:	8d 65 f8             	lea    -0x8(%ebp),%esp
 2c7:	89 f0                	mov    %esi,%eax
 2c9:	5b                   	pop    %ebx
 2ca:	5e                   	pop    %esi
 2cb:	5d                   	pop    %ebp
 2cc:	c3                   	ret    
 2cd:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 2d0:	be ff ff ff ff       	mov    $0xffffffff,%esi
 2d5:	eb ed                	jmp    2c4 <stat+0x34>
 2d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 2de:	66 90                	xchg   %ax,%ax

000002e0 <atoi>:

int
atoi(const char *s)
{
 2e0:	55                   	push   %ebp
 2e1:	89 e5                	mov    %esp,%ebp
 2e3:	53                   	push   %ebx
 2e4:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2e7:	0f be 02             	movsbl (%edx),%eax
 2ea:	8d 48 d0             	lea    -0x30(%eax),%ecx
 2ed:	80 f9 09             	cmp    $0x9,%cl
  n = 0;
 2f0:	b9 00 00 00 00       	mov    $0x0,%ecx
  while('0' <= *s && *s <= '9')
 2f5:	77 1e                	ja     315 <atoi+0x35>
 2f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 2fe:	66 90                	xchg   %ax,%ax
    n = n*10 + *s++ - '0';
 300:	83 c2 01             	add    $0x1,%edx
 303:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
 306:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
  while('0' <= *s && *s <= '9')
 30a:	0f be 02             	movsbl (%edx),%eax
 30d:	8d 58 d0             	lea    -0x30(%eax),%ebx
 310:	80 fb 09             	cmp    $0x9,%bl
 313:	76 eb                	jbe    300 <atoi+0x20>
  return n;
}
 315:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 318:	89 c8                	mov    %ecx,%eax
 31a:	c9                   	leave  
 31b:	c3                   	ret    
 31c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000320 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 320:	55                   	push   %ebp
 321:	89 e5                	mov    %esp,%ebp
 323:	57                   	push   %edi
 324:	8b 45 10             	mov    0x10(%ebp),%eax
 327:	8b 55 08             	mov    0x8(%ebp),%edx
 32a:	56                   	push   %esi
 32b:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 32e:	85 c0                	test   %eax,%eax
 330:	7e 13                	jle    345 <memmove+0x25>
 332:	01 d0                	add    %edx,%eax
  dst = vdst;
 334:	89 d7                	mov    %edx,%edi
 336:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 33d:	8d 76 00             	lea    0x0(%esi),%esi
    *dst++ = *src++;
 340:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
 341:	39 f8                	cmp    %edi,%eax
 343:	75 fb                	jne    340 <memmove+0x20>
  return vdst;
}
 345:	5e                   	pop    %esi
 346:	89 d0                	mov    %edx,%eax
 348:	5f                   	pop    %edi
 349:	5d                   	pop    %ebp
 34a:	c3                   	ret    

0000034b <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 34b:	b8 01 00 00 00       	mov    $0x1,%eax
 350:	cd 40                	int    $0x40
 352:	c3                   	ret    

00000353 <exit>:
SYSCALL(exit)
 353:	b8 02 00 00 00       	mov    $0x2,%eax
 358:	cd 40                	int    $0x40
 35a:	c3                   	ret    

0000035b <wait>:
SYSCALL(wait)
 35b:	b8 03 00 00 00       	mov    $0x3,%eax
 360:	cd 40                	int    $0x40
 362:	c3                   	ret    

00000363 <pipe>:
SYSCALL(pipe)
 363:	b8 04 00 00 00       	mov    $0x4,%eax
 368:	cd 40                	int    $0x40
 36a:	c3                   	ret    

0000036b <read>:
SYSCALL(read)
 36b:	b8 05 00 00 00       	mov    $0x5,%eax
 370:	cd 40                	int    $0x40
 372:	c3                   	ret    

00000373 <write>:
SYSCALL(write)
 373:	b8 10 00 00 00       	mov    $0x10,%eax
 378:	cd 40                	int    $0x40
 37a:	c3                   	ret    

0000037b <close>:
SYSCALL(close)
 37b:	b8 15 00 00 00       	mov    $0x15,%eax
 380:	cd 40                	int    $0x40
 382:	c3                   	ret    

00000383 <kill>:
SYSCALL(kill)
 383:	b8 06 00 00 00       	mov    $0x6,%eax
 388:	cd 40                	int    $0x40
 38a:	c3                   	ret    

0000038b <exec>:
SYSCALL(exec)
 38b:	b8 07 00 00 00       	mov    $0x7,%eax
 390:	cd 40                	int    $0x40
 392:	c3                   	ret    

00000393 <open>:
SYSCALL(open)
 393:	b8 0f 00 00 00       	mov    $0xf,%eax
 398:	cd 40                	int    $0x40
 39a:	c3                   	ret    

0000039b <mknod>:
SYSCALL(mknod)
 39b:	b8 11 00 00 00       	mov    $0x11,%eax
 3a0:	cd 40                	int    $0x40
 3a2:	c3                   	ret    

000003a3 <unlink>:
SYSCALL(unlink)
 3a3:	b8 12 00 00 00       	mov    $0x12,%eax
 3a8:	cd 40                	int    $0x40
 3aa:	c3                   	ret    

000003ab <fstat>:
SYSCALL(fstat)
 3ab:	b8 08 00 00 00       	mov    $0x8,%eax
 3b0:	cd 40                	int    $0x40
 3b2:	c3                   	ret    

000003b3 <link>:
SYSCALL(link)
 3b3:	b8 13 00 00 00       	mov    $0x13,%eax
 3b8:	cd 40                	int    $0x40
 3ba:	c3                   	ret    

000003bb <mkdir>:
SYSCALL(mkdir)
 3bb:	b8 14 00 00 00       	mov    $0x14,%eax
 3c0:	cd 40                	int    $0x40
 3c2:	c3                   	ret    

000003c3 <chdir>:
SYSCALL(chdir)
 3c3:	b8 09 00 00 00       	mov    $0x9,%eax
 3c8:	cd 40                	int    $0x40
 3ca:	c3                   	ret    

000003cb <dup>:
SYSCALL(dup)
 3cb:	b8 0a 00 00 00       	mov    $0xa,%eax
 3d0:	cd 40                	int    $0x40
 3d2:	c3                   	ret    

000003d3 <getpid>:
SYSCALL(getpid)
 3d3:	b8 0b 00 00 00       	mov    $0xb,%eax
 3d8:	cd 40                	int    $0x40
 3da:	c3                   	ret    

000003db <sbrk>:
SYSCALL(sbrk)
 3db:	b8 0c 00 00 00       	mov    $0xc,%eax
 3e0:	cd 40                	int    $0x40
 3e2:	c3                   	ret    

000003e3 <sleep>:
SYSCALL(sleep)
 3e3:	b8 0d 00 00 00       	mov    $0xd,%eax
 3e8:	cd 40                	int    $0x40
 3ea:	c3                   	ret    

000003eb <uptime>:
SYSCALL(uptime)
 3eb:	b8 0e 00 00 00       	mov    $0xe,%eax
 3f0:	cd 40                	int    $0x40
 3f2:	c3                   	ret    

000003f3 <cps>:
SYSCALL(cps)
 3f3:	b8 16 00 00 00       	mov    $0x16,%eax
 3f8:	cd 40                	int    $0x40
 3fa:	c3                   	ret    

000003fb <calls>:
SYSCALL(calls)
 3fb:	b8 17 00 00 00       	mov    $0x17,%eax
 400:	cd 40                	int    $0x40
 402:	c3                   	ret    

00000403 <get_process_type>:
SYSCALL(get_process_type)
 403:	b8 18 00 00 00       	mov    $0x18,%eax
 408:	cd 40                	int    $0x40
 40a:	c3                   	ret    

0000040b <mem_usage>:
SYSCALL(mem_usage)
 40b:	b8 1b 00 00 00       	mov    $0x1b,%eax
 410:	cd 40                	int    $0x40
 412:	c3                   	ret    

00000413 <get_priority>:
SYSCALL(get_priority)
 413:	b8 1c 00 00 00       	mov    $0x1c,%eax
 418:	cd 40                	int    $0x40
 41a:	c3                   	ret    

0000041b <set_priority>:
SYSCALL(set_priority)
 41b:	b8 1d 00 00 00       	mov    $0x1d,%eax
 420:	cd 40                	int    $0x40
 422:	c3                   	ret    

00000423 <sem_init>:
SYSCALL(sem_init)
 423:	b8 1e 00 00 00       	mov    $0x1e,%eax
 428:	cd 40                	int    $0x40
 42a:	c3                   	ret    

0000042b <sem_destroy>:
SYSCALL(sem_destroy)
 42b:	b8 1f 00 00 00       	mov    $0x1f,%eax
 430:	cd 40                	int    $0x40
 432:	c3                   	ret    

00000433 <sem_wait>:
SYSCALL(sem_wait)
 433:	b8 20 00 00 00       	mov    $0x20,%eax
 438:	cd 40                	int    $0x40
 43a:	c3                   	ret    

0000043b <sem_signal>:
SYSCALL(sem_signal)
 43b:	b8 21 00 00 00       	mov    $0x21,%eax
 440:	cd 40                	int    $0x40
 442:	c3                   	ret    

00000443 <getppid>:
 443:	b8 22 00 00 00       	mov    $0x22,%eax
 448:	cd 40                	int    $0x40
 44a:	c3                   	ret    
 44b:	66 90                	xchg   %ax,%ax
 44d:	66 90                	xchg   %ax,%ax
 44f:	90                   	nop

00000450 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 450:	55                   	push   %ebp
 451:	89 e5                	mov    %esp,%ebp
 453:	57                   	push   %edi
 454:	56                   	push   %esi
 455:	53                   	push   %ebx
 456:	83 ec 3c             	sub    $0x3c,%esp
 459:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 45c:	89 d1                	mov    %edx,%ecx
{
 45e:	89 45 b8             	mov    %eax,-0x48(%ebp)
  if(sgn && xx < 0){
 461:	85 d2                	test   %edx,%edx
 463:	0f 89 7f 00 00 00    	jns    4e8 <printint+0x98>
 469:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 46d:	74 79                	je     4e8 <printint+0x98>
    neg = 1;
 46f:	c7 45 bc 01 00 00 00 	movl   $0x1,-0x44(%ebp)
    x = -xx;
 476:	f7 d9                	neg    %ecx
  } else {
    x = xx;
  }

  i = 0;
 478:	31 db                	xor    %ebx,%ebx
 47a:	8d 75 d7             	lea    -0x29(%ebp),%esi
 47d:	8d 76 00             	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
 480:	89 c8                	mov    %ecx,%eax
 482:	31 d2                	xor    %edx,%edx
 484:	89 cf                	mov    %ecx,%edi
 486:	f7 75 c4             	divl   -0x3c(%ebp)
 489:	0f b6 92 68 09 00 00 	movzbl 0x968(%edx),%edx
 490:	89 45 c0             	mov    %eax,-0x40(%ebp)
 493:	89 d8                	mov    %ebx,%eax
 495:	8d 5b 01             	lea    0x1(%ebx),%ebx
  }while((x /= base) != 0);
 498:	8b 4d c0             	mov    -0x40(%ebp),%ecx
    buf[i++] = digits[x % base];
 49b:	88 14 1e             	mov    %dl,(%esi,%ebx,1)
  }while((x /= base) != 0);
 49e:	39 7d c4             	cmp    %edi,-0x3c(%ebp)
 4a1:	76 dd                	jbe    480 <printint+0x30>
  if(neg)
 4a3:	8b 4d bc             	mov    -0x44(%ebp),%ecx
 4a6:	85 c9                	test   %ecx,%ecx
 4a8:	74 0c                	je     4b6 <printint+0x66>
    buf[i++] = '-';
 4aa:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    buf[i++] = digits[x % base];
 4af:	89 d8                	mov    %ebx,%eax
    buf[i++] = '-';
 4b1:	ba 2d 00 00 00       	mov    $0x2d,%edx

  while(--i >= 0)
 4b6:	8b 7d b8             	mov    -0x48(%ebp),%edi
 4b9:	8d 5c 05 d7          	lea    -0x29(%ebp,%eax,1),%ebx
 4bd:	eb 07                	jmp    4c6 <printint+0x76>
 4bf:	90                   	nop
    putc(fd, buf[i]);
 4c0:	0f b6 13             	movzbl (%ebx),%edx
 4c3:	83 eb 01             	sub    $0x1,%ebx
  write(fd, &c, 1);
 4c6:	83 ec 04             	sub    $0x4,%esp
 4c9:	88 55 d7             	mov    %dl,-0x29(%ebp)
 4cc:	6a 01                	push   $0x1
 4ce:	56                   	push   %esi
 4cf:	57                   	push   %edi
 4d0:	e8 9e fe ff ff       	call   373 <write>
  while(--i >= 0)
 4d5:	83 c4 10             	add    $0x10,%esp
 4d8:	39 de                	cmp    %ebx,%esi
 4da:	75 e4                	jne    4c0 <printint+0x70>
}
 4dc:	8d 65 f4             	lea    -0xc(%ebp),%esp
 4df:	5b                   	pop    %ebx
 4e0:	5e                   	pop    %esi
 4e1:	5f                   	pop    %edi
 4e2:	5d                   	pop    %ebp
 4e3:	c3                   	ret    
 4e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
 4e8:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
 4ef:	eb 87                	jmp    478 <printint+0x28>
 4f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 4f8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 4ff:	90                   	nop

00000500 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 500:	55                   	push   %ebp
 501:	89 e5                	mov    %esp,%ebp
 503:	57                   	push   %edi
 504:	56                   	push   %esi
 505:	53                   	push   %ebx
 506:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 509:	8b 5d 0c             	mov    0xc(%ebp),%ebx
{
 50c:	8b 75 08             	mov    0x8(%ebp),%esi
  for(i = 0; fmt[i]; i++){
 50f:	0f b6 13             	movzbl (%ebx),%edx
 512:	84 d2                	test   %dl,%dl
 514:	74 6a                	je     580 <printf+0x80>
  ap = (uint*)(void*)&fmt + 1;
 516:	8d 45 10             	lea    0x10(%ebp),%eax
 519:	83 c3 01             	add    $0x1,%ebx
  write(fd, &c, 1);
 51c:	8d 7d e7             	lea    -0x19(%ebp),%edi
  state = 0;
 51f:	31 c9                	xor    %ecx,%ecx
  ap = (uint*)(void*)&fmt + 1;
 521:	89 45 d0             	mov    %eax,-0x30(%ebp)
 524:	eb 36                	jmp    55c <printf+0x5c>
 526:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 52d:	8d 76 00             	lea    0x0(%esi),%esi
 530:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
 533:	b9 25 00 00 00       	mov    $0x25,%ecx
      if(c == '%'){
 538:	83 f8 25             	cmp    $0x25,%eax
 53b:	74 15                	je     552 <printf+0x52>
  write(fd, &c, 1);
 53d:	83 ec 04             	sub    $0x4,%esp
 540:	88 55 e7             	mov    %dl,-0x19(%ebp)
 543:	6a 01                	push   $0x1
 545:	57                   	push   %edi
 546:	56                   	push   %esi
 547:	e8 27 fe ff ff       	call   373 <write>
 54c:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
      } else {
        putc(fd, c);
 54f:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
 552:	0f b6 13             	movzbl (%ebx),%edx
 555:	83 c3 01             	add    $0x1,%ebx
 558:	84 d2                	test   %dl,%dl
 55a:	74 24                	je     580 <printf+0x80>
    c = fmt[i] & 0xff;
 55c:	0f b6 c2             	movzbl %dl,%eax
    if(state == 0){
 55f:	85 c9                	test   %ecx,%ecx
 561:	74 cd                	je     530 <printf+0x30>
      }
    } else if(state == '%'){
 563:	83 f9 25             	cmp    $0x25,%ecx
 566:	75 ea                	jne    552 <printf+0x52>
      if(c == 'd'){
 568:	83 f8 25             	cmp    $0x25,%eax
 56b:	0f 84 07 01 00 00    	je     678 <printf+0x178>
 571:	83 e8 63             	sub    $0x63,%eax
 574:	83 f8 15             	cmp    $0x15,%eax
 577:	77 17                	ja     590 <printf+0x90>
 579:	ff 24 85 10 09 00 00 	jmp    *0x910(,%eax,4)
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 580:	8d 65 f4             	lea    -0xc(%ebp),%esp
 583:	5b                   	pop    %ebx
 584:	5e                   	pop    %esi
 585:	5f                   	pop    %edi
 586:	5d                   	pop    %ebp
 587:	c3                   	ret    
 588:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 58f:	90                   	nop
  write(fd, &c, 1);
 590:	83 ec 04             	sub    $0x4,%esp
 593:	88 55 d4             	mov    %dl,-0x2c(%ebp)
 596:	6a 01                	push   $0x1
 598:	57                   	push   %edi
 599:	56                   	push   %esi
 59a:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 59e:	e8 d0 fd ff ff       	call   373 <write>
        putc(fd, c);
 5a3:	0f b6 55 d4          	movzbl -0x2c(%ebp),%edx
  write(fd, &c, 1);
 5a7:	83 c4 0c             	add    $0xc,%esp
 5aa:	88 55 e7             	mov    %dl,-0x19(%ebp)
 5ad:	6a 01                	push   $0x1
 5af:	57                   	push   %edi
 5b0:	56                   	push   %esi
 5b1:	e8 bd fd ff ff       	call   373 <write>
        putc(fd, c);
 5b6:	83 c4 10             	add    $0x10,%esp
      state = 0;
 5b9:	31 c9                	xor    %ecx,%ecx
 5bb:	eb 95                	jmp    552 <printf+0x52>
 5bd:	8d 76 00             	lea    0x0(%esi),%esi
        printint(fd, *ap, 16, 0);
 5c0:	83 ec 0c             	sub    $0xc,%esp
 5c3:	b9 10 00 00 00       	mov    $0x10,%ecx
 5c8:	6a 00                	push   $0x0
 5ca:	8b 45 d0             	mov    -0x30(%ebp),%eax
 5cd:	8b 10                	mov    (%eax),%edx
 5cf:	89 f0                	mov    %esi,%eax
 5d1:	e8 7a fe ff ff       	call   450 <printint>
        ap++;
 5d6:	83 45 d0 04          	addl   $0x4,-0x30(%ebp)
 5da:	83 c4 10             	add    $0x10,%esp
      state = 0;
 5dd:	31 c9                	xor    %ecx,%ecx
 5df:	e9 6e ff ff ff       	jmp    552 <printf+0x52>
 5e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        s = (char*)*ap;
 5e8:	8b 45 d0             	mov    -0x30(%ebp),%eax
 5eb:	8b 10                	mov    (%eax),%edx
        ap++;
 5ed:	83 c0 04             	add    $0x4,%eax
 5f0:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
 5f3:	85 d2                	test   %edx,%edx
 5f5:	0f 84 8d 00 00 00    	je     688 <printf+0x188>
        while(*s != 0){
 5fb:	0f b6 02             	movzbl (%edx),%eax
      state = 0;
 5fe:	31 c9                	xor    %ecx,%ecx
        while(*s != 0){
 600:	84 c0                	test   %al,%al
 602:	0f 84 4a ff ff ff    	je     552 <printf+0x52>
 608:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
 60b:	89 d3                	mov    %edx,%ebx
 60d:	8d 76 00             	lea    0x0(%esi),%esi
  write(fd, &c, 1);
 610:	83 ec 04             	sub    $0x4,%esp
          s++;
 613:	83 c3 01             	add    $0x1,%ebx
 616:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 619:	6a 01                	push   $0x1
 61b:	57                   	push   %edi
 61c:	56                   	push   %esi
 61d:	e8 51 fd ff ff       	call   373 <write>
        while(*s != 0){
 622:	0f b6 03             	movzbl (%ebx),%eax
 625:	83 c4 10             	add    $0x10,%esp
 628:	84 c0                	test   %al,%al
 62a:	75 e4                	jne    610 <printf+0x110>
      state = 0;
 62c:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
 62f:	31 c9                	xor    %ecx,%ecx
 631:	e9 1c ff ff ff       	jmp    552 <printf+0x52>
 636:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 63d:	8d 76 00             	lea    0x0(%esi),%esi
        printint(fd, *ap, 10, 1);
 640:	83 ec 0c             	sub    $0xc,%esp
 643:	b9 0a 00 00 00       	mov    $0xa,%ecx
 648:	6a 01                	push   $0x1
 64a:	e9 7b ff ff ff       	jmp    5ca <printf+0xca>
 64f:	90                   	nop
        putc(fd, *ap);
 650:	8b 45 d0             	mov    -0x30(%ebp),%eax
  write(fd, &c, 1);
 653:	83 ec 04             	sub    $0x4,%esp
        putc(fd, *ap);
 656:	8b 00                	mov    (%eax),%eax
  write(fd, &c, 1);
 658:	6a 01                	push   $0x1
 65a:	57                   	push   %edi
 65b:	56                   	push   %esi
        putc(fd, *ap);
 65c:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 65f:	e8 0f fd ff ff       	call   373 <write>
        ap++;
 664:	83 45 d0 04          	addl   $0x4,-0x30(%ebp)
 668:	83 c4 10             	add    $0x10,%esp
      state = 0;
 66b:	31 c9                	xor    %ecx,%ecx
 66d:	e9 e0 fe ff ff       	jmp    552 <printf+0x52>
 672:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        putc(fd, c);
 678:	88 55 e7             	mov    %dl,-0x19(%ebp)
  write(fd, &c, 1);
 67b:	83 ec 04             	sub    $0x4,%esp
 67e:	e9 2a ff ff ff       	jmp    5ad <printf+0xad>
 683:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 687:	90                   	nop
          s = "(null)";
 688:	ba 06 09 00 00       	mov    $0x906,%edx
        while(*s != 0){
 68d:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
 690:	b8 28 00 00 00       	mov    $0x28,%eax
 695:	89 d3                	mov    %edx,%ebx
 697:	e9 74 ff ff ff       	jmp    610 <printf+0x110>
 69c:	66 90                	xchg   %ax,%ax
 69e:	66 90                	xchg   %ax,%ax

000006a0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6a0:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6a1:	a1 24 0c 00 00       	mov    0xc24,%eax
{
 6a6:	89 e5                	mov    %esp,%ebp
 6a8:	57                   	push   %edi
 6a9:	56                   	push   %esi
 6aa:	53                   	push   %ebx
 6ab:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = (Header*)ap - 1;
 6ae:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 6b8:	89 c2                	mov    %eax,%edx
 6ba:	8b 00                	mov    (%eax),%eax
 6bc:	39 ca                	cmp    %ecx,%edx
 6be:	73 30                	jae    6f0 <free+0x50>
 6c0:	39 c1                	cmp    %eax,%ecx
 6c2:	72 04                	jb     6c8 <free+0x28>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6c4:	39 c2                	cmp    %eax,%edx
 6c6:	72 f0                	jb     6b8 <free+0x18>
      break;
  if(bp + bp->s.size == p->s.ptr){
 6c8:	8b 73 fc             	mov    -0x4(%ebx),%esi
 6cb:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 6ce:	39 f8                	cmp    %edi,%eax
 6d0:	74 30                	je     702 <free+0x62>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 6d2:	89 43 f8             	mov    %eax,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 6d5:	8b 42 04             	mov    0x4(%edx),%eax
 6d8:	8d 34 c2             	lea    (%edx,%eax,8),%esi
 6db:	39 f1                	cmp    %esi,%ecx
 6dd:	74 3a                	je     719 <free+0x79>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 6df:	89 0a                	mov    %ecx,(%edx)
  } else
    p->s.ptr = bp;
  freep = p;
}
 6e1:	5b                   	pop    %ebx
  freep = p;
 6e2:	89 15 24 0c 00 00    	mov    %edx,0xc24
}
 6e8:	5e                   	pop    %esi
 6e9:	5f                   	pop    %edi
 6ea:	5d                   	pop    %ebp
 6eb:	c3                   	ret    
 6ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6f0:	39 c2                	cmp    %eax,%edx
 6f2:	72 c4                	jb     6b8 <free+0x18>
 6f4:	39 c1                	cmp    %eax,%ecx
 6f6:	73 c0                	jae    6b8 <free+0x18>
  if(bp + bp->s.size == p->s.ptr){
 6f8:	8b 73 fc             	mov    -0x4(%ebx),%esi
 6fb:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 6fe:	39 f8                	cmp    %edi,%eax
 700:	75 d0                	jne    6d2 <free+0x32>
    bp->s.size += p->s.ptr->s.size;
 702:	03 70 04             	add    0x4(%eax),%esi
 705:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 708:	8b 02                	mov    (%edx),%eax
 70a:	8b 00                	mov    (%eax),%eax
 70c:	89 43 f8             	mov    %eax,-0x8(%ebx)
  if(p + p->s.size == bp){
 70f:	8b 42 04             	mov    0x4(%edx),%eax
 712:	8d 34 c2             	lea    (%edx,%eax,8),%esi
 715:	39 f1                	cmp    %esi,%ecx
 717:	75 c6                	jne    6df <free+0x3f>
    p->s.size += bp->s.size;
 719:	03 43 fc             	add    -0x4(%ebx),%eax
  freep = p;
 71c:	89 15 24 0c 00 00    	mov    %edx,0xc24
    p->s.size += bp->s.size;
 722:	89 42 04             	mov    %eax,0x4(%edx)
    p->s.ptr = bp->s.ptr;
 725:	8b 4b f8             	mov    -0x8(%ebx),%ecx
 728:	89 0a                	mov    %ecx,(%edx)
}
 72a:	5b                   	pop    %ebx
 72b:	5e                   	pop    %esi
 72c:	5f                   	pop    %edi
 72d:	5d                   	pop    %ebp
 72e:	c3                   	ret    
 72f:	90                   	nop

00000730 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 730:	55                   	push   %ebp
 731:	89 e5                	mov    %esp,%ebp
 733:	57                   	push   %edi
 734:	56                   	push   %esi
 735:	53                   	push   %ebx
 736:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 739:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 73c:	8b 3d 24 0c 00 00    	mov    0xc24,%edi
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 742:	8d 70 07             	lea    0x7(%eax),%esi
 745:	c1 ee 03             	shr    $0x3,%esi
 748:	83 c6 01             	add    $0x1,%esi
  if((prevp = freep) == 0){
 74b:	85 ff                	test   %edi,%edi
 74d:	0f 84 9d 00 00 00    	je     7f0 <malloc+0xc0>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 753:	8b 17                	mov    (%edi),%edx
    if(p->s.size >= nunits){
 755:	8b 4a 04             	mov    0x4(%edx),%ecx
 758:	39 f1                	cmp    %esi,%ecx
 75a:	73 6a                	jae    7c6 <malloc+0x96>
 75c:	bb 00 10 00 00       	mov    $0x1000,%ebx
 761:	39 de                	cmp    %ebx,%esi
 763:	0f 43 de             	cmovae %esi,%ebx
  p = sbrk(nu * sizeof(Header));
 766:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
 76d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 770:	eb 17                	jmp    789 <malloc+0x59>
 772:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 778:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 77a:	8b 48 04             	mov    0x4(%eax),%ecx
 77d:	39 f1                	cmp    %esi,%ecx
 77f:	73 4f                	jae    7d0 <malloc+0xa0>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 781:	8b 3d 24 0c 00 00    	mov    0xc24,%edi
 787:	89 c2                	mov    %eax,%edx
 789:	39 d7                	cmp    %edx,%edi
 78b:	75 eb                	jne    778 <malloc+0x48>
  p = sbrk(nu * sizeof(Header));
 78d:	83 ec 0c             	sub    $0xc,%esp
 790:	ff 75 e4             	push   -0x1c(%ebp)
 793:	e8 43 fc ff ff       	call   3db <sbrk>
  if(p == (char*)-1)
 798:	83 c4 10             	add    $0x10,%esp
 79b:	83 f8 ff             	cmp    $0xffffffff,%eax
 79e:	74 1c                	je     7bc <malloc+0x8c>
  hp->s.size = nu;
 7a0:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 7a3:	83 ec 0c             	sub    $0xc,%esp
 7a6:	83 c0 08             	add    $0x8,%eax
 7a9:	50                   	push   %eax
 7aa:	e8 f1 fe ff ff       	call   6a0 <free>
  return freep;
 7af:	8b 15 24 0c 00 00    	mov    0xc24,%edx
      if((p = morecore(nunits)) == 0)
 7b5:	83 c4 10             	add    $0x10,%esp
 7b8:	85 d2                	test   %edx,%edx
 7ba:	75 bc                	jne    778 <malloc+0x48>
        return 0;
  }
}
 7bc:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
 7bf:	31 c0                	xor    %eax,%eax
}
 7c1:	5b                   	pop    %ebx
 7c2:	5e                   	pop    %esi
 7c3:	5f                   	pop    %edi
 7c4:	5d                   	pop    %ebp
 7c5:	c3                   	ret    
    if(p->s.size >= nunits){
 7c6:	89 d0                	mov    %edx,%eax
 7c8:	89 fa                	mov    %edi,%edx
 7ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
 7d0:	39 ce                	cmp    %ecx,%esi
 7d2:	74 4c                	je     820 <malloc+0xf0>
        p->s.size -= nunits;
 7d4:	29 f1                	sub    %esi,%ecx
 7d6:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 7d9:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 7dc:	89 70 04             	mov    %esi,0x4(%eax)
      freep = prevp;
 7df:	89 15 24 0c 00 00    	mov    %edx,0xc24
}
 7e5:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
 7e8:	83 c0 08             	add    $0x8,%eax
}
 7eb:	5b                   	pop    %ebx
 7ec:	5e                   	pop    %esi
 7ed:	5f                   	pop    %edi
 7ee:	5d                   	pop    %ebp
 7ef:	c3                   	ret    
    base.s.ptr = freep = prevp = &base;
 7f0:	c7 05 24 0c 00 00 28 	movl   $0xc28,0xc24
 7f7:	0c 00 00 
    base.s.size = 0;
 7fa:	bf 28 0c 00 00       	mov    $0xc28,%edi
    base.s.ptr = freep = prevp = &base;
 7ff:	c7 05 28 0c 00 00 28 	movl   $0xc28,0xc28
 806:	0c 00 00 
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 809:	89 fa                	mov    %edi,%edx
    base.s.size = 0;
 80b:	c7 05 2c 0c 00 00 00 	movl   $0x0,0xc2c
 812:	00 00 00 
    if(p->s.size >= nunits){
 815:	e9 42 ff ff ff       	jmp    75c <malloc+0x2c>
 81a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        prevp->s.ptr = p->s.ptr;
 820:	8b 08                	mov    (%eax),%ecx
 822:	89 0a                	mov    %ecx,(%edx)
 824:	eb b9                	jmp    7df <malloc+0xaf>
