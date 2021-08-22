#[
  Created at: 08/09/2021 14:31:52 Monday
  Modified at: 08/20/2021 01:01:16 PM Friday
]#

import std/json
from std/times import DateTime, `$`
from std/strutils import parseEnum
import ytextractor/[video, channel]

proc `%`*[T: DateTime or YoutubeVideoId](v: T): JsonNode =
  % $v

{.push exportc.}

proc updateVideo*(self: var YoutubeVideo; proxy = "".cstring): bool =
  video.update(self, $proxy)
proc extractVideo*(url: cstring; proxy = "".cstring): YoutubeVideo =
  video.extractVideo($url, $proxy)
proc initYoutubeVideo*(id: YoutubeVideoId): YoutubeVideo =
  video.initYoutubeVideo id

proc updateChannel*(self: var YoutubeChannel; page: cstring; proxy = "".cstring): bool =
  channel.update(self, parseEnum[YoutubeChannelPage]($page), $proxy)
proc extractChannel*(url: cstring; page: cstring; proxy = "".cstring): YoutubeChannel =
  channel.extractChannel($url, parseEnum[YoutubeChannelPage]($page), $proxy)
proc initYoutubeChannel*(id: YoutubeChannelId): YoutubeChannel =
  channel.initYoutubeChannel id

proc videoJson*(self: YoutubeVideo): cstring =
  ## Parse the `YoutubeVideo` to JSON
  cstring($(%* self))
proc channelJson*(self: YoutubeChannel): cstring =
  ## Parse the `YoutubeChannel` to JSON
  cstring($(%* self))

# proc getJson*[T: YoutubeVideo or YoutubeChannel](self: T): cstring =
#   cstring($(%* self))

{.pop.}
