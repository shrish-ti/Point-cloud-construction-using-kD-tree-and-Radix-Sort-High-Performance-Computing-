%%cu
#include <iostream>
#define loopy cout<<"loopy"<<" "
#define pp pair<int,int>
#define pb push_back
#define sp " "
#define ll long long int
#define nl "\n"
#define pf cout<<
#define fir first
#define sec second
#include<cstdio>
#include "cuda_runtime.h"
#include "device_launch_parameters.h"
#include <stdio.h>
#include <chrono>
using namespace std::chrono;
using namespace std;
#include <chrono>
using namespace std::chrono;
#define BLOCK 3
#define THREAD 1024
#define MAX_DIM 3
struct Node {
    double val[3];
    struct Node* left, * right;
    Node()
    {
        for (int i = 0; i < MAX_DIM; i++)
        {
            val[i] = 0;
        }
        left = NULL;
        right = NULL;
    }
};
void insertionSort(int h_array[][MAX_DIM], int numberofElements, int dim, int idx)  
{  
    int i, key, temp1, temp2, j;  
    
    for (i = 1; i<=numberofElements-1; i++) 
    {  
        
        key = h_array[i][idx];
        if(idx==0)
        {
        temp1=h_array[i][1];
        temp2=h_array[i][2];
        }
        else if(idx==1)
        {
        temp1=h_array[i][0];
        temp2=h_array[i][2];
        }
        else
        {
            temp1=h_array[i][0];
            temp2=h_array[i][1];
        }
        j = i - 1; 
        while (j >= 0 && h_array[j][idx] > key) 
        {  
            h_array[j + 1][idx]=h_array[j][idx];
            if(idx==0)
            {
            h_array[j+1][1]=h_array[j][1];
            h_array[j+1][2]=h_array[j][2];
            }
            else if(idx==1)
            {
            h_array[j+1][0]=h_array[j][0];
            h_array[j+1][2]=h_array[j][2];
            }
            else
            {
                h_array[j+1][0]=h_array[j][0];
                h_array[j+1][1]=h_array[j][1];
            }
            j = j - 1;  
        }  
        h_array[j + 1][idx] = key;  
        
        if(idx==0)
        {
        h_array[j+1][1]=temp1;
        h_array[j+1][2]=temp2;
        }
        
        else if(idx==1)
        {
        h_array[j+1][0]=temp1;
        h_array[j+1][2]=temp2;
        }
        
        else
        {
        h_array[j+1][0]=temp1;
        h_array[j+1][1]=temp2;
        }
    }
}

int getMax(int h_array[][MAX_DIM], int numberOfElements, int dim, int idx) 
{   
	int mx = h_array[0][idx]; 
	for (int i = 0; i < numberOfElements; i++) 
		if (h_array[i][idx] > mx) 
			mx = h_array[i][idx]; 
	return mx; 
	
} 

void countSort(int h_array[][MAX_DIM], int numberOfElements, int dim, int idx, int exp) 
{ 
	int output[numberOfElements][dim]; 
	int i, count[10] = { 0 }; 

	for (i = 0; i < numberOfElements; i++) 
		count[(h_array[i][idx] / exp) % 10]++; 

	for (i = 1; i < 10; i++) 
		count[i] += count[i - 1]; 

	for (i = numberOfElements - 1; i >= 0; i--) { 
		output[count[(h_array[i][idx] / exp) % 10] - 1][idx] = h_array[i][idx];
		if(idx==0)
		{
		output[count[(h_array[i][idx] / exp) % 10] - 1][1] = h_array[i][1];
		output[count[(h_array[i][idx] / exp) % 10] - 1][2] = h_array[i][2];
		}
		else if(idx==1)
		{
		output[count[(h_array[i][idx] / exp) % 10] - 1][0] = h_array[i][0];
		output[count[(h_array[i][idx] / exp) % 10] - 1][2] = h_array[i][2];
		}
		else
		{
		    output[count[(h_array[i][idx] / exp) % 10] - 1][0] = h_array[i][0];
		    output[count[(h_array[i][idx] / exp) % 10] - 1][1] = h_array[i][1];
		}
		count[(h_array[i][idx] / exp) % 10]--; 
	} 

	for (i = 0; i < numberOfElements; i++) 
	{
		h_array[i][0] = output[i][0]; 
		h_array[i][1]=output[i][1];
		h_array[i][2]=output[i][2];
}
    
} 

