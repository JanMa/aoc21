import strutils
import sequtils
import algorithm

proc parseInput(path:string): seq[seq[int]] =
  var
    input = readFile(path).strip().split("\n")
    tmp: seq[int]
  for line in input:
    var
      l = line.splitWhitespace.filterIt(it != "->")
    tmp.add(l[0].split(",").mapIt(parseInt(it)))
    tmp.add(l[1].split(",").mapIt(parseInt(it)))
    result.add(tmp)
    tmp = new(seq[int])[]

proc gridSize(input: seq[seq[int]]): (int,int) =
  for i in input:
    if i[0] > result[0]: result[0] = i[0]
    if i[1] > result[1]: result[1] = i[1]
    if i[2] > result[0]: result[0] = i[2]
    if i[3] > result[1]: result[1] = i[3]

proc generateGrid(x,y: int): seq[seq[int]] =
  result = newSeqWith(y+1, newSeq[int](x+1))

proc printGrid(grid: seq[seq[int]]) =
  for line in grid:
    echo line

proc drawLine(grid: seq[seq[int]], coords: seq[int], diagonal: bool = false): seq[seq[int]] =
  result = grid
  if coords[0] == coords[2]:
    # vertical line
    var tmp = @[coords[1], coords[3]]
    tmp.sort()
    for i in countup(tmp[0], tmp[1]):
      inc(result[i][coords[0]])
  elif coords[1] == coords[3]:
    # horizonzal line
    var tmp = @[coords[0],coords[2]]
    tmp.sort()
    for i in countup(tmp[0],tmp[1]):
      inc(result[coords[1]][i])
  elif diagonal:
    var
      x = @[coords[0], coords[2]]
      y = @[coords[1], coords[3]]
    for i in countup(0, abs(x[1] - x[0])):
      if x[1] > x[0] and y[1] > y[0]:
        inc(result[y[0] + i][x[0] + i])
      elif x[1] < x[0] and y[1] > y[0]:
        inc(result[y[0] + i][x[0] - i])
      elif x[1] > x[0] and y[1] < y[0]:
        inc(result[y[0] - i][x[0] + i])
      elif x[1] < x[0] and y[1] < y[0]:
        inc(result[y[0] - i][x[0] - i])

proc countOverlap(grid: seq[seq[int]]): int =
  for line in grid:
    result += line.filterIt(it > 1 ).len()

proc applyInput(grid, coords: seq[seq[int]], diagonal: bool = false): seq[seq[int]] =
  var tmp = grid
  for pair in coords:
    tmp = drawLine(tmp, pair, diagonal)
  result = tmp

var
  sample = parseInput("sample/day05.txt")
  (xSample,ySample) = gridSize(sample)
  sampleGrid = applyInput(generateGrid(xSample,ySample), sample)
  sampleGrid2 = applyInput(generateGrid(xSample,ySample), sample, true)

assert countOverlap(sampleGrid) == 5
assert countOverlap(sampleGrid2) == 12

var
  input = parseInput("input/day05.txt")
  (x,y) = gridSize(input)
  grid = applyInput(generateGrid(x,y), input)
  grid2 = applyInput(generateGrid(x,y), input, true)

echo "Part one: ", countOverlap(grid)
echo "Part two: ", countOverlap(grid2)
