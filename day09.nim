import strutils
import sequtils

proc parseInput(path: string): seq[seq[int]] =
  result = readFile(path).strip().splitLines().mapIt(toSeq(it).mapIt(parseInt($it)))

proc isLowPoint(i,j: int, input: seq[seq[int]]): bool =
  var
    y = input.len - 1
    x = input[0].len - 1
  if i > 0 and j > 0 and i < y and j < x:
    if input[i - 1][j] > input[i][j] and
       input[i][j - 1] > input[i][j] and
       input[i][j + 1] > input[i][j] and
       input[i + 1][j] > input[i][j]:
      return true
  if i == 0 and j > 0 and j < x:
    if input[i][j - 1] > input[i][j] and
       input[i][j + 1] > input[i][j] and
       input[i + 1][j] > input[i][j]:
      return true
  if i == y and j > 0 and j < x:
    if input[i - 1][j] > input[i][j] and
       input[i][j - 1] > input[i][j] and
       input[i][j + 1] > input[i][j]:
      return true
  if i > 0 and i < y and j == 0:
    if input[i][j + 1] > input[i][j] and
       input[i - 1][j] > input[i][j] and
       input[i + 1][j] > input[i][j]:
      return true
  if i > 0 and i < y and j == x:
    if input[i][j - 1] > input[i][j] and
       input[i - 1][j] > input[i][j] and
       input[i + 1][j] > input[i][j]:
      return true
  if i == 0 and j == 0:
    if input[0][1] > input[0][0] and
       input[1][0] > input[0][0]:
      return true
  if i == 0 and j == x:
    if input[0][x-1] > input[0][x] and
       input[1][x] > input[0][x]:
      return true
  if i == y and j == x:
    if input[y][x-1] > input[y][x] and
       input[y-1][x] > input[y][x]:
      return true
  if i == y and j == 0:
    if input[y][1] > input[y][0] and
       input[y-1][0] > input[y][0]:
      return true
  return false

proc findLowPoints(input: seq[seq[int]]): seq[int] =
  for i in countup(0, len(input) - 1):
    for j in countup(0, len(input[0]) - 1):
      if isLowPoint(i,j,input): result.add(input[i][j])

var
  sample = parseInput("sample/day09.txt")
  input = parseInput("input/day09.txt")

assert findLowPoints(sample).mapIt(it + 1).foldl(a+b) == 15
echo "Part one: ", findLowPoints(input).mapIt(it + 1).foldl(a+b)
