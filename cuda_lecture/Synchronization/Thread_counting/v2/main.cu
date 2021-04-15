#include "cuda_runtime.h"
#include "device_launch_parameters.h"

#include <stdio.h>
__global__ void threadCounting_atomicGlobal(int *a){
	atomicAdd(a, 1);
}

int main(void){
	int a = 0;
	int *d;

	cudaMalloc((void**)&d, sizeof(int));
	cudaMemset(d, 0, sizeof(int)*1);

	threadCounting_atomicGlobal<<<10240,512>>>(d);
	cudaDeviceSynchronize();
	
	cudaMemcpy(&a, d, sizeof(int), cudaMemcpyDeviceToHost);

	printf("%d\n",a);
	cudaFree(d);
}
