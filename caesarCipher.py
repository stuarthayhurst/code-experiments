#!/usr/bin/python3
#Take required user inputs
inputStr = input("Enter a string to be encoded: ")
shiftSize = int(input("Enter the number of characters to shift by (use a negative to decode): "))

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

for char in inputStr:
  #Don't print newline automatically
  print(shiftChar(char, shiftSize), end='')

#Provide final endline character
print()
