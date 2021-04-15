#include "cuda_runtime.h"
#include "device_launch_parameters.h"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define NUM_DATA 1024000 // << 1024*100
#define MAX_THREAD_IN_SINGLE_BLOCK = 1024

__global__ void vecAdd(int *_a, int *_b, int *_c)
{
	int tID = blockIdx.x*blockDim.x+threadIdx.x;
	_c[tID] = _a[tID] + _b[tID];
}

int main(void){
	int *a, *b, *c;
	int *d_a, *d_b, *d_c;

	int memSize = sizeof(int)*NUM_DATA;
	printf("%d elements, memSize = %d bytes\n", NUM_DATA, memSize);

	a = new int[NUM_DATA]; memset(a, 0, memSize);
	b = new int[NUM_DATA]; memset(b, 0, memSize);
	c = new int[NUM_DATA]; memset(c, 0, memSize);
	
	for (int i =0; i< NUM_DATA; i++){
		a[i] = rand() % 10;
		b[i] = rand() % 10;
	}
	cudaMalloc(&d_a, memSize);
	cudaMalloc(&d_b, memSize);
	cudaMalloc(&d_c, memSize);
	
	//Under two line synchronize automatically. You don't need to use synchronize.
	cudaMemcpy(d_a, a, memSize, cudaMemcpyHostToDevice); 
	cudaMemcpy(d_b, b, memSize, cudaMemcpyHostToDevice);
	
	// Kernel call
	dim3 dimGrid(NUM_DATA/1024, 1, 1);
	dim3 dimBlock(1024,1,1); //MAX_SIZE = 1024
	vecAdd<<<dimGrid, dimBlock >>>(d_a, d_b, d_c);
	cudaDeviceSynchronize();
	cudaMemcpy(c, d_c, memSize, cudaMemcpyDeviceToHost);

	//check results
	bool result = true;
	for (int i =0; i<NUM_DATA; i++)
	{
		if((a[i] + b[i]) != c[i]){
			printf("[%d] The results is not matched! (%d, %d)\n",
					i, a[i] + b[i], c[i]);
			result = false;
		}
	}

	if(result)
		printf("GPU works well!\n");

	cudaFree(d_a); cudaFree(d_b); cudaFree(d_c);
	delete [] a; delete [] b; delete [] c;

	return 0;
}
