#!/usr/bin/python3
import random, copy

def getRandomChar():
	return chr(random.randint(65, 90))

def createGrid(gridSize):
	return [[getRandomChar() for x in range(gridSize)] for y in range(gridSize)]

def displayGrid(grid):
	for row in grid:
		for column in row:
			print(column, end="")
		print()

#Remove character and return true as soon as it's found
def findCharacter(grid, char):
	for i, row in enumerate(grid):
		if char in row:
			grid[i].remove(char)
			return True
	return False

def checkWord(grid, word):
	word = word.upper()

	foundChar = False
	#Check each character of the word is in the grid, give up as soon as one isn't
	for char in word:
		#If found, the character is removed to avoid duplicates
		if not findCharacter(grid, char):
			return False
	return True

grid = createGrid(4)
displayGrid(grid)

score = 0
usedWords = []
while True:
	word = input("Enter any word you see (leave empty to finish): ")
	if word == "":
		break
	#Pass a deep copy, to avoid the actual grid being modified
	elif checkWord(copy.deepcopy(grid), word):
		#Add length of word as score, and remember the word
		if word not in usedWords:
			score += len(word)
			usedWords.append(word)
		else:
			print(f"You've already used {word}!")
	else:
		print(f"{word} wasn't on the grid, try again")

print(f"\nYou scored {score}, using {len(usedWords)} word(s)")
