# Migration guide

## Migrate assets (episodes text, audio, covers)

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
i

## Create account and folder structure

- Create an account with `/usr/sbin/adduser podcastname` with a strong password
- login with SSH

<!-- 
- create symbolic links (and create folders if they don't exist):

````bash
# as user $PODCASTKEY
export PODCASTKEY=$USER

cp -a /home/yattoz/calvinball-website/audio/$PODCASTKEY $HOME/"$PODCASTKEY"_audio
cp -a /home/yattoz/calvinball-website/images/$PODCASTKEY/full $HOME/"$PODCASTKEY"_images
cp -a /home/yattoz/calvinball-website/resources/$PODCASTKEY $HOME/"$PODCASTKEY"_resources
cp -a /home/yattoz/calvinball-website/docs/podcasts/$PODCASTKEY/episodes $HOME/"$PODCASTKEY"_episodes

mkdir $HOME/generation_token
```

```bash
# as user yattoz for user $PODCASTKEY
rm -rf /home/yattoz/calvinball-website/audio/$PODCASTKEY
ln -s /home/$PODCASTKEY/"$PODCASTKEY"_audio /home/yattoz/calvinball-website/audio/$PODCASTKEY

rm -rf /home/yattoz/calvinball-website/images/$PODCASTKEY/full
ln -s /home/$PODCASTKEY/"$PODCASTKEY"_images /home/yattoz/calvinball-website/images/$PODCASTKEY/full

rm -rf /home/yattoz/calvinball-website/resources/$PODCASTKEY
ln -s /home/$PODCASTKEY/"$PODCASTKEY"_resources /home/yattoz/calvinball-website/resources/$PODCASTKEY

rm -rf /home/yattoz/calvinball-website/docs/podcasts/$PODCASTKEY/episodes
ln -s /home/$PODCASTKEY/"$PODCASTKEY"_episodes /home/yattoz/calvinball-website/docs/podcasts/$PODCASTKEY/episodes

```

-->

- change group ownership of the following directories to allow user `podcastname` to write on these only:
  - `audio/#{podcastname}`
  - `images/#{podcastname}`
  - `resources/#{podcastname}`
  - `docs/podcasts/#{podcastname}`

so in bash fashion:
```bash
# as user $PODCASTKEY
export PODCASTKEY=$USER
su
# as root
chown -R yattoz:$PODCASTKEY /home/yattoz/calvinball-website/audio/$PODCASTKEY
chown -R yattoz:$PODCASTKEY /home/yattoz/calvinball-website/images/$PODCASTKEY
chown -R yattoz:$PODCASTKEY /home/yattoz/calvinball-website/resources/$PODCASTKEY
chown -R yattoz:$PODCASTKEY /home/yattoz/calvinball-website/docs/podcasts/$PODCASTKEY
```

This should allow user $PODCASTKEY to write on the directories they have access as a group.


<!--
DON'T DO THAT BECAUSE VUEPRESS WANTS TO PARSE THE FOLDERS BELOW IN THE SYMLINK.
SYMLINKS SHOULD BE DECLARED THE OTHER WAY ROUND.
- create symbolic links to facilitate navigation in Filezilla:

````bash
ln -s $HOME/$PODCASTKEY_audio/$USER $HOME
ln -s $HOME/$PODCASTKEY_images/$USER $HOME
ln -s $HOME/$PODCASTKEY_resources/$USER $HOME
ln -s $HOME/$PODCASTKEY_episodes/$USER $HOME
ln -s $HOME/generation_token/$USER $HOME
```

-->

- from root account, add user to `publisher` group to have access to `generation_token`:

```bash
/usr/sbin/usermod -a -G publisher
```

- from root account, give ownership to these folders

```bash
chown -R $PODCASTKEY:$PODCASTKEY /home/yattoz/calvinball-website/audio/$PODCASTKEY
chown -R $PODCASTKEY:$PODCASTKEY /home/yattoz/calvinball-website/images/$PODCASTKEY/full
chown -R $PODCASTKEY:$PODCASTKEY /home/yattoz/calvinball-website/resources/$PODCASTKEY
chown -R $PODCASTKEY:$PODCASTKEY /home/yattoz/calvinball-website/docs/podcasts/$PODCASTKEY/episodes
```

People with the account should now drop their files in the correct folders.

You should put:
- your MP3 in `$PODCASTKEY_audio`
- your episode cover in JPG (I insist: IN JPG) in `$PODCASTKEY_images`
- your episode text in `$PODCASTKEY_episodes`
- and if you want to add images to your episode texts, put the images in `$PODCASTKEY_resources`.

Finally, you must create a file named `token` in the folder `generatoin_token` to have your new episode added after at most 15 minutes.



## Known bug 

Podtrack Not Supported

NOTE: podtrack is not supported - yet! I need to add a field in the Podcast Page Front Matter to tell "hey, I'm using podtrack, so please prepend the URL with some PodTrack URL". I'll put that in a issue too.
