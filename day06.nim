import strutils
import sequtils
import algorithm

proc parseInput(path: string): seq[int] =
  result = readFile(path).strip().split(",").mapIt(parseInt(it))

proc transformInput(input: seq[int]): seq[int] =
  result = newSeq[int](9)
  for i in countup(0, 8):
    result[i] = input.count(i)

proc newGeneration(input: seq[int]): seq[int] =
  result = input.rotatedLeft(1)
  result[6] += input[0]

proc simulateFish(input: seq[int], n: int): seq[int] =
  result = input
  for i in countup(1, n):
    result = newGeneration(result)

proc countFish(input: seq[int]): int =
  result = input.foldl(a+b)

var
  sample = transformInput(parseInput("sample/day06.txt"))
  sampleResult = simulateFish(sample, 18)
  sampleResult2 = simulateFish(sample, 256)
  input = transformInput(parseInput("input/day06.txt"))
  result = simulateFish(input,80)
  result2 = simulateFish(input, 256)

assert countFish(sampleResult) == 26
assert countFish(sampleResult2) == 26984457539
echo "Part one: ", countFish(result)
echo "Part two: ", countFish(result2)
