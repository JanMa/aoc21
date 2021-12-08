import strutils
import sequtils

proc parseInput(path: string): (seq[seq[string]], seq[seq[string]]) =
  var
    lines = readFile(path).strip().split("\n")
  result[0] = lines.mapIt(split(it, " | ")[0].splitWhiteSpace())
  result[1] = lines.mapIt(split(it, " | ")[1].splitWhiteSpace())

proc simpleDigits(input: seq[string]): seq[string] =
  result = input.filterIt(len(it) == 2 or len(it) == 3 or len(it) == 4 or len(it) == 7)

proc countDigits(input: seq[seq[string]]): int =
  result = input.mapIt(simpleDigits(it)).mapIt(len(it)).foldl(a+b)

proc containsAll(input, sub: string): bool =
  result = sub.toSeq.allIt(input.contains(it))

proc findDigit(input: seq[string], digit: int): string =
  case digit:
    of 0:
      result = input.filterIt(it.len() == 6 and containsAll(it, findDigit(input, 7)) and not containsAll(it, findDigit(input, 3)))[0]
    of 1:
      result = input.filterIt(it.len() == 2)[0]
    of 2:
      result = input.filterIt(it.len() == 5 and not containsAll(findDigit(input, 9), it))[0]
    of 3:
      result = input.filterIt(it.len() == 5 and containsAll(it, findDigit(input, 7)))[0]
    of 4:
      result = input.filterIt(it.len() == 4)[0]
    of 5:
      result = input.filterIt(it.len() == 5 and containsAll(findDigit(input, 9), it) and it != findDigit(input, 3))[0]
    of 6:
      result = input.filterIt(it.len() == 6 and not containsAll(it, findDigit(input, 7)))[0]
    of 7:
      result = input.filterIt(it.len() == 3)[0]
    of 8:
      result = input.filterIt(it.len() == 7)[0]
    of 9:
      result = input.filterIt(it.len() == 6 and containsAll(it,findDigit(input, 3)))[0]
    else:
      result = ""

proc findAllDigits(input: seq[string]): seq[string] =
  for i in countup(0,9):
    result.add(findDigit(input, i))

proc transformDigit(digit: string, input: seq[string]): int =
  var digits = findAllDigits(input)
  for i in countup(0,9):
    if len(digit) == len(digits[i]) and containsAll(digit, digits[i]):
      return i

proc transformOutput(input,output: seq[string]): int =
  result = output.mapIt(transformDigit(it,input)).foldl($a & $b, "").parseInt()

proc sumOutput(input, output: seq[seq[string]]): int =
  for i in countup(0, input.len() - 1 ):
    var tmp = transformOutput(input[i], output[i])
    # echo output[i], " ", tmp
    result += tmp

var
  (sampleIn, sampleOut) = parseInput("sample/day08.txt")
  (input, output) = parseInput("input/day08.txt")

assert countDigits(sampleOut) == 26
assert sumOutput(sampleIn,sampleOut) == 61229

echo "Part one: ", countDigits(output)
echo "Part two: ", sumOutput(input,output)
