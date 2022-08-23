##[
  TODO: Transform this as a module
]##

from std/json import `{}`, getStr, parseJson, keys, `$`, `%*`, `[]=`
from std/os import getTempDir, `/`
from std/strutils import split, strip
from std/strformat import fmt
import tables

export tables

type
  Cookies* = Table[string, string]

const cookieCachePath* {.strdefine.} = getTempDir() / "ytextractor_cookies.json"

proc getCookies*: Cookies =
  try:
    var cookies = readFile(cookieCachePath).parseJson
    for key in cookies.keys:
      result[key] = cookies{key}.getStr
  except: discard

func `$`*(cookies: Cookies): string =
  for key in cookies.keys:
    result.add fmt"{key}={cookies[key]}; "
  if result.len > 0:
    result = result[0..^3]

proc save*(self: Cookies) =
  try:
    writeFile cookieCachePath, $ %*self
  except:
    echo "Error when saving cookies"

when isMainModule:
  var cookies = getCookies()
  echo cookies

  cookies["test"] = "value"

  echo cookies
  cookies.save()
