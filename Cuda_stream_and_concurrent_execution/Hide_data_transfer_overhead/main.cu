#include "cuda_runtime.h"
#include "device_launch_parameters.h"

#include <stdio.h>

#define NUM_BLOCK (128*1024)
#define NUM_T_IN_B 1024
#define ARRAY_SIZE (NUM_T_IN_B*NUM_BLOCK)
#define NUM_STREAMS 2

int main(void)
{
	int *in = NULL, *out = NULL, *dIn = NULL, *dOut = NULL;

	cudaMallocHost(&in, sizeof(int)*ARRAY_SIZE); memset(in, 0, sizeof(int)*ARRAY_SIZE);
	cudaMallocHost(&out, sizeof(int)*ARRAY_SIZE); memset(out, 0, sizeof(int)*ARRAY_SIZE);
	
	cudaMalloc(&dIn, sizeof(int)*ARRAY_SIZE);
	cudaMalloc(&dOut, sizeof(int)*ARRAY_SIZE);
	
	LOOP_I(ARRAY_SIZE);
	in[i] = rand() % 10;
	
	// Single stream version
	cudaMemcpy(dIn, in, sizeof(int)*ARRAY_SIZE, cudaMemcpyHostToDevice);
	myKernel << <NUM_BLOCK, NUM_T_IN_B>>> (dIn, dOut);
	cudaMemcpy(out, dOut, sizeof(int)*ARRAY_SIZE, cudaMemcpyDeviceToHost);

	// Multi-stream version
	cudaStream_t stream[NUM_STREAMS];
	LOOP_I(NUM_STREAMS);
	cudaStreamCreate(&stream[i]);
	
	int chunkSize = ARRAY_SIZE / NUM_STREAMS;
	LOOP_I(NUM_STREAMS)
	{
		int offset = chunkSize * i;
		cudaMemcpyAsync(dIn + offset, in + offset
				, sizeof(int)*chunkSize, cudaMemcpyHostToDevice, stream[i]);
		myKernel <<<NUM_BLOCK / NUM_STREAMS, NUM_T_IN_B, 0, stream[i]>>>
			(dIn + offset, dOut + offset);
		cudaMemcpyAsync(out2 + offset, dOut + offset
				, sizeof(int)*chunkSize, cudaMemcpyDeviceToHost, stream[i]);
	}
	cudaDeviceSynchronize();
	
	LOOP_I(NUM_STREAMS) cudaStreamDestroy(stream[i]);
	cudaFree(dIn); cudaFree(dOut);
	cudaFreeHost(in); cudaFreeHost(out); cudaFreeHost(out2);
}
