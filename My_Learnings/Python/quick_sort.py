from statistics import median
def quick_sort(array):

    #three arrays are created
    left_arr = []
    match = []
    right_arr = []

    # size of our array
    if len(array) > 1:

        pivot = median([array[0],array[int((len(array)-1)/2)],array[len(array)-1]])

        #sorting the numbers to the defined arrays
        for x in array:
            if x < pivot:
                left_arr.append(x)
            if x == pivot:
                match.append(x)
            if x > pivot:
                right_arr.append(x)

        # using recursive call
        return quick_sort(left_arr)+match+quick_sort(right_arr)

    else:
        return array

print(quick_sort([9,5,1,-5,10,0,23, 7]))