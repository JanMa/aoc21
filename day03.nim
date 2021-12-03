import strutils
import sequtils

proc parseInput(path: string): seq[string] =
  result = readFile(path).strip().split("\n")

proc positionBits(input: seq[string]): seq[string] =
  for i in countup(0, input[0].len() - 1):
    result.add(input.mapIt(it[i]).join())

proc mostCommon(pos: string): string =
  if pos.count('0') > pos.count('1'):
    result = "0"
  else:
    result = "1"

proc leastCommon(pos: string): string =
  if pos.count('0') > pos.count('1'):
    result = "1"
  else:
    result = "0"

proc oxigenGenerator(input: seq[string]): string =
  var tmp = input
  for i in countup(0, tmp.len() - 1):
    var m = positionBits(tmp).mapIt(mostCommon(it))[i]
    tmp.keepItIf($it[i] == m)
    if tmp.len() == 1:
      break
  result = tmp[0]


proc co2Scrubber(input: seq[string]): string =
  var tmp = input
  for i in countup(0, tmp.len() - 1):
    var m = positionBits(tmp).mapIt(leastCommon(it))[i]
    tmp.keepItIf($it[i] == m)
    if tmp.len() == 1:
      break
  result = tmp[0]

var
  input = parseInput("input/day03.txt")
  sample = parseInput("sample/day03.txt")
  gamma = positionBits(input).mapIt(mostCommon(it)).join()
  epsilon = positionBits(input).mapIt(leastCommon(it)).join()
  oxi = oxigenGenerator(input)
  co2 = co2Scrubber(input)

echo "Part one: ", gamma.parseBinInt() * epsilon.parseBinInt()
echo "Part two: ", oxi.parseBinInt() * co2.parseBinInt()
