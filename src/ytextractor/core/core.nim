## Core functions and constants for lib

from std/strutils import find, replace, multiReplace, join, split
from std/json import parseJson, JsonNode, newJObject, items, hasKey, `{}`, getStr, keys

import ytextractor/core/cookies
import ytextractor/core/types; export types

proc parseYoutubeJson*(
  html: string
): tuple[ytInitialPlayerResponse: JsonNode, ytInitialData: JsonNode] =
  ## Parses the html to get `ytInitialPlayerResponse` and `ytInitialData`
  try:
  # echo html
  # block:
    block ytInitialData:
      const
        startIndexFinder = "var ytInitialData = "
        endIndexFinder = "};"
      let
        startIndex = startIndexFinder.len + html.find startIndexFinder
        endIndex = startIndex + html[startIndex..^1].find endIndexFinder
      result.ytInitialData = html[startIndex..endIndex].parseJson
    block ytInitialPlayerResponse:
      const
        startIndexFinder = "var ytInitialPlayerResponse = "
        endIndexFinder = "};"
      let
        startIndex = startIndexFinder.len + html.find startIndexFinder
        endIndex = startIndex + html[startIndex..^1].find endIndexFinder
      result.ytInitialPlayerResponse = html[startIndex..endIndex].parseJson
  except: discard

const userAgent = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/87.0.4280.141 Safari/537.36"

when not defined js:
  from std/httpclient import newHttpClient, newHttpHeaders, get, code, Http200,
                             body, close, `==`
  import std/httpclient except `[]`
  from std/tables import `[]`

  proc fetch*(url: string): string =
    ## Fetches a page using `GET` method and returns the response body
    ## It also uses a browser user agent to not be blocked as bot
    var
      cookies = getCookies()
      client = newHttpClient()
    client.headers = newHttpHeaders({
      "accept-language": "en-US,en;q=0.9",
      "user-agent": userAgent,
      "referer": url,
      "dpr": "1",
      "dnt": "1",
      "cookie": $cookies,
    })
    let res = client.get url
    block cookieExtract:
      if res.headers.hasKey "set-cookie":
        for setCookie in res.headers.table["set-cookie"]:
          let cookie = setCookie[0..setCookie.find(';') - 1].split '='
          cookies[cookie[0]] = cookie[1]
        cookies.save()
    if res.code == Http200:
      result = res.body
    client.close()
else:
  when defined nodejs:
    # TODO nodejs implementation
    discard
  else:
    from pkg/ajax import newXmlHttpRequest, setRequestHeader, open, send
    proc fetch*(url: string): string =
      ## Fetches a page using `GET` method and returns the response body
      ## It also uses a browser user agent to not be blocked as bot
      ## JS backend
      var req = newXmlHttpRequest()
      req.open("GET", url, async = false)
      req.setRequestHeader("accept-language", "en-US,en;q=0.9")
      # req.setRequestHeader("user-agent", userAgent) # Refused to set unsafe header
      req.send()
      if req.status == 200:
        result = $req.responseText

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
