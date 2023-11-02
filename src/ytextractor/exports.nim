import std/json
from std/times import DateTime, `$`
from std/strutils import parseEnum
when defined js:
  import std/asyncjs
else:
  import std/asyncdispatch

import ytextractor/[video, channel]

proc `%`[T: DateTime or YoutubeVideoId](v: T): JsonNode =
  % $v

{.push exportc.}

proc updateVideo*(self: var YoutubeVideo; proxy = "".cstring): bool {.async.} =
  await video.update(self, $proxy)
proc extractVideo*(url: cstring; proxy = "".cstring): YoutubeVideo {.async.} =
  await video.extractVideo($url, $proxy)
proc newYoutubeVideo*(id: YoutubeVideoId): YoutubeVideo =
  video.newYoutubeVideo id

proc updateChannel*(self: var YoutubeChannel; page: cstring; proxy = "".cstring): bool {.async.} =
  await channel.update(self, parseEnum[YoutubeChannelPage]($page), $proxy)
proc extractChannel*(url: cstring; page: cstring; proxy = "".cstring): YoutubeChannel {.async.} =
  await channel.extractChannel($url, parseEnum[YoutubeChannelPage]($page), $proxy)
proc newYoutubeChannel*(id: YoutubeChannelId): YoutubeChannel =
  channel.newYoutubeChannel id

proc videoJson*(self: YoutubeVideo): cstring =
  ## Parse the `YoutubeVideo` to JSON
  cstring($(%* self))
proc channelJson*(self: YoutubeChannel): cstring =
  ## Parse the `YoutubeChannel` to JSON
  cstring($(%* self))

# proc getJson*[T: YoutubeVideo or YoutubeChannel](self: T): cstring =
#   cstring($(%* self)) 

{.pop.}
