//original array, number of elements, total (dim), current dim to sort idx 
#include <iostream> 
#define MAX_DIM 2
using namespace std; 

int getMax(int h_array[][MAX_DIM], int numberOfElements, int dim, int idx) 
{   
	int mx = h_array[0][idx]; 
	for (int i = 0; i < numberOfElements; i++) 
		if (d_array[i][idx] > mx) 
			mx = d_array[i][idx]; 
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
		output[count[(h_array[i][idx] / exp) % 10] - 1][1] = h_array[i][1];
		else if(idx==1)
		output[count[(h_array[i][idx] / exp) % 10] - 1][0] = h_array[i][0];
		count[(h_array[i][idx] / exp) % 10]--; 
	} 

	for (i = 0; i < numberOfElements; i++) 
	{
		h_array[i][0] = output[i][0]; 
		h_array[i][1]=output[i][1];
}
    
} 

void radixsort(int h_array[][MAX_DIM], int numberOfElements, int dim, int idx) 
{ 
	int m = getMax(h_array, numberOfElements, dim, idx); 

	for (int exp = 1; m / exp > 0; exp *= 10) 
		countSort(h_array, numberOfElements, dim, idx, exp); 
} 

/*void print(int h_array[][MAX_DIM], int numberOfElements, int dim, int idx) 
{ 
	for (int i = 0; i < numberOfElements; i++) 
		cout << h_array[i][0] << " "<< d_array[i][1] << " "<<endl; 
} */

int main() 
{ 
    int numberOfElements = 5;
    int dim = 2;
	int d_array[numberOfElements][MAX_DIM] = { {170,0}, {45,1}, {75,2}, {90,3}, {60,4} }; 
	int idx =0;
	radixsort(d_array, numberOfElements, dim, idx);
	print(d_array, numberOfElements, dim, idx);
	return 0; 
}
