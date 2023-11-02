when defined js: import std/asyncjs
else: import std/asyncdispatch
from std/times import DateTime, Duration, initDuration, now
from std/tables import Table
from std/json import parseJson, items, getStr, getInt, `{}`, JsonNode

import ytextractor/core/core
from ytextractor/core/types import ExtractError
from ytextractor/video import YoutubeVideo

type
  YoutubeCaptions* = ref object
    status*: ExtractStatus
    error*: ExtractError
    texts*: YoutubeCaptionTexts
  YoutubeCaptionTexts* = seq[YoutubeCaptionText]
  YoutubeCaptionText* = tuple
    startMs, ms: int64
    word: string
  YoutubeCaptionTextSeconds* = seq[YoutubeCaptionTextSecond]
  YoutubeCaptionTextSecond* = ref object
    second*: int
    text*: string

proc newYoutubeCaptions*: YoutubeCaptions =
  ## Initialize a new `YoutubeCaptions` table
  new result


proc update*(self: YoutubeCaptions; jsonData: JsonNode): Future[bool] {.async.} =
  ## Returns `false` on error.
  ##
  runnableExamples:
    from std/json import parseJson
    var cc = new YoutubeCaptions
    cc.update parseJson "{\"events\":[]}" # JSON returned from Youtube captions
    echo cc
  result = true
  self.status.lastUpdate = now()
  try:
    var currMs = 0'i64
    for part in jsonData{"events"}:
      if not part{"segs"}.isNil:
        let startMs = int64 part{"tStartMs"}.getInt
        currMs = startMs
        for seg in part{"segs"}:
          let 
            tOffsetMs = seg{"tOffsetMs"}.getInt
            word = seg{"utf8"}.getStr
          self.texts.add YoutubeCaptionText (
            startMs,
            currMs,
            word
          )
          currMs += tOffsetMs
    self.status.error = ExtractError.None
  except:
    self.status.error = ExtractError.ParseError
    echo "Error: " & getCurrentExceptionMsg()
    return false

proc update*(self: YoutubeCaptions; url: string; proxy = ""): Future[bool] {.async.} =
  ## Returns `false` on error.
  runnableExamples:
    from pkg/ytextractor/video import extractVideo, update
    var vid = extractVideo "Dx4eelwPGaQ"
    if not update vid:
      echo "Error to update: " & $vid.status.error
    var cc = new YoutubeCaptions
    cc.update vid.captions[0].url
    echo cc[]
  let jsonData = parseJson await fetch(proxy & url)
  if jsonData.isNil:
    self.status.error = ExtractError.FetchError
    return false
  result = await self.update jsonData


proc extractCaptions*(url: string; proxy = ""): Future[YoutubeCaptions] {.async.} =
  ## Extract all data from youtube video.
  ##
  ## `url` can be the video URL or id
  ##
  ## Just an alias for:
  ##
  ## .. code-block:: nim
  ##   var vid = newYoutubeCaptions("jjEQ-yKVPMg".videoId)
  ##   await vid.update():
  ## **Example:**
  ##
  ## .. code-block:: nim
  ##   var vid = await extractVideo("jjEQ-yKVPMg")
  ##   echo vid
  new result
  await result.update(url, proxy)

proc captionsBySeconds*(texts: YoutubeCaptionTexts; newLines = false): YoutubeCaptionTextSeconds =
  ## Organize the captions to match with seconds
  var
    lastSec = 0'i64
    words = ""
  template addWords =
    if not newLines and words != "\n":
      if words.len > 0:
        result.add YoutubeCaptionTextSecond(
          second: int (lastSec div 1000'i64),
          text: words
        )
  for text in texts:
    if lastSec != text.startMs:
      addWords()
      lastSec = text.startMs
      words = ""
    words.add text.word
  addWords()

when isMainModule:
  import ./video
  import json
  var vid = extractVideo "7on15IWC2u4"
  if not vid.update():
    echo "Error to update: " & $vid.status.error
  echo vid.captions
  var captions = new YoutubeCaptions
  if not captions.update vid.captions[0].url:
    echo "error"
  echo captions.texts.captionsBySeconds
