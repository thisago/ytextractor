#[
  Created at: 08/04/2021 16:25:48 Wednesday
  Modified at: 08/14/2021 11:23:03 PM Saturday
]#

##[
  test Video
]##

import unittest
from times import initDuration, `$`

import ytextractor

suite "Youtube video":
  var videoData = initYoutubeVideo("https://www.youtube.com/watch?v=jjEQ-yKVPMg".videoId)

  test "Video Id": check "jjEQ-yKVPMg" == $videoData.id
  test "Get data":
    check videoData.update()
    check videoData.status.error == ExtractError.None
  test "Video title":
    check videoData.title == "Bolachinhas de GERGELIM com CEBOLA - super CROCANTE"
  test "Views": check videoData.views > 170
  test "Video length": check videoData.length == initDuration(seconds = 202)
  test "Description": check videoData.description[0..3] == "Oie!"
  test "Thumbnails":
    check videoData.thumbnails.len > 1
  test "Embed":
    check videoData.embed.url == "https://www.youtube.com/embed/jjEQ-yKVPMg"
    check videoData.embed.width == 1280
    check videoData.embed.height == 720

  test "Family friendly": check videoData.familyFriendly == true
  test "Unlisted": check videoData.unlisted == false
  test "Private": check videoData.private == false
  test "Live": check videoData.live == false

  test "Category": check videoData.category == YoutubeVideoCategories.PeopleAndBlogs
  test "Channel name": check videoData.channel.name == "Antes do Almoço"
  test "Channel id": check videoData.channel.id.id == "UC3aGq0eFrvrjM4F1dLUo87A"
  test "Channel subscribers": check videoData.channel.subscribers > 29
  test "Channel hiddenSubscribers": check videoData.channel.hiddenSubscribers == false
  test "Channel icons": check videoData.channel.icons.len == 3
  test "Likes": check videoData.likes > 25
  test "Dislikes": check videoData.dislikes < 1_000
  test "Keywords": check "bolachinhas de gergelim" in videoData.keywords

  test "Publish date": check $videoData.publishDate == "2021-07-30T00:00:00+00:00"
  test "Upload date": check $videoData.uploadDate == "2021-07-30T00:00:00+00:00"
