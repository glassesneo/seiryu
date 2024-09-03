import
  std/[macros],
  seiryu/private/macro_utils

func isOption(typeNode: NimNode): bool {.compileTime.} =
  return typeNode.kind == nnkBracketExpr and typeNode[0].eqIdent"Option"

macro construct*(theProc: untyped): untyped =
  theProc.expectKind({nnkProcDef, nnkFuncDef})

  let T = theProc.params[0]
  result = theProc.copy()

  let identDefList = theProc.params[2..^1].formatIdentDefs()

  for i, identDef in identDefList:
    result.params[i+2] = identDef.copy()
    if identDef[1].isOption and identDef[2].kind == nnkEmpty:
      let generic = identDef[1][1]
      result.params[i+2][2] = quote do: none(`generic`)

  if theProc.body.kind == nnkEmpty:
    result.body = newStmtList()
    for identDef in identDefList:
      let variable = identDef[0]
      result.body.add quote do:
        result.`variable` = `variable`

  result.body.insert 0, quote do:
    result = `T`()

macro getter*(theProc: untyped): untyped =
  theProc.expectKind({nnkProcDef, nnkFuncDef})

  if theProc.body.kind != nnkEmpty:
    error "The body must be empty"

  result = theProc.copy()
  let
    valueName = theProc[0].basename
    objectName = theProc.params[1][0]

  result.body = quote do:
    return `objectName`.`valueName`

