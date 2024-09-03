import
  std/[macros]

{.push warning[deprecated]: off.}
export
  macros.body,
  macros.newIdentNode
{.pop.}

macro advice*(name, body: untyped): untyped =
  var preBlock, postBlock = quote:
    block:
      discard

  for node in body:
    if node.kind != nnkCall:
      error "Unsupported syntax", node

    let process = node[1]
    case node[0].strVal
    of "pre":
      preBlock = quote:
        block:
          `process`

    of "post":
      postBlock = quote:
        defer:
          `process`

    else:
      error "Unsupported syntax", node[0]

  result = quote("@") do:
    macro `@name`*(theProc: untyped): untyped =
      result = theProc.copy()
      result.body.insert 0, quote do: `@postBlock`
      result.body.insert 0, quote do: `@preBlock`

