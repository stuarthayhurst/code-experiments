#!/usr/bin/python3

def shiftChar(char, shift):
  alphabetPosition = ord(char)

  #Work out an offset to help with wraparound
  if alphabetPosition >= 65 and alphabetPosition <= 90:
    offset = 65
  elif alphabetPosition >= 97 and alphabetPosition <= 122:
    offset = 97
  else: #Don't encode number and symbols
    return char

  #Shft character range to 1-26 and apply cipher
  newPosition = (alphabetPosition - offset) + shift
  #Warap around to prevent leaving character range
  newPosition = newPosition % 26
  #Correct for adjusted character range
  newPosition += offset

  return chr(newPosition)

#Return true if character is a letter
def isAlphabetical(character):
  character = character.lower()
  charVal = ord(character) - 97
  return (charVal >= 0 and charVal <= 25)

#Relative frequencies of occurences of each character in English
relativeFreqs = [0.117, 0.044, 0.052, 0.032, 0.028, 0.04, 0.016, 0.042, 0.073, 0.0051, 0.0086, 0.024, 0.038, 0.023, 0.076, 0.043, 0.0022, 0.028, 0.067, 0.16, 0.012, 0.082, 0.055, 0.00045, 0.0076, 0.00045]

inputStr = input("Enter a string to be deciphered: ")

#Generate every combination of cipher
possibleStrings = []
for i in range(26):
  possibleStrings.append("")
  for char in inputStr:
    possibleStrings[i] += shiftChar(char, i + 1)

#Get number of actual letters inside string
letterCount = 0
for character in inputStr:
  if isAlphabetical(character):
    letterCount += 1

#Get frequencies of each letter in each cipher combinaton
stringWeights = []
for possibleString in possibleStrings:
  currStringWeights = [0 for i in range(26)]
  for character in possibleString:
    character = character.lower()
    if isAlphabetical(character):
      currStringWeights[ord(character) - 97] += 1

  stringWeights.append(currStringWeights)

#Normalise the frequencies
for weightNum in range(26):
  for i in range(26):
    stringWeights[weightNum][i] = stringWeights[weightNum][i] / letterCount

#Work out how close each combination is to English
weightMatches = [[0, 0] for i in range(26)]
for weightNum in range(26):
  distance = 0
  for i in range(26):
    difference = abs(stringWeights[weightNum][i] - relativeFreqs[i])
    distance += (difference / relativeFreqs[i])
  weightMatches[weightNum] = [distance, weightNum]

#Sort the matches, display closest match last
weightMatches = sorted(weightMatches, key=lambda x:x[0])
weightMatches.reverse()
for weightMatch in weightMatches:
  print(f"{weightMatch[1]}, {possibleStrings[weightMatch[1]]}")
