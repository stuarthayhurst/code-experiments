#include <stdio.h>
#include <stdlib.h>

int main(int argc, char** argv) {
  int numCells, numGens, ruleNum;
  char *currentGen, *nextGen, *tmpGen;
  int gen, cellIndex;
  char nextCell, prevCell;
  int ruleSet[8];

  /* Verify number of arguments */
  if (argc != 4) {
    printf("Incorrect number of arguments, expected 3 got %d\n", argc - 1);
    return 1;
  }

  /* Get command line arguments */
  numCells = atoi(argv[1]);
  numGens = atoi(argv[2]);
  ruleNum = atoi(argv[3]);

  /* Validate arguments */
  if (numCells < 1) {
    printf("Number of cells must be an integer greater than 1\n");
    return 1;
  }
  if (numGens < 1) {
    printf("Number of generations must be an integer greater than 1\n");
    return 1;
  }
  if (ruleNum < 0 || ruleNum > 255) {
    printf("Rule number must be an integer within the range [0, 255]\n");
    return 1;
  }

  /* Generate ruleset from number */
  ruleSet[7] = !!(ruleNum & 128);
  ruleSet[6] = !!(ruleNum & 64);
  ruleSet[5] = !!(ruleNum & 32);
  ruleSet[4] = !!(ruleNum & 16);
  ruleSet[3] = !!(ruleNum & 8);
  ruleSet[2] = !!(ruleNum & 4);
  ruleSet[1] = !!(ruleNum & 2);
  ruleSet[0] = !!(ruleNum & 1);

  /* Allocate memory for generations */
  currentGen = (char*)calloc(numCells, sizeof(char));
  nextGen = (char*)calloc(numCells, sizeof(char));

  /* Place initial cell */
  nextGen[numCells / 2] = 1;

  for (gen = 0; gen < numGens; gen++) {
    /* Swap nextGen to currentGen */
    tmpGen = currentGen;
    currentGen = nextGen;
    nextGen = tmpGen;

    /* Display generation, and calculate next generation */
    for (cellIndex = 0; cellIndex < numCells; cellIndex++) {
      /* Print an asterisk or a space */
      printf("%c", currentGen[cellIndex] ? '*' : ' ');

      /* Apply wraparound using (index + length) % length */
      prevCell = currentGen[(cellIndex - 1 + numCells) % numCells];
      nextCell = currentGen[(cellIndex + 1 + numCells) % numCells];

      /* Calculate and store cell state */
      nextGen[cellIndex] = ruleSet[prevCell << 2 | currentGen[cellIndex] << 1 | nextCell];
    }
    printf("\n");
  }

  /* Clean up memory */
  free(currentGen);
  free(nextGen);

  return 0;
}
