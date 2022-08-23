import ytextractor/video; export video
import ytextractor/channel; export channel

when isMainModule and not defined js:
  # debug purposes
  from std/times import `$`
  # import ytextractor/exports
  # import std/json

  # var vid = initYoutubeVideo "4zRK0t4caOg".videoId
  # discard vid.update()

  # echo "Video data:"
  # echo vid

  # echo extractVideo("https://www.youtube.com/watch?v=4zRK0t4caOg")

  var chan = initYoutubeChannel "https://www.youtube.com/c/taofledermaus".channelId
  discard chan.update(home)

  echo "\nChannel data:"
  echo chan
