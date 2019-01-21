# Get data from Spotify

library(tidyverse)
library(purrr)
library(tm)
library(tidytext)


# from https://www.rcharlie.com/post/fitter-happier/ &
# https://www.rcharlie.com/spotifyr/
devtools::install_github('charlie86/spotifyr')
library(spotifyr)

Sys.setenv(SPOTIFY_CLIENT_ID = 'ID')
Sys.setenv(SPOTIFY_CLIENT_SECRET = 'SECRET')
access_token <- get_spotify_access_token()

albums <- get_artist_albums(artist = "Cardi B")
tracks <- get_album_tracks(albums, access_token = get_spotify_access_token(),
                 parallelize = FALSE, future_plan = "multiprocess")

features <- get_artist_audio_features(artist = "Cardi B", album_types = "album",
                          return_closest_artist = TRUE,
                          access_token = get_spotify_access_token(),
                          parallelize = FALSE, future_plan = "multiprocess")

lyrics <- albums$album_name %>%
    map(~ genius_album(artist = "Cardi B", album = ., info = "simple")) %>%
    set_names(albums$album_name) %>%
    bind_rows(.id = "album")


# tidy

lyrics %>%
    tolower() %>%
    removePunctuation()

# tomorrow: need to unnnest lyrics column but keep albumns, export to csv


