#include <iostream> 
using namespace std; 

int getMax(int arr[][2], int n) 
{ 
	int mx = arr[0][0]; 
	for (int i = 0; i < n; i++) 
		if (arr[i][0] > mx) 
			mx = arr[i][0]; 
	return mx; 
} 

void countSort(int arr[][2], int n, int exp) 
{ 
	int output[n][2]; 
	int i, count[10] = { 0 }; 

	for (i = 0; i < n; i++) 
		count[(arr[i][0] / exp) % 10]++; 

	for (i = 1; i < 10; i++) 
		count[i] += count[i - 1]; 

	for (i = n - 1; i >= 0; i--) { 
		output[count[(arr[i][0] / exp) % 10] - 1][0] = arr[i][0];
		output[count[(arr[i][0] / exp) % 10] - 1][1] = arr[i][1];
		count[(arr[i][0] / exp) % 10]--; 
	} 

	for (i = 0; i < n; i++) 
	{
		arr[i][0] = output[i][0]; 
		arr[i][1]=output[i][1];
}
    
} 

void radixsort(int arr[][2], int n) 
{ 
	int m = getMax(arr, n); 

	for (int exp = 1; m / exp > 0; exp *= 10) 
		countSort(arr, n, exp); 
} 

void print(int arr[][2], int n) 
{ 
	for (int i = 0; i < n; i++) 
		cout << arr[i][0] << " "<< arr[i][1] << " "<<endl; 
} 

int main() 
{ 
	int arr[][2] = { {170,0}, {45,1}, {75,2}, {90,4}, {802,5}, {24,6}, {2,7}, {66,8} }; 
	int n = 8; 
	radixsort(arr, n); 
	return 0; 
}
