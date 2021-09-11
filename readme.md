<!--
  Created at: 08/03/2021 17:17:54 Tuesday
  Modified at: 09/10/2021 11:39:54 PM Friday
-->

# ytextractor

**Y**ou**t**ube data **extractor**

Extracts the data of a Youtube url. Now it just parses a video url (watch page)
but more will be added soon!

The objective is extract every data that don't need authentication

This lib is WIP, but quite usable.

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
    - [x] Dislikes
    - [x] Keywords
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

Unfortunately the implementation isn't async, soon will be fixed

---

## Usage

### [`video.nim`](src/ytextractor/video.nim)

```nim
import ytextractor
echo extractVideo "_o2y1SxprA0"
```
or
```nim
import ytextractor
var vid = initYoutubeVideo "_o2y1SxprA0".videoId
discard vid.update()
echo vid
```
<details>
<summary>Out</summary>

```
(status: (lastUpdate: (nanosecond: 87569130, second: 26, minute: 28, hour: 23, monthdayZero: 10, monthZero: 9, year: 2021, weekday: Friday, yearday: 252, isDst: false, timezone: ..., utcOffset: 0), error: None), description: "Oie! esse foi o nosso primeiro vídeo do canal!\nNesse vídeo ensinamos você à fazer uma Pasta de berinjela com tahine, Dá para comer tanto quanto na salada tanto no pão, é uma delícia! Aqui nos fazemos sempre! É super nutritivo e gostoso!\nSe você gostou da receita, avalie o vídeo e se  inscreva se gostou do conteúdo do canal!!! Comente! sugestões, dúvidas, críticas construtivas, São bem vindas!\nMuito obrigada por assistir e até mais :)\n\n\nINGREDIENTES:\n\n2 beringelas\n1 litro de água ou até que cubra todas as beringelas\n2 colheres de (sopa) de sal\n8 colheres de (sopa) de vinagre\n1 cebola grande cortado em cubos\n2 tomates pequenos cortado em cubos\nUm fio de azeite de oliva\n2 á 3 colheres de tahine\nSuco de 1 limão \nSal, pimenta, orégano, temperos, azeite\n\n\nMODO DE PREPARO:\n🎬 Assista no vídeo com o passo a passo!\n\n\nMEDIDAS\n1 colher de sopa = 15 ml\n1/2 colher de sopa = 7,5 ml\n1 colher de chá = 5 ml\n1/2 colher de chá = 2,5 ml\n1/4 colher de c\n\n________________________________________\nOBRIGADA", embed: (url: "https://www.youtube.com/embed/_o2y1SxprA0", width: 1280, height: 720), publishDate: (nanosecond: 0, second: 0, minute: 0, hour: 0, monthdayZero: 23, monthZero: 7, year: 2021, weekday: Friday, yearday: 203, isDst: false, timezone: ..., utcOffset: 0), uploadDate: (nanosecond: 0, second: 0, minute: 0, hour: 0, monthdayZero: 23, monthZero: 7, year: 2021, weekday: Friday, yearday: 203, isDst: false, timezone: ..., utcOffset: 0), length: (seconds: 255, nanosecond: 0), familyFriendly: true, unlisted: false, private: false, live: false, channel: (id: (id: "UC3aGq0eFrvrjM4F1dLUo87A", kind: channel), name: "Antes do Almoço", subscribers: 59, icons: @[(url: "https://yt3.ggpht.com/NtBpZbStXa_UHGyVTNJjbcY1l929iynk_SWK5n54_2euHEL72lMkUkfp_iu5orn901QvbvuVRg=s48-c-k-c0x00ffffff-no-rj", width: 48, height: 48), (url: "https://yt3.ggpht.com/NtBpZbStXa_UHGyVTNJjbcY1l929iynk_SWK5n54_2euHEL72lMkUkfp_iu5orn901QvbvuVRg=s88-c-k-c0x00ffffff-no-rj", width: 88, height: 88), (url: "https://yt3.ggpht.com/NtBpZbStXa_UHGyVTNJjbcY1l929iynk_SWK5n54_2euHEL72lMkUkfp_iu5orn901QvbvuVRg=s176-c-k-c0x00ffffff-no-rj", width: 176, height: 176)], hiddenSubscribers: false), category: PeopleAndBlogs, likes: 26, dislikes: 0, keywords: @["salada de beringela", "patê de beringela", "creme de beringela com tahine", "tahine", "receita vegetariana", "beringela assada", "beringela cozida", "o que fazer com beringela", "o que fazer com tahine", "receita vegana"], id: _o2y1SxprA0, title: "Pasta de Berinjela com tahine - NUTRITIVO E GOSTOSO!", views: 360, thumbnails: @[(url: "https://i.ytimg.com/vi/_o2y1SxprA0/hqdefault.jpg?sqp=-oaymwEbCKgBEF5IVfKriqkDDggBFQAAiEIYAXABwAEG&rs=AOn4CLDnCSI12cIFP-xXDleG6ff3xAtjpg", width: 168, height: 94), (url: "https://i.ytimg.com/vi/_o2y1SxprA0/hqdefault.jpg?sqp=-oaymwEbCMQBEG5IVfKriqkDDggBFQAAiEIYAXABwAEG&rs=AOn4CLB1RXtSof6PmldxUp_v_zRwoIuIHQ", width: 196, height: 110), (url: "https://i.ytimg.com/vi/_o2y1SxprA0/hqdefault.jpg?sqp=-oaymwEcCPYBEIoBSFXyq4qpAw4IARUAAIhCGAFwAcABBg==&rs=AOn4CLCR1W06HQAU-0EU2ZyfuCoXyMrqBA", width: 246, height: 138), (url: "https://i.ytimg.com/vi/_o2y1SxprA0/hqdefault.jpg?sqp=-oaymwEcCNACELwBSFXyq4qpAw4IARUAAIhCGAFwAcABBg==&rs=AOn4CLB1wuOintx-pcJ3ErKiAuaEF6M-Ww", width: 336, height: 188), (url: "https://i.ytimg.com/vi_webp/_o2y1SxprA0/maxresdefault.webp", width: 1920, height: 1080)])
```
</details>

