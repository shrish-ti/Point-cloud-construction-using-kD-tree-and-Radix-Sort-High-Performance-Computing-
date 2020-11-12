#include <iostream>
#define MAX_DIM 2
using namespace std;
void insertionSort(int h_array[][MAX_DIM], int numberofElements, int dim, int idx)  
{  
    int i, key, temp, j;  
    
    for (i = 1; i<=numberofElements-1; i++) 
    {  
        
        key = h_array[i][idx];
        if(idx==0)
        temp=h_array[i][1];
        else if(idx==1)
        temp=h_array[i][0];
        j = i - 1; 
        while (j >= 0 && h_array[j][idx] > key) 
        {  
            h_array[j + 1][idx]=h_array[j][idx];
            if(idx==0)
            h_array[j+1][1]=h_array[j][1];
            else if(idx==1)
            h_array[j+1][0]=h_array[j][0];
            j = j - 1;  
        }  
        h_array[j + 1][idx] = key;  
        if(idx==0)
        h_array[j+1][1]=temp;
        else if(idx==1)
        h_array[j+1][0]=temp;
    }
    
    for (i = 0; i<=numberofElements-1; i++) 
    {  
       cout<<h_array[i][0]<<" "<<h_array[i][1]<<endl;
    }
}  
int main() {
    int h_array[10][MAX_DIM];
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
    insertionSort(h_array, 10, 2, 1);
	return 0;
}
