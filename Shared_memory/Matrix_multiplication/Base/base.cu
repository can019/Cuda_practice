#include "cuda_runtime.h"
#include "device_launch_parmeters.h"

#include <DS_timer.h>

#include <omp.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define NUM_CPU_THREADS(4)

#define ROW_SIZE(32)
#define K_SIZE(128)
#define COL_SIZE(32)

#define WORK_LOAD(1024)
#define MAT_SIZE_A (ROW_SIZE*K_SIZE)
#define MAT_SIZE_B (K_SIZE*COL_SIZE)
#define MAT_SIZE_C (ROW_SIZE*COL_SIZE)

float A[ROW_SIZE][K_SIZE];
float B[K_SIZE][COL_SIZE];

// Timer
#define TIMER_HOST	0
#define TIMER_KERNEL	1

