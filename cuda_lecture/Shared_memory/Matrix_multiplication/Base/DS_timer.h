//#pragma once
  2 #ifndef _DS_TIMER_H
  3 #define _DS_TIMER_H
  4 
  5 #include <string> // std string
  6 
  7 #ifndef UINT
  8 typedef unsigned int UINT;
  9 #endif
 10 
 11 #ifdef _WIN32
 12         // For windows
 13         #include <Windows.h>
 14         typedef LARGE_INTEGER   TIME_VAL;
 15 #else
 16         // For Unix/Linux
 17         #include <stdio.h>
 18         #include <stdlib.h>
 19         #include <sys/time.h>
 20         #include <string.h>     // c string
 21         typedef struct timeval  TIME_VAL;
 22 #endif
 23 

