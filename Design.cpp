#include <iostream>
using namespace std;

//Blueprint of a node of the 3 dimensional tree
struct Node
{
    long long int point[3];
    Node* left;
    Node* right;
}

//Creation of new Node of 3 dimensional tree  
Node* kDtreeconstruction(p[])
{
    Node* n =new Node;
    for(int i=0; i<3; i++)
    {
        n->point[i]=p[i];
    }
    n->left=NULL;
    n->right=NULL;
    return n;
}

//Sorting decider

//Radix Sort

//Insertion sort

int main() {
	cout<<"Incomplete Code";
	return 0;
}
