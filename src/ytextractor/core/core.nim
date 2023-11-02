## Core functions and constants for lib
when defined js: import std/asyncjs
else: import std/asyncdispatch

from std/strutils import find, replace, multiReplace, join, split
from std/json import parseJson, JsonNode, newJObject, items, hasKey, `{}`, getStr, keys
from std/tables import `[]`

from pkg/util/forStr import between
import pkg/unifetch

import ytextractor/core/cookies
import ytextractor/core/types; export types

proc parseYoutubeJson*(
  html: string
): tuple[ytInitialPlayerResponse: JsonNode, ytInitialData: JsonNode] =
  ## Parses the html to get `ytInitialPlayerResponse` and `ytInitialData`
  try:
    result.ytInitialData = parseJson html.
      between("var ytInitialData = ", "};") & "}"
    result.ytInitialPlayerResponse = parseJson html.
      between("var ytInitialPlayerResponse = ", "};") & "}"
  except: discard

const userAgent = "Mozilla/5.0 (Windows NT 10.0; rv:109.0) Gecko/20100101 Firefox/115.0"

proc fetch*(url: string): Future[string] {.async.} =
  ## Fetches a page using `GET` method and returns the response body
  ## It also uses a browser user agent to not be blocked as bot
  var
    cookies = getCookies()
    client = newUniClient()
  client.headers = newHttpHeaders({
    "accept-language": "en-US,en;q=0.9",
    "user-agent": userAgent,
    "referer": url,
    "dpr": "1",
    "dnt": "1",
    "cookie": $cookies,
  })
  let res = await client.get url
  block cookieExtract:
    if res.headers.hasKey "set-cookie":
      for setCookie in res.headers.table["set-cookie"]:
        let cookie = setCookie[0..setCookie.find(';') - 1].split '='
        cookies[cookie[0]] = cookie[1]
      save cookies
  if res.code == Http200:
    result = res.body
  close client

func findInJson*(nodes: JsonNode; key: string): JsonNode =
  ## Gets an json array and returns a object
  ## If not found, returns a empty one
  result = newJObject()
  for node in nodes:
    if node.hasKey key:
      return node{key}

func parseSubs*(str: string): string =
  str.multiReplace({
    "K": "000",
    "M": "000000",
    " million": "000000",
    "B": "000000000",
    " subscribers": "",
    ".": ""
  })
