import strutils
import sequtils

proc parseInput(path: string): (seq[int], seq[seq[seq[int]]]) =
    var
      input = readFile(path).strip().split("\n")
      tmp: seq[seq[int]]

    result[0] = input[0].split(",").mapIt(parseInt(it))

    for line in input[2..^1]:
      if line == "":
        result[1].add(tmp)
        tmp = new(seq[seq[int]])[]
        continue
      tmp.add(line.splitWhitespace.mapIt(parseInt(it)))
    result[1].add(tmp)

proc markField(field: seq[seq[int]], n: int): seq[seq[int]] =
  result = field
  for i in mitems(result):
    i.applyIt(if it == n: (it * 0)  - 1 else: it * 1)

proc isWinner(field: seq[seq[int]]): bool =
  for i in field:
    if i.allIt(it == -1):
      return true
  for i in countup(0, field[0].len() - 1 ):
    if field.mapIt(it[i]).allIt(it == -1):
      return true

proc applyInput(input: seq[int], fields: seq[seq[seq[int]]], findLast: bool = false): (int, seq[seq[int]]) =
  var tmp = fields
  for i in input:
    tmp.applyIt(markField(it, i))
    if findLast and tmp.len() > 1:
      tmp.keepItIf(not isWinner(it))
    if tmp.anyIt(isWinner(it)):
      return (i, tmp.filterIt(isWinner(it))[0])

proc finalScore(field: seq[seq[int]]): int =
  var tmp: seq[int]
  for i in field:
    tmp = tmp.concat(i.filterIt(it != -1))
  result = tmp.foldl(a + b)

var
  ( sample, sampleFields ) = parseInput("sample/day04.txt")
  ( input, fields ) = parseInput("input/day04.txt")
  (last, winner) = applyInput(input, fields)
  (veryLast, lastWinner) = applyInput(input, fields, true)

echo "Part one: ", finalScore(winner) * last
echo "Part two: ", finalScore(lastWinner) * veryLast
