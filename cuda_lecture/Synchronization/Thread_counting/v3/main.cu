#include "cuda_runtime.h"
#include "device_launch_parameters.h"

#include <stdio.h>
__global__ void threadCounting_atomicShared(int *a){
	__shared__ int sa;
	if(threadIdx.x == 0)
		sa = 0;
	__syncthreads();

	atomicAdd(&sa, 1);
	__syncthreads();

	if(threadIdx.x ==0)
		atomicAdd(a, sa);
}

int main(void){
	int a = 0;
	int *d;

	cudaMalloc((void**)&d, sizeof(int));
	cudaMemset(d, 0, sizeof(int)*1);

	threadCounting_atomicShared<<<10240,512>>>(d);
	cudaDeviceSynchronize();

	cudaMemcpy(&a, d, sizeof(int), cudaMemcpyDeviceToHost);

	printf("%d\n",a);
	cudaFree(d);
}
