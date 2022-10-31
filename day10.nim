import strutils
import std/algorithm

proc parseInput(path: string): seq[string] =
  result = readFile(path).strip().splitLines()


proc isOpenChar(c: char): bool =
  case c:
    of '(', '{', '[', '<':
      result = true
    else:
      result = false

proc closeChar(c: char): char =
  case c:
    of '(':
      result = ')'
    of '{':
      result = '}'
    of '[':
      result = ']'
    of '<':
      result = '>'
    else:
      result = '-'

proc points(c: char): int =
  case c:
    of ')':
      result = 3
    of '}':
      result = 1197
    of ']':
      result = 57
    of '>':
      result = 25137
    else:
      result = 0

proc pointsTwo(c: char): int =
  case c:
    of ')':
      result = 1
    of '}':
      result = 3
    of ']':
      result = 2
    of '>':
      result = 4
    else:
      result = 0

proc parseLine(line: string): (bool, char) =
  var lastOpen: seq[char]

  for c in line:
    var b = isOpenChar(c)
    if b:
      lastOpen.add(c)
    elif not b and len(lastOpen) > 0:
      var o = lastOpen.pop
      if c != closeChar(o):
        return (false, c)
  result = (true, line[^1])


proc calculateScore(path: string): int =
    for l in parseInput(path):
        var l = parseLine(l)
        if not l[0]:
          result += points(l[1])

proc incompleteLines(path: string): seq[string] =
    for l in parseInput(path):
        var p = parseLine(l)
        if p[0]:
          result.add(l)

proc completeLine(line: string): string =
  var lastOpen: seq[char]

  for c in line:
    var b = isOpenChar(c)
    if b:
      lastOpen.add(c)
    elif not b and len(lastOpen) > 0:
      var o = lastOpen.pop
      if c != closeChar(o):
        return ""
  for i in countdown(len(lastOpen)-1,0):
    result.add(closeChar(lastOpen[i]))

proc completeionScore(line: string): int =
  for c in line:
    result = result * 5 + pointsTwo(c)

proc middleScore(path: string): int =
  var scores: seq[int]
  for line in incompleteLines(path):
    scores.add(completeionScore(completeLine(line)))
  scores.sort()
  result = scores[(len(scores)-1) div 2]

assert calculateScore("sample/day10.txt") == 26397
assert middleScore("sample/day10.txt") == 288957

echo "Part one: ", calculateScore("input/day10.txt")
echo "Part two: ", middleScore("input/day10.txt")