void sradixsort(int h_array[][MAX_DIM], int numberOfElements, int dim, int idx) 
{ 
	int m = getMax(h_array, numberOfElements, dim, idx); 

	for (int exp = 1; m / exp > 0; exp *= 10) 
		countSort(h_array, numberOfElements, dim, idx, exp); 
} 

__device__ int function(int value, int bit, int bitset)
{
    if (bitset == 1)
    {
        if ((value & bit) != 0)
        {
            return 1;
        }
        else
            return 0;
    }
    else
    {
        if ((value & bit) == 0)
        {
            return 1;
        }
        else
        {
            return 0;
        }
    }
}
__global__ void predicateDevice(int* d_array, int* d_predicateArrry, int d_numberOfElements, int bit, int bitset, int dim, int idx)
{
    int index = threadIdx.x + blockIdx.x * blockDim.x;
    if (index < d_numberOfElements)
    {

        d_predicateArrry[index] = function(d_array[dim * index + idx], bit, bitset);
    }
}

__global__ void scatter(int* d_array, int* d_scanArray, int* d_predicateArrry, int* d_scatteredArray, int d_numberOfElements, int offset, int dim, int idx)
{
    int index = threadIdx.x + blockIdx.x * blockDim.x;
    if (index < d_numberOfElements)
    {
        if (d_predicateArrry[index] == 1)
        {
            for (int i = 0; i < dim; i++)
            {
                d_scatteredArray[dim * (d_scanArray[index] - 1 + offset) + i] = d_array[dim * index + i];
            }
            /*
            d_scatteredArray[dim*(d_scanArray[index] - 1 + offset)] = d_array[dim*index];
            d_scatteredArray[dim*(d_scanArray[index] - 1 + offset) +1] = d_array[dim*index +1];
            */
        }
    }
}
__global__ void hillisSteeleScanDevice(int* d_array, int numberOfElements, int* d_tmpArray, int moveIndex)
{
    int index = threadIdx.x + blockDim.x * blockIdx.x;
    if (index > numberOfElements)
    {
        return;
    }
    d_tmpArray[index] = d_array[index];
    if (index - moveIndex >= 0)
    {

        d_tmpArray[index] = d_tmpArray[index] + d_array[index - moveIndex];
    }
}
int* hillisSteeleScanHost(int* d_scanArray, int numberOfElements)
{


    int* d_tmpArray;
    int* d_tmpArray1;
    cudaMalloc(&d_tmpArray1, sizeof(int) * numberOfElements);
    cudaMalloc(&d_tmpArray, sizeof(int) * numberOfElements);
    cudaMemcpy(d_tmpArray1, d_scanArray, sizeof(int) * numberOfElements, cudaMemcpyDeviceToDevice);
    int j, k = 0;
    for (j = 1; j < numberOfElements; j = j * 2, k++)
    {
        if (k % 2 == 0)
        {
            hillisSteeleScanDevice << <BLOCK, THREAD >> > (d_tmpArray1, numberOfElements, d_tmpArray, j);
            cudaDeviceSynchronize();
        }
        else
        {
            hillisSteeleScanDevice << <BLOCK, THREAD >> > (d_tmpArray, numberOfElements, d_tmpArray1, j);
            cudaDeviceSynchronize();
        }
    }
    cudaDeviceSynchronize();
    if (k % 2 == 0)
    {

        return d_tmpArray1;
    }
    else
    {
        return d_tmpArray;
    }
}
__global__ void print(int* d_predicateArrry, int numberOfElements)
{

    for (int i = 0; i < numberOfElements; i++)
    {
        printf("index = %d value = %d\n", i, d_predicateArrry[i]);
    }
}

