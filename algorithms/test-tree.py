#!/usr/bin/python3

from structures.tree import TreeNode

root = TreeNode("M")
testData = ["B", "P", "Q", "F", "Z", "E", "T"]
for element in testData:
  root.addData(element)

for mode in ["pre", "in", "post"]:
  print(f"Printing in {mode}:")
  root.traverse(mode)
  print()

for search in testData + ["M", "X"]:
  if root.findData(search):
    print(f"Found {search}")
  else:
    print(f"Not found {search}")

print()
print(root.pathToData("E"))
