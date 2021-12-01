import strutils

proc parseInput(path: string): seq[int] =
  let input = readFile(path).strip().split("\n")
  for line in input:
    result.add(parseInt(line))

let
  input: seq[int] = parseInput("input/day01.txt")

var count = 0

for i in countup(1, input.len - 1):
  if input[i] > input[i-1]:
    inc count

echo "Part 1: ", count
count = 0

for i in countup(0, input.len - 4):
  var
    i1 = input[i] + input[i+1] + input[i+2]
    i2 = input[i+1] + input[i+2] + input[i+3]
  if i1 < i2:
    inc count

echo "Part 2: ", count
