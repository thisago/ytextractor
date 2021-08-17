#[
  Created at: 08/09/2021 14:31:52 Monday
  Modified at: 08/17/2021 12:32:54 PM Tuesday
]#

import std/json
from times import DateTime, `$`
import ytextractor/[video, channel]

proc `%`*[T: DateTime or YoutubeVideoId](v: T): JsonNode =
  % $v

{.push exportc.}

proc update*(self: var YoutubeVideo; proxy = "".cstring): bool =
  video.update(self, $proxy)
proc extractVideo*(url: cstring; proxy = "".cstring): YoutubeVideo =
  video.extractVideo($url, $proxy)
proc initYoutubeVideo*(id: YoutubeVideoId): YoutubeVideo =
  video.initYoutubeVideo id

proc videoJson*(self: YoutubeVideo): cstring =
  ## Parse the `YoutubeVideo` to JSON
  cstring($(%* self))
proc channelJson*(self: YoutubeChannel): cstring =
  ## Parse the `YoutubeChannel` to JSON
  cstring($(%* self))

# proc getJson*[T: YoutubeVideo or YoutubeChannel](self: T): cstring =
#   cstring($(%* self))

{.pop.}
