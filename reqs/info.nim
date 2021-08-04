#[
  Created at: 08/03/2021 18:11:00 Tuesday
  Modified at: 08/03/2021 08:48:09 PM Tuesday
]#

##[
  info
  ----

  Run with `nim r ./reqs/info.nim`
]##

{.experimental: "codeReordering".}

import std/[httpclient]
from std/strutils import find
from std/strformat import fmt
from std/json import parseJson, JsonNode, `{}`, `$`


when isMainModule:
  main("jjEQ-yKVPMg")

proc main(videoId: string) =
  proc getVideoData(html: string): JsonNode =
    const
      startIndexFinder = "var ytInitialPlayerResponse = "
      endIndexFinder = "};"
    let
      startIndex = startIndexFinder.len + html.find startIndexFinder
      endIndex = startIndex + html[startIndex..^1].find endIndexFinder
    return html[startIndex..endIndex].parseJson

  var client = newHttpClient()
  let res = client.get(fmt"https://www.youtube.com/watch?v={videoId}")
  if res.code == Http200:
    let
      html = res.body
      videoData = html.getVideoData()

    echo videoData{"microformat", "playerMicroformatRenderer", "description", "simpleText"}
