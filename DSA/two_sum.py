# Q1. Given an array and a target, return indices of two numbers such that sum = target

# Optimize the solution fron O(n^2) to O(n)


#   Brute Force approach
array = [3, 1, 2, 2, 9, 6]
target = 7

# def search_indices(arr, target):
#     for i in range(len(arr)):
#         for j in range(i + 1, len(arr)):
#             if arr[i] + arr[j] == target:
#                 return i, j
# print(search_indices(array, target))

#   Optimul Approach

def two_sum(arr, target):
    map = {}
    for i, num in enumerate(arr):
        complement = target - num
        if complement in map:
            return map[complement], i
        map[num] = i
    return None
print(two_sum(array, target))
    