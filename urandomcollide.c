#include <fcntl.h>
#include <unistd.h>
#include <stdio.h>
#include <stdint.h>
#include <sys/mount.h>
#include <string.h>
#include <errno.h>
#include <sys/reboot.h>
#include <linux/reboot.h>

//number of bytes to read from /dev/urandom
//should be <=256 to ensure that "reads of up to 256 bytes will return as many
// bytes as are requested and will not be interrupted by a signal handler"
#define READ_LEN 16

//importantLog saved to file, debugLog not saved
#define importantLog(...) do { printf("[urandomcollide-important] "); printf(__VA_ARGS__); } while(0)
#define debugLog(...) do { printf("[urandomcollide-debug] "); printf(__VA_ARGS__); } while(0)

int main() {

    debugLog("mount devtmpfs on /dev\n");

    if (mount("", "/dev", "devtmpfs", 0, NULL) < 0) {
        importantLog("error: failed to mount devtmpfs: %s\n", strerror(errno));
        return 1;
    }

    debugLog("open /dev/urandom\n");
    int urandomFd = open("/dev/urandom", O_RDONLY);
    if (urandomFd < 0) {
        importantLog("error: failed to open /dev/urandom: %s\n", strerror(errno));
        return 1;
    }

    debugLog("read %d bytes from urandom\n", READ_LEN);
    uint8_t buf[READ_LEN];
    int numBytesRead = read(urandomFd, buf, READ_LEN);
    if (numBytesRead != READ_LEN) {
        //urandom should always give the number of bytes you asked for if <=256
        importantLog("error: read() /dev/urandom gave %d bytes, asked for %d\n", numBytesRead, READ_LEN);
        return 1;
    }

    if (close(urandomFd) < 0) {
        importantLog("error: failed to close urandom: %s\n", strerror(errno));
        return 1;
    }

    importantLog("success: ");
    for (int i = 0; i < READ_LEN; i++) {
        printf("%02x", buf[i]);
    }
    printf("\n");

    debugLog("power off\n");
    reboot(LINUX_REBOOT_CMD_POWER_OFF);

    //should never get here
    importantLog("error: did not power off\n");

    return 1;

}