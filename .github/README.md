# seiryu
seiryu is a nimble package for improving your Nim code with its sophisticated macros.

## Installation
```sh
nimble install seiryu
```

## What seiryu provides
### constructor
```nim
import
  pkg/seiryu

type
  Player = object
    name: string
    hp: int

func init(T: type Player; name: string): T {.construct.} =
  result.name = name
  result.hp = 50

# Every argument is assigned to each field.
func init(T: type Player; name: string = "player", hp: int): T {.construct.}

let
  player1 = Player.init("player")
  player2 = Player.init(hp = 50)
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

### getter
```nim
proc name*(player: Player): string {.getter.}
```

### Design by Contract
```nim
import
  pkg/seiryu/dbc

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
import
  pkg/seiryu/aop

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
Each macro in seiryu is implemented not to affect the others so you can attach multiple techniques to one procedure like this:
```nim
import
  std/options,
  pkg/[seiryu, seiryu/dbc, seiryu/aop]

advice log:
  before:
    echo "start!"

  after:
    echo "finish!"

proc new*(T: type SomeObject; v1: string, v2: Option[int]): T {.construct, log.} =
  precondition:
    v1.len <= 10

  result.v1 = v1
  result.v2 = v2.get(otherwise = 50)
```

## License
ecslib is licensed under the MIT license. See COPYING for details.

