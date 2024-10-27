import ../src/seiryu/sugar

type ContextManager* = object
  value: string

func enter*(cm: ContextManager): ContextManager =
  debugEcho "enter called"
  return cm

func exit*(cm: ContextManager) =
  debugEcho "exit called"

with ContextManager(value: "aaa") as cm:
  echo cm.value