int* compact(int* d_array, int numberOfElements, int bit, int dim, int idx)
{
    int offset;
    int* d_predicateArrry;
    cudaMalloc((void**)&d_predicateArrry, sizeof(int) * numberOfElements);
    predicateDevice << <BLOCK, THREAD >> > (d_array, d_predicateArrry, numberOfElements, bit, 0, dim, idx);
    int* d_scanArray;
    d_scanArray = hillisSteeleScanHost(d_predicateArrry, numberOfElements);
    int* d_scatteredArray;
    cudaMalloc((void**)&d_scatteredArray, sizeof(int) * numberOfElements * dim);
    //cout<<"offset = "<<offset<<"\n";
    scatter << <BLOCK, THREAD >> > (d_array, d_scanArray, d_predicateArrry, d_scatteredArray, numberOfElements, 0, dim, idx);
    cudaMemcpy(&offset, d_scanArray + numberOfElements - 1, sizeof(int), cudaMemcpyDeviceToHost);
    predicateDevice << <BLOCK, THREAD >> > (d_array, d_predicateArrry, numberOfElements, bit, 1, dim, idx);
    d_scanArray = hillisSteeleScanHost(d_predicateArrry, numberOfElements);
    scatter << <BLOCK, THREAD >> > (d_array, d_scanArray, d_predicateArrry, d_scatteredArray, numberOfElements, offset, dim, idx);
    return d_scatteredArray;
}
int offset;
int* positivenegativesplit(int* d_array, int numberOfElements, int bit, int bitset, int dim, int idx)
{   
    /*
    int blockSize;      
    int minGridSize;    
    int gridSize;
    cudaOccupancyMaxPotentialBlockSize(&minGridSize, &blockSize, predicateDevice, 0, numberOfElements);
    gridSize = (numberOfElements + blockSize - 1) / blockSize;
    cout << gridSize << sp << blockSize << nl;
    */
    int* d_predicateArrry;
    cudaMalloc((void**)&d_predicateArrry, sizeof(int) * numberOfElements);
    predicateDevice << <BLOCK, THREAD >> > (d_array, d_predicateArrry, numberOfElements, bit, bitset, dim, idx);
    /*
    cudaError_t cudaStatus;
    cudaStatus = cudaGetLastError();
    if (cudaStatus != cudaSuccess) {
        fprintf(stderr, "addKernel launch failed: %s\n", cudaGetErrorString(cudaStatus));
    }
    */
    int* d_scanArray;
    d_scanArray = hillisSteeleScanHost(d_predicateArrry, numberOfElements);
    int* d_scatteredArray;
    cudaMemcpy(&offset, d_scanArray + numberOfElements - 1, sizeof(int), cudaMemcpyDeviceToHost);
    //cout << offset << "\n";
    cudaMalloc((void**)&d_scatteredArray, sizeof(int) * offset * dim);
    scatter << <BLOCK, THREAD >> > (d_array, d_scanArray, d_predicateArrry, d_scatteredArray, numberOfElements, 0, dim, idx);
    return d_scatteredArray;
}
int* radixSort(int* d_array, int numberOfElements, int dim, int idx)
{
    int bit;
    int* d_negativeArray = positivenegativesplit(d_array, numberOfElements, 1L << 31, 1, dim, idx);
    for (int i = 0; i < sizeof(int) * 8; i++)
    {
        bit = 1 << i;
        d_negativeArray = compact(d_negativeArray, offset, bit, dim, idx);
    }
    int* d_postiveArray = positivenegativesplit(d_array, numberOfElements, 1L << 31, 0, dim, idx);

    /*
    int* temp = new int[6];
    cudaMemcpy(temp, d_postiveArray, sizeof(int) * 3 * 2, cudaMemcpyDeviceToHost);
    for (int i = 0; i < 6; i++)cout << temp[i] << " ";
    cout << "\n";
    */

    for (int i = 0; i < sizeof(int) * 8; i++)
    {
        bit = 1 << i;
        d_postiveArray = compact(d_postiveArray, offset, bit, dim, idx);
        /*
        cudaMemcpy(temp, d_postiveArray, sizeof(int) * 3 * 2, cudaMemcpyDeviceToHost);
        for (int i = 0; i < 6; i++)cout << temp[i] << " ";
        cout << "\n";
        */
    }

    cudaMemcpy(d_array, d_negativeArray, sizeof(int) * (numberOfElements - offset) * dim, cudaMemcpyDeviceToDevice);
    cudaMemcpy(d_array + (numberOfElements - offset), d_postiveArray, sizeof(int) * offset * dim, cudaMemcpyDeviceToDevice);
    return d_array;
}
void sort(int h_array[][3], int numberOfElements, int dim, int idx)
{
    int* d_array;
    cudaMalloc((void**)&d_array, sizeof(int) * numberOfElements * dim);
    cudaMemcpy(d_array, h_array, sizeof(int) * numberOfElements * dim, cudaMemcpyHostToDevice);
   
    d_array = radixSort(d_array, numberOfElements, dim, idx);
   
    cudaMemcpy(h_array, d_array, sizeof(int) * numberOfElements * dim, cudaMemcpyDeviceToHost);

}

