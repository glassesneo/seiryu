import std/unittest

import
  std/[options],
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

block:
  func init(T: type TestObject; v1: int; v2: Option[string]): T {.construct.} =
    result.v1 = v1
    result.v2 = v2.get(otherwise = "")

  let
    test1 = TestObject.init(1, option("nullable"))
    test2 = TestObject.init(1)

  check test1.v2 == "nullable"
  check test2.v2 == ""

