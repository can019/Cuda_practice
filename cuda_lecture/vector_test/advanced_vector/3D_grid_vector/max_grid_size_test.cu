#include "cuda_runtime.h"
#include "device_launch_parameters.h"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

//#define NUM_DATA = 65535
unsigned NUM_DATA = 2147483647;
//#define MAX_THREAD_IN_SINGLE_BLOCK = 8*8*8
//#define MAX_BLOCK_COUNT_IN_GRID = 1024*1024*1024*4 // Same as unsigned size
//#define BLOCK_SIZE = 1024
//#define NUM_THREAD_IN_BLOCK = 8*8*8
//int block_size = 1024;
__global__ void vecAdd(unsigned *_a, unsigned *_b, unsigned *_c)
{
	//int tID = threadId.x; //1차원 grid 1차원 block
	//int tID = threadIdx.y*blockDim.x+threadIdx.x; //1차원 grid 2차원 block
	//int tID = (blockDim.x*blockDim.y*threadIdx.z) + //1차원 grid 3차원 block
	//	(threadIdx.y*blockDim.x)+
	//		threadIdx.x
	//중략

	unsigned tID = blockIdx.z*(gridDim.y*gridDim.x*1)
		+blockIdx.y*(gridDim.x*1)+blockIdx.x*(blockDim.x*blockDim.y*blockDim.z)+blockDim.y*blockDim.x*threadIdx.z+blockDim.x*threadIdx.y+threadIdx.x;
	_c[tID] = _a[tID] + _b[tID];
}

int main(void){
	unsigned *a, *b, *c;
	unsigned *d_a, *d_b, *d_c;
	
	unsigned memSize = NUM_DATA*sizeof(unsigned);
	printf("%u elements, memSize = %u bytes\n", NUM_DATA, memSize);


	a = new unsigned[NUM_DATA]; memset(a, 0, memSize);
	b = new unsigned[NUM_DATA]; memset(b, 0, memSize);
	c = new unsigned[NUM_DATA]; memset(c, 0, memSize);

	for (unsigned i =0; i< NUM_DATA; i++){
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
	dim3 dimGrid(2147483647, 1, 1);
	dim3 dimBlock(1, 1, 1); //dimBlock should be total <= 1024
	vecAdd<<<dimGrid, dimBlock >>>(d_a, d_b, d_c);
	cudaDeviceSynchronize();
	cudaMemcpy(c, d_c, memSize, cudaMemcpyDeviceToHost);

	//check results
	bool result = true;
	for (unsigned i =0; i<NUM_DATA; i++)
	{
		if((a[i] + b[i]) != c[i]){
			printf("[%u] The results is not matched! (%u, %u)\n",
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
