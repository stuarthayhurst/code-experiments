#!/usr/bin/python3

class TreeNode:
  def __init__(self, data, parent = None):
    self.data = data
    self.parent = parent

    self.children = [None, None]

  def addData(self, data):
    index = 0 if data < self.data else 1
    if self.children[index] == None:
      self.children[index] = TreeNode(data, self)
    else:
      self.children[index].addData(data)

  def traverse(self, order):
    if order == "pre":
      print(self.data)

    for i in [0, 1]:
      if order == "in":
        if i == 1:
          print(self.data)

      if self.children[i] != None:
        self.children[i].traverse(order)

    if order == "post":
      print(self.data)

  def findData(self, targetData):
    if self.data == targetData:
      return True

    index = 0 if targetData < self.data else 1
    if self.children[index] != None:
      return self.children[index].findData(targetData)
    else:
      return False

  def pathToData(self, targetData):
    if self.data == targetData:
      return True

    index = 0 if targetData < self.data else 1
    if self.children[index] != None:
      print(index)
      return self.children[index].pathToData(targetData)
    else:
      print("Not in tree")
      return False
