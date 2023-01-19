#!/usr/bin/python3
import sys, math, random

def binarySearch(dataset, searchValue, lowerBound, upperBound):
  #Find the midpoint of the search region
  midpoint = math.floor((lowerBound + upperBound) / 2)

  if lowerBound > upperBound:
    return None

  if dataset[midpoint] == searchValue:
    return midpoint
  #If it wasn't found, adjust the search region
  elif dataset[midpoint] < searchValue:
    return binarySearch(dataset, searchValue, midpoint + 1, upperBound)
  else:
    return binarySearch(dataset, searchValue, lowerBound, midpoint - 1)


#Generate random, sorted dataset
dataset = sorted([random.randint(0, 1000) for i in range(0, 1000)])

#Take the value to search for
if len(sys.argv) <= 1:
  print("Requires an argument")
  exit(1)

searchValue = int(sys.argv[1])
print(f"Looking for {searchValue}")

position = binarySearch(dataset, searchValue, 0, len(dataset) - 1)

#Tell user whether data was found or not, and where
if position != None:
  print(f"Search found at: {position}")
else:
  print("Search not found")

