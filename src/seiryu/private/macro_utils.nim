import
  std/[macros]

func formatIdentDefs*(
    defList: NimNode | seq[NimNode]
): seq[NimNode] {.compileTime.} =
  result = @[]
  for identDefs in defList:
    for v in identDefs[0..^3]:
      result.add newIdentDefs(v, identDefs[^2], identDefs[^1])

