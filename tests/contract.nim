import
  ../src/seiryu/dbc

func f(a, b: int): int =
  precondition:
    a > 0
    a > b
    var flag = true
    for i in 0..<100:
      if i == 100:
        flag = false
        break
    flag

  postcondition:
    result > 0

  return a + b

discard f(5, 4)

