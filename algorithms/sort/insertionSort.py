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

#Sort passed list using insertion sort
def insertionSort(dataset):
  swaps = 0
  for i in range(1, len(dataset)):
    position = i
    currentValue = dataset[i]
    while position > 0 and dataset[position - 1] > currentValue:
      swaps += 1
      dataset[position] = dataset[position - 1]
      position -= 1
    dataset[position] = currentValue

  return dataset, swaps

#Wrapper function for multiprocessing, takes the dataset number, generates the dataset and returns performance metrics
def benchmarkLength(i):
  dataset = getRandomList(100 * i)

  start = time.time()
  data, swaps = insertionSort(dataset)

  runtime = time.time() - start
  print(f"Ran test {i} ({len(dataset)}, {runtime})")
  print(f"Test {i}: {swaps} swaps")

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
