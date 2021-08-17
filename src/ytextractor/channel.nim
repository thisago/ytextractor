#[
  Created at: 08/09/2021 12:10:05 Monday
  Modified at: 08/17/2021 02:38:44 PM Tuesday
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
from std/tables import Table, `[]`, `[]=`
from std/uri import parseUri, decodeUrl

export tables

import ytextractor/core/types; export types
import ytextractor/core/core



import json

type
  YoutubeChannel* = object of YoutubeChannelPreview
    ## Youtube channel object
    status*: ExtractStatus
    description*: string
    banners*: YoutubeChannelBanners
    familySafe*: bool
    tags*: seq[string]
    videos*: YoutubeChannelVideos
    links*: YoutubeChannelLinks
  YoutubeChannelLinks* = object
    primary*, secondary*: seq[string]
  YoutubeChannelBanners* = object
    ## Channel banners
    desktop*, mobile*, tv*: seq[UrlAndSize]
  YoutubeChannelPage* {.pure.} = enum
    ## The page that will be extracted
    ##
    ## Available: home
    home, videos, playlists, community, channels, about
  YoutubeChannelVideo* = object of YoutubeVideoPreview
    roundedPublishedDate*: string
  YoutubeChannelHighlightVideo* = object of YoutubeChannelVideo
    description*: string
  YoutubeChannelVideos* = object
    ## The extracted videos of channel
    all: seq[YoutubeChannelVideo]
    playlists: Table[string, seq[YoutubeChannelVideo]]
    homePlaylists: Table[string, seq[YoutubeChannelVideo]]
    highlighted: YoutubeChannelHighlightVideo

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
    jsonData = self.id.getUrl(page, proxy).fetch().parseYoutubeJson().ytInitialData
    contents = jsonData{"contents"}
    header = jsonData{"header", "c4TabbedHeaderRenderer"}
    metadata = jsonData{"metadata", "channelMetadataRenderer"}
    microformat = jsonData{"microformat", "microformatDataRenderer"}

  if contents.isNil:
    self.status.error = ExtractError.FetchError
    return false

  self.status.lastUpdate = now()

  proc parseViews(views: string): int =
    views.multiReplace({
      " views": "",
      ",": "",
    }).parseInt
  proc parseYtTrackingUrl(url: string): string =
    const toFind = "&q="
    let
      url = url.parseUri
      query = url.query.decodeUrl
      i = query.find(toFind)
    if i > 0:
      result = query[i + toFind.len..^1]

  template getName =
    self.name = header{"title"}.getStr
  template getIconsAndBanners =
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
  template getSubscribers =
    var subs = header{"subscriberCountText", "simpleText"}.getStr.parseSubs
    if subs.len == 0:
      self.hiddenSubscribers = true
    else:
      self.subscribers = subs.parseInt
  template getFamilySafe =
    self.familySafe = metadata{"isFamilySafe"}.getBool
  template getDescription =
    self.description = metadata{"description"}.getStr
  template getKeywords =
    if microformat.hasKey "tags":
      for tag in microformat{"tags"}:
        self.tags.add tag.getStr
  proc isPlaylist(jsonNode: JsonNode): bool =
    result = false
    try:
      if jsonNode{"content", "horizontalListRenderer", "items"}{0}{
                  "gridVideoRenderer", "videoId"}.getStr != "":
        return true
    except: discard
  template getHomePlaylists(startIndex: int) =

    let jsonObj = contents{"twoColumnBrowseResultsRenderer","tabs"}{0}{
                           "tabRenderer","content","sectionListRenderer",
                           "contents"}
    for i in startIndex..jsonObj.len:
      let playlistJson = jsonObj{i}{"itemSectionRenderer","contents"}{0}{"shelfRenderer"}

      if not playlistJson.isPlaylist:
        continue

      var playlist: seq[YoutubeChannelVideo]
      for video in playlistJson{"content", "horizontalListRenderer", "items"}:
        let video = video{"gridVideoRenderer"}
        var thumbs: seq[UrlAndSize]
        for thumb in video{"thumbnail", "thumbnails"}:
          thumbs.add UrlAndSize(
            url: thumb{"url"}.getStr,
            width: thumb{"width"}.getInt,
            height: thumb{"height"}.getInt,
          )
        playlist.add YoutubeChannelVideo(
          title: video{"title", "simpleText"}.getStr,
          roundedPublishedDate: video{"publishedTimeText", "simpleText"}.getStr,
          views: video{"viewCountText", "simpleText"}.getStr.parseViews,
          id: video{"videoId"}.getStr.YoutubeVideoId,
          thumbnails: thumbs
        )
      self.videos.playlists[playlistJson{"title", "runs"}{0}{"text"}.getStr] = playlist

    # self.videos.homePlaylists.add
  proc getHighlightVideo(self: var YoutubeChannel): bool =
    result = false
    let jsonObj = contents{"twoColumnBrowseResultsRenderer","tabs"}{0}{
                           "tabRenderer","content","sectionListRenderer",
                           "contents"}{0}{"itemSectionRenderer","contents"}{0}{
                           "channelVideoPlayerRenderer"}
    if jsonObj.hasKey "videoId":
      result = true
      self.videos.highlighted.id = jsonObj{"videoId"}.getStr.YoutubeVideoId
      self.videos.highlighted.title = jsonObj{"title", "runs"}{0}{"text"}.getStr
      self.videos.highlighted.views = jsonObj{"viewCountText", "simpleText"}.
                                        getStr.parseViews
      self.videos.highlighted.roundedPublishedDate =
        jsonObj{"publishedTimeText"}{"runs"}{0}{"text"}.getStr
      block description:
        for desc in jsonObj{"description", "runs"}:
          if desc.hasKey "navigationEndpoint":
            self.videos.highlighted.description.add desc{"navigationEndpoint",
                                                         "commandMetadata",
                                                         "webCommandMetadata",
                                                         "url"}.getstr.
                                                         parseYtTrackingUrl
          else:
            self.videos.highlighted.description.add desc{"text"}.getStr
  template getLinks =
    proc getLinks(res: var seq[string]; name: string) =
      for link in header{"headerLinks", "channelHeaderLinksRenderer", name}:
        res.add link{"navigationEndpoint", "commandMetadata",
                        "webCommandMetadata", "url"}.getStr.parseYtTrackingUrl
    self.links.primary.getLinks "primaryLinks"
    self.links.secondary.getLinks "secondaryLinks"

  try:
    case page:
    of home:
      getName
      getIconsAndBanners
      getSubscribers
      getFamilySafe
      getDescription
      getKeywords
      if self.getHighlightVideo:
        getHomePlaylists 1
      else:
        getHomePlaylists 0
      getLinks
    else:
      doAssert false, "Page not implemented."
  except:
    self.status.error = ExtractError.ParseError
    doAssert false, getCurrentExceptionMsg()
    return false

proc getUrl*(self: YoutubeChannelId; page: YoutubeChannelPage; proxy: string): string =
  fmt"{proxy}https://www.youtube.com/{self.kind}/{self.id}/{page}"

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
