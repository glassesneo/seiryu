import
  std/[macros, strformat]

const IgnoredNodeKinds = {
  nnkVarSection,
  nnkLetSection,
  nnkConstSection,
  nnkAsgn,
  nnkForStmt,
  nnkIfStmt
}

func assertionInfoFormat*(filename: string, line: int): string =
  return fmt"[{filename}:{line}]"

func createAssertionNode*(
    condition, assertOutput, info: NimNode,
    assertMsg: string
): NimNode {.compileTime.} =
  let assertMsgLit = assertMsg.newLit()

  return if assertOutput.kind == nnkEmpty:
    quote do:
      if not `condition`:
        let infoMsg = assertionInfoFormat(`info`.filename, `info`.line)
        raiseAssert(`assertMsgLit` & infoMsg & "\n")
  else:
    quote do:
      if not `condition`:
        let infoMsg = assertionInfoFormat(`info`.filename, `info`.line)
        raiseAssert(`assertMsgLit` & infoMsg & "\n" & `assertOutput` & "\n")

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

