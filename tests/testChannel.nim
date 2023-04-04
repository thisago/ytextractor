#[
  Created at: 08/15/2021 19:03:47 Sunday
  Modified at: 08/18/2021 06:54:07 PM Wednesday
]#

##[
  Tests for channel extractor
]##

import unittest
from std/times import initDuration, `$`
from std/strutils import contains

import ytextractor

suite "Youtube channel":
  var channelData = initYoutubeChannel("https://www.youtube.com/c/taofledermaus".channelId)

  test "Channel Id": check "taofledermaus" == $channelData.id.id
  test "Get data":
    check channelData.update(home)
    check channelData.status.error == ExtractError.None
  test "Channel name": check channelData.name == "TAOFLEDERMAUS"
  test "Description": check "TAOFLEDERMAUS" in channelData.description
  test "Thumbnails": check channelData.icons.len > 1
  test "Banners":
    check channelData.banners.desktop.len > 1
    check channelData.banners.mobile.len > 1
    check channelData.banners.tv.len > 1
  test "Family safe": check channelData.familySafe == true
  test "Tags":
    check "slomo" in channelData.tags
  test "Links":
    check channelData.links.primary[0] == "http://patreon.com/user?u=3751733"
    check channelData.links.secondary[0] == "https://www.facebook.com/taofledermaus"
  test "Home playlists":
    check channelData.videos.homePlaylists.len >= 1
    let playlist = channelData.videos.homePlaylists[0]
    check playlist.name == "Videos"
    check playlist.videos.len > 3
    let video = playlist.videos[^1]
    check video.title.len > 0
    check video.views > 0
    