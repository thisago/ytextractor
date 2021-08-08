<!--
  Created at: 08/03/2021 17:17:54 Tuesday
  Modified at: 08/08/2021 05:59:06 PM Sunday
-->

# ytextractor

**Y**ou**t**ube data **extractor**

---

## Features

This parser gets:
- Common video info
  - [x] Code
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
  - [x] Dislikes
  - [x] Keywords
- Channel
  - [x] Subscribers
  - [x] Channel icons
  - [x] Url
  - [x] Id
  - [x] Name
  - [x] Hidden subscribers (bool)

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

---

## Usage

```nim
import ytextractor
echo extractVideo "_o2y1SxprA0"
```
or
```nim
import ytextractor
var vid = initYoutubeVideo "_o2y1SxprA0".videoCode
vid.update()
echo vid
```
<details>
<summary>Out</summary>

```
(status: (lastUpdate: 2021-08-08T17:58:54+00:00, error: None), code: _o2y1SxprA0, title: "Pasta de Berinjela com tahine", description: "Oie! esse foi o nosso primeiro vídeo do canal!\nNesse vídeo ensinamos você à fazer uma Pasta de berinjela com tahine, Dá para comer tanto quanto na salada tanto no pão, é uma delícia! Aqui nos fazemos sempre! É super nutritivo e gostoso!\nSe vocês gostaram, avalie o vídeo, se inscreva se gostou do conteúdo do canal e comente, Sugestões, dúvidas, críticas construtivas, São bem vindas!\nMuito obrigada por assistir e até mais!\n\n\nMEDIDAS:\n\n1 xícara = 250 ml\n1/2 xícara = 125 ml\n1/3 xícara = 85 ml\n1/4 xícara = 60 ml\n\n1 colher de sopa = 15 ml\n1/2 colher de sopa = 7,5 ml\n1 colher de chá = 5 ml\n1/2 colher de chá = 2,5 ml\n1/4 colher de chá = 1,5 ml\n\n\nINGREDIENTES: \n\n2 beringelas\n1 cebola grande cortado em cubos\n2 tomates pequenos cortado em cubos\n1 litro de água ou até que cubra todas as beringelas\n2 colheres de (sopa) de sal\n8 colheres de (sopa) de vinagre\nUm fio de azeite de oliva\n2 á 3 colheres de tahine\nSuco de 1 limão \nsal, pimenta, orégano, temperos, azeite\n\nModo de preparo:\n\nAssista no vídeo com o passo a passo!\n\n muito obrigada e até mais!", thumbnails: @[(url: "https://i.ytimg.com/vi/_o2y1SxprA0/hqdefault.jpg?sqp=-oaymwEiCKgBEF5IWvKriqkDFQgBFQAAAAAYASUAAMhCPQCAokN4AQ==&rs=AOn4CLBoiQsXUwD2LJ3PUzO3DprR4vwy1Q", width: 168, height: 94), (url: "https://i.ytimg.com/vi/_o2y1SxprA0/hqdefault.jpg?sqp=-oaymwEiCMQBEG5IWvKriqkDFQgBFQAAAAAYASUAAMhCPQCAokN4AQ==&rs=AOn4CLBUv0jjfnfXPL3QKfdiPMlVX4B88A", width: 196, height: 110), (url: "https://i.ytimg.com/vi/_o2y1SxprA0/hqdefault.jpg?sqp=-oaymwEjCPYBEIoBSFryq4qpAxUIARUAAAAAGAElAADIQj0AgKJDeAE=&rs=AOn4CLCwAVMbzGigVmYC8mU3y9op6Pg9Wg", width: 246, height: 138), (url: "https://i.ytimg.com/vi/_o2y1SxprA0/hqdefault.jpg?sqp=-oaymwEjCNACELwBSFryq4qpAxUIARUAAAAAGAElAADIQj0AgKJDeAE=&rs=AOn4CLCQr-EQhVY7kNthUWT06s26k-Je5A", width: 336, height: 188), (url: "https://i.ytimg.com/vi/_o2y1SxprA0/maxresdefault.jpg", width: 1920, height: 1080)], embed: (url: "https://www.youtube.com/embed/_o2y1SxprA0", width: 1280, height: 720), publishDate: 2021-07-23T00:00:00+00:00, uploadDate: 2021-07-23T00:00:00+00:00, length: 4 minutes and 15 seconds, familyFriendly: true, unlisted: false, private: false, live: false, channel: (url: "http://www.youtube.com/channel/UC3aGq0eFrvrjM4F1dLUo87A", name: "Antes do Almoço", id: "UC3aGq0eFrvrjM4F1dLUo87A", subscribers: 33, icons: @[(url: "https://yt3.ggpht.com/NtBpZbStXa_UHGyVTNJjbcY1l929iynk_SWK5n54_2euHEL72lMkUkfp_iu5orn901QvbvuVRg=s48-c-k-c0x00ffffff-no-rj", width: 48, height: 48), (url: "https://yt3.ggpht.com/NtBpZbStXa_UHGyVTNJjbcY1l929iynk_SWK5n54_2euHEL72lMkUkfp_iu5orn901QvbvuVRg=s88-c-k-c0x00ffffff-no-rj", width: 88, height: 88), (url: "https://yt3.ggpht.com/NtBpZbStXa_UHGyVTNJjbcY1l929iynk_SWK5n54_2euHEL72lMkUkfp_iu5orn901QvbvuVRg=s176-c-k-c0x00ffffff-no-rj", width: 176, height: 176)], hiddenSubscribers: false), views: 230, category: PeopleAndBlogs, likes: 23, dislikes: 0, keywords: @["salada de beringela", "patê de beringela", "creme de beringela com tahine", "tahine", "receita vegetariana", "beringela assada", "beringela cozida", "o que fazer com beringela", "o que fazer com tahine"])
```
</details>

---

## Installation

Please choice one installation method:

- Automatically with nimble
  ```bash
  nimble install ytextractor
  ```
  or
  ```bash
  nimble install https://github.com/thisago/ytextractor
  ```

Or

- Manually
  ```bash
  git clone https://github.com/thisago/ytextractor
  cd ytextractor/
  nimble install
  ```

---

## TODO

Usage guide (not only Nim)

---

## Useful links

### [nlitsme/youtube_tool](https://github.com/nlitsme/youtube_tool)

Python3 parser\
With a "How it works" section

---

## License

MIT
