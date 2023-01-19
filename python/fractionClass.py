#!/usr/bin/python3

class Fraction:
  def __init__(self, value = "0/0"):
    self.numerator = int(value.split("/")[0])
    self.denominator = int(value.split("/")[1])

  def reciprocal(self):
    return Fraction(f"{self.denominator}/{self.numerator}")

  def __str__(self):
    return f"{self.numerator}/{self.denominator}"

  def __add__(self, other):
    numerator = (self.numerator * other.denominator) + (other.numerator * self.denominator)
    denominator = self.denominator * other.denominator

    return Fraction(f"{numerator}/{denominator}")

  def __sub__(self, other):
    numerator = (self.numerator * other.denominator) - (other.numerator * self.denominator)
    denominator = self.denominator * other.denominator

    return Fraction(f"{numerator}/{denominator}")

  def __mul__(self, other):
    numerator = self.numerator * other.numerator
    denominator = self.denominator * other.denominator

    return Fraction(f"{numerator}/{denominator}")  

  def __truediv__(self, other):
    return self.__mul__(other.reciprocal())

print(Fraction("1/3") + (Fraction("1/3") * Fraction("2/1")))
print(Fraction("1/3") / Fraction("2/1"))
print(Fraction("1/3") * 4)
