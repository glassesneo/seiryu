import
  ../src/seiryu

type
  TestObject* = object
    v1: int
    v2: string

func v1*(testObj: TestObject): int {.getter.}

