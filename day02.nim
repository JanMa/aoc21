import strutils
import sequtils

var aim = 0

proc parseInput(path: string): seq[(string,int)] =
  let input = readFile(path).strip().split("\n")
  for line in input:
    var l = line.split(" ")
    result.add((l[0],parseInt(l[1])))

proc handleCommand(command: (string,int), withAim: bool = false): (int,int) =
  case command[0]
  of "forward":
    result = (command[1],if withAim: aim * command[1] else : 0)
  of "down":
    if withAim:
      aim += command[1]
    result = (0, if withAim: 0 else: command[1])
  of "up":
    if withAim:
      aim -= command[1]
    result = (0, if withAim: 0 else: -command[1])
  else:
    result = (0,0)

proc position(input: seq[(string,int)], withAim: bool = false): int =
  var
    positions = input.mapIt(handleCommand(it, withAim))
    dest = positions.foldl((a[0]+b[0],a[1]+b[1]),(0,0))
  result = dest[0] * dest[1]

var
  input: seq[(string,int)] = parseInput("input/day02.txt")

echo "Part one: ", position(input)
echo "Part two: ", position(input, true)
