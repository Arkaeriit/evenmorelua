/*--------------------------------------------------------------\
|Ces fonctions servent à lire stdin pour que evenmorelua soir le|
|résultat de piping                                             |
\--------------------------------------------------------------*/

#include <stdio.h>
#include <sys/time.h>
#include <sys/types.h>
#include <unistd.h>

int detectSTDIN(void); //Indique si il y a des choses dans  STDIN et si c'est le cas on copie le contenue de stdin dans un fichier temporaire
void copySTDIN(void); //S'occupe de la copie
void clearcopy(void); //Efface la copie

