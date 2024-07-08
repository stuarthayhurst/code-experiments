#include <cstdint>
#include <cstdlib>
#include <string>
#include <iostream>
#include <cstring>
#include <algorithm>

//Don't use this for security, you'll lose your job
static uint64_t generateCacheString(std::string* filePaths, unsigned int fileCount) {
  alignas(uint64_t) uint8_t output[8] = {0};
  uint8_t prev = 0;

  /*
   - XOR the first byte of the hash with each character of each path
   - After each character, sequentially XOR every byte of the hash with the result of
     the previous XOR
  */
  for (unsigned int i = 0; i < fileCount; i++) {
    uint8_t* filePath = (uint8_t*)filePaths[i].c_str();
    int pathLength = filePaths[i].length();
    for (int i = 0; i < pathLength; i++) {
      output[0] ^= filePath[i];
      for (int j = 0; j < 8; j++) {
        output[j] ^= prev;
        prev = output[j];
      }
    }
  }

  return *(uint64_t*)output;
}

/*
 - Find another useable file path that has a cache string collision with another group
 - Needed to properly test cache collision resolution in ammonite-engine
 - Uses a random length and random characters
*/

int main() {
  std::string defaults[] = {
    "shaders/depth/depthShader.fs", "shaders/depth/depthShader.gs", "shaders/depth/depthShader.vs",
    "shaders/lights/lightShader.fs", "shaders/lights/lightShader.vs",
    "shaders/loading/loadingShader.fs", "shaders/loading/loadingShader.vs",
    "shaders/models/modelShader.fs", "shaders/models/modelShader.vs",
    "shaders/screen/screenShader.fs", "shaders/screen/screenShader.vs",
    "shaders/skybox/skyboxShader.fs", "shaders/skybox/skyboxShader.vs"
  };

  uint64_t values[] = {
    generateCacheString(defaults, 3),
    generateCacheString(defaults + 3, 2),
    generateCacheString(defaults + 5, 2),
    generateCacheString(defaults + 7, 2),
    generateCacheString(defaults + 9, 2),
    generateCacheString(defaults + 11, 2)
  };

  std::string inputs[2] = {
    "shaders/test/testShader.fs",
    ""
  };

  char raw[4096];
  char* buffer = raw + 13;
  std::strcpy(raw, "shaders/test/");

  std::srand((unsigned)time(nullptr));
  bool found = false;
  while (!found) {
    int length = 6 + std::rand() % 123;
    for (int i = 0; i < length; i++) {
      buffer[i] = std::rand() % 52;
      if (buffer[i] < 26) {
        buffer[i] += 65;
      } else {
        buffer[i] += 71;
      }
    }

    buffer[length] = '.';
    buffer[length + 1] = 'v';
    buffer[length + 2] = 's';
    buffer[length + 3] = '\0';

    inputs[1] = raw;
    uint64_t cache = generateCacheString(inputs, 2);
    for (int i = 0; i < sizeof(values) / sizeof(uint64_t); i++) {
      if (cache == values[i]) {
        found = true;
        std::cout << "Match!" << std::endl;
        std::cout << cache << std::endl;
        std::cout << inputs[0] << std::endl;
        std::cout << inputs[1] << std::endl;
      }
    }

    buffer[0]++;
  }

  return 0;
}
