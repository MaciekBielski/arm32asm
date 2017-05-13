###############################################################################
# qemu-user-static from repository
###############################################################################
xcc = /opt/gcc-linaro-5.3.1-2016.05-x86_64_arm-linux-gnueabihf/bin/arm-linux-gnueabihf-
lib_path = /opt/gcc-linaro-5.3.1-2016.05-x86_64_arm-linux-gnueabihf/ 

define HELLO_C
cat << EOF > hello.c
#include <stdio.h>
int main(void) { printf("Hello ARM!\n"); return 0; }
EOF
endef
export HELLO_C

hello.c:
	sh -c "$$HELLO_C"

# '|| true' mutes annoying non-zero value and reported error
hello: hello.c
	@ $(xcc)gcc -static -o $@ $< && \
	qemu-arm-static -L $(lib_path) ./hello || true

