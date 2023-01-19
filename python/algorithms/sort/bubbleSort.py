#!/usr/bin/python3
import random, time
import matplotlib.pyplot as plt
import multiprocessing as mp

#Functions to return specific datasets
def getNearList(targetLength):
  return [random.randint(i, i + 2) for i in range(targetLength)]

def getReverseList(targetLength):
  return [targetLength - i for i in range(targetLength)]

def getRandomList(targetLength):
  return [random.randint(0, 499) for i in range(targetLength)]

#Sort passed list using bubble sort
def bubbleSort(dataset):
  isSorted = False
  #Keep sorting until no swaps are made in a pass
  while not isSorted:
    isSorted = True
    #Iterate over the dataset and compare very item
    for i in range(0, len(dataset) - 1):
      if dataset[i] > dataset[i + 1]:
        temp = dataset[i]
        dataset[i] = dataset[i + 1]
        dataset[i + 1] = temp
        isSorted = False
  return dataset

#Wrapper function for multiprocessing, takes the dataset number, generates the dataset and returns performance metrics
def benchmarkLength(i):
  dataset = getRandomList(100 * i)

  start = time.time()
  bubbleSort(dataset)

  runtime = time.time() - start
  print(f"Ran test {i} ({len(dataset)}, {runtime})")

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
