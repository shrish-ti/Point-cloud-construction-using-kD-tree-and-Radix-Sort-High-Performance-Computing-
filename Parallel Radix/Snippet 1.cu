#include <bits/stdc++.h>
using namespace std;
int main()
{
//Basic declaration
int NoOfElements=2000;
int *h_array= new int[NoOfElements];
int *d_array;
for(int i=0; i<NoOfElements; i++)
{
h_array[i]=rand()%1000;
}

//Allocation on GPU
cudaMalloc((void**)&d_array, sizeof(int)*NoOfElements);

//Copying from Device to GPU
cudaMemcpy(d_array, h_array,sizeof(int)*NoOfElements, cudaMemcpyHostToDevice);

//Calling kernel
d_array=radixSort(d_array, NoOfElements);

//Copying from GPU to CPU
cudaMemcpy(h_array, d_array,sizeof(int)*NoOfElements,cudaMemcpyDeviceToHost);

}
