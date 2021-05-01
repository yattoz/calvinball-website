# Migration guide

## How to

How to migrate a podcast to a local storage on this website?

- Enable download assets in `scripts/podcast_resources.rb`:

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

- clean and regenerate podcast resources ONCE with `ruby scripts/podcast_resources.rb --clean`. This will remove old pages. The new generated pages will have links that point locally instead of remotely (e.g. `/audio/thing.mp3` etc.)
- Change feed link in `docs/podcast/#{podcast}/README.md` with local link, like `feed: /podcasts/recommande/feed.rss`
- add line to `.gitignore` to **not ignore** the newly added podcast, e.g.: `!docs/**/recommande/**`
- generate RSS link with `ruby scripts/generate_rss.rb` (run from top folder)
- remove podcast from the array of monitored podcasts in script `script/podcast_resources.rb` (resources will be uploaded on this server from now on!)

You should be good to go now for the server.
- set the new RSS feed link in iTunes, Spotify, etc.

## Podtrack Not Supported

NOTE: podtrack is not supported - yet! I need to add a field in the Podcast Page Front Matter to tell "hey, I'm using podtrack, so please prepend the URL with some PodTrack URL". I'll put that in a issue too.