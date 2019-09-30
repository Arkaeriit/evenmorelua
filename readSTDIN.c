#include "readSTDIN.h"

int detectSTDIN(void) {
    fd_set rfds; 
    struct timeval tv;
    int retval;

    FD_ZERO(&rfds); //On essaye de voir si il y a des trucs dans stdin au bout de tv comme timeout
    FD_SET(0, &rfds);
    tv.tv_sec = 0;
    tv.tv_usec = 100000;
    retval = select(1, &rfds, NULL, NULL, &tv);

    if (retval == -1){
        fprintf(stderr,"Error while reading stdin.\n");
        return 0;
    }else if (retval){
        copySTDIN();
        return 1;
    }else{
        return 0;
    }
    return 0;
}

void copySTDIN(void){
    char buff[1024];
    FILE* fpnt;
    fpnt = fopen("/tmp/evenmorelua.tmp","w");
    while(read(STDIN_FILENO,buff,1024)){
        fprintf(fpnt,"%s",buff);
    }
    fclose(fpnt);
}

void clearcopy(void){
    unlink("/tmp/evenmorelua.tmp");
}

