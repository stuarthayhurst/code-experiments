#!/usr/bin/python3

#Check if a number is a prime
def checkPrime(number):
  #Special handling for 0->2 and even numbers
  if number <= 1:
    return False
  elif number == 2:
    return True
  elif number % 2 == 0:
    return False

  #Attempt to divide number by every odd number from 3 to the number
  for i in range(3, number, 2):
    if number % i == 0:
      return False
  return True

#Check each component of the input is a prime (left to right)
def leftTrunc(string):
  for i in range(len(string)):
    leftTrunc = checkPrime(int(string[i:]))
    if not leftTrunc:
      return False
  return True

#Check each component of the input is a prime (right to left)
def rightTrunc(string):
  for i in range(len(string), 0, -1):
    rightTrunc = checkPrime(int(string[:i]))
    if not rightTrunc:
      return False
  return True

def truncatablePrime(number):
  string = str(number)
  if "0" in string: #Eliminate any number containing a 0
    return False

  #Decide if the input is left and / or right truncatable
  left = leftTrunc(string)
  right = rightTrunc(string)

  #Return correct value based on tests
  if left and right:
    return "both"
  elif left:
    return "left"
  elif right:
    return "right"
  else:
    return False

if __name__ == "__main__":
  #Use known inputs and outputs to test
  results = ['left', 'right', 'both', 'both', False, False]
  inputs = [9137, 5939, 317, 5, 139, 103]
  outputs = []
  for i in inputs:
    result = truncatablePrime(int(i))
    outputs.append(result)
    print(f"  {i}: {result}")

  print(f"Expected output: {results}")
  print(f"Actual output  : {outputs}")
  if outputs == results:
    print("Passed")
  else:
    print("Failed")

  exit() #Use the following to test individual inputs in a loop
  while True:
    print(truncatablePrime(int(input())))
