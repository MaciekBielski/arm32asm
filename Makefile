###############################################################################
# 1. User-space programs, not used anymore
###############################################################################
#
# lib_path = /opt/gcc-linaro-6.3.1-2017.02-x86_64_arm-eabi/arm-eabi/libc
# cflags = -mtune=cortex-m4 -mfloat-abi=hard -O0 -fno-dce
# cflags = -mtune=cortex-a9 -mfloat-abi=hard
#
# These was for hello
# hello: hello.S
# 	@ $(xcc)gcc $(cflags) -o $@ $< && \
# 	qemu-arm-static -L $(lib_path) ./$@ || true
# Test userspace programs
# define TEST_C
# cat << EOF > test.c
# #include <stdio.h>
# int main(void) { printf("Hello ARM!\n"); return 0; }
# EOF
# endef
# export TEST_C
#
# test.c:
# 	sh -c "$$TEST_C"

# '|| true' mutes annoying non-zero value and reported error
# test: test.c
# 	@ $(xcc)gcc -static -o $@ $< && \
# 	qemu-arm-static ./test || true

###############################################################################
# 2. Running on bare metal with the STM32F429 Discovery emulation
#
###############################################################################
xcc = arm-none-eabi-
asflags = -mimplicit-it=always
cflags = -mcpu=cortex-m4 -march=armv7 -mlittle-endian -mfloat-abi=hard
ld_script 	= ./bare_metal.ld
gdbcmd		= .gdbcmd

bare_metal: startup.s $(ld_script)
	@$(xcc)as $(asflags) $(cflags) -g startup.s -o startup.o
	@$(xcc)ld -T $(ld_script) -g -o $@.elf startup.o
	@$(xcc)objcopy -O binary $@.elf $@.bin

# run:
# 	$(qemu_build)/arm-softmmu/qemu-system-arm \
# 		-M lm3s811evb -m 8K \
# 		-nographic -kernel bare_metal.bin

run:
	./gnuarmeclipse \
		--board STM32F429I-Discovery \
        --mcu STM32F429ZI -d unimp,guest_errors \
        --verbose --verbose \
        --nographic \
        --serial /dev/null \
        --gdb tcp::1234 \
        --image bare_metal.bin \
        --semihosting-config enable=on,target=native \

# call 'load' after!
#
define GDB_CMDS
cat <<@ >$(gdbcmd)
set height 60
file bare_metal.elf
target extended-remote 127.0.0.1:1234
handle SIGUSR1 nostop noprint pass

endef
export GDB_CMDS
gdb:
	sh -c "$$GDB_CMDS" && \
	cgdb -darm-none-eabi-gdb -- -q -x $(gdbcmd)


clean:
	@rm -f bare_metal.o bare_metal.elf bare_metal.bin bare_setup.o startup.o

monitor:
	telnet 127.0.0.1 3333

