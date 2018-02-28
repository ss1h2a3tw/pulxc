#define _GNU_SOURCE

#include <pwd.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/types.h>
#include <unistd.h>

#define KEY_BASE_PATH "BASE_PATH"

int main() {
    if (clearenv()) {
        perror("Cannot clear environment variable\n");
        return 1;
    }

    FILE *fptr = fopen("/etc/pulxc/pulxc.conf","r");
    if (!fptr) {
        perror("Cannot open /etc/pulxc/pulxc.conf");
        return 1;
    }

    char *line = NULL, *basepath = NULL;
    ssize_t n = 0;
    while (getline(&line, &n, fptr) != -1) {
        if (*line == '\n' || *line == '#') // empty line or comment
            continue;

        char *ptr = strtok(line, "=");
        if (!ptr) {
            fputs("bad config\n", stderr);
            return 1;
        }

        if (strcmp(ptr, KEY_BASE_PATH)) // wrong key
            continue;

        ptr = strtok(NULL, "\n");
        if (!ptr) {
            fputs("bad config\n", stderr);
            return 1;
        }

        if (basepath)
            free(basepath);
        basepath = strdup(ptr);
    }
    free(line);

    if (!basepath) {
        fputs("missing required key '" KEY_BASE_PATH "' in config\n", stderr);
        return 1;
    }

    char *lxcpath = NULL;
    if (asprintf(&lxcpath, "%s/lxc", basepath) < 0) {
        perror("asprintf");
        return 1;
    }
    free(basepath);

    // Avoid using getlogin for security issue
    struct passwd *pw = getpwuid(getuid());
    setreuid(geteuid(), geteuid());

    char *const argv[] = {
        "/usr/bin/lxc-attach",
        "--clear-env",
        "-P", lxcpath,
        "-n", pw->pw_name,
        NULL,
    };

    execve(argv[0], argv, NULL);
}
