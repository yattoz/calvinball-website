   <template>
 
    <fieldset>
        <legend>Générer une page d'épisode</legend>

        <div class="form-field">
        <label for="podcast_key">Podcast</label>
        <select name="podcast_key" id="podcast_key">
            <option value="recommande">Recommandé</option>
            <option value="leretourdujeudi">Le Retour du Jeudi</option>
            <option value="lesreglesdujeu">Les Règles du Jeu</option>
            <option value="mjee">Le Meilleur Jeu Electronique Ever</option>
            <option value="lesfrancobelges">Les Franco-Belges</option>
            <option value="lebestiairedesbesties">Le Bestiaire des Besties</option>
            <option value="ksdd">KSDD</option>
            <option value="ludographie">Ludographie</option>
            <option value="calvinball">Calvinball</option>
            <option value="calweebball">Calweeb Ball</option>
            <option value="lappeldekathulu">L'appel de Kathulu</option>
            <option value="capycast">Capycast</option>
        </select>
        </div>
        <div class="form-field">
        <label for="title">Titre de l'épisode</label>
        <input type="text" name="title" id="title" placeholder="Entrez le titre..." required />
        </div>
        <div class="form-field">
        <label for="image_filename">Pochette de l'épisode (image)</label>
        <input type="file" name="image_filename" id="image_filename" accept="jpg,png" required />
        </div>
        <div class="form-field">
        <label for="episode_filename">Fichier audio</label>
        <input type="file" name="episode_filename" id="episode_filename" placeholder="" required />
        </div>
        <div class="form-field">
        <label for="datetime">Date et heure</label>
        <input type="datetime-local" name="datetime" id="datetime" required >
        <span>Fuseau horaire : <span id="timezone"></span></span>
        </div>
        <!--
            <div>We'll fill the Author field automagically. It's always the same for iTunes anyway.</div>
        <label for="author">Auteur (pour iTunes)</label>
        -->
        <div class="form-field">
        <label for="duration">Durée (format heures:minutes:secondes)</label>
        <input type="text" name="duration" id="duration" placeholder="HH:MM:SS" required>
        </div>
        <!-- 
            <div>We'll also create the people_link field automatically.</div>
            <div>It's easier, although it doesn't offer the full flexibility available on the website.</div>
            <div>I would need some JS to dynamically create more people_link fields...</div>
        -->
        <div class="form-field">
        <button value="Send" class="submit-btn" v-on:click="add_participant()">
            Ajouter un participant
        </button>
        <div id="participants" class="form-field">
        
        </div>
        </div>

        <div class="form-field">
        <label for=is_explicit>Episode réservé à un public averti</label>
        <input type="checkbox" name="is_explicit" id="is_explicit">
        </div>

        <div class="form-field">
        <label for="description">Description de l'épisode (Markdown)</label>
        <div>
        <textarea type="text" name="description" id="description" placeholder="Ecrivez ici la description de l'épisode." required
        @keyup="markdown_render" >
        </textarea>
        </div>
        </div>

        <div class="form-field">
        <button value="Send" class="submit-btn" v-on:click="write_doc()">
            Générer
        </button>
        <button value="Send" class="submit-btn" v-on:click="download_file()">
            Télécharger
        </button>
        </div>
        <div id="markdown-preview">
        </div>
        <div id="alert"><pre><code  id="generated-markdown"></code></pre></div>
    </fieldset>

</template>

<script>
import MarkdownIt from 'markdown-it';
import debounce from './helpers'

