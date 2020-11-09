#include <iostream>
using namespace std;
void insertionSort(int h_array[][2], int numberofElements, int dim, int idx)  
{  
    int i, key, temp, j;  
    if(dim==0)
    {
    for (i = 1; i<=numberofElements-1; i++) 
    {  
        key = h_array[i][0];
        temp=h_array[i][1];
        j = i - 1; 
        while (j >= 0 && h_array[j][0] > key) 
        {  
            h_array[j + 1][0]=h_array[j][0];  
            h_array[j+1][1]=h_array[j][1];
            j = j - 1;  
        }  
        h_array[j + 1][0] = key;  
        h_array[j+1][1]=temp;
    }
    }
    for (i = 0; i<=numberofElements-1; i++) 
    {  
       cout<<h_array[i][0]<<" "<<h_array[i][1]<<endl;
    }
}  
int main() {
    int h_array[10][2];
    for(int i=0; i<10; i++)
    {
        h_array[i][0]=rand()%50;
        h_array[i][1]=i;
    }
    for (int i = 0; i<=9; i++) 
    {  
       cout<<h_array[i][0]<<" "<<h_array[i][1]<<endl;
    }
    cout<<"Shrishti"<<endl;
    insertionSort(h_array, 10, 0, 9);
	return 0;
}
