import strutils
import sequtils
import algorithm

proc parseInput(path: string): seq[int] =
  result = readFile(path).strip().split(",").mapIt(parseInt(it))

proc sumUp(lo, hi: int): int =
  for i in countup(lo, hi):
    result += i

proc minFuel(input: seq[int], exponential: bool = false): int =
  var
    tmp = input
    fuelPositions: seq[int]
  tmp.sort()
  for i in countup(tmp[0],tmp[^1]):
    if exponential:
       fuelPositions.add(input.mapIt(sumUp(0,abs(it - i))).foldl(a+b))
    else:
       fuelPositions.add(input.mapIt(abs(it - i)).foldl(a+b))
  fuelPositions.sort
  result = fuelPositions[0]


var
  sample = parseInput("sample/day07.txt")
  input = parseInput("input/day07.txt")

assert minFuel(sample) == 37
assert minFuel(sample, true) == 168

echo "Part one: ", minFuel(input)
echo "Part two: ", minFuel(input, true)
