###############################################################################
# qemu-user-static from repository
###############################################################################
xcc = /opt/gcc-linaro-5.3.1-2016.05-x86_64_arm-linux-gnueabihf/bin/arm-linux-gnueabihf-
lib_path = /opt/gcc-linaro-5.3.1-2016.05-x86_64_arm-linux-gnueabihf/arm-linux-gnueabihf/libc
cflags = -march=armv7-a -mtune=cortex-a9

define TEST_C
cat << EOF > test.c
#include <stdio.h>
int main(void) { printf("Hello ARM!\n"); return 0; }
EOF
endef
export TEST_C

test.c:
	sh -c "$$TEST_C"

# '|| true' mutes annoying non-zero value and reported error
test: test.c
	@ $(xcc)gcc -static -o $@ $< && \
	qemu-arm-static ./test || true

###############################################################################
# 1. asm Hello world
###############################################################################
hello: hello.S
	@ $(xcc)gcc $(cflags) -o $@ $< && \
	qemu-arm-static -L $(lib_path) ./$@ || true

