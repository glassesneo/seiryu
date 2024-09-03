import
  ../src/seiryu/aop

advice log:
  before:
    echo "start"

  after:
    echo "finish"

proc f(a, b: int): int {.log.} =
  return a + b

discard f(5, 4)

