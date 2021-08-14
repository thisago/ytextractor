#[
  Created at: 08/09/2021 12:10:05 Monday
  Modified at: 08/14/2021 11:25:06 PM Saturday
]#

##[
  video
  -----

  Parser for "https://www.youtube.com/channel/CHANNELID"
]##

{.experimental: "codeReordering".}

from std/times import DateTime, Duration, initDuration, now
from std/json import JsonNode, items, hasKey, `{}`, getStr, getInt, getBool
from std/strformat import fmt
from std/strutils import parseInt, multiReplace, find, strip, contains, parseEnum
from std/uri import parseUri

import json

import ytextractor/core/core

type
  YoutubeChannel* = object of YoutubeChannelPreview
    ## Youtube channel object
    status*: ExtractStatus
    description*: string
    banners*: YoutubeChannelBanners
    familySafe*: bool
    tags*: seq[string]
    videos*: YoutubeChannelVideos

  YoutubeChannelBanners* = object
    ## Channel banners
    desktop*, mobile*, tv*: seq[UrlAndSize]
  YoutubeChannelPage* {.pure.} = enum
    ## The page that will be extracted
    ##
    ## Available: home
    home, videos, playlists, community, channels, about
  YoutubeChannelVideos* = object
    ## The extracted videos of channel
    all: seq[YoutubeVideoPreview]

proc initYoutubeChannel*(id: YoutubeChannelId): YoutubeChannel =
  ## Initialize a new `YoutubeChannel` instance
  YoutubeChannel(id: id)

proc update*(self: var YoutubeChannel; page: YoutubeChannelPage; proxy = ""): bool =
  ## Update all `YoutubeChannel` data
  ## Returns `false` on error.
  ##
  ##
  ## =================    =========  ===========  ==============  ==============  =============  ==========
  ## Property             Home Page  Videos Page  Playlists Page  Community Page  Channels Page  About Page
  ## =================    =========  ===========  ==============  ==============  =============  ==========
  ## name                 yes         no          no              no              no             no
  ## description          yes         no          no              no              no             no
  ## icons                yes         no          no              no              no             no
  ## banners              yes         no          no              no              no             no
  ## subscribers          yes         no          no              no              no             no
  ## hiddenSubscribers    yes         no          no              no              no             no
  ## familySafe           yes         no          no              no              no             no
  ## tags                 yes         no          no              no              no             no
  ## =================    =========  ===========  ==============  ==============  =============  ==========
  ##
  ## .. code-block:: nim
  ##   var channel = initYoutubeChannel("UC3aGq0eFrvrjM4F1dLUo87A".channelId)
  ##   if not channel.update():
  ##     echo "Error to update: " & $channel.status.error
  ##   echo channel
  result = true

  if not self.id.valid:
    self.status.error = ExtractError.InvalidId
    return false

  let
    jsonData = self.id.getUrl(proxy).fetch().parseYoutubeJson().ytInitialData
    contents = jsonData{"contents"}
    header = jsonData{"header", "c4TabbedHeaderRenderer"}
    metadata = jsonData{"metadata", "channelMetadataRenderer"}
    microformat = jsonData{"microformat", "microformatDataRenderer"}

  if contents.isNil:
    self.status.error = ExtractError.NotExist
    return false

  self.status.lastUpdate = now()

  try:
    self.name = header{"title"}.getStr

    block iconsAndBanner:
      proc getImages(res: var seq[UrlAndSize]; nodeObj: JsonNode; nodeName: string) =
        for node in nodeObj{nodeName, "thumbnails"}:
          res.add UrlAndSize(
            url: node{"url"}.getStr,
            width: node{"width"}.getInt,
            height: node{"height"}.getInt
          )
      self.icons.getImages(header, "avatar")
      self.icons.getImages(metadata, "avatar")
      self.banners.desktop.getImages(header, "banner")
      self.banners.mobile.getImages(header, "mobileBanner")
      self.banners.tv.getImages(header, "tvBanner")

    block subscribers:
      var subs = header{"subscriberCountText", "simpleText"}.getStr.parseSubs
      if subs.len == 0:
        self.hiddenSubscribers = true
      else:
        self.subscribers = subs.parseInt

    self.familySafe = metadata{"isFamilySafe"}.getBool
    self.description = metadata{"description"}.getStr

    block keywords:
      if microformat.hasKey "tags":
        for tag in microformat{"tags"}:
          self.tags.add tag.getStr

  except:
    self.status.error = ExtractError.ParseError
    # doAssert false, getCurrentExceptionMsg()
    return false

