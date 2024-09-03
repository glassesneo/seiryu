import
  ../src/seiryu/aop

advice log:
  pre:
    echo "pre!"

  post:
    echo "post!"

proc f(a, b: int): int {.log.} =
  return a + b

discard f(5, 4)