export default {
  props: {
    mini: {
      type: Boolean,
      default: false
    }
  },
  mounted() {
    let resopt = (new Intl.DateTimeFormat('default').resolvedOptions())
    document.getElementById('timezone').innerHTML = resopt["timeZone"]
    const now = new Date();
    // now.setMinutes(now.getMinutes() - now.getTimezoneOffset());
    now.setMilliseconds(null)
    now.setSeconds(null)
    document.getElementById('datetime').value = now.toISOString().slice(0, -1);
  },
  computed: {

  },
  methods: {
    add_participant() {
        let node = document.getElementById('participants')
        content = `<div>`
    },
    fill_participants() {

    },
    markdown_render: debounce(function () {        
        let description =  document.getElementById('description').value
        let md_options = {
                            html: true,
                            breaks: true,
                            linkify: true,
                            typographer: true
                            }
        let md = new MarkdownIt(md_options);

        let res = md.render(description)
        document.getElementById('markdown-preview').innerHTML = res
        return res;
    }, 200) ,
    download_file() {
        // Start file download.
        // Generate download of hello.txt file with some content
        let content = this.write_doc()
        let filename = `${document.getElementById('title').value}.md`;
        let element = document.createElement('a');
        element.setAttribute('href', 'data:text/plain;charset=utf-8,' + encodeURIComponent(content));
        element.setAttribute('download', filename);

        element.style.display = 'none';
        document.body.appendChild(element);

        element.click();
        document.body.removeChild(element);
    },
    write_doc() {
        let page_template = `
---
title: "{{title}}"
image: "/images/recommande/thumbnail/{{image_filename}}"
date: {{datetime}}

episode_mp3: "/audio/{{podcast_key}}/{{episode_filename}}"
author: "{{author}}"
duration: "{{duration}}"
people_link: 
{{people_link}}


is_explicit: {{is_explicit}}
guid: "{{guid}}"
---

<PodcastHeader/>

{{description}}
`

        let key_to_author_key = {
            recommande: "yattoz",
            lesreglesdujeu: "jok",
            mjee: "zalifalcam,jok",
            lesfrancobelges: "lyonsbanner",
            lebestiairedesbesties: "capycec,lucile",
            ksdd: "ashki",
            ludographie: "mathieugoux",
            calvinball: "zalifalcam",
            lappeldekathulu: "zalifalcam,bob",
            capycast: "capycec",
            leretourdujeudi: "kalkulmatriciel,juuniper"
        }

        let author_key_to_name = {
            yattoz: "Yattoz",
            jok: "JoK",
            zalifalcam: "Zali Falcam",
            lyonsbanner: "Lyonsbanner",
            capycec: "CapyCec",
            lucile: "Lucile",
            ashki: "Ashki",
            mathieugoux: "Mathieu Goux",
            juuniper: "Justine",
            kalkulmatriciel: "Kalkulmatriciel"
        }

        let title = document.getElementById('title').value;
        let image_filename = document.getElementById('image_filename').value.replace(/^.*\\/, "").replace(/\..*$/, ".jpg");
        let episode_filename = document.getElementById('episode_filename').value.replace(/^.*\\/, "");
        let podcast_key = document.getElementById('podcast_key').value;
        
        let date = new Date(document.getElementById('datetime').value);
        let datetime = date.toISOString().replace(/\.000Z$/, "+00:00")

        let duration = document.getElementById('duration').value;
        let description = document.getElementById('description').value;
        let author_list = key_to_author_key[podcast_key].split(",")
        let author = ""
        let people_link = ""
        author_list.forEach(author_key => {
            if (author !== "")
            {
                author = author = ", "
            }
            author = author + author_key_to_name[author_key]
            people_link = people_link + `  - name: ${author_key_to_name[author_key]}\n    key: ${author_key}\n`
        });
        let is_explicit = document.getElementById('is_explicit').checked;

        // this is an old handmade UUID generator, maybe use NPM package "uuid"
        function uuidv4() {
            return ([1e7]+-1e3+-4e3+-8e3+-1e11).replace(/[018]/g, c =>
                (c ^ crypto.getRandomValues(new Uint8Array(1))[0] & 15 >> c / 4).toString(16)
            );
        }
        let guid = uuidv4()

        let page = page_template
                    .replace("{{title}}", title)
                    .replace("{{podcast_key}}", podcast_key)
                    .replace("{{image_filename}}", image_filename)
                    .replace("{{episode_filename}}", episode_filename)
                    .replace("{{duration}}", duration)
                    .replace("{{datetime}}", datetime)
                    .replace("{{author}}", author)
                    .replace("{{people_link}}", people_link)
                    .replace("{{is_explicit}}", is_explicit)
                    .replace("{{guid}}", guid)
                    .replace("{{description}}", description)

        document.getElementById('generated-markdown').innerHTML = page
        console.log(page)
        return page
      }  
    }
}
</script>
