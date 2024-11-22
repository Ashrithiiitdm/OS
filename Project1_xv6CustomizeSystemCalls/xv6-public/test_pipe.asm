
_test_pipe:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
  close(fds[0]); // Close read end

  printf(1, "Pipe close test passed!\n");
}

int main(void) {
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 e4 f0             	and    $0xfffffff0,%esp
  test_pipe_basic();
   6:	e8 65 00 00 00       	call   70 <test_pipe_basic>
  test_pipe_full();
   b:	e8 80 01 00 00       	call   190 <test_pipe_full>
  test_pipe_close();
  10:	e8 eb 02 00 00       	call   300 <test_pipe_close>
  exit();
  15:	e8 c9 05 00 00       	call   5e3 <exit>
  1a:	66 90                	xchg   %ax,%ax
  1c:	66 90                	xchg   %ax,%ax
  1e:	66 90                	xchg   %ax,%ax

00000020 <memcmp>:
int memcmp(const void *s1, const void *s2, unsigned int  n) {
  20:	55                   	push   %ebp
  21:	89 e5                	mov    %esp,%ebp
  23:	56                   	push   %esi
  24:	8b 75 10             	mov    0x10(%ebp),%esi
  27:	53                   	push   %ebx
    for (unsigned int  i = 0; i < n; i++) {
  28:	85 f6                	test   %esi,%esi
  2a:	74 34                	je     60 <memcmp+0x40>
  2c:	8b 45 08             	mov    0x8(%ebp),%eax
  2f:	8b 55 0c             	mov    0xc(%ebp),%edx
  32:	01 c6                	add    %eax,%esi
  34:	eb 14                	jmp    4a <memcmp+0x2a>
  36:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  3d:	8d 76 00             	lea    0x0(%esi),%esi
  40:	83 c0 01             	add    $0x1,%eax
  43:	83 c2 01             	add    $0x1,%edx
  46:	39 f0                	cmp    %esi,%eax
  48:	74 16                	je     60 <memcmp+0x40>
        if (u1[i] != u2[i])
  4a:	0f b6 08             	movzbl (%eax),%ecx
  4d:	0f b6 1a             	movzbl (%edx),%ebx
  50:	38 d9                	cmp    %bl,%cl
  52:	74 ec                	je     40 <memcmp+0x20>
            return u1[i] - u2[i];
  54:	0f b6 c1             	movzbl %cl,%eax
  57:	29 d8                	sub    %ebx,%eax
}
  59:	5b                   	pop    %ebx
  5a:	5e                   	pop    %esi
  5b:	5d                   	pop    %ebp
  5c:	c3                   	ret    
  5d:	8d 76 00             	lea    0x0(%esi),%esi
  60:	5b                   	pop    %ebx
    return 0;
  61:	31 c0                	xor    %eax,%eax
}
  63:	5e                   	pop    %esi
  64:	5d                   	pop    %ebp
  65:	c3                   	ret    
  66:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  6d:	8d 76 00             	lea    0x0(%esi),%esi

00000070 <test_pipe_basic>:
void test_pipe_basic() {
  70:	55                   	push   %ebp
  71:	89 e5                	mov    %esp,%ebp
  73:	56                   	push   %esi
  74:	53                   	push   %ebx
  75:	83 ec 38             	sub    $0x38,%esp
  char write_data[] = "Hello, xv6 pipe!";
  78:	c7 45 d6 48 65 6c 6c 	movl   $0x6c6c6548,-0x2a(%ebp)
  printf(1, "Starting basic pipe test...\n");
  7f:	68 c8 0a 00 00       	push   $0xac8
  84:	6a 01                	push   $0x1
  char write_data[] = "Hello, xv6 pipe!";
  86:	c7 45 da 6f 2c 20 78 	movl   $0x78202c6f,-0x26(%ebp)
  8d:	c7 45 de 76 36 20 70 	movl   $0x70203676,-0x22(%ebp)
  94:	c7 45 e2 69 70 65 21 	movl   $0x21657069,-0x1e(%ebp)
  9b:	c6 45 e6 00          	movb   $0x0,-0x1a(%ebp)
  printf(1, "Starting basic pipe test...\n");
  9f:	e8 fc 06 00 00       	call   7a0 <printf>
  if (pipe(fds) < 0) {
  a4:	8d 45 cc             	lea    -0x34(%ebp),%eax
  a7:	89 04 24             	mov    %eax,(%esp)
  aa:	e8 44 05 00 00       	call   5f3 <pipe>
  af:	83 c4 10             	add    $0x10,%esp
  b2:	85 c0                	test   %eax,%eax
  b4:	0f 88 81 00 00 00    	js     13b <test_pipe_basic+0xcb>
  if (write(fds[1], write_data, sizeof(write_data)) != sizeof(write_data)) {
  ba:	83 ec 04             	sub    $0x4,%esp
  bd:	8d 75 d6             	lea    -0x2a(%ebp),%esi
  c0:	6a 11                	push   $0x11
  c2:	56                   	push   %esi
  c3:	ff 75 d0             	push   -0x30(%ebp)
  c6:	e8 38 05 00 00       	call   603 <write>
  cb:	83 c4 10             	add    $0x10,%esp
  ce:	83 f8 11             	cmp    $0x11,%eax
  d1:	0f 85 9d 00 00 00    	jne    174 <test_pipe_basic+0x104>
  if (read(fds[0], read_data, sizeof(read_data)) != sizeof(read_data)) {
  d7:	83 ec 04             	sub    $0x4,%esp
  da:	8d 5d e7             	lea    -0x19(%ebp),%ebx
  dd:	6a 11                	push   $0x11
  df:	53                   	push   %ebx
  e0:	ff 75 cc             	push   -0x34(%ebp)
  e3:	e8 13 05 00 00       	call   5fb <read>
  e8:	83 c4 10             	add    $0x10,%esp
  eb:	83 f8 11             	cmp    $0x11,%eax
  ee:	75 71                	jne    161 <test_pipe_basic+0xf1>
  printf(1,"%s\n",read_data);
  f0:	83 ec 04             	sub    $0x4,%esp
  f3:	53                   	push   %ebx
  f4:	68 13 0b 00 00       	push   $0xb13
  f9:	6a 01                	push   $0x1
  fb:	e8 a0 06 00 00       	call   7a0 <printf>
  if (strcmp(write_data, read_data) != 0) {
 100:	59                   	pop    %ecx
 101:	58                   	pop    %eax
 102:	53                   	push   %ebx
 103:	56                   	push   %esi
 104:	e8 b7 02 00 00       	call   3c0 <strcmp>
 109:	83 c4 10             	add    $0x10,%esp
 10c:	85 c0                	test   %eax,%eax
 10e:	75 3e                	jne    14e <test_pipe_basic+0xde>
  printf(1, "Basic pipe test passed!\n");
 110:	83 ec 08             	sub    $0x8,%esp
 113:	68 34 0b 00 00       	push   $0xb34
 118:	6a 01                	push   $0x1
 11a:	e8 81 06 00 00       	call   7a0 <printf>
  close(fds[0]);
 11f:	58                   	pop    %eax
 120:	ff 75 cc             	push   -0x34(%ebp)
 123:	e8 e3 04 00 00       	call   60b <close>
  close(fds[1]);
 128:	5a                   	pop    %edx
 129:	ff 75 d0             	push   -0x30(%ebp)
 12c:	e8 da 04 00 00       	call   60b <close>
}
 131:	83 c4 10             	add    $0x10,%esp
 134:	8d 65 f8             	lea    -0x8(%ebp),%esp
 137:	5b                   	pop    %ebx
 138:	5e                   	pop    %esi
 139:	5d                   	pop    %ebp
 13a:	c3                   	ret    
    printf(1, "pipe() failed\n");
 13b:	50                   	push   %eax
 13c:	50                   	push   %eax
 13d:	68 e5 0a 00 00       	push   $0xae5
 142:	6a 01                	push   $0x1
 144:	e8 57 06 00 00       	call   7a0 <printf>
    exit();
 149:	e8 95 04 00 00       	call   5e3 <exit>
    printf(1, "Data mismatch: '%s' != '%s'\n", write_data, read_data);
 14e:	53                   	push   %ebx
 14f:	56                   	push   %esi
 150:	68 17 0b 00 00       	push   $0xb17
 155:	6a 01                	push   $0x1
 157:	e8 44 06 00 00       	call   7a0 <printf>
    exit();
 15c:	e8 82 04 00 00       	call   5e3 <exit>
    printf(1, "read() failed\n");
 161:	50                   	push   %eax
 162:	50                   	push   %eax
 163:	68 04 0b 00 00       	push   $0xb04
 168:	6a 01                	push   $0x1
 16a:	e8 31 06 00 00       	call   7a0 <printf>
    exit();
 16f:	e8 6f 04 00 00       	call   5e3 <exit>
    printf(1, "write() failed\n");
 174:	50                   	push   %eax
 175:	50                   	push   %eax
 176:	68 f4 0a 00 00       	push   $0xaf4
 17b:	6a 01                	push   $0x1
 17d:	e8 1e 06 00 00       	call   7a0 <printf>
    exit();
 182:	e8 5c 04 00 00       	call   5e3 <exit>
 187:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 18e:	66 90                	xchg   %ax,%ax

00000190 <test_pipe_full>:
void test_pipe_full() {
 190:	55                   	push   %ebp
 191:	89 e5                	mov    %esp,%ebp
 193:	56                   	push   %esi
 194:	53                   	push   %ebx
 195:	81 ec 18 04 00 00    	sub    $0x418,%esp
  printf(1, "Starting pipe full test...\n");
 19b:	68 4d 0b 00 00       	push   $0xb4d
 1a0:	6a 01                	push   $0x1
 1a2:	e8 f9 05 00 00       	call   7a0 <printf>
  if (pipe(fds) < 0) {
 1a7:	8d 85 f0 fb ff ff    	lea    -0x410(%ebp),%eax
 1ad:	89 04 24             	mov    %eax,(%esp)
 1b0:	e8 3e 04 00 00       	call   5f3 <pipe>
 1b5:	83 c4 10             	add    $0x10,%esp
 1b8:	85 c0                	test   %eax,%eax
 1ba:	0f 88 25 01 00 00    	js     2e5 <test_pipe_full+0x155>
 1c0:	8d 9d f8 fb ff ff    	lea    -0x408(%ebp),%ebx
    write_data[i] = 'A' + (i % 26);
 1c6:	b9 41 00 00 00       	mov    $0x41,%ecx
 1cb:	8d b5 12 fc ff ff    	lea    -0x3ee(%ebp),%esi
  if (pipe(fds) < 0) {
 1d1:	89 d8                	mov    %ebx,%eax
    write_data[i] = 'A' + (i % 26);
 1d3:	29 d9                	sub    %ebx,%ecx
 1d5:	8d 76 00             	lea    0x0(%esi),%esi
 1d8:	8d 14 01             	lea    (%ecx,%eax,1),%edx
  for (i = 0; i < 26; i++) {
 1db:	83 c0 01             	add    $0x1,%eax
    write_data[i] = 'A' + (i % 26);
 1de:	88 50 ff             	mov    %dl,-0x1(%eax)
  for (i = 0; i < 26; i++) {
 1e1:	39 c6                	cmp    %eax,%esi
 1e3:	75 f3                	jne    1d8 <test_pipe_full+0x48>
  if (write(fds[1], write_data, PIPESIZE) == PIPESIZE) {
 1e5:	83 ec 04             	sub    $0x4,%esp
 1e8:	68 00 02 00 00       	push   $0x200
 1ed:	53                   	push   %ebx
 1ee:	ff b5 f4 fb ff ff    	push   -0x40c(%ebp)
 1f4:	e8 0a 04 00 00       	call   603 <write>
 1f9:	83 c4 10             	add    $0x10,%esp
 1fc:	3d 00 02 00 00       	cmp    $0x200,%eax
 201:	0f 84 cb 00 00 00    	je     2d2 <test_pipe_full+0x142>
  if (write(fds[1], "X", 1) != -1) {
 207:	83 ec 04             	sub    $0x4,%esp
 20a:	6a 01                	push   $0x1
 20c:	68 84 0b 00 00       	push   $0xb84
 211:	ff b5 f4 fb ff ff    	push   -0x40c(%ebp)
 217:	e8 e7 03 00 00       	call   603 <write>
 21c:	83 c4 10             	add    $0x10,%esp
 21f:	83 f8 ff             	cmp    $0xffffffff,%eax
 222:	0f 85 97 00 00 00    	jne    2bf <test_pipe_full+0x12f>
  if (read(fds[0], read_data, PIPESIZE) != PIPESIZE) {
 228:	83 ec 04             	sub    $0x4,%esp
 22b:	8d b5 f8 fd ff ff    	lea    -0x208(%ebp),%esi
 231:	68 00 02 00 00       	push   $0x200
 236:	56                   	push   %esi
 237:	ff b5 f0 fb ff ff    	push   -0x410(%ebp)
 23d:	e8 b9 03 00 00       	call   5fb <read>
 242:	83 c4 10             	add    $0x10,%esp
 245:	3d 00 02 00 00       	cmp    $0x200,%eax
 24a:	75 60                	jne    2ac <test_pipe_full+0x11c>
    for (unsigned int  i = 0; i < n; i++) {
 24c:	31 c0                	xor    %eax,%eax
 24e:	66 90                	xchg   %ax,%ax
        if (u1[i] != u2[i])
 250:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
 254:	38 0c 03             	cmp    %cl,(%ebx,%eax,1)
 257:	75 3f                	jne    298 <test_pipe_full+0x108>
    for (unsigned int  i = 0; i < n; i++) {
 259:	83 c0 01             	add    $0x1,%eax
 25c:	3d 00 02 00 00       	cmp    $0x200,%eax
 261:	75 ed                	jne    250 <test_pipe_full+0xc0>
  printf(1, "Pipe full test passed!\n");
 263:	83 ec 08             	sub    $0x8,%esp
 266:	68 a0 0b 00 00       	push   $0xba0
 26b:	6a 01                	push   $0x1
 26d:	e8 2e 05 00 00       	call   7a0 <printf>
  close(fds[0]);
 272:	58                   	pop    %eax
 273:	ff b5 f0 fb ff ff    	push   -0x410(%ebp)
 279:	e8 8d 03 00 00       	call   60b <close>
  close(fds[1]);
 27e:	5a                   	pop    %edx
 27f:	ff b5 f4 fb ff ff    	push   -0x40c(%ebp)
 285:	e8 81 03 00 00       	call   60b <close>
}
 28a:	83 c4 10             	add    $0x10,%esp
 28d:	8d 65 f8             	lea    -0x8(%ebp),%esp
 290:	5b                   	pop    %ebx
 291:	5e                   	pop    %esi
 292:	5d                   	pop    %ebp
 293:	c3                   	ret    
 294:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    printf(1, "Data mismatch in full pipe test\n");
 298:	83 ec 08             	sub    $0x8,%esp
 29b:	68 30 0c 00 00       	push   $0xc30
 2a0:	6a 01                	push   $0x1
 2a2:	e8 f9 04 00 00       	call   7a0 <printf>
    exit();
 2a7:	e8 37 03 00 00       	call   5e3 <exit>
    printf(1, "Failed to read full pipe\n");
 2ac:	51                   	push   %ecx
 2ad:	51                   	push   %ecx
 2ae:	68 86 0b 00 00       	push   $0xb86
 2b3:	6a 01                	push   $0x1
 2b5:	e8 e6 04 00 00       	call   7a0 <printf>
    exit();
 2ba:	e8 24 03 00 00       	call   5e3 <exit>
    printf(1, "Write to full pipe did not block\n");
 2bf:	53                   	push   %ebx
 2c0:	53                   	push   %ebx
 2c1:	68 0c 0c 00 00       	push   $0xc0c
 2c6:	6a 01                	push   $0x1
 2c8:	e8 d3 04 00 00       	call   7a0 <printf>
    exit();
 2cd:	e8 11 03 00 00       	call   5e3 <exit>
    printf(1, "Failed to write full pipe\n");
 2d2:	56                   	push   %esi
 2d3:	56                   	push   %esi
 2d4:	68 69 0b 00 00       	push   $0xb69
 2d9:	6a 01                	push   $0x1
 2db:	e8 c0 04 00 00       	call   7a0 <printf>
    exit();
 2e0:	e8 fe 02 00 00       	call   5e3 <exit>
    printf(1, "pipe() failed\n");
 2e5:	50                   	push   %eax
 2e6:	50                   	push   %eax
 2e7:	68 e5 0a 00 00       	push   $0xae5
 2ec:	6a 01                	push   $0x1
 2ee:	e8 ad 04 00 00       	call   7a0 <printf>
    exit();
 2f3:	e8 eb 02 00 00       	call   5e3 <exit>
 2f8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 2ff:	90                   	nop

00000300 <test_pipe_close>:
void test_pipe_close() {
 300:	55                   	push   %ebp
 301:	89 e5                	mov    %esp,%ebp
 303:	83 ec 30             	sub    $0x30,%esp
  printf(1, "Starting pipe close test...\n");
 306:	68 b8 0b 00 00       	push   $0xbb8
 30b:	6a 01                	push   $0x1
 30d:	e8 8e 04 00 00       	call   7a0 <printf>
  if (pipe(fds) < 0) {
 312:	8d 45 e0             	lea    -0x20(%ebp),%eax
 315:	89 04 24             	mov    %eax,(%esp)
 318:	e8 d6 02 00 00       	call   5f3 <pipe>
 31d:	83 c4 10             	add    $0x10,%esp
 320:	85 c0                	test   %eax,%eax
 322:	78 41                	js     365 <test_pipe_close+0x65>
  close(fds[1]); // Close write end
 324:	83 ec 0c             	sub    $0xc,%esp
 327:	ff 75 e4             	push   -0x1c(%ebp)
 32a:	e8 dc 02 00 00       	call   60b <close>
  if (read(fds[0], buf, sizeof(buf)) != 0) { // Reading from pipe after write end closed
 32f:	83 c4 0c             	add    $0xc,%esp
 332:	8d 45 e8             	lea    -0x18(%ebp),%eax
 335:	6a 10                	push   $0x10
 337:	50                   	push   %eax
 338:	ff 75 e0             	push   -0x20(%ebp)
 33b:	e8 bb 02 00 00       	call   5fb <read>
 340:	83 c4 10             	add    $0x10,%esp
 343:	85 c0                	test   %eax,%eax
 345:	75 31                	jne    378 <test_pipe_close+0x78>
  close(fds[0]); // Close read end
 347:	83 ec 0c             	sub    $0xc,%esp
 34a:	ff 75 e0             	push   -0x20(%ebp)
 34d:	e8 b9 02 00 00       	call   60b <close>
  printf(1, "Pipe close test passed!\n");
 352:	58                   	pop    %eax
 353:	5a                   	pop    %edx
 354:	68 f3 0b 00 00       	push   $0xbf3
 359:	6a 01                	push   $0x1
 35b:	e8 40 04 00 00       	call   7a0 <printf>
}
 360:	83 c4 10             	add    $0x10,%esp
 363:	c9                   	leave  
 364:	c3                   	ret    
    printf(1, "pipe() failed\n");
 365:	50                   	push   %eax
 366:	50                   	push   %eax
 367:	68 e5 0a 00 00       	push   $0xae5
 36c:	6a 01                	push   $0x1
 36e:	e8 2d 04 00 00       	call   7a0 <printf>
    exit();
 373:	e8 6b 02 00 00       	call   5e3 <exit>
    printf(1, "Read from closed pipe failed\n");
 378:	51                   	push   %ecx
 379:	51                   	push   %ecx
 37a:	68 d5 0b 00 00       	push   $0xbd5
 37f:	6a 01                	push   $0x1
 381:	e8 1a 04 00 00       	call   7a0 <printf>
    exit();
 386:	e8 58 02 00 00       	call   5e3 <exit>
 38b:	66 90                	xchg   %ax,%ax
 38d:	66 90                	xchg   %ax,%ax
 38f:	90                   	nop

00000390 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 390:	55                   	push   %ebp
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 391:	31 c0                	xor    %eax,%eax
{
 393:	89 e5                	mov    %esp,%ebp
 395:	53                   	push   %ebx
 396:	8b 4d 08             	mov    0x8(%ebp),%ecx
 399:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 39c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while((*s++ = *t++) != 0)
 3a0:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
 3a4:	88 14 01             	mov    %dl,(%ecx,%eax,1)
 3a7:	83 c0 01             	add    $0x1,%eax
 3aa:	84 d2                	test   %dl,%dl
 3ac:	75 f2                	jne    3a0 <strcpy+0x10>
    ;
  return os;
}
 3ae:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 3b1:	89 c8                	mov    %ecx,%eax
 3b3:	c9                   	leave  
 3b4:	c3                   	ret    
 3b5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 3bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000003c0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 3c0:	55                   	push   %ebp
 3c1:	89 e5                	mov    %esp,%ebp
 3c3:	53                   	push   %ebx
 3c4:	8b 55 08             	mov    0x8(%ebp),%edx
 3c7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
 3ca:	0f b6 02             	movzbl (%edx),%eax
 3cd:	84 c0                	test   %al,%al
 3cf:	75 17                	jne    3e8 <strcmp+0x28>
 3d1:	eb 3a                	jmp    40d <strcmp+0x4d>
 3d3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 3d7:	90                   	nop
 3d8:	0f b6 42 01          	movzbl 0x1(%edx),%eax
    p++, q++;
 3dc:	83 c2 01             	add    $0x1,%edx
 3df:	8d 59 01             	lea    0x1(%ecx),%ebx
  while(*p && *p == *q)
 3e2:	84 c0                	test   %al,%al
 3e4:	74 1a                	je     400 <strcmp+0x40>
    p++, q++;
 3e6:	89 d9                	mov    %ebx,%ecx
  while(*p && *p == *q)
 3e8:	0f b6 19             	movzbl (%ecx),%ebx
 3eb:	38 c3                	cmp    %al,%bl
 3ed:	74 e9                	je     3d8 <strcmp+0x18>
  return (uchar)*p - (uchar)*q;
 3ef:	29 d8                	sub    %ebx,%eax
}
 3f1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 3f4:	c9                   	leave  
 3f5:	c3                   	ret    
 3f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 3fd:	8d 76 00             	lea    0x0(%esi),%esi
  return (uchar)*p - (uchar)*q;
 400:	0f b6 59 01          	movzbl 0x1(%ecx),%ebx
 404:	31 c0                	xor    %eax,%eax
 406:	29 d8                	sub    %ebx,%eax
}
 408:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 40b:	c9                   	leave  
 40c:	c3                   	ret    
  return (uchar)*p - (uchar)*q;
 40d:	0f b6 19             	movzbl (%ecx),%ebx
 410:	31 c0                	xor    %eax,%eax
 412:	eb db                	jmp    3ef <strcmp+0x2f>
 414:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 41b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 41f:	90                   	nop

00000420 <strlen>:

uint
strlen(const char *s)
{
 420:	55                   	push   %ebp
 421:	89 e5                	mov    %esp,%ebp
 423:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
 426:	80 3a 00             	cmpb   $0x0,(%edx)
 429:	74 15                	je     440 <strlen+0x20>
 42b:	31 c0                	xor    %eax,%eax
 42d:	8d 76 00             	lea    0x0(%esi),%esi
 430:	83 c0 01             	add    $0x1,%eax
 433:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
 437:	89 c1                	mov    %eax,%ecx
 439:	75 f5                	jne    430 <strlen+0x10>
    ;
  return n;
}
 43b:	89 c8                	mov    %ecx,%eax
 43d:	5d                   	pop    %ebp
 43e:	c3                   	ret    
 43f:	90                   	nop
  for(n = 0; s[n]; n++)
 440:	31 c9                	xor    %ecx,%ecx
}
 442:	5d                   	pop    %ebp
 443:	89 c8                	mov    %ecx,%eax
 445:	c3                   	ret    
 446:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 44d:	8d 76 00             	lea    0x0(%esi),%esi

00000450 <memset>:

void*
memset(void *dst, int c, uint n)
{
 450:	55                   	push   %ebp
 451:	89 e5                	mov    %esp,%ebp
 453:	57                   	push   %edi
 454:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 457:	8b 4d 10             	mov    0x10(%ebp),%ecx
 45a:	8b 45 0c             	mov    0xc(%ebp),%eax
 45d:	89 d7                	mov    %edx,%edi
 45f:	fc                   	cld    
 460:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 462:	8b 7d fc             	mov    -0x4(%ebp),%edi
 465:	89 d0                	mov    %edx,%eax
 467:	c9                   	leave  
 468:	c3                   	ret    
 469:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000470 <strchr>:

char*
strchr(const char *s, char c)
{
 470:	55                   	push   %ebp
 471:	89 e5                	mov    %esp,%ebp
 473:	8b 45 08             	mov    0x8(%ebp),%eax
 476:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 47a:	0f b6 10             	movzbl (%eax),%edx
 47d:	84 d2                	test   %dl,%dl
 47f:	75 12                	jne    493 <strchr+0x23>
 481:	eb 1d                	jmp    4a0 <strchr+0x30>
 483:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 487:	90                   	nop
 488:	0f b6 50 01          	movzbl 0x1(%eax),%edx
 48c:	83 c0 01             	add    $0x1,%eax
 48f:	84 d2                	test   %dl,%dl
 491:	74 0d                	je     4a0 <strchr+0x30>
    if(*s == c)
 493:	38 d1                	cmp    %dl,%cl
 495:	75 f1                	jne    488 <strchr+0x18>
      return (char*)s;
  return 0;
}
 497:	5d                   	pop    %ebp
 498:	c3                   	ret    
 499:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return 0;
 4a0:	31 c0                	xor    %eax,%eax
}
 4a2:	5d                   	pop    %ebp
 4a3:	c3                   	ret    
 4a4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 4ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 4af:	90                   	nop

000004b0 <gets>:

char*
gets(char *buf, int max)
{
 4b0:	55                   	push   %ebp
 4b1:	89 e5                	mov    %esp,%ebp
 4b3:	57                   	push   %edi
 4b4:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
 4b5:	8d 7d e7             	lea    -0x19(%ebp),%edi
{
 4b8:	53                   	push   %ebx
  for(i=0; i+1 < max; ){
 4b9:	31 db                	xor    %ebx,%ebx
{
 4bb:	83 ec 1c             	sub    $0x1c,%esp
  for(i=0; i+1 < max; ){
 4be:	eb 27                	jmp    4e7 <gets+0x37>
    cc = read(0, &c, 1);
 4c0:	83 ec 04             	sub    $0x4,%esp
 4c3:	6a 01                	push   $0x1
 4c5:	57                   	push   %edi
 4c6:	6a 00                	push   $0x0
 4c8:	e8 2e 01 00 00       	call   5fb <read>
    if(cc < 1)
 4cd:	83 c4 10             	add    $0x10,%esp
 4d0:	85 c0                	test   %eax,%eax
 4d2:	7e 1d                	jle    4f1 <gets+0x41>
      break;
    buf[i++] = c;
 4d4:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 4d8:	8b 55 08             	mov    0x8(%ebp),%edx
 4db:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
    if(c == '\n' || c == '\r')
 4df:	3c 0a                	cmp    $0xa,%al
 4e1:	74 1d                	je     500 <gets+0x50>
 4e3:	3c 0d                	cmp    $0xd,%al
 4e5:	74 19                	je     500 <gets+0x50>
  for(i=0; i+1 < max; ){
 4e7:	89 de                	mov    %ebx,%esi
 4e9:	83 c3 01             	add    $0x1,%ebx
 4ec:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 4ef:	7c cf                	jl     4c0 <gets+0x10>
      break;
  }
  buf[i] = '\0';
 4f1:	8b 45 08             	mov    0x8(%ebp),%eax
 4f4:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
 4f8:	8d 65 f4             	lea    -0xc(%ebp),%esp
 4fb:	5b                   	pop    %ebx
 4fc:	5e                   	pop    %esi
 4fd:	5f                   	pop    %edi
 4fe:	5d                   	pop    %ebp
 4ff:	c3                   	ret    
  buf[i] = '\0';
 500:	8b 45 08             	mov    0x8(%ebp),%eax
 503:	89 de                	mov    %ebx,%esi
 505:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
}
 509:	8d 65 f4             	lea    -0xc(%ebp),%esp
 50c:	5b                   	pop    %ebx
 50d:	5e                   	pop    %esi
 50e:	5f                   	pop    %edi
 50f:	5d                   	pop    %ebp
 510:	c3                   	ret    
 511:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 518:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 51f:	90                   	nop

00000520 <stat>:

int
stat(const char *n, struct stat *st)
{
 520:	55                   	push   %ebp
 521:	89 e5                	mov    %esp,%ebp
 523:	56                   	push   %esi
 524:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 525:	83 ec 08             	sub    $0x8,%esp
 528:	6a 00                	push   $0x0
 52a:	ff 75 08             	push   0x8(%ebp)
 52d:	e8 f1 00 00 00       	call   623 <open>
  if(fd < 0)
 532:	83 c4 10             	add    $0x10,%esp
 535:	85 c0                	test   %eax,%eax
 537:	78 27                	js     560 <stat+0x40>
    return -1;
  r = fstat(fd, st);
 539:	83 ec 08             	sub    $0x8,%esp
 53c:	ff 75 0c             	push   0xc(%ebp)
 53f:	89 c3                	mov    %eax,%ebx
 541:	50                   	push   %eax
 542:	e8 f4 00 00 00       	call   63b <fstat>
  close(fd);
 547:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 54a:	89 c6                	mov    %eax,%esi
  close(fd);
 54c:	e8 ba 00 00 00       	call   60b <close>
  return r;
 551:	83 c4 10             	add    $0x10,%esp
}
 554:	8d 65 f8             	lea    -0x8(%ebp),%esp
 557:	89 f0                	mov    %esi,%eax
 559:	5b                   	pop    %ebx
 55a:	5e                   	pop    %esi
 55b:	5d                   	pop    %ebp
 55c:	c3                   	ret    
 55d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 560:	be ff ff ff ff       	mov    $0xffffffff,%esi
 565:	eb ed                	jmp    554 <stat+0x34>
 567:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 56e:	66 90                	xchg   %ax,%ax

00000570 <atoi>:

int
atoi(const char *s)
{
 570:	55                   	push   %ebp
 571:	89 e5                	mov    %esp,%ebp
 573:	53                   	push   %ebx
 574:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 577:	0f be 02             	movsbl (%edx),%eax
 57a:	8d 48 d0             	lea    -0x30(%eax),%ecx
 57d:	80 f9 09             	cmp    $0x9,%cl
  n = 0;
 580:	b9 00 00 00 00       	mov    $0x0,%ecx
  while('0' <= *s && *s <= '9')
 585:	77 1e                	ja     5a5 <atoi+0x35>
 587:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 58e:	66 90                	xchg   %ax,%ax
    n = n*10 + *s++ - '0';
 590:	83 c2 01             	add    $0x1,%edx
 593:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
 596:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
  while('0' <= *s && *s <= '9')
 59a:	0f be 02             	movsbl (%edx),%eax
 59d:	8d 58 d0             	lea    -0x30(%eax),%ebx
 5a0:	80 fb 09             	cmp    $0x9,%bl
 5a3:	76 eb                	jbe    590 <atoi+0x20>
  return n;
}
 5a5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 5a8:	89 c8                	mov    %ecx,%eax
 5aa:	c9                   	leave  
 5ab:	c3                   	ret    
 5ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000005b0 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 5b0:	55                   	push   %ebp
 5b1:	89 e5                	mov    %esp,%ebp
 5b3:	57                   	push   %edi
 5b4:	8b 45 10             	mov    0x10(%ebp),%eax
 5b7:	8b 55 08             	mov    0x8(%ebp),%edx
 5ba:	56                   	push   %esi
 5bb:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 5be:	85 c0                	test   %eax,%eax
 5c0:	7e 13                	jle    5d5 <memmove+0x25>
 5c2:	01 d0                	add    %edx,%eax
  dst = vdst;
 5c4:	89 d7                	mov    %edx,%edi
 5c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 5cd:	8d 76 00             	lea    0x0(%esi),%esi
    *dst++ = *src++;
 5d0:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
 5d1:	39 f8                	cmp    %edi,%eax
 5d3:	75 fb                	jne    5d0 <memmove+0x20>
  return vdst;
}
 5d5:	5e                   	pop    %esi
 5d6:	89 d0                	mov    %edx,%eax
 5d8:	5f                   	pop    %edi
 5d9:	5d                   	pop    %ebp
 5da:	c3                   	ret    

000005db <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 5db:	b8 01 00 00 00       	mov    $0x1,%eax
 5e0:	cd 40                	int    $0x40
 5e2:	c3                   	ret    

000005e3 <exit>:
SYSCALL(exit)
 5e3:	b8 02 00 00 00       	mov    $0x2,%eax
 5e8:	cd 40                	int    $0x40
 5ea:	c3                   	ret    

000005eb <wait>:
SYSCALL(wait)
 5eb:	b8 03 00 00 00       	mov    $0x3,%eax
 5f0:	cd 40                	int    $0x40
 5f2:	c3                   	ret    

000005f3 <pipe>:
SYSCALL(pipe)
 5f3:	b8 04 00 00 00       	mov    $0x4,%eax
 5f8:	cd 40                	int    $0x40
 5fa:	c3                   	ret    

000005fb <read>:
SYSCALL(read)
 5fb:	b8 05 00 00 00       	mov    $0x5,%eax
 600:	cd 40                	int    $0x40
 602:	c3                   	ret    

00000603 <write>:
SYSCALL(write)
 603:	b8 10 00 00 00       	mov    $0x10,%eax
 608:	cd 40                	int    $0x40
 60a:	c3                   	ret    

0000060b <close>:
SYSCALL(close)
 60b:	b8 15 00 00 00       	mov    $0x15,%eax
 610:	cd 40                	int    $0x40
 612:	c3                   	ret    

00000613 <kill>:
SYSCALL(kill)
 613:	b8 06 00 00 00       	mov    $0x6,%eax
 618:	cd 40                	int    $0x40
 61a:	c3                   	ret    

0000061b <exec>:
SYSCALL(exec)
 61b:	b8 07 00 00 00       	mov    $0x7,%eax
 620:	cd 40                	int    $0x40
 622:	c3                   	ret    

00000623 <open>:
SYSCALL(open)
 623:	b8 0f 00 00 00       	mov    $0xf,%eax
 628:	cd 40                	int    $0x40
 62a:	c3                   	ret    

0000062b <mknod>:
SYSCALL(mknod)
 62b:	b8 11 00 00 00       	mov    $0x11,%eax
 630:	cd 40                	int    $0x40
 632:	c3                   	ret    

00000633 <unlink>:
SYSCALL(unlink)
 633:	b8 12 00 00 00       	mov    $0x12,%eax
 638:	cd 40                	int    $0x40
 63a:	c3                   	ret    

0000063b <fstat>:
SYSCALL(fstat)
 63b:	b8 08 00 00 00       	mov    $0x8,%eax
 640:	cd 40                	int    $0x40
 642:	c3                   	ret    

00000643 <link>:
SYSCALL(link)
 643:	b8 13 00 00 00       	mov    $0x13,%eax
 648:	cd 40                	int    $0x40
 64a:	c3                   	ret    

0000064b <mkdir>:
SYSCALL(mkdir)
 64b:	b8 14 00 00 00       	mov    $0x14,%eax
 650:	cd 40                	int    $0x40
 652:	c3                   	ret    

00000653 <chdir>:
SYSCALL(chdir)
 653:	b8 09 00 00 00       	mov    $0x9,%eax
 658:	cd 40                	int    $0x40
 65a:	c3                   	ret    

0000065b <dup>:
SYSCALL(dup)
 65b:	b8 0a 00 00 00       	mov    $0xa,%eax
 660:	cd 40                	int    $0x40
 662:	c3                   	ret    

00000663 <getpid>:
SYSCALL(getpid)
 663:	b8 0b 00 00 00       	mov    $0xb,%eax
 668:	cd 40                	int    $0x40
 66a:	c3                   	ret    

0000066b <sbrk>:
SYSCALL(sbrk)
 66b:	b8 0c 00 00 00       	mov    $0xc,%eax
 670:	cd 40                	int    $0x40
 672:	c3                   	ret    

00000673 <sleep>:
SYSCALL(sleep)
 673:	b8 0d 00 00 00       	mov    $0xd,%eax
 678:	cd 40                	int    $0x40
 67a:	c3                   	ret    

0000067b <uptime>:
SYSCALL(uptime)
 67b:	b8 0e 00 00 00       	mov    $0xe,%eax
 680:	cd 40                	int    $0x40
 682:	c3                   	ret    

00000683 <cps>:
SYSCALL(cps)
 683:	b8 16 00 00 00       	mov    $0x16,%eax
 688:	cd 40                	int    $0x40
 68a:	c3                   	ret    

0000068b <calls>:
SYSCALL(calls)
 68b:	b8 17 00 00 00       	mov    $0x17,%eax
 690:	cd 40                	int    $0x40
 692:	c3                   	ret    

00000693 <get_process_type>:
SYSCALL(get_process_type)
 693:	b8 18 00 00 00       	mov    $0x18,%eax
 698:	cd 40                	int    $0x40
 69a:	c3                   	ret    

0000069b <wait_pid>:
SYSCALL(wait_pid)
 69b:	b8 19 00 00 00       	mov    $0x19,%eax
 6a0:	cd 40                	int    $0x40
 6a2:	c3                   	ret    

000006a3 <unwait_pid>:
SYSCALL(unwait_pid)
 6a3:	b8 1a 00 00 00       	mov    $0x1a,%eax
 6a8:	cd 40                	int    $0x40
 6aa:	c3                   	ret    

000006ab <mem_usage>:
SYSCALL(mem_usage)
 6ab:	b8 1b 00 00 00       	mov    $0x1b,%eax
 6b0:	cd 40                	int    $0x40
 6b2:	c3                   	ret    

000006b3 <get_priority>:
SYSCALL(get_priority)
 6b3:	b8 1c 00 00 00       	mov    $0x1c,%eax
 6b8:	cd 40                	int    $0x40
 6ba:	c3                   	ret    

000006bb <set_priority>:
SYSCALL(set_priority)
 6bb:	b8 1d 00 00 00       	mov    $0x1d,%eax
 6c0:	cd 40                	int    $0x40
 6c2:	c3                   	ret    

000006c3 <sem_init>:
SYSCALL(sem_init)
 6c3:	b8 1e 00 00 00       	mov    $0x1e,%eax
 6c8:	cd 40                	int    $0x40
 6ca:	c3                   	ret    

000006cb <sem_destroy>:
SYSCALL(sem_destroy)
 6cb:	b8 1f 00 00 00       	mov    $0x1f,%eax
 6d0:	cd 40                	int    $0x40
 6d2:	c3                   	ret    

000006d3 <sem_wait>:
SYSCALL(sem_wait)
 6d3:	b8 20 00 00 00       	mov    $0x20,%eax
 6d8:	cd 40                	int    $0x40
 6da:	c3                   	ret    

000006db <sem_signal>:
SYSCALL(sem_signal)
 6db:	b8 21 00 00 00       	mov    $0x21,%eax
 6e0:	cd 40                	int    $0x40
 6e2:	c3                   	ret    

000006e3 <getppid>:
 6e3:	b8 22 00 00 00       	mov    $0x22,%eax
 6e8:	cd 40                	int    $0x40
 6ea:	c3                   	ret    
 6eb:	66 90                	xchg   %ax,%ax
 6ed:	66 90                	xchg   %ax,%ax
 6ef:	90                   	nop

000006f0 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 6f0:	55                   	push   %ebp
 6f1:	89 e5                	mov    %esp,%ebp
 6f3:	57                   	push   %edi
 6f4:	56                   	push   %esi
 6f5:	53                   	push   %ebx
 6f6:	83 ec 3c             	sub    $0x3c,%esp
 6f9:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 6fc:	89 d1                	mov    %edx,%ecx
{
 6fe:	89 45 b8             	mov    %eax,-0x48(%ebp)
  if(sgn && xx < 0){
 701:	85 d2                	test   %edx,%edx
 703:	0f 89 7f 00 00 00    	jns    788 <printint+0x98>
 709:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 70d:	74 79                	je     788 <printint+0x98>
    neg = 1;
 70f:	c7 45 bc 01 00 00 00 	movl   $0x1,-0x44(%ebp)
    x = -xx;
 716:	f7 d9                	neg    %ecx
  } else {
    x = xx;
  }

  i = 0;
 718:	31 db                	xor    %ebx,%ebx
 71a:	8d 75 d7             	lea    -0x29(%ebp),%esi
 71d:	8d 76 00             	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
 720:	89 c8                	mov    %ecx,%eax
 722:	31 d2                	xor    %edx,%edx
 724:	89 cf                	mov    %ecx,%edi
 726:	f7 75 c4             	divl   -0x3c(%ebp)
 729:	0f b6 92 b0 0c 00 00 	movzbl 0xcb0(%edx),%edx
 730:	89 45 c0             	mov    %eax,-0x40(%ebp)
 733:	89 d8                	mov    %ebx,%eax
 735:	8d 5b 01             	lea    0x1(%ebx),%ebx
  }while((x /= base) != 0);
 738:	8b 4d c0             	mov    -0x40(%ebp),%ecx
    buf[i++] = digits[x % base];
 73b:	88 14 1e             	mov    %dl,(%esi,%ebx,1)
  }while((x /= base) != 0);
 73e:	39 7d c4             	cmp    %edi,-0x3c(%ebp)
 741:	76 dd                	jbe    720 <printint+0x30>
  if(neg)
 743:	8b 4d bc             	mov    -0x44(%ebp),%ecx
 746:	85 c9                	test   %ecx,%ecx
 748:	74 0c                	je     756 <printint+0x66>
    buf[i++] = '-';
 74a:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    buf[i++] = digits[x % base];
 74f:	89 d8                	mov    %ebx,%eax
    buf[i++] = '-';
 751:	ba 2d 00 00 00       	mov    $0x2d,%edx

  while(--i >= 0)
 756:	8b 7d b8             	mov    -0x48(%ebp),%edi
 759:	8d 5c 05 d7          	lea    -0x29(%ebp,%eax,1),%ebx
 75d:	eb 07                	jmp    766 <printint+0x76>
 75f:	90                   	nop
    putc(fd, buf[i]);
 760:	0f b6 13             	movzbl (%ebx),%edx
 763:	83 eb 01             	sub    $0x1,%ebx
  write(fd, &c, 1);
 766:	83 ec 04             	sub    $0x4,%esp
 769:	88 55 d7             	mov    %dl,-0x29(%ebp)
 76c:	6a 01                	push   $0x1
 76e:	56                   	push   %esi
 76f:	57                   	push   %edi
 770:	e8 8e fe ff ff       	call   603 <write>
  while(--i >= 0)
 775:	83 c4 10             	add    $0x10,%esp
 778:	39 de                	cmp    %ebx,%esi
 77a:	75 e4                	jne    760 <printint+0x70>
}
 77c:	8d 65 f4             	lea    -0xc(%ebp),%esp
 77f:	5b                   	pop    %ebx
 780:	5e                   	pop    %esi
 781:	5f                   	pop    %edi
 782:	5d                   	pop    %ebp
 783:	c3                   	ret    
 784:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
 788:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
 78f:	eb 87                	jmp    718 <printint+0x28>
 791:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 798:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 79f:	90                   	nop

000007a0 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 7a0:	55                   	push   %ebp
 7a1:	89 e5                	mov    %esp,%ebp
 7a3:	57                   	push   %edi
 7a4:	56                   	push   %esi
 7a5:	53                   	push   %ebx
 7a6:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 7a9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
{
 7ac:	8b 75 08             	mov    0x8(%ebp),%esi
  for(i = 0; fmt[i]; i++){
 7af:	0f b6 13             	movzbl (%ebx),%edx
 7b2:	84 d2                	test   %dl,%dl
 7b4:	74 6a                	je     820 <printf+0x80>
  ap = (uint*)(void*)&fmt + 1;
 7b6:	8d 45 10             	lea    0x10(%ebp),%eax
 7b9:	83 c3 01             	add    $0x1,%ebx
  write(fd, &c, 1);
 7bc:	8d 7d e7             	lea    -0x19(%ebp),%edi
  state = 0;
 7bf:	31 c9                	xor    %ecx,%ecx
  ap = (uint*)(void*)&fmt + 1;
 7c1:	89 45 d0             	mov    %eax,-0x30(%ebp)
 7c4:	eb 36                	jmp    7fc <printf+0x5c>
 7c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 7cd:	8d 76 00             	lea    0x0(%esi),%esi
 7d0:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
 7d3:	b9 25 00 00 00       	mov    $0x25,%ecx
      if(c == '%'){
 7d8:	83 f8 25             	cmp    $0x25,%eax
 7db:	74 15                	je     7f2 <printf+0x52>
  write(fd, &c, 1);
 7dd:	83 ec 04             	sub    $0x4,%esp
 7e0:	88 55 e7             	mov    %dl,-0x19(%ebp)
 7e3:	6a 01                	push   $0x1
 7e5:	57                   	push   %edi
 7e6:	56                   	push   %esi
 7e7:	e8 17 fe ff ff       	call   603 <write>
 7ec:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
      } else {
        putc(fd, c);
 7ef:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
 7f2:	0f b6 13             	movzbl (%ebx),%edx
 7f5:	83 c3 01             	add    $0x1,%ebx
 7f8:	84 d2                	test   %dl,%dl
 7fa:	74 24                	je     820 <printf+0x80>
    c = fmt[i] & 0xff;
 7fc:	0f b6 c2             	movzbl %dl,%eax
    if(state == 0){
 7ff:	85 c9                	test   %ecx,%ecx
 801:	74 cd                	je     7d0 <printf+0x30>
      }
    } else if(state == '%'){
 803:	83 f9 25             	cmp    $0x25,%ecx
 806:	75 ea                	jne    7f2 <printf+0x52>
      if(c == 'd'){
 808:	83 f8 25             	cmp    $0x25,%eax
 80b:	0f 84 07 01 00 00    	je     918 <printf+0x178>
 811:	83 e8 63             	sub    $0x63,%eax
 814:	83 f8 15             	cmp    $0x15,%eax
 817:	77 17                	ja     830 <printf+0x90>
 819:	ff 24 85 58 0c 00 00 	jmp    *0xc58(,%eax,4)
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 820:	8d 65 f4             	lea    -0xc(%ebp),%esp
 823:	5b                   	pop    %ebx
 824:	5e                   	pop    %esi
 825:	5f                   	pop    %edi
 826:	5d                   	pop    %ebp
 827:	c3                   	ret    
 828:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 82f:	90                   	nop
  write(fd, &c, 1);
 830:	83 ec 04             	sub    $0x4,%esp
 833:	88 55 d4             	mov    %dl,-0x2c(%ebp)
 836:	6a 01                	push   $0x1
 838:	57                   	push   %edi
 839:	56                   	push   %esi
 83a:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 83e:	e8 c0 fd ff ff       	call   603 <write>
        putc(fd, c);
 843:	0f b6 55 d4          	movzbl -0x2c(%ebp),%edx
  write(fd, &c, 1);
 847:	83 c4 0c             	add    $0xc,%esp
 84a:	88 55 e7             	mov    %dl,-0x19(%ebp)
 84d:	6a 01                	push   $0x1
 84f:	57                   	push   %edi
 850:	56                   	push   %esi
 851:	e8 ad fd ff ff       	call   603 <write>
        putc(fd, c);
 856:	83 c4 10             	add    $0x10,%esp
      state = 0;
 859:	31 c9                	xor    %ecx,%ecx
 85b:	eb 95                	jmp    7f2 <printf+0x52>
 85d:	8d 76 00             	lea    0x0(%esi),%esi
        printint(fd, *ap, 16, 0);
 860:	83 ec 0c             	sub    $0xc,%esp
 863:	b9 10 00 00 00       	mov    $0x10,%ecx
 868:	6a 00                	push   $0x0
 86a:	8b 45 d0             	mov    -0x30(%ebp),%eax
 86d:	8b 10                	mov    (%eax),%edx
 86f:	89 f0                	mov    %esi,%eax
 871:	e8 7a fe ff ff       	call   6f0 <printint>
        ap++;
 876:	83 45 d0 04          	addl   $0x4,-0x30(%ebp)
 87a:	83 c4 10             	add    $0x10,%esp
      state = 0;
 87d:	31 c9                	xor    %ecx,%ecx
 87f:	e9 6e ff ff ff       	jmp    7f2 <printf+0x52>
 884:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        s = (char*)*ap;
 888:	8b 45 d0             	mov    -0x30(%ebp),%eax
 88b:	8b 10                	mov    (%eax),%edx
        ap++;
 88d:	83 c0 04             	add    $0x4,%eax
 890:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
 893:	85 d2                	test   %edx,%edx
 895:	0f 84 8d 00 00 00    	je     928 <printf+0x188>
        while(*s != 0){
 89b:	0f b6 02             	movzbl (%edx),%eax
      state = 0;
 89e:	31 c9                	xor    %ecx,%ecx
        while(*s != 0){
 8a0:	84 c0                	test   %al,%al
 8a2:	0f 84 4a ff ff ff    	je     7f2 <printf+0x52>
 8a8:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
 8ab:	89 d3                	mov    %edx,%ebx
 8ad:	8d 76 00             	lea    0x0(%esi),%esi
  write(fd, &c, 1);
 8b0:	83 ec 04             	sub    $0x4,%esp
          s++;
 8b3:	83 c3 01             	add    $0x1,%ebx
 8b6:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 8b9:	6a 01                	push   $0x1
 8bb:	57                   	push   %edi
 8bc:	56                   	push   %esi
 8bd:	e8 41 fd ff ff       	call   603 <write>
        while(*s != 0){
 8c2:	0f b6 03             	movzbl (%ebx),%eax
 8c5:	83 c4 10             	add    $0x10,%esp
 8c8:	84 c0                	test   %al,%al
 8ca:	75 e4                	jne    8b0 <printf+0x110>
      state = 0;
 8cc:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
 8cf:	31 c9                	xor    %ecx,%ecx
 8d1:	e9 1c ff ff ff       	jmp    7f2 <printf+0x52>
 8d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 8dd:	8d 76 00             	lea    0x0(%esi),%esi
        printint(fd, *ap, 10, 1);
 8e0:	83 ec 0c             	sub    $0xc,%esp
 8e3:	b9 0a 00 00 00       	mov    $0xa,%ecx
 8e8:	6a 01                	push   $0x1
 8ea:	e9 7b ff ff ff       	jmp    86a <printf+0xca>
 8ef:	90                   	nop
        putc(fd, *ap);
 8f0:	8b 45 d0             	mov    -0x30(%ebp),%eax
  write(fd, &c, 1);
 8f3:	83 ec 04             	sub    $0x4,%esp
        putc(fd, *ap);
 8f6:	8b 00                	mov    (%eax),%eax
  write(fd, &c, 1);
 8f8:	6a 01                	push   $0x1
 8fa:	57                   	push   %edi
 8fb:	56                   	push   %esi
        putc(fd, *ap);
 8fc:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 8ff:	e8 ff fc ff ff       	call   603 <write>
        ap++;
 904:	83 45 d0 04          	addl   $0x4,-0x30(%ebp)
 908:	83 c4 10             	add    $0x10,%esp
      state = 0;
 90b:	31 c9                	xor    %ecx,%ecx
 90d:	e9 e0 fe ff ff       	jmp    7f2 <printf+0x52>
 912:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        putc(fd, c);
 918:	88 55 e7             	mov    %dl,-0x19(%ebp)
  write(fd, &c, 1);
 91b:	83 ec 04             	sub    $0x4,%esp
 91e:	e9 2a ff ff ff       	jmp    84d <printf+0xad>
 923:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 927:	90                   	nop
          s = "(null)";
 928:	ba 51 0c 00 00       	mov    $0xc51,%edx
        while(*s != 0){
 92d:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
 930:	b8 28 00 00 00       	mov    $0x28,%eax
 935:	89 d3                	mov    %edx,%ebx
 937:	e9 74 ff ff ff       	jmp    8b0 <printf+0x110>
 93c:	66 90                	xchg   %ax,%ax
 93e:	66 90                	xchg   %ax,%ax

00000940 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 940:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 941:	a1 00 10 00 00       	mov    0x1000,%eax
{
 946:	89 e5                	mov    %esp,%ebp
 948:	57                   	push   %edi
 949:	56                   	push   %esi
 94a:	53                   	push   %ebx
 94b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = (Header*)ap - 1;
 94e:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 951:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 958:	89 c2                	mov    %eax,%edx
 95a:	8b 00                	mov    (%eax),%eax
 95c:	39 ca                	cmp    %ecx,%edx
 95e:	73 30                	jae    990 <free+0x50>
 960:	39 c1                	cmp    %eax,%ecx
 962:	72 04                	jb     968 <free+0x28>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 964:	39 c2                	cmp    %eax,%edx
 966:	72 f0                	jb     958 <free+0x18>
      break;
  if(bp + bp->s.size == p->s.ptr){
 968:	8b 73 fc             	mov    -0x4(%ebx),%esi
 96b:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 96e:	39 f8                	cmp    %edi,%eax
 970:	74 30                	je     9a2 <free+0x62>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 972:	89 43 f8             	mov    %eax,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 975:	8b 42 04             	mov    0x4(%edx),%eax
 978:	8d 34 c2             	lea    (%edx,%eax,8),%esi
 97b:	39 f1                	cmp    %esi,%ecx
 97d:	74 3a                	je     9b9 <free+0x79>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 97f:	89 0a                	mov    %ecx,(%edx)
  } else
    p->s.ptr = bp;
  freep = p;
}
 981:	5b                   	pop    %ebx
  freep = p;
 982:	89 15 00 10 00 00    	mov    %edx,0x1000
}
 988:	5e                   	pop    %esi
 989:	5f                   	pop    %edi
 98a:	5d                   	pop    %ebp
 98b:	c3                   	ret    
 98c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 990:	39 c2                	cmp    %eax,%edx
 992:	72 c4                	jb     958 <free+0x18>
 994:	39 c1                	cmp    %eax,%ecx
 996:	73 c0                	jae    958 <free+0x18>
  if(bp + bp->s.size == p->s.ptr){
 998:	8b 73 fc             	mov    -0x4(%ebx),%esi
 99b:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 99e:	39 f8                	cmp    %edi,%eax
 9a0:	75 d0                	jne    972 <free+0x32>
    bp->s.size += p->s.ptr->s.size;
 9a2:	03 70 04             	add    0x4(%eax),%esi
 9a5:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 9a8:	8b 02                	mov    (%edx),%eax
 9aa:	8b 00                	mov    (%eax),%eax
 9ac:	89 43 f8             	mov    %eax,-0x8(%ebx)
  if(p + p->s.size == bp){
 9af:	8b 42 04             	mov    0x4(%edx),%eax
 9b2:	8d 34 c2             	lea    (%edx,%eax,8),%esi
 9b5:	39 f1                	cmp    %esi,%ecx
 9b7:	75 c6                	jne    97f <free+0x3f>
    p->s.size += bp->s.size;
 9b9:	03 43 fc             	add    -0x4(%ebx),%eax
  freep = p;
 9bc:	89 15 00 10 00 00    	mov    %edx,0x1000
    p->s.size += bp->s.size;
 9c2:	89 42 04             	mov    %eax,0x4(%edx)
    p->s.ptr = bp->s.ptr;
 9c5:	8b 4b f8             	mov    -0x8(%ebx),%ecx
 9c8:	89 0a                	mov    %ecx,(%edx)
}
 9ca:	5b                   	pop    %ebx
 9cb:	5e                   	pop    %esi
 9cc:	5f                   	pop    %edi
 9cd:	5d                   	pop    %ebp
 9ce:	c3                   	ret    
 9cf:	90                   	nop

000009d0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 9d0:	55                   	push   %ebp
 9d1:	89 e5                	mov    %esp,%ebp
 9d3:	57                   	push   %edi
 9d4:	56                   	push   %esi
 9d5:	53                   	push   %ebx
 9d6:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 9d9:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 9dc:	8b 3d 00 10 00 00    	mov    0x1000,%edi
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 9e2:	8d 70 07             	lea    0x7(%eax),%esi
 9e5:	c1 ee 03             	shr    $0x3,%esi
 9e8:	83 c6 01             	add    $0x1,%esi
  if((prevp = freep) == 0){
 9eb:	85 ff                	test   %edi,%edi
 9ed:	0f 84 9d 00 00 00    	je     a90 <malloc+0xc0>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9f3:	8b 17                	mov    (%edi),%edx
    if(p->s.size >= nunits){
 9f5:	8b 4a 04             	mov    0x4(%edx),%ecx
 9f8:	39 f1                	cmp    %esi,%ecx
 9fa:	73 6a                	jae    a66 <malloc+0x96>
 9fc:	bb 00 10 00 00       	mov    $0x1000,%ebx
 a01:	39 de                	cmp    %ebx,%esi
 a03:	0f 43 de             	cmovae %esi,%ebx
  p = sbrk(nu * sizeof(Header));
 a06:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
 a0d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 a10:	eb 17                	jmp    a29 <malloc+0x59>
 a12:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a18:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 a1a:	8b 48 04             	mov    0x4(%eax),%ecx
 a1d:	39 f1                	cmp    %esi,%ecx
 a1f:	73 4f                	jae    a70 <malloc+0xa0>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 a21:	8b 3d 00 10 00 00    	mov    0x1000,%edi
 a27:	89 c2                	mov    %eax,%edx
 a29:	39 d7                	cmp    %edx,%edi
 a2b:	75 eb                	jne    a18 <malloc+0x48>
  p = sbrk(nu * sizeof(Header));
 a2d:	83 ec 0c             	sub    $0xc,%esp
 a30:	ff 75 e4             	push   -0x1c(%ebp)
 a33:	e8 33 fc ff ff       	call   66b <sbrk>
  if(p == (char*)-1)
 a38:	83 c4 10             	add    $0x10,%esp
 a3b:	83 f8 ff             	cmp    $0xffffffff,%eax
 a3e:	74 1c                	je     a5c <malloc+0x8c>
  hp->s.size = nu;
 a40:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 a43:	83 ec 0c             	sub    $0xc,%esp
 a46:	83 c0 08             	add    $0x8,%eax
 a49:	50                   	push   %eax
 a4a:	e8 f1 fe ff ff       	call   940 <free>
  return freep;
 a4f:	8b 15 00 10 00 00    	mov    0x1000,%edx
      if((p = morecore(nunits)) == 0)
 a55:	83 c4 10             	add    $0x10,%esp
 a58:	85 d2                	test   %edx,%edx
 a5a:	75 bc                	jne    a18 <malloc+0x48>
        return 0;
  }
}
 a5c:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
 a5f:	31 c0                	xor    %eax,%eax
}
 a61:	5b                   	pop    %ebx
 a62:	5e                   	pop    %esi
 a63:	5f                   	pop    %edi
 a64:	5d                   	pop    %ebp
 a65:	c3                   	ret    
    if(p->s.size >= nunits){
 a66:	89 d0                	mov    %edx,%eax
 a68:	89 fa                	mov    %edi,%edx
 a6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
 a70:	39 ce                	cmp    %ecx,%esi
 a72:	74 4c                	je     ac0 <malloc+0xf0>
        p->s.size -= nunits;
 a74:	29 f1                	sub    %esi,%ecx
 a76:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 a79:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 a7c:	89 70 04             	mov    %esi,0x4(%eax)
      freep = prevp;
 a7f:	89 15 00 10 00 00    	mov    %edx,0x1000
}
 a85:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
 a88:	83 c0 08             	add    $0x8,%eax
}
 a8b:	5b                   	pop    %ebx
 a8c:	5e                   	pop    %esi
 a8d:	5f                   	pop    %edi
 a8e:	5d                   	pop    %ebp
 a8f:	c3                   	ret    
    base.s.ptr = freep = prevp = &base;
 a90:	c7 05 00 10 00 00 04 	movl   $0x1004,0x1000
 a97:	10 00 00 
    base.s.size = 0;
 a9a:	bf 04 10 00 00       	mov    $0x1004,%edi
    base.s.ptr = freep = prevp = &base;
 a9f:	c7 05 04 10 00 00 04 	movl   $0x1004,0x1004
 aa6:	10 00 00 
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 aa9:	89 fa                	mov    %edi,%edx
    base.s.size = 0;
 aab:	c7 05 08 10 00 00 00 	movl   $0x0,0x1008
 ab2:	00 00 00 
    if(p->s.size >= nunits){
 ab5:	e9 42 ff ff ff       	jmp    9fc <malloc+0x2c>
 aba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        prevp->s.ptr = p->s.ptr;
 ac0:	8b 08                	mov    (%eax),%ecx
 ac2:	89 0a                	mov    %ecx,(%edx)
 ac4:	eb b9                	jmp    a7f <malloc+0xaf>
