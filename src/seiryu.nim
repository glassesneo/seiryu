import
  std/[macros],
  seiryu/private/macro_utils

macro construct*(theProc: untyped): untyped =
  theProc.expectKind({nnkProcDef, nnkFuncDef})

  let T = theProc.params[0]
  result = copy theProc

  if theProc.body.kind == nnkEmpty:
    result.body = newStmtList()
    let identDefList = theProc.params[2..^1].formatIdentDefs()
    for identDef in identDefList:
      let variable = identDef[0]
      result.body.add quote do:
        result.`variable` = `variable`

  result.body.insert 0, quote do:
    result = `T`()

