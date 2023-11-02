<!--
  Created at: 08/03/2021 17:17:54 Tuesday
  Modified at: 09/10/2021 11:39:54 PM Friday
-->

# ytextractor

**Y**ou**t**ube data **extractor**

Extracts the data of a Youtube url.
but more will be added soon!

The objective is extract every data that don't need authentication

---

## Features

This parser gets:
- Video url
  - Video info
    - [x] Id (video code)
    - [x] Title
    - [x] Description
    - [x] Thumbnails
    - [x] Embed
    - [x] Publish date
    - [x] Upload date
    - [x] Length
    - [x] Family friendly
    - [x] Unlisted
    - [x] Private
    - [x] Live (is live)
    - [x] Channel
    - [x] Views
    - [x] Category
    - [x] Likes
    - [x] Keywords
    - [x] Captions URLs 
  - Channel
    - [x] Name
    - [x] Id
    - [x] Url
    - [x] Subscribers
    - [x] Channel icons
    - [x] Hidden subscribers (bool)
- Channel url
  - [x] Id
  - [x] Url
  - [x] Name
  - [x] Subscribers
  - [x] Channel icons
  - [x] Hidden subscribers (bool)
  - [x] Family safe
  - [x] Tags
  - [x] Description (about)
  - [x] Banners
  - [x] Links
    - [x] Primary
    - [x] Secondary
  - [x] Highlighted playlists videos
  - [x] Highlighted video
    - [x] Id (video code)
    - [x] Title
    - [x] Description
    - [ ] Thumbnails
    - [x] Views
    - [x] Rounded publish date
    - [x] Badges
      - [x] Name
      - [x] Icon
      - [x] IconType
      - [x] Style

- [x] Video captions

- Video data
  - [ ] Subtitles
  - [ ] Comments
    - [ ] Comments of comments
  - Livechat
    - [ ] Realtime
    - [ ] Replay
- [ ] Search results
- [ ] All videos from channel/user
- [ ] All videos of playlist (a seq of videos)

### JS (browser) target avaliable!

[Online example](https://thisago.github.io/ytextractor/examples/web/)

An example can be found in [`examples/web`](examples/web).

Unfortunately the implementation isn't async, soon it will be fixed

**TODO:** Add captions extraction to JS example

---

## Usage

### [`video.nim`](src/ytextractor/video.nim)

```nim
import ytextractor
echo extractVideo "7on15IWC2u4"
```
or
```nim
import ytextractor
var vid = newYoutubeVideo "7on15IWC2u4".videoId
discard vid.update()
echo vid
```

---

### [`channel.nim`](src/ytextractor/channel.nim)

```nim
import ytextractor
echo extractChannel "https://www.youtube.com/c/taofledermaus"
```
or
```nim
import ytextractor
var channel = newYoutubeChannel "https://www.youtube.com/c/taofledermaus".channelId
discard channel.update(home)
echo channel
```

---

### [`captions.nim`](src/ytextractor/captions.nim)

```nim
import ytextractor
echo "7on15IWC2u4".extractVideo.captions[0].url.extractCaptions
```
or
```nim
import ytextractor
var captions = initYoutubecaptions()
discard captions.update "7on15IWC2u4".extractVideo.captions[0].url
echo captions
```

---

## Installation

Minimum [Nim](https://nim-lang.org) version is `1.2.2`

Please choice one installation method:

- Automatically with nimble
  ```bash
  nimble install ytextractor
  ```
Or
- Manually
  ```bash
  git clone https://github.com/thisago/ytextractor
  cd ytextractor/
  nimble install
  ```

---

## Docs

A online docs is hosted in [Github Pages](https://thisago.github.io/ytextractor/docs/ytextractor.html)

---

## TODO

- [ ] Usage guide (not only Nim)
- [ ] Make requests async
- [ ] Use API https://www.youtube.com/youtubei/v1/browse to get channel data
      instead using simple page request
- [ ] Add tests for captions sub module

---

## Useful links

### [nlitsme/youtube_tool](https://github.com/nlitsme/youtube_tool)

Python3 parser\
With a "How it works" section

---

## License

MIT
