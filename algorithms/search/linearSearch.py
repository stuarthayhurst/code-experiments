#!/usr/bin/python3
import sys, random

def linearSearch(dataset, searchValue):
  #Iterate over dataset
  for i in range(len(dataset)):
    #If the search value is found, exit early and return the index
    if dataset[i] == searchValue:
      return i
  #If the end of the dataset was reached, the value wan't present
  return None

#Generate random dataset
dataset = [random.randint(0, 1000) for i in range(0, 1000)]

#Take the value to search for
if len(sys.argv) <= 1:
  print("Requires an argument")
  exit(1)

searchValue = int(sys.argv[1])
print(f"Looking for {searchValue}")

position = linearSearch(dataset, searchValue)

#Tell user whether data was found or not, and where
if position != None:
  print(f"Search found at: {position}")
else:
  print("Search not found")

