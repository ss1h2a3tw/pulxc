#include <stdlib.h>
#include <stdio.h>
#include <unistd.h>
#include <string.h>
#include <stdbool.h>
#include <pwd.h>
#include <sys/types.h>
char buf[2000];
char buf2[1000];
const char key[] = "BASE_PATH";
int main(){
    //Avoid using getlogin for security issue
    FILE* fptr=fopen("/etc/pulxc/pulxc.conf","r");
    bool find=false;
    while(fscanf(fptr,"%1999s=%999s",buf,buf2)==2){
        if(strcmp(buf,key)==0){
            find=true;
        }
    }
    if(!find){
        fprintf(stderr,"Failed to get base path from config\n");
        return 1;
    }
    struct passwd* pw=getpwuid(getuid());
    setreuid(geteuid(),geteuid());
    if(clearenv()){
        fprintf(stderr,"Failed to clear env\n");
        return 1;
    }
    sprintf(buf,"/usr/bin/lxc-attach --clear-env -P %s/lxc -n \'%s\'",buf2,pw->pw_name);
    system(buf);
}
