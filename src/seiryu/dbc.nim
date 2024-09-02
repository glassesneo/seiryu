import
  std/[macros, strformat]

const IgnoredNodeKinds = {nnkVarSection, nnkAsgn, nnkForStmt, nnkIfStmt}

func assertionInfoFormat*(filename: string, line: int): string =
  return fmt"[{filename}:{line}]"

func createAssertionNode*(
    condition, process, info: NimNode,
    assertMsg: string
): NimNode {.compileTime.} =
  let ast = condition.toStrLit()
  let assertMsgLit = assertMsg.newLit()

  return if process == (quote do: nil):
    quote do:
      if not `condition`:
        let infoMsg = assertionInfoFormat(`info`.filename, `info`.line)
        raiseAssert(`assertMsgLit` & infoMsg & `ast` & "\n")
  else:
    quote do:
      if not `condition`:
        `process`
        let infoMsg = assertionInfoFormat(`info`.filename, `info`.line)
        raiseAssert(`assertMsgLit` & infoMsg & `ast` & "\n")

macro precondition*(stmtList: untyped, process: untyped = nil): untyped =
  let
    conditionList = newStmtList()
    info = ident"info"

  var condition = newStmtList()
  for stmt in stmtList:
    condition.add stmt
    if stmt.kind notin IgnoredNodeKinds:
      conditionList.add createAssertionNode(
        condition, process, info,
        "Precondition failed at "
      )
      condition = newStmtList()

  result = quote do:
    when compileOption "assertions":
      let `info` = instantiationInfo()
      `conditionList`

macro postcondition*(stmtList: untyped, process: untyped = nil): untyped =
  let
    conditionList = newStmtList()
    info = ident"info"

  var condition = newStmtList()
  for stmt in stmtList:
    condition.add stmt
    if stmt.kind notin IgnoredNodeKinds:
      conditionList.add createAssertionNode(
        condition, process, info,
        "Postcondition failed at "
      )
      condition = newStmtList()

  result = quote do:
    when compileOption "assertions":
      defer:
        let `info` = instantiationInfo()
        `conditionList`

