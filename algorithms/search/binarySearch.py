#!/usr/bin/python3
import sys, math, random

def binarySearch(dataset, searchValue):
  lowerBound = 0
  upperBound = len(dataset) - 1
  found = False

  #If the value isn't found and the whole dataset hasn't been searched, keep looking
  while found == False and lowerBound <= upperBound:
    #Find the midpoint of the search region
    midpoint = math.floor((lowerBound + upperBound) / 2)
    #If the item has been found, stop searching
    if dataset[midpoint] == searchValue:
      found = True
    #If it wasn't found, adjust the search region
    elif dataset[midpoint] < searchValue:
      lowerBound = midpoint + 1
    else:
      upperBound = midpoint - 1

  if found == True:
    return midpoint
  else:
    return None

#Generate random, sorted dataset
dataset = sorted([random.randint(0, 1000) for i in range(0, 1000)])

#Take the value to search for
if len(sys.argv) <= 1:
  print("Requires an argument")
  exit(1)

searchValue = int(sys.argv[1])
print(f"Looking for {searchValue}")

position = binarySearch(dataset, searchValue)

#Tell user whether data was found or not, and where
if position != None:
  print(f"Search found at: {position}")
else:
  print("Search not found")

