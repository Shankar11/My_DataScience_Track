def partition(arr,first,last): 
    i = ( first-1 )        
    pivot = arr[last]      
  
    for j in range(first , last):   
        if   arr[j] <= pivot:         
            i = i+1 
            swap( arr, i, j )
  
    swap( arr, i+1, last )
    return ( i+1 ) 

def swap( arr, i, j ):
  arr[i],arr[j]=arr[j],arr[i]

def quickSort(arr,first,last):    
    if first < last: 

        pi = partition(arr,first,last)   
        quickSort(arr, first, pi-1) 
        quickSort(arr, pi+1, last) 



q_arr = [9,5,1,-5,10,0,23, 7]
quickSort(q_arr,0,len(q_arr)-1)
print(q_arr)