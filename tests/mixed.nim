import pkg/[seiryu, seiryu/dbc, seiryu/aop]

type SomeObject = object
  v1: string
  v2: int

advice log:
  before:
    debugEcho "start!"

  after:
    debugEcho "finish!"

func init*(T: type SomeObject, v1: string, v2: int): T {.construct, log.} =
  precondition:
    v1.len <= 10

func v2*(some: SomeObject): lent int {.getter, log.}

let some = SomeObject.init("aaa", 5)

echo some
echo some.v2()
