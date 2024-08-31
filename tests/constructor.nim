import
  ../src/seiryu

type
  TestObject = object
    v1: int
    v2: string

  TestObjectRef = ref TestObject

block:
  func init(T: type TestObject; v1: int; v2: string): T {.construct.} =
    result.v1 = v1
    result.v2 = v2

  let _ = TestObject.init(1, "")

  func new(T: type TestObjectRef; v1: int; v2: string): T {.construct.} =
    result.v1 = v1
    result.v2 = v2

  let _ = TestObjectRef.new(1, "")

block:
  func init(T: type TestObject; v1: int; v2: string): T {.construct.}

  let _ = TestObject.init(1, "")

