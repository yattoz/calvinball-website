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
    :location => Location::LOCAL,
    :cover_keep_orig => true,
    :audio_download => true,
    :resources_download => true
}
```

- clean and regenerate podcast resources with `ruby scripts/podcast_resources.rb --clean PODCASTKEY`. This will remove old pages. The new generated pages will have links that point locally instead of remotely (e.g. `/audio/thing.mp3` etc.)
- Change feed link in `docs/podcast/#{podcast}/README.md` with local link, like `feed: /podcasts/recommande/feed.rss`
- add line to `.gitignore` to **not ignore** the newly added podcast, e.g.: `!docs/**/recommande/**`
- set location of podcast as `Location::LOCAL` in `script/podcast_resources.rb`
- generate RSS link with `ruby scripts/generate_rss.rb` (run from top folder)


You should be good to go now for the server.
- set the new RSS feed link in iTunes, Spotify, etc.

## Create account and folder structure

- Create an account with `/usr/sbin/adduser podcastname` with a strong password
- login with SSH

<!-- 
- create symbolic links (and create folders if they don't exist):

````bash
# as user $PODCASTKEY
export PODCASTKEY=$USER

cp -a /opt/calvinball-website/audio/$PODCASTKEY $HOME/"$PODCASTKEY"_audio
cp -a /opt/calvinball-website/images/$PODCASTKEY/full $HOME/"$PODCASTKEY"_images
cp -a /opt/calvinball-website/resources/$PODCASTKEY $HOME/"$PODCASTKEY"_resources
cp -a /opt/calvinball-website/docs/podcasts/$PODCASTKEY/episodes $HOME/"$PODCASTKEY"_episodes

mkdir $HOME/generation_token
```

```bash
# as user yattoz for user $PODCASTKEY
rm -rf /opt/calvinball-website/audio/$PODCASTKEY
ln -s /home/$PODCASTKEY/"$PODCASTKEY"_audio /opt/calvinball-website/audio/$PODCASTKEY

rm -rf /opt/calvinball-website/images/$PODCASTKEY/full
ln -s /home/$PODCASTKEY/"$PODCASTKEY"_images /opt/calvinball-website/images/$PODCASTKEY/full

rm -rf /opt/calvinball-website/resources/$PODCASTKEY
ln -s /home/$PODCASTKEY/"$PODCASTKEY"_resources /opt/calvinball-website/resources/$PODCASTKEY

rm -rf /opt/calvinball-website/docs/podcasts/$PODCASTKEY/episodes
ln -s /home/$PODCASTKEY/"$PODCASTKEY"_episodes /opt/calvinball-website/docs/podcasts/$PODCASTKEY/episodes

```

-->

- change group ownership of the following directories to allow user `podcastname` to write on these only:
  - `audio/#{podcastname}`
  - `images/#{podcastname}`
  - `resources/#{podcastname}`
  - `docs/podcasts/#{podcastname}`

so in bash:

```bash
# as user $PODCASTKEY
export PODCASTKEY=$USER
su
```

```bash
# as root
chown -R $PODCASTKEY:developer /opt/calvinball-website/audio/$PODCASTKEY
chown -R $PODCASTKEY:developer /opt/calvinball-website/images/$PODCASTKEY
chown -R $PODCASTKEY:developer /opt/calvinball-website/resources/$PODCASTKEY
chown -R $PODCASTKEY:developer /opt/calvinball-website/docs/podcasts/$PODCASTKEY
```

This should allow user $PODCASTKEY to write on the directories they have access as a group.

Remember to chmod 775 these folders too (give RWX access to group!)

```bash
chmod 775 -R /opt/calvinball-website/audio/$PODCASTKEY
chmod 775 -R /opt/calvinball-website/images/$PODCASTKEY
chmod 775 -R /opt/calvinball-website/resources/$PODCASTKEY
chmod 775 -R /opt/calvinball-website/docs/podcasts/$PODCASTKEY
```

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

- from root account, add user to `podcasters` group to have access to `generation_token`:

```bash
/usr/sbin/usermod -G podcasters $PODCASTKEY
```


People with the account should now drop their files in the correct folders.

For ease of manipulation create a symlink to the calvinball-website folder in their home:

```bash
# as user $PODCASTKEY
ln -s /opt/calvinball-website $HOME/calvinball-website
```

## Known bug 

-
