#[
  Created at: 08/04/2021 16:25:48 Wednesday
  Modified at: 08/04/2021 05:40:34 PM Wednesday
]#

##[
  test Video
]##

import unittest
from times import initDuration

import ytextractor

suite "Youtube video":
  var videoData = initYoutubeVideo("https://www.youtube.com/watch?v=jjEQ-yKVPMg".videoCode)

  test "Video Code": check "jjEQ-yKVPMg" == $videoData.code
  test "Get data":
    check videoData.update()
    check videoData.status.error == YoutubeVideoError.None
  test "Video title":
    check videoData.title == "Bolachinhas de GERGELIM com CEBOLA super CROCANTE"
  test "Views": check videoData.views > 170
  test "Video length": check videoData.length == initDuration(seconds = 202)
  test "Description": check videoData.description[0..3] == "Oie!"
  test "Thumbnail":
    check videoData.thumbnail.url.len > 0
    check videoData.thumbnail.width == 1280
    check videoData.thumbnail.height == 720
  test "Embed":
    check videoData.embed.url == "https://www.youtube.com/embed/jjEQ-yKVPMg"
    check videoData.embed.width == 1280
    check videoData.embed.height == 720
  test "Family friendly": check videoData.familyFriendly == true
  test "Unlisted": check videoData.unlisted == false
  test "Category": check videoData.category == YoutubeVideoCategories.PeopleAndBlogs
  test "Channel name": check videoData.channel.name == "Antes do Almoço"
  test "Channel url": check videoData.channel.url == "http://www.youtube.com/channel/UC3aGq0eFrvrjM4F1dLUo87A"
  test "Channel id": check videoData.channel.id == "UC3aGq0eFrvrjM4F1dLUo87A"
