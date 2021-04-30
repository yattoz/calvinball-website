# Migration guide

How to migrate a podcast to a local storage on this website?

- Enable download assets in podcast_resources.rb

e.g. 

```json
recommande = {
    :url => "https://recommande.duckdns.org/episodes.mp3.rss",
    :separator => "-",
    :usual_author => "Yattoz",
    :always_people => {"yattoz" => "Yattoz"},
    :podcast_key => "recommande",
    :cover_keep_orig => true,
    :audio_download => true,
    :resources_download => true
}
```

- Remove remote feed link in docs/podcast/#{podcast}/README.md and put local link, like `feed: /podcasts/recommande/feed.rss`
- generate RSS link with generate_rss.rb (run from top folder)
- set that new link in iTunes, Spotify, etc