#[
  Created at: 08/15/2021 19:03:47 Sunday
  Modified at: 08/16/2021 01:51:11 PM Monday
]#

##[
  Tests for channel extractor
]##

import unittest
from times import initDuration, `$`
from std/strutils import contains

import ytextractor

suite "Youtube channel":
  var channelData = initYoutubeChannel("https://www.youtube.com/channel/UC3aGq0eFrvrjM4F1dLUo87A".channelId)

  test "Channel Id": check "UC3aGq0eFrvrjM4F1dLUo87A" == $channelData.id.id
  test "Get data":
    check channelData.update(home)
    check channelData.status.error == ExtractError.None
  test "Channel name": check channelData.name == "Antes do Almoço"
  test "Description": check "Antes do Almoço" in channelData.description
  test "Thumbnails": check channelData.icons.len > 1
  test "Banners":
    check channelData.banners.desktop.len > 1
    check channelData.banners.mobile.len > 1
    check channelData.banners.tv.len > 1
  test "Family safe": check channelData.familySafe == true
  test "Tags": check channelData.tags.len == 0
