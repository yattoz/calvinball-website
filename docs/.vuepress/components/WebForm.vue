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
            <option value="capycast">capycast</option>
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
        <label for=is_explicit>Episode réservé à un public averti</label>
        <input type="checkbox" name="is_explicit" id="is_explicit">
        </div>

        <div class="form-field">
        <label for="description">Description de l'épisode (Markdown)</label>
        <div>
        <textarea type="text" name="description" id="description" placeholder="Ecrivez ici la description de l'épisode." required>
        </textarea>
        </div>
        </div>

        <div class="form-field">
        <button value="Send" class="submit-btn" v-on:click="write_doc()">
            Générer
        </button>
        </div>

        <div id="alert"><pre><code  id="generated-markdown"></code></pre></div>
    </fieldset>

</template>

<script>
import MarkdownIt from 'markdown-it';

export default {
  props: {
    mini: {
      type: Boolean,
      default: false
    }
  },
  mounted() {

  },
  methods: {

      write_doc() {
        let page_template = `
---
title: "{{title}}"
image: "/images/recommande/thumbnail/{{image_filename}}.jpg"
date: {{datetime}}

episode_mp3: "/audio/{{podcast_key}}/{{episode_filename}}.mp3"
author: "{{author}}"
duration: "{{duration}}"
people_link: 
{{people_link}}


is_explicit: {{is_explicit}}
guid: "{{guid}}"
---

<PodcastHeader/>

<!-- ECRIRE LA DESCRIPTION DE L'EPISODE SOUS CETTE LIGNE -->
{{description}}
`

        let key_to_author_key = {
            recommande: "yattoz",
            lesreglesdujeu: "jok",
            mjee: "zalifalcam,jok",
            lesfrancobelges: "lyonsbanner",
            lebestiairedesbesties: "capycec,lucille",
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
        let image_filename = document.getElementById('image_filename').value;
        let episode_filename = document.getElementById('episode_filename').value;
        let podcast_key = document.getElementById('podcast_key').value;
        let datetime = document.getElementById('datetime').value;
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
      }  
    }
}
</script>