proc getUrl*(self: YoutubeChannelId; proxy: string): string =
  result = fmt"https://www.youtube.com/{self.kind}/{self.id}"
  result = proxy & result

proc channelId*(url: string): YoutubeChannelId =
  ## Parses the video ID from url
  ## If gave a code instead url, it will return itself
  ##
  ## Reference: https://stackoverflow.com/a/65726047
  runnableExamples:
    doAssert "https://www.youtube.com/channel/UCARj2eHnsYMuCZDmYZ5q4_g".channelId.id == "UCARj2eHnsYMuCZDmYZ5q4_g"
    doAssert "https://www.youtube.com/channel/UCUZHFZ9jIKrLroW8LcyJEQQ".channelId.id == "UCUZHFZ9jIKrLroW8LcyJEQQ"
    doAssert "https://www.youtube.com/c/YouTubeCreators".channelId.id == "YouTubeCreators"
    doAssert "https://www.youtube.com/YouTubeCreators".channelId.id == "YouTubeCreators"
    doAssert "https://www.youtube.com/user/partnersupport".channelId.id == "partnersupport"
    doAssert "https://www.youtube.com/partnersupport".channelId.id == "partnersupport"
    doAssert "http://www.youtube.com/partnersupport".channelId.id == "partnersupport"
    doAssert "https://youtube.com/partnersupport".channelId.id == "partnersupport"
    doAssert "http://youtube.com/partnersupport".channelId.id == "partnersupport"
  var
    id = ""
    uri = url.parseUri
  if uri.scheme == "" and uri.hostname == "":
    result.id = url
  else:
    result.id = uri.path[1..^1]
    result.kind = YoutubeChannelIdKind.root
    for route in ["user", "c", "channel"]:
      let path = fmt"{route}/"
      var i = result.id.find path
      if i > -1:
        i += path.len
        let s = result.id[i..^1]
        var endI = s.find '/'
        if endI == -1:
          endI = s.len
        result.kind = parseEnum[YoutubeChannelIdKind](route)
        result.id = s[0..<endI]

proc valid*(self: YoutubeChannelId): bool =
  ## Checks if this `YoutubeChannelId` instance is a valid youtube id
  ##
  ## Currently is just checking the length, but later will be added more checks
  runnableExamples:
    import ytextractor/core/types
    doAssert "https://www.youtube.com/channel/UC3aGq0eFrvrjM4F1dLUo87A".channelId.valid == true
    doAssert "https://domain-doesn't-matters/channel/UC3aGq0eFrvrjM4F1dLUo87A".channelId.valid == true
    doAssert "https://www.youtube.com/channel/UCARj2eHnsYMuCZDmYZ5q4_g".channelId.valid == true
    doAssert "https://www.youtube.com/channel/UCUZHFZ9jIKrLroW8LcyJEQQ".channelId.valid == true
    doAssert "https://www.youtube.com/c/YouTubeCreators".channelId.valid == true
    doAssert "https://www.youtube.com/YouTubeCreators".channelId.valid == true
    doAssert "https://www.youtube.com/user/partnersupport".channelId.valid == true
    doAssert "https://www.youtube.com/partnersupport".channelId.valid == true
    doAssert "http://www.youtube.com/partnersupport".channelId.valid == true
    doAssert "https://youtube.com/partnersupport".channelId.valid == true
    doAssert "http://youtube.com/partnersupport".channelId.valid == true
    doAssert YoutubeChannelId(id: "invalid").valid == false
    # The below will not be valid because the kind cannot be inferred
    doAssert YoutubeChannelId(id: "Dx4eelwPGaQ").valid == false
  result = true
  if self.id.len != self.id.strip.len:
    return false
  if self.kind == YoutubeChannelIdKind.invalid:
    return false


proc extractChannel*(url: string; proxy = ""): YoutubeChannel =
  ## Extract all data from youtube video.
  ##
  ## `url` can be the video URL or id
  ##
  ## Just an alias of:
  ##
  ## .. code-block:: nim
  ##   var vid = initYoutubeChannel("https://www.youtube.com/channel/UC3aGq0eFrvrjM4F1dLUo87A".channelId)
  ##   discard vid.update():
  ## **Example:**
  ##
  ## .. code-block:: nim
  ##   var vid = extractChannel("https://www.youtube.com/channel/UC3aGq0eFrvrjM4F1dLUo87A")
  ##   echo vid
  result = initYoutubeChannel(url.channelId)
  discard result.update(YoutubeChannelPage.home, proxy = proxy)
