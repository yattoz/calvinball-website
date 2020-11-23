---
title: Recommandé
description: Le podcast musical par vidéos recommandées de Youtube
podcast: true

podcast_title: Calvinball
podcast_description: Le podcast musical par vidéos recommandées de Youtube
podcast_image: /image.png
author: Yattoz
email: recommande@hotmail.com
last_build_date: 2020-10-11
is_explicit: no
itunes_keywords: music, youtube, random, calvinball
itunes_category: Music
---

## {{ $frontmatter.title }}

{{ $description }}

[Flux rss](./feed.rss)

<PodcastEpisodeList v-bind:podcast="'recommande'" />