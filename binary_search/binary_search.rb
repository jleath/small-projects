# perform binary search to return the index of the first
# occurrence of value in arr. Assumes that arr is a sorted array.
# if value does not exist in arr, will return nil
def binary_search(arr, value)
  index = find_value_index(arr, value, 0, arr.size - 1)
  return nil unless arr[index] == value

  seek_left(arr, value, index)
end

# return the index of the first occurrence of value found in arr between
# positions front and back (inclusive). Search used is a binary search
# assumes arr is a sorted array
def find_value_index(arr, value, front, back)
  mid = middle_value(front, back)
  while arr[mid] != value && front < back
    front = mid + 1 if arr[mid] < value
    back = mid - 1 if arr[mid] > value
    mid = middle_value(front, back)
  end
  mid
end

# return the smallest index in arr that references an object equal to value
# assumes that the initial value of index is a position in arr
# that contains value
def seek_left(arr, value, index)
  index -= 1 while index >= 0 && arr[index] == value
  index + 1
end

def middle_value(front, back)
  front + (back - front) / 2
end
