import
  std/[macros],
  seiryu/private/macro_utils

func isTypeDesc(typeNode: NimNode): bool {.compileTime.} =
  return typeNode.kind == nnkCommand and typeNode[0].eqIdent"type" or
  typeNode.kind == nnkBracketExpr and typeNode[0].eqIdent"typedesc"

func isOption(typeNode: NimNode): bool {.compileTime.} =
  return typeNode.kind == nnkBracketExpr and typeNode[0].eqIdent"Option"

macro construct*(theProc: untyped): untyped =
  theProc.expectKind({nnkProcDef, nnkFuncDef})
  if not theProc.params[1][1].isTypeDesc:
    error "The first argument must be a type itself", theProc.params[1]

  let T = theProc.params[0]
  let identDefList = theProc.params[2..^1].formatIdentDefs()

  result = theProc.copy()
  result.params = nnkFormalParams.newTree(
    theProc.params[0],
    theProc.params[1]
  )

  for identDef in identDefList:
    let param = identDef.copy()
    if identDef[1].isOption and identDef[2].kind == nnkEmpty:
      let generic = identDef[1][1]
      param[2] = quote do: none(`generic`)
    result.params.add param

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

  if theProc.params[0].kind == nnkEmpty:
    error "The return value must not be empty", theProc.params[0]

  if theProc.body.kind != nnkEmpty:
    error "The body must be empty"

  result = theProc.copy()
  let
    valueName = theProc[0].basename
    objectName = theProc.params[1][0]

  result.body = quote do:
    return `objectName`.`valueName`

