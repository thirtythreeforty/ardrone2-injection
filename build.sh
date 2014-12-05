~/x-tools/arm-cortex_a8-linux-gnueabi/bin/arm-cortex_a8-linux-gnueabi-gcc -O3 -fPIC -c -o inject.o inject.c
~/x-tools/arm-cortex_a8-linux-gnueabi/bin/arm-cortex_a8-linux-gnueabi-gcc -shared -o inject.so inject.o -ldl
~/x-tools/arm-cortex_a8-linux-gnueabi/bin/arm-cortex_a8-linux-gnueabi-strip --strip-all inject.so
