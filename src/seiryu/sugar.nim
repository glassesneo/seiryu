{.experimental: "strictFuncs".}
{.experimental: "strictDefs".}
{.experimental: "views".}
{.experimental: "caseStmtMacros".}
{.push raises: [].}
import std/macros

macro with*(head, body: untyped): untyped =
  if head.kind == nnkInfix:
    if not head[0].eqIdent"as":
      error "Unsupported syntax", head

    let
      instance = head[1]
      variable = head[2]
    result = quote:
      block:
        defer:
          `instance`.exit()
        let `variable` = `instance`.enter()
        `body`
  else:
    let instance = head
    return quote:
      block:
        let instance = `instance`
        defer:
          instance.exit()
        discard instance.enter()
        `body`

func enter*(f: File): File =
  return f

proc exit*(f: File) =
  f.close()

type Comparable* =
  concept a, b
      `==`(a, b) is bool
      `<`(a, b) is bool

func `<=>`*(a, b: Comparable): range[-1 .. 1] =
  return
    if a == b:
      0
    elif a < b:
      -1
    else:
      1
