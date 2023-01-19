#!/usr/bin/python3
import random, time, math
import matplotlib.pyplot as plt
import multiprocessing as mp

#Functions to return specific datasets
def getNearList(targetLength):
  return [random.randint(i, i + 2) for i in range(targetLength)]

def getReverseList(targetLength):
  return [targetLength - i for i in range(targetLength)]

def getRandomList(targetLength):
  return [random.randint(0, 499) for i in range(targetLength)]

#Sort passed list using merge sort
def mergeSort(dataset):
  comparisons = 0
  if len(dataset) > 1:
    mid = math.floor(len(dataset) / 2)
    leftSubList = dataset[:mid]
    rightSubList = dataset[mid:]
    mergeSort(leftSubList)
    mergeSort(rightSubList)

    i, j, target = 0, 0, 0

    #Merge the 2 sub lists
    while i < len(leftSubList) and j < len(rightSubList):
      comparisons += 1
      if leftSubList[i] < rightSubList[j]:
        dataset[target] = leftSubList[i]
        i += 1
      else:
        dataset[target] = rightSubList[j]
        j += 1
      target += 1

    #Clean up stray elements in leftSubList
    while i < len(leftSubList):
      comparisons += 1
      dataset[target] = leftSubList[i]
      i += 1
      target += 1

    #Clean up stray elements in leftSubList
    while j < len(rightSubList):
      comparisons += 1
      dataset[target] = rightSubList[j]
      j += 1
      target += 1

  return dataset, comparisons

#Wrapper function for multiprocessing, takes the dataset number, generates the dataset and returns performance metrics
def benchmarkLength(i):
  dataset = getRandomList(10000 * i)

  start = time.time()
  data, comps = mergeSort(dataset)

  runtime = time.time() - start
  print(f"Ran test {i} ({len(dataset)}, {runtime})")
  print(f"{i}: {comps}")

  return [len(dataset), runtime]

#Benchmark settings
tests = 24
processes = mp.cpu_count()

#Split tests among all available cores
with mp.Pool(processes) as pool:
  runtimeData = pool.map(benchmarkLength, [i for i in range(1, tests + 1)])

#As testing was done in parallel, the data isn't necessarily ordered by length until it's sorted
runtimeData = sorted(runtimeData, key=lambda runtimeData: runtimeData[0])

#Separate dataset lengths and runtime data
datasetLengths = []
runtimes = []
for datapair in runtimeData:
  datasetLengths.append(datapair[0])
  runtimes.append(datapair[1])

#Generate the graph from dataset length and runtime
plt.xlabel("Dataset length")
plt.ylabel("Time to order")
plt.plot(datasetLengths, runtimes)
plt.show()