---

### [`channel.nim`](src/ytextractor/channel.nim)

```nim
import ytextractor
echo extractChannel "https://www.youtube.com/channel/UC3aGq0eFrvrjM4F1dLUo87A"
```
or
```nim
import ytextractor
var channel = initYoutubeChannel "https://www.youtube.com/channel/UC3aGq0eFrvrjM4F1dLUo87A".channelId
discard channel.update(home)
echo channel
```
<details>
<summary>Out</summary>

```
(status: (lastUpdate: (nanosecond: 384031067, second: 19, minute: 29, hour: 23, monthdayZero: 10, monthZero: 9, year: 2021, weekday: Friday, yearday: 252, isDst: false, timezone: ..., utcOffset: 0), error: None), description: "Esse é o canal Antes do Almoço!\nAqui você encontra receitas vegetarianas, únicas, fáceis, rápidas e muito gostosas!\nSe você é novo aqui, seja muito bem vindo, e se gostar das receitas, avalie os vídeos e se gostar do conteúdo do canal se inscreva-se e ative o sininho pois aqui vai ter vídeo novo toda semana! Então se você gosta de comer comidas vegetarianas, ou se você é um vegetariano ou pretende ser, você está no lugar certo, aqui vamos te ensinar receitas, dicas...\nSe puder compartilhe com seus amigos, família e comente! Sugestões, dúvidas e críticas construtivas São bem vindas!\nMuito obrigada.", banners: (desktop: @[(url: "https://yt3.ggpht.com/gGYY9J-IElCnN5-WzZWQmQnHOY9x1sx4go_MVCE8YuiCNyfOdtoV2ecUGrBB6mJ6joHt66EZEQ=w1060-fcrop64=1,00005a57ffffa5a8-k-c0xffffffff-no-nd-rj", width: 1060, height: 175), (url: "https://yt3.ggpht.com/gGYY9J-IElCnN5-WzZWQmQnHOY9x1sx4go_MVCE8YuiCNyfOdtoV2ecUGrBB6mJ6joHt66EZEQ=w1138-fcrop64=1,00005a57ffffa5a8-k-c0xffffffff-no-nd-rj", width: 1138, height: 188), (url: "https://yt3.ggpht.com/gGYY9J-IElCnN5-WzZWQmQnHOY9x1sx4go_MVCE8YuiCNyfOdtoV2ecUGrBB6mJ6joHt66EZEQ=w1707-fcrop64=1,00005a57ffffa5a8-k-c0xffffffff-no-nd-rj", width: 1707, height: 283), (url: "https://yt3.ggpht.com/gGYY9J-IElCnN5-WzZWQmQnHOY9x1sx4go_MVCE8YuiCNyfOdtoV2ecUGrBB6mJ6joHt66EZEQ=w2120-fcrop64=1,00005a57ffffa5a8-k-c0xffffffff-no-nd-rj", width: 2120, height: 351), (url: "https://yt3.ggpht.com/gGYY9J-IElCnN5-WzZWQmQnHOY9x1sx4go_MVCE8YuiCNyfOdtoV2ecUGrBB6mJ6joHt66EZEQ=w2276-fcrop64=1,00005a57ffffa5a8-k-c0xffffffff-no-nd-rj", width: 2276, height: 377), (url: "https://yt3.ggpht.com/gGYY9J-IElCnN5-WzZWQmQnHOY9x1sx4go_MVCE8YuiCNyfOdtoV2ecUGrBB6mJ6joHt66EZEQ=w2560-fcrop64=1,00005a57ffffa5a8-k-c0xffffffff-no-nd-rj", width: 2560, height: 424)], mobile: @[(url: "https://yt3.ggpht.com/gGYY9J-IElCnN5-WzZWQmQnHOY9x1sx4go_MVCE8YuiCNyfOdtoV2ecUGrBB6mJ6joHt66EZEQ=w320-fcrop64=1,32b75a57cd48a5a8-k-c0xffffffff-no-nd-rj", width: 320, height: 88), (url: "https://yt3.ggpht.com/gGYY9J-IElCnN5-WzZWQmQnHOY9x1sx4go_MVCE8YuiCNyfOdtoV2ecUGrBB6mJ6joHt66EZEQ=w640-fcrop64=1,32b75a57cd48a5a8-k-c0xffffffff-no-nd-rj", width: 640, height: 175), (url: "https://yt3.ggpht.com/gGYY9J-IElCnN5-WzZWQmQnHOY9x1sx4go_MVCE8YuiCNyfOdtoV2ecUGrBB6mJ6joHt66EZEQ=w960-fcrop64=1,32b75a57cd48a5a8-k-c0xffffffff-no-nd-rj", width: 960, height: 263), (url: "https://yt3.ggpht.com/gGYY9J-IElCnN5-WzZWQmQnHOY9x1sx4go_MVCE8YuiCNyfOdtoV2ecUGrBB6mJ6joHt66EZEQ=w1280-fcrop64=1,32b75a57cd48a5a8-k-c0xffffffff-no-nd-rj", width: 1280, height: 351), (url: "https://yt3.ggpht.com/gGYY9J-IElCnN5-WzZWQmQnHOY9x1sx4go_MVCE8YuiCNyfOdtoV2ecUGrBB6mJ6joHt66EZEQ=w1440-fcrop64=1,32b75a57cd48a5a8-k-c0xffffffff-no-nd-rj", width: 1440, height: 395)], tv: @[(url: "https://yt3.ggpht.com/gGYY9J-IElCnN5-WzZWQmQnHOY9x1sx4go_MVCE8YuiCNyfOdtoV2ecUGrBB6mJ6joHt66EZEQ=w320-fcrop64=1,00000000ffffffff-k-c0xffffffff-no-nd-rj", width: 320, height: 180), (url: "https://yt3.ggpht.com/gGYY9J-IElCnN5-WzZWQmQnHOY9x1sx4go_MVCE8YuiCNyfOdtoV2ecUGrBB6mJ6joHt66EZEQ=w854-fcrop64=1,00000000ffffffff-k-c0xffffffff-no-nd-rj", width: 854, height: 480), (url: "https://yt3.ggpht.com/gGYY9J-IElCnN5-WzZWQmQnHOY9x1sx4go_MVCE8YuiCNyfOdtoV2ecUGrBB6mJ6joHt66EZEQ=w1280-fcrop64=1,00000000ffffffff-k-c0xffffffff-no-nd-rj", width: 1280, height: 720), (url: "https://yt3.ggpht.com/gGYY9J-IElCnN5-WzZWQmQnHOY9x1sx4go_MVCE8YuiCNyfOdtoV2ecUGrBB6mJ6joHt66EZEQ=w1920-fcrop64=1,00000000ffffffff-k-c0xffffffff-no-nd-rj", width: 1920, height: 1080), (url: "https://yt3.ggpht.com/gGYY9J-IElCnN5-WzZWQmQnHOY9x1sx4go_MVCE8YuiCNyfOdtoV2ecUGrBB6mJ6joHt66EZEQ=w2120-fcrop64=1,00000000ffffffff-k-c0xffffffff-no-nd-rj", width: 2120, height: 1192)]), familySafe: true, tags: @[], videos: (all: @[], playlists: @[], homePlaylists: @[(videos: @[(roundedPublishedDate: "4 days ago", id: yWb4nF84PoA, title: "PÃO INTEGRAL DE HAMBÚRGUER - O MAIS FOFINHO E GOSTOSO!", views: 193, thumbnails: @[(url: "https://i.ytimg.com/vi/yWb4nF84PoA/hqdefault.jpg?sqp=-oaymwEbCKgBEF5IVfKriqkDDggBFQAAiEIYAXABwAEG&rs=AOn4CLAVWIapZe3B7enQFu1ChivHTUhsLg", width: 168, height: 94), (url: "https://i.ytimg.com/vi/yWb4nF84PoA/hqdefault.jpg?sqp=-oaymwEbCMQBEG5IVfKriqkDDggBFQAAiEIYAXABwAEG&rs=AOn4CLBGJ7FDAimK5oLtUM88cyq4WHYE_A", width: 196, height: 110), (url: "https://i.ytimg.com/vi/yWb4nF84PoA/hqdefault.jpg?sqp=-oaymwEcCPYBEIoBSFXyq4qpAw4IARUAAIhCGAFwAcABBg==&rs=AOn4CLCiK6VtyKsyWAY9wz25LHLt8EYr0g", width: 246, height: 138), (url: "https://i.ytimg.com/vi/yWb4nF84PoA/hqdefault.jpg?sqp=-oaymwEcCNACELwBSFXyq4qpAw4IARUAAIhCGAFwAcABBg==&rs=AOn4CLAtDbA-8s28DhtHJSHnd8wGETfviQ", width: 336, height: 188)]), (roundedPublishedDate: "2 weeks ago", id: 4zRK0t4caOg, title: "A MELHOR TORTA DE MAÇÃ DE TODAS! Você vai se surpreender.", views: 210, thumbnails: @[(url: "https://i.ytimg.com/vi/4zRK0t4caOg/hqdefault.jpg?sqp=-oaymwEbCKgBEF5IVfKriqkDDggBFQAAiEIYAXABwAEG&rs=AOn4CLB2ZYbf8McnYpUA2PgS7Yxpi-SCxw", width: 168, height: 94), (url: "https://i.ytimg.com/vi/4zRK0t4caOg/hqdefault.jpg?sqp=-oaymwEbCMQBEG5IVfKriqkDDggBFQAAiEIYAXABwAEG&rs=AOn4CLAngHHrDLGcaWit8y42sOvEJO0vew", width: 196, height: 110), (url: "https://i.ytimg.com/vi/4zRK0t4caOg/hqdefault.jpg?sqp=-oaymwEcCPYBEIoBSFXyq4qpAw4IARUAAIhCGAFwAcABBg==&rs=AOn4CLChcfGsdnraCkvDqSnBauHOm3RpRA", width: 246, height: 138), (url: "https://i.ytimg.com/vi/4zRK0t4caOg/hqdefault.jpg?sqp=-oaymwEcCNACELwBSFXyq4qpAw4IARUAAIhCGAFwAcABBg==&rs=AOn4CLBwZ038zbREoSfT6cHtHEwK_YgeNA", width: 336, height: 188)]), (roundedPublishedDate: "4 weeks ago", id: rxnfm6COBVk, title: "Torta de PALMITO tipo EMPADÃO - Super cremosa", views: 328, thumbnails: @[(url: "https://i.ytimg.com/vi/rxnfm6COBVk/hqdefault.jpg?sqp=-oaymwEbCKgBEF5IVfKriqkDDggBFQAAiEIYAXABwAEG&rs=AOn4CLCg9POZ1V8i7WRt3zUmBoiBY0MTnA", width: 168, height: 94), (url: "https://i.ytimg.com/vi/rxnfm6COBVk/hqdefault.jpg?sqp=-oaymwEbCMQBEG5IVfKriqkDDggBFQAAiEIYAXABwAEG&rs=AOn4CLCBCOh6mWQa5V6ZeBHmBQNinro8Ww", width: 196, height: 110), (url: "https://i.ytimg.com/vi/rxnfm6COBVk/hqdefault.jpg?sqp=-oaymwEcCPYBEIoBSFXyq4qpAw4IARUAAIhCGAFwAcABBg==&rs=AOn4CLCNcF3dW6qGpDOzyVus2r200ZBzKQ", width: 246, height: 138), (url: "https://i.ytimg.com/vi/rxnfm6COBVk/hqdefault.jpg?sqp=-oaymwEcCNACELwBSFXyq4qpAw4IARUAAIhCGAFwAcABBg==&rs=AOn4CLDeLuwrgyQPYpK0mU3_OCq4kntjBw", width: 336, height: 188)]), (roundedPublishedDate: "1 month ago", id: Dx4eelwPGaQ, title: "Hambúrguer de PVT - O melhor que você vai ver! RENDE MUITO", views: 353, thumbnails: @[(url: "https://i.ytimg.com/vi/Dx4eelwPGaQ/hqdefault.jpg?sqp=-oaymwEbCKgBEF5IVfKriqkDDggBFQAAiEIYAXABwAEG&rs=AOn4CLCQ_5NIwcs9P_uJfpsUU3DVXFD_Og", width: 168, height: 94), (url: "https://i.ytimg.com/vi/Dx4eelwPGaQ/hqdefault.jpg?sqp=-oaymwEbCMQBEG5IVfKriqkDDggBFQAAiEIYAXABwAEG&rs=AOn4CLDF70JeTQTNHoF2eOdbc05uv8GIEQ", width: 196, height: 110), (url: "https://i.ytimg.com/vi/Dx4eelwPGaQ/hqdefault.jpg?sqp=-oaymwEcCPYBEIoBSFXyq4qpAw4IARUAAIhCGAFwAcABBg==&rs=AOn4CLAPW_vQcUW4WrnvVsMBM4BeRE3fdw", width: 246, height: 138), (url: "https://i.ytimg.com/vi/Dx4eelwPGaQ/hqdefault.jpg?sqp=-oaymwEcCNACELwBSFXyq4qpAw4IARUAAIhCGAFwAcABBg==&rs=AOn4CLDgd1yggjYaDIb9nHNr5_z_8iVY9Q", width: 336, height: 188)]), (roundedPublishedDate: "1 month ago", id: jjEQ-yKVPMg, title: "Bolachinhas de GERGELIM com CEBOLA super CROCANTE - sem ovo/sem leite", views: 405, thumbnails: @[(url: "https://i.ytimg.com/vi/jjEQ-yKVPMg/hqdefault.jpg?sqp=-oaymwEbCKgBEF5IVfKriqkDDggBFQAAiEIYAXABwAEG&rs=AOn4CLB1PpD2XRnd2O1XXE9NipxyTD9VHg", width: 168, height: 94), (url: "https://i.ytimg.com/vi/jjEQ-yKVPMg/hqdefault.jpg?sqp=-oaymwEbCMQBEG5IVfKriqkDDggBFQAAiEIYAXABwAEG&rs=AOn4CLDP14lLrxmVQURd9NWNP13CvhUrAA", width: 196, height: 110), (url: "https://i.ytimg.com/vi/jjEQ-yKVPMg/hqdefault.jpg?sqp=-oaymwEcCPYBEIoBSFXyq4qpAw4IARUAAIhCGAFwAcABBg==&rs=AOn4CLBmG0m90VKChxxoGTgbSy2L3jS07g", width: 246, height: 138), (url: "https://i.ytimg.com/vi/jjEQ-yKVPMg/hqdefault.jpg?sqp=-oaymwEcCNACELwBSFXyq4qpAw4IARUAAIhCGAFwAcABBg==&rs=AOn4CLCikGJ9YPp81EbOSjqYuei-jqvJZA", width: 336, height: 188)]), (roundedPublishedDate: "1 month ago", id: _o2y1SxprA0, title: "Pasta de Berinjela com tahine - NUTRITIVO E GOSTOSO!", views: 362, thumbnails: @[(url: "https://i.ytimg.com/vi/_o2y1SxprA0/hqdefault.jpg?sqp=-oaymwEbCKgBEF5IVfKriqkDDggBFQAAiEIYAXABwAEG&rs=AOn4CLDnCSI12cIFP-xXDleG6ff3xAtjpg", width: 168, height: 94), (url: "https://i.ytimg.com/vi/_o2y1SxprA0/hqdefault.jpg?sqp=-oaymwEbCMQBEG5IVfKriqkDDggBFQAAiEIYAXABwAEG&rs=AOn4CLB1RXtSof6PmldxUp_v_zRwoIuIHQ", width: 196, height: 110), (url: "https://i.ytimg.com/vi/_o2y1SxprA0/hqdefault.jpg?sqp=-oaymwEcCPYBEIoBSFXyq4qpAw4IARUAAIhCGAFwAcABBg==&rs=AOn4CLCR1W06HQAU-0EU2ZyfuCoXyMrqBA", width: 246, height: 138), (url: "https://i.ytimg.com/vi/_o2y1SxprA0/hqdefault.jpg?sqp=-oaymwEcCNACELwBSFXyq4qpAw4IARUAAIhCGAFwAcABBg==&rs=AOn4CLB1wuOintx-pcJ3ErKiAuaEF6M-Ww", width: 336, height: 188)])], name: "Uploads")], highlighted: (description: "", roundedPublishedDate: "", id: , title: "", views: 0, thumbnails: @[])), links: (primary: @[], secondary: @[]), id: (id: "UC3aGq0eFrvrjM4F1dLUo87A", kind: channel), name: "Antes do Almoço", subscribers: 59, icons: @[(url: "https://yt3.ggpht.com/NtBpZbStXa_UHGyVTNJjbcY1l929iynk_SWK5n54_2euHEL72lMkUkfp_iu5orn901QvbvuVRg=s48-c-k-c0x00ffffff-no-rj", width: 48, height: 48), (url: "https://yt3.ggpht.com/NtBpZbStXa_UHGyVTNJjbcY1l929iynk_SWK5n54_2euHEL72lMkUkfp_iu5orn901QvbvuVRg=s88-c-k-c0x00ffffff-no-rj", width: 88, height: 88), (url: "https://yt3.ggpht.com/NtBpZbStXa_UHGyVTNJjbcY1l929iynk_SWK5n54_2euHEL72lMkUkfp_iu5orn901QvbvuVRg=s176-c-k-c0x00ffffff-no-rj", width: 176, height: 176), (url: "https://yt3.ggpht.com/NtBpZbStXa_UHGyVTNJjbcY1l929iynk_SWK5n54_2euHEL72lMkUkfp_iu5orn901QvbvuVRg=s900-c-k-c0x00ffffff-no-rj", width: 900, height: 900)], hiddenSubscribers: false)
```
</details>

---

## Installation

Minimum [Nim](https://nim-lang.org) version is `1.2.2`

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

## Docs

A online docs is hosted in [Github Pages](https://thisago.github.io/ytextractor/docs/ytextractor.html)

---

## TODO

- [ ] Usage guide (not only Nim)
- [ ] Make requests async
- [ ] Use API https://www.youtube.com/youtubei/v1/browse to get channel data
      instead using simple page request

---

## Useful links

### [nlitsme/youtube_tool](https://github.com/nlitsme/youtube_tool)

Python3 parser\
With a "How it works" section

---

## FAQ

### What is these videos?

Is a recently initiated cooking channel from one of my relatives

---

## License

MIT
