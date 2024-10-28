import std/unittest
import ../src/seiryu/sugar

check (5 <=> 5) == 0
check (5 <=> 3) == 1
check (5 <=> 8) == -1

type Human = object
  height: int
  age: int
