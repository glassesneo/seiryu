# seiryu
seiryu is a nimble package for improving your Nim code with its sophisticated macros.

## What seiryu provides
### constructor
```nim
type
  Player = object
    name: string
    hp: int

func init(T: type Player; name: string): T {.construct.} =
  result.name = name
  result.hp = 50

# Every argument is assigned to each field.
func init(T: type Player; name: string, hp: int): T {.construct.}
```

```nim
import
  std/options

# arguments with `Option` become optional.
func initWithOptional(T: type Player; name: Option[string], hp: int): T {.construct.}
  result.name = name.get(otherwise = "player")
  result.hp = hp

let
  player1 = Player.initWithOptional(option("named player"), 50)
  player2 = Player.initWithOptional(hp = 50)
```

### Design by Contract
```nim
func fn(a, b: int): int =
  precondition:
    # `fn` must meet all the conditions
    a > 0
    a > b
    # you can use any statement
    var flag = true
    for i in 0..<100:
      if i == 100:
        flag = false
        break
    flag

  postcondition:
    result > 0

  return a + b

discard fn(5, 4)
```
Class invariant is not implemented for now.

### Aspect Oriented Programming
```nim
# create an advice
advice log:
  before:
    echo "start process"

  after:
    echo "finish process"

# attach `log` advice
proc f() {.log.} =
  echo "during process.."

f()

#[
output:
  start process
  during process..
  finish process
]#
```

## The principles of seiryu
Each macro in seiryu is implemented not to affect the others so you can attach multiple techniques to one procedure like this.
```nim
import
  std/options

advice log:
  after:
    echo "done!"

proc new*(T: type SomeObject; v1: string, v2: Option[int]): T {.construct, log.} =
  precondition:
    v1.len <= 10

  result.v1 = v1
  result.v2 = v2.get(otherwise = 50)
```
