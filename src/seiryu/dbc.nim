{.push raises: [].}
import
  std/[macros]

const IgnoredNodeKinds = {
  nnkVarSection,
  nnkLetSection,
  nnkConstSection,
  nnkAsgn,
  nnkForStmt,
  nnkIfStmt
}

func createAssertionNode*(
    condition, assertOutput, info: NimNode,
    assertMsg: string
): NimNode {.compileTime.} =
  let assertMsgLit = assertMsg.newLit()

  let assertNode = if assertOutput.kind == nnkEmpty:
    quote do:
      raiseAssert(
        `assertMsgLit` &
        "[" & `info`.filename & ":" & $`info`.line & "]" & "\n"
      )
  else:
    quote do:
      raiseAssert(
        `assertMsgLit` &
        "[" & `info`.filename & ":" & $`info`.line & "]" & "\n" &
        `assertOutput` & "\n"
      )

  return quote do:
    if not `condition`:
      `assertNode`

macro precondition*(stmtList: untyped): untyped =
  let
    conditionList = newStmtList()
    info = ident"info"

  var condition = newStmtList()
  var assertOutput = newEmptyNode()
  for stmt in stmtList:
    if stmt.len != 0 and stmt[0].eqIdent"output":
      assertOutput = stmt[1]
    else:
      condition.add stmt
      if stmt.kind notin IgnoredNodeKinds:
        conditionList.add createAssertionNode(
          condition, assertOutput, info,
          "Precondition failed at "
        )
        condition = newStmtList()
        assertOutput = newEmptyNode()

  result = quote do:
    when compileOption "assertions":
      let `info` = instantiationInfo()
      `conditionList`

macro postcondition*(stmtList: untyped): untyped =
  let
    conditionList = newStmtList()
    info = ident"info"

  var condition = newStmtList()
  var assertOutput = newEmptyNode()
  for stmt in stmtList:
    if stmt.len != 0 and stmt[0].eqIdent"output":
      assertOutput = stmt[1]
    else:
      condition.add stmt
      if stmt.kind notin IgnoredNodeKinds:
        conditionList.add createAssertionNode(
          condition, assertOutput, info,
          "Postcondition failed at "
        )
        condition = newStmtList()
        assertOutput = newEmptyNode()

  result = quote do:
    when compileOption "assertions":
      defer:
        let `info` = instantiationInfo()
        `conditionList`

