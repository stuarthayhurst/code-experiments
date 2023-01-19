#!/usr/bin/python3

numbers = [3, 7, 5, 1, 8, 2, 9, 4, 10]

swapped = True
while swapped:
  swapped = False
  for i in range(len(numbers)):
    if i + 1 < len(numbers):
      if numbers[i] > numbers[i + 1]:
        swapped = True
        temp = numbers[i + 1]
        numbers[i + 1] = numbers[i]
        numbers[i] = temp

print(numbers)
