import strutils
import sequtils

proc parseInput(path: string): seq[seq[int]] =
  for line in readFile(path).strip().splitLines():
    result.add(line.mapIt($it).mapIt(it.parseInt))

proc plusOne(field: seq[seq[int]]): seq[seq[int]] =
  result = field.mapIt(it.mapIt(it + 1))

proc findFlashing(field: seq[seq[int]]): seq[(int,int)] =
  for y in 0..9:
    for x in 0..9:
      if field[y][x] > 9:
        result.add((x,y))

proc increaseEnergy(energy: int): int =
  case energy:
    of 0:
      result = energy
    else:
      result = energy + 1

proc flash(field: seq[seq[int]], x,y: int): seq[seq[int]] =
  result = field
  result[y][x] = 0
  if x-1 >= 0:
    result[y][x-1] = increaseEnergy(result[y][x-1])
  if x-1 >= 0 and y-1 >= 0:
    result[y-1][x-1] = increaseEnergy(result[y-1][x-1])
  if x-1 >= 0 and y+1 < 10:
    result[y+1][x-1] = increaseEnergy(result[y+1][x-1])
  if y-1 >= 0:
    result[y-1][x] = increaseEnergy(result[y-1][x])
  if y-1 >= 0 and x+1 < 10:
    result[y-1][x+1] = increaseEnergy(result[y-1][x+1])
  if x+1 < 10:
    result[y][x+1] = increaseEnergy(result[y][x+1])
  if x+1 < 10 and y+1 < 10:
    result[y+1][x+1] = increaseEnergy(result[y+1][x+1])
  if y+1 < 10:
    result[y+1][x] = increaseEnergy(result[y+1][x])

proc printField(field: seq[seq[int]]) =
  echo ""
  for l in field:
    echo l

proc step(field: seq[seq[int]]): (seq[seq[int]],int) =
  result[0] = plusOne(field)
  var nines = findFlashing(result[0])
  while len(nines) > 0:
    for n in nines:
      result[0] = flash(result[0], n[0], n[1])
      result[1] += 1
    nines = findFlashing(result[0])

proc allSteps(path: string): (seq[seq[int]],int) =
  var
    field = parseInput(path)
    flashes = 0
  for i in 1..100:
    var f = 0
    (field, f) = step(field)
    flashes += f
  result = (field, flashes)

var
  (sampleField, sampleFlashes) = allSteps("sample/day11.txt")
  (field, flashes) = allSteps("input/day11.txt")

assert sampleFlashes == 1656

echo "Part one:"
printField(field)
echo "Flashes: ", flashes

proc inSync(field: seq[seq[int]]): bool =
  result = field.allIt(all(it, proc (x: int): bool = x == 0))

proc allSync(path: string): (seq[seq[int]],int) =
  var
    field = parseInput(path)
    steps = 0
  while not inSync(field):
    field = step(field)[0]
    steps += 1
  result = (field, steps)

var
  sampleSteps: int
  steps: int

(sampleField, sampleSteps) = allSync("sample/day11.txt")
(field, steps) = allSync("input/day11.txt")

assert sampleSteps == 195

echo "Part two:"
printField(field)
echo "Steps: ", steps
