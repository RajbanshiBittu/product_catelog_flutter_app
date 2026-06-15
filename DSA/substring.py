# Q2. Longest substring without repeating characters
# Input: "abcabcbb"
# Output: 3

#   Bruate Force Approach
# def is_unique(substring):
#     return len(substring) == len(set(substring))

# def longest_substring(s):
#     max_length = 0
#     for i in range(len(s)):
#         for j in range(i, len(s)):
#             substring = s[i:j+1]
            
#             if is_unique(substring):
#                 max_length = max(max_length, len(substring))
#     return max_length

# print(longest_substring("abcabcbb"))


# Optimal Approach
def longest_substring(str):
    seen = set()

    left = 0
    max_length = 0

    for right in range(len(str)):
        while str[right] in seen:
            seen.remove(str[left])
            left += 1

        seen.add(str[right])

        max_length = max(max_length, right - left + 1)
    return max_length

print(longest_substring("abcabcbb"))