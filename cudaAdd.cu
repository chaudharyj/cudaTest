#include<iostream>
#include<cuda.h>
#include<cstdlib>
#include<ctime>

#define LIM 100

using namespace std;

__global__ void cudaAdd(int *d_a, int *d_b, int *d_c) {
	int i = (blockIdx.x * blockDim.x) + threadIdx.x;
	if (i<LIM) {
		d_c[i] = d_a[i] + d_b[i];
	}
}

int main() {

	int a[LIM],b[LIM],c[LIM];
	int *d_a, *d_b, *d_c;
	srand(time(NULL));
	for(int i = 0;i<LIM;i++) {
		a[i] = rand()%1000;
		b[i]= rand()%1000;
	}

	cudaMalloc(&d_a,sizeof(int)*LIM);
	cudaMalloc(&d_b,sizeof(int)*LIM);
	cudaMalloc(&d_c,sizeof(int)*LIM);

	cudaMemcpy(d_a,a,sizeof(int)*LIM,cudaMemcpyHostToDevice);
	cudaMemcpy(d_b,b,sizeof(int)*LIM,cudaMemcpyHostToDevice);
	cudaAdd<<<(LIM/100)+1,100>>>(d_a,d_b,d_c);
	cudaMemcpy(c,d_c,sizeof(int)*LIM,cudaMemcpyDeviceToHost);

	for(int i = 0;i<LIM;i++) {
		cout<<a[i]<<" + "<<b[i]<<" = "<<c[i]<<endl;
	}

	cudaFree(d_a);
	cudaFree(d_b);
	cudaFree(d_c);
	//delete[] a;
	//delete[] b;
	//delete[] c;
}
