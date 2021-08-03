#[
  Created at: 08/03/2021 19:58:57 Tuesday
  Modified at: 08/03/2021 08:28:02 PM Tuesday
]#

##[
  ytdata
]##

from std/times import DateTime, Duration, initDuration

type
  YoutubeVideo* = object
    code*, title*, description*: string
    thumbnail*, embed*: YoutubeVideoUrl
    publishDate*, uploadDate: DateTime
    length*: Duration
    familyFriendly*, unlisted*: bool
    channel: YoutubeVideoChannel
    views*: int
    category*: YoutubeVideoCategories

  YoutubeVideoUrl* = object
    url*: string
    width*, height*: int
  YoutubeVideoChannel* = object
    url*, name*, id*: string
  YoutubeVideoCategories {.pure.} = enum
    FilmAndAnimation, AutosAndVehicles, Music, PetsAndAnimals, Sports,
    TravelAndEvents, Gaming, PeopleAndBlogs, Comedy, Entertainment,
    NewsAndPolitics, HowtoAndStyle, Education, ScienceAndTechnology,
    NonprofitsAndActivism

proc parseEnum(str: string): YoutubeVideoChannel =
  case str:
  of "Film & Animation": FilmAndAnimation
  of "Autos & Vehicles": AutosAndVehicles
  of "Music": Music
  of "Pets & Animals": PetsAndAnimals
  of "Sports": Sports
  of "Travel & Events": TravelAndEvents
  of "Gaming": Gaming
  of "People & Blogs": PeopleAndBlogs
  of "Comedy": Comedy
  of "Entertainment": Entertainment
  of "News & Politics": NewsAndPolitics
  of "Howto & Style": HowtoAndStyle
  of "Education": Education
  of "Science & Technology": ScienceAndTechnology
  of "Nonprofits & Activism": NonprofitsAndActivism
