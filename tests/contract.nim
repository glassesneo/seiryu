import
  ../src/seiryu/dbc

func f(a, b: int): int =
  precondition:
    output "a is a negative number!"
    a > 0
    a > b
    var flag = true
    for i in 0..<100:
      if i == 100:
        flag = false
        break
    flag

  postcondition:
    output "result is a negative number!"
    result > 0

  return a + b

discard f(5, 4)