Node* make_tree( int h_array[][3], int numberOfElements, int dim, int idx)
{
    //cout << start << sp << end << nl;
    if (numberOfElements<=0)return NULL;
    if (numberOfElements == 1)
    {
        Node* root = new Node();
        root->val[0] = *(*(h_array + 0) + 0);
        root->val[1] = *(*(h_array + 0) + 1);
        root->val[2] = *(*(h_array + 0) + 2);
        //cout << root->val[0] << sp << root->val[1] << nl;
        return root;
    }

    if(numberOfElements>=1024)
 {
    sort(h_array, numberOfElements, dim, idx);
 }
 else if(16<=numberOfElements&&numberOfElements<1024) 
 {
     sradixsort(h_array, numberOfElements, dim, idx);
 } 
 else
 {
     insertionSort(h_array, numberOfElements, dim, idx);
 }
    
    int md = numberOfElements / 2;
    int count2 = md - 1;
    if (numberOfElements % 2 == 1)count2 = md;
    
    Node* root = new Node();
    
    root->val[0] = *(*(h_array + md) + 0);
    root->val[1] = *(*(h_array + md) + 1);
    root->val[2] = *(*(h_array + md) + 2);
    //cout << root->val[0] << sp << root->val[1] << nl;

    root->left = make_tree(h_array, md, dim, (idx + 1) % dim);
    root->right = make_tree(h_array+md+1, count2, dim, (idx + 1) % dim);
    

    return root;

}

int main()
{
    int numberOfElements = 200000;
    int dim = MAX_DIM;
    cout << "The dimensions of mtrix are " << numberOfElements << " x " << dim << " \n";
    int h_array[numberOfElements][MAX_DIM];
    //cout << "Enter the elemets of the matrix \n";
    for (int i = 0; i < numberOfElements; i++)
    {
        h_array[i][0] = rand()%5000;
        h_array[i][1] = rand()%5000; 
        h_array[i][2] = rand()%5000;
    }
    auto start = high_resolution_clock::now();
    cout << "Cons start!!!";
    Node* root = make_tree(h_array, numberOfElements, dim, 0);
    cout << "Cons end!!!";
    
    auto stop = high_resolution_clock::now();
    auto duration = duration_cast<microseconds>(stop - start);
    cout << nl;
    cout << "Test duration is " << duration.count()/1000 << endl;
     

}
