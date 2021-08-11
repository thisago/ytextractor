#[
  Created at: 08/09/2021 12:21:27 Monday
  Modified at: 08/10/2021 03:10:10 PM Tuesday
]#

##[
  base
  ----

  Base utilities, types and constants for lib
]##

from std/strutils import find, replace
from std/json import parseJson, JsonNode

proc parseYoutubeJson*(
  html: string
): tuple[ytInitialPlayerResponse: JsonNode, ytInitialData: JsonNode] =
  ## Parses the html to get `ytInitialPlayerResponse` and `ytInitialData`
  block ytInitialPlayerResponse:
    const
      startIndexFinder = "var ytInitialPlayerResponse = "
      endIndexFinder = "};"
    let
      startIndex = startIndexFinder.len + html.find startIndexFinder
      endIndex = startIndex + html[startIndex..^1].find endIndexFinder
    result.ytInitialPlayerResponse = html[startIndex..endIndex].parseJson
  block ytInitialData:
    const
      startIndexFinder = "var ytInitialData = "
      endIndexFinder = "};"
    let
      startIndex = startIndexFinder.len + html.find startIndexFinder
      endIndex = startIndex + html[startIndex..^1].find endIndexFinder
    result.ytInitialData = html[startIndex..endIndex].parseJson


const userAgent = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/87.0.4280.141 Safari/537.36"

when not defined js:
  from std/httpclient import newHttpClient, newHttpHeaders, get, code, Http200,
                             body, close, `==`
  proc fetch*(url: string): string =
    ## Fetches a page using `GET` method and returns the response body
    ## It also uses a browser user agent to not be blocked as bot
    var client = newHttpClient()
    client.headers = newHttpHeaders({
      "accept-language": "en-US,en;q=0.9",
      "user-agent": userAgent,
      "referer": "https://www.youtube.com/"
    })
    let res = client.get url
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
