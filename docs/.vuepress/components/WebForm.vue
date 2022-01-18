   <template>
    <fieldset>
        <legend>Générer une page d'épisode</legend>

        <div class="form-field">
            <label for="podcast_key">Podcast</label>
            <select
                name="podcast_key"
                id="podcast_key"
                @change="update_participants"
            >
                <option value="leretourdujeudi">Le Retour du Jeudi</option>
                <option value="recommande">Recommandé</option>
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
            <input
                type="text"
                name="title"
                id="title"
                placeholder="Entrez le titre..."
                required
            />
        </div>
        <div class="form-field">
            <label for="image_filename">Pochette de l'épisode (image)</label>
            <input
                type="file"
                name="image_filename"
                id="image_filename"
                accept="jpg,png"
                required
            />
        </div>
        <div class="form-field">
            <label for="episode_filename">Fichier audio</label>
            <input
                type="file"
                name="episode_filename"
                id="episode_filename"
                placeholder=""
                required
            />
        </div>
        <div class="form-field">
            <label for="datetime">Date et heure</label>
            <input
                type="datetime-local"
                name="datetime"
                id="datetime"
                required
            />
            <span>Fuseau horaire : <span id="timezone"></span></span>
        </div>
        <!--
            <div>We'll fill the Author field automagically. It's always the same for iTunes anyway.</div>
        <label for="author">Auteur (pour iTunes)</label>
        -->
        <div class="form-field">
            <label for="duration">Durée (format heures:minutes:secondes)</label>
            <input
                type="text"
                name="duration"
                id="duration"
                placeholder="HH:MM:SS"
                required
            />
        </div>
        <!-- 
            <div>We'll also create the people_link field automatically.</div>
            <div>It's easier, although it doesn't offer the full flexibility available on the website.</div>
            <div>I would need some JS to dynamically create more people_link fields and remove them... mendou</div>

            <div class="form-field">
                <button value="Send" class="submit-btn" v-on:click="add_participant()">
                    Ajouter un participant
                </button>
                <div id="participants" class="form-field">
                
                </div>
            </div>
        -->

        <div class="form-field">
            <label for="participants_list"
                >Editer la liste des participants</label
            >
            <div>
                <textarea
                    type="text"
                    name="participants_list"
                    id="participants_list"
                    @keyup="markdown_render"
                >
                </textarea>
            </div>
        </div>

        <div class="form-field">
            <label for="is_explicit">Episode réservé à un public averti</label>
            <input type="checkbox" name="is_explicit" id="is_explicit" />
        </div>

        <div class="splitview">
            <div class="vertical-grid">
                <span for="description"
                    >Description de l'épisode (Markdown)</span
                >
                <div>
                    <textarea
                        type="text"
                        name="description"
                        id="description"
                        placeholder="Ecrivez ici la description de l'épisode."
                        required
                        @keyup="markdown_render"
                    >
                    </textarea>
                </div>
            </div>
            <div class="vertical-grid">
                <span for="markdown-preview">Prévisualisation</span>
                <div id="markdown-preview"></div>
            </div>
        </div>

        <div id="alerts">

        </div>

        <div id="valid" v-if="computedIsDownload">
            <span>Les données semblent valides.</span>
        </div>

        <div class="form-field">
            <button value="Send" class="submit-btn" v-on:click="write_doc()">
                Générer
            </button>
            <button
                id="download"
                value="Send"
                class="submit-btn"
                v-on:click="download_file()"
                :disabled="!computedIsDownload">
                Télécharger
            </button>
        </div>
        <div>
            <pre><code  id="generated-markdown"></code>
        </pre>
        </div>
    </fieldset>
</template>

<script>
import MarkdownIt from "markdown-it";
import debounce from "./helpers";

export default {
    props: {
        mini: {
            type: Boolean,
            default: false,
        },
    },
    data() {
        return {
            is_download: true,
            author_key_to_name: {
                yattoz: "Yattoz",
                jok: "JoK",
                zalifalcam: "Zali Falcam",
                lyonsbanner: "Lyonsbanner",
                sonneper: "SonnePer",
                capycec: "CapyCec",
                lucile: "Lucile",
                ashki: "Ashki",
                mathieugoux: "Mathieu Goux",
                juuniper: "Juuniper",
                kalkulmatriciel: "Kalkulmatriciel",
                bob: "Bob",
                pegase: "Pegase"
            }
        }
    },
    mounted() {
        let resopt = new Intl.DateTimeFormat("default").resolvedOptions();
        document.getElementById("timezone").innerHTML = resopt["timeZone"];
        const now = new Date();
        // now.setMinutes(now.getMinutes() - now.getTimezoneOffset());
        now.setMilliseconds(null);
        now.setSeconds(null);
        document.getElementById("datetime").value = now
            .toISOString()
            .slice(0, -1);
        this.update_participants();
        this.sanitize()
    },
    computed: {
        computedIsDownload() {
            return this.is_download
        }
    },
    methods: {
        sanitize() {
            //this checks input with basic testing to ensure it corresponds to what we're expecting.
            let title = document.getElementById("title").value;
            let image_filename_withext = document
                .getElementById("image_filename")
                .value.replace(/^.*\\/, "")
            let episode_filename = document
                .getElementById("episode_filename")
                .value.replace(/^.*\\/, "");

            let date = new Date(document.getElementById("datetime").value);
            let datetime = date.toISOString().replace(/\.000Z$/, "+00:00");

            let duration = document.getElementById("duration").value;
            let description = document.getElementById("description").value;

            let podcast_key = document.getElementById("podcast_key").value;

            let res = this.default_participants();
            let author = res["author"];
            let people_link = document
                .getElementById("participants_list")
                .value
            let begin_pplk_rgx = /^- name:\s*|^\s*key: |^\s*$/
            let name_pplk_rgx = /^- name:\s*/
            let key_pplk_rgx = /^\s*key:\s*/

            console.log(people_link)

            let is_explicit = document.getElementById("is_explicit").checked;
            let duration_regex = /\d{2}:\d{2}:\d{2}/

            let alerts = []
            people_link.split("\n").forEach( (line, index, fullarray) => {
                if (!(begin_pplk_rgx.test(line)))
                {
                    alerts.push(`Erreur: la ligne ${index + 1} de la liste des participants ne commence pas par: <code>- name: \n</code> ou par <code>&nbsp;&nbsp;key: </code>`)
                } else if (name_pplk_rgx.test(line)) {
                    // it's a "-name:" line. We check that it's immediately followed by a "key" line.
                    if (index + 1 <= fullarray.length - 1)
                    {
                        let next_line = fullarray[index + 1]
                        if (!key_pplk_rgx.test(next_line))
                        {
                            alerts.push(`Erreur: la ligne ${index + 1} est une ligne avec <code>- name:</code> et doit impérativement être suivie d'une ligne avec <code>&nbsp;&nbsp;key=...</code>`)
                        }
                    } else {
                        alerts.push(`Erreur: la ligne ${index + 1} est une ligne avec <code>- name:</code> et doit impérativement être suivie d'une ligne avec <code>&nbsp;&nbsp;key: ...</code>`)
                    }
                } else if (key_pplk_rgx.test(line)) {
                    // it's a "- key:" line. We check that it's followed by either a "- name" line or a blank line
                    if (index + 1 <= fullarray.length - 1)
                    {
                        let next_line = fullarray[index + 1]
                        let blank_rgx = /^\s*$/
                        if (!name_pplk_rgx.test(next_line) && !blank_rgx.test(next_line))
                        {
                            alerts.push(`Erreur: la ligne ${index + 1} est une ligne avec <code>&nbsp;&nbsp;key: </code> et ne peut être suivie que d'une ligne vide ou d'une ligne  avec <code>- name: ...</code>`)
                        }
                    }
                }
                if (key_pplk_rgx.test(line))
                {
                    let valid_key_site_rgx = /^\s*key:\s*site=http/
                    let valid_key_twitter_rgx = /^\s*key:\s*twitter=/
                    let entered_user = line.replaceAll(/^\s*key:\s*/g, "").replace("\n", "")
                    let valid_names = Object.getOwnPropertyNames(this.author_key_to_name)
                    valid_names.pop(valid_names.findIndex( x => x == "__ob__"))

                    if (!(this.author_key_to_name.hasOwnProperty(entered_user)) && !valid_key_site_rgx.test(line) && !valid_key_twitter_rgx.test(line))
                    {
                        alerts.push(`Erreur: la ligne ${index + 1} de la liste des participants a un nom d'utilisateur invalide: <code>${entered_user}</code>.<ul><li>Les valeurs acceptées sont : ${valid_names.map(x => {return `<code>${x}</code>`})}.</li><li>Sont aussi acceptés : <code>&nbsp;&nbsp;key: site=https://unsite.com</code> et <code>&nbsp;&nbsp;key: twitter=un_identifiant_twitter</code></li></ul>`)
                    }
                    /*else if (!valid_key_site_rgx.test(line) && !valid_key_twitter_rgx.test(line))
                    {
                        alerts.push(`Erreur: la ligne ${index + 1} de la liste des participants a une valeur key invalide. Les valeurs acceptées sont, par exemple:)`
                    }
                    */
                    
                }
            })
            if (title.replaceAll(/\s/g, "").length == 0)
                alerts.push("Erreur: titre vide")
            if (description.replaceAll(/\s/g, "").length == 0)
                alerts.push("Erreur: description vide")
            if (people_link.replaceAll(/\s/g, "").length == 0)
                alerts.push("Erreur: liste des participants vide")
            if (!duration_regex.test(duration))
                alerts.push("Erreur: le format de la durée est incorrect.")
            let ext = image_filename_withext.replaceAll(/.*\./g, "")
            let valid_ext = ["jpg", "jpeg", "png", "webp"]
            if (image_filename_withext.length == 0)
                alerts.push("Erreur: fichier d'image manquant.")
            else if (!valid_ext.includes(ext))
                alerts.push("Erreur: fichier d'image non pris en charge. Valeurs acceptées: JPG, PNG, WEBP")

            if (episode_filename.length == 0)
                alerts.push("Erreur: fichier audio d'épisode manquant.")


            let alertHtmlBlock = document.getElementById("alerts")
            alertHtmlBlock.innerHTML = ""
            alerts.forEach( a => {
                let alert = `<span>${a}</span><br/>`
                alertHtmlBlock.innerHTML = `${alertHtmlBlock.innerHTML}${alert}`
            })

            let download_button = document.getElementById("download")
            this.is_download = alerts.length == 0
        },
        add_participant: function() {
            let timestamp = new Date().getTime(); // poor man's unique id
            let node = document.getElementById("participants");
            let contentHTML = `
        <div>
        <label for="${timestamp}">Nom</label>
        <input type="text" name="${timestamp}" class="people_link" placeholder="Entrez le nom..." required />
        </div>
        `;
            node.innerHTML = node.innerHTML + contentHTML;
        },
        default_participants: function () {
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
                leretourdujeudi: "kalkulmatriciel,juuniper",
                calweebball: "zalifalcam,pegase",
            };

            let author_key_to_name = this.author_key_to_name

            let podcast_key = document.getElementById("podcast_key").value;
            let author_list = key_to_author_key[podcast_key].split(",");
            let author = "";
            let people_link = "";
            author_list.forEach((author_key) => {
                if (author !== "") {
                    author = `${author}, `;
                }
                author = `${author}${author_key_to_name[author_key]}`;
                people_link = `${people_link}- name: ${author_key_to_name[author_key]}\n  key: ${author_key}\n`;
            });

            return { people_link: people_link, author: author };
        },
        update_participants() {
            let res = this.default_participants();
            document.getElementById("participants_list").value =
                res["people_link"];
        },
        markdown_render: debounce(function () {
            let description = document.getElementById("description").value;
            let md_options = {
                html: true,
                breaks: true,
                linkify: true,
                typographer: true,
            };
            let md = new MarkdownIt(md_options);

            let res = md.render(description);
            document.getElementById("markdown-preview").innerHTML = res;
            return res;
        }, 200),
        download_file() {
            // Start file download.
            // Generate download of hello.txt file with some content
            let content = this.write_doc();
            function toKebabCase(str) {
                return str && str.match(/[A-Z]{2,}(?=[A-Z][a-z]+[0-9]*|\b)|[A-Z]?[a-z]+[0-9]*|[A-Z]|[0-9]+/g)
                    .map(x => x.toLowerCase())
                    .join('-');
            }

            let date = new Date(document.getElementById("datetime").value);
            let date_only = toKebabCase(date.toLocaleDateString("ja-jp", { // you can use undefined as first argument
                year: "numeric",
                month: "2-digit",
                day: "2-digit",
            }));

            let filename = `${date_only}-${toKebabCase(document.getElementById("title").value)}.md`;
            let element = document.createElement("a");
            element.setAttribute(
                "href",
                "data:text/plain;charset=utf-8," + encodeURIComponent(content)
            );
            element.setAttribute("download", filename);

            element.style.display = "none";
            document.body.appendChild(element);

            element.click();
            document.body.removeChild(element);
        },
        write_doc() {
            let page_template = `---
title: "{{title}}"
image: "/images/{{podcast_key}}/thumbnail/{{image_filename}}"
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
`;

            let title = document.getElementById("title").value;
            let image_filename = document
                .getElementById("image_filename")
                .value.replace(/^.*\\/, "")
                .replace(/\..*$/, ".jpg");
            let episode_filename = document
                .getElementById("episode_filename")
                .value.replace(/^.*\\/, "");

            let date = new Date(document.getElementById("datetime").value);
            let datetime = date.toISOString().replace(/\.000Z$/, "+00:00");

            let duration = document.getElementById("duration").value;
            let description = document.getElementById("description").value;

            let podcast_key = document.getElementById("podcast_key").value;

            let res = this.default_participants();
            let author = res["author"];
            let people_link = document
                .getElementById("participants_list")
                .value.replaceAll(/- name:/g, "  - name:")
                .replaceAll(/key:/g, "  key:");

            let is_explicit = document.getElementById("is_explicit").checked;

            // this is an old handmade UUID generator, maybe use NPM package "uuid"
            function uuidv4() {
                return ([1e7] + -1e3 + -4e3 + -8e3 + -1e11).replace(
                    /[018]/g,
                    (c) =>
                        (
                            c ^
                            (crypto.getRandomValues(new Uint8Array(1))[0] &
                                (15 >> (c / 4)))
                        ).toString(16)
                );
            }
            let guid = uuidv4();

            let page = page_template
                .replace("{{title}}", title)
                .replaceAll("{{podcast_key}}", podcast_key)
                .replace("{{image_filename}}", image_filename)
                .replace("{{episode_filename}}", episode_filename)
                .replace("{{duration}}", duration)
                .replace("{{datetime}}", datetime)
                .replace("{{author}}", author)
                .replace("{{people_link}}", people_link)
                .replace("{{is_explicit}}", is_explicit)
                .replace("{{guid}}", guid)
                .replace("{{description}}", description);

            document.getElementById("generated-markdown").innerText = page;
            // console.log(page)
            this.sanitize()
            return page;
        },
    },
};
</script>

<style scoped>
.form-field {
    margin: 1em;
}
.splitview {
    display: grid;
    grid-template-columns: 1fr 1fr;
    gap: 2em;
}

.vertical-grid {
    display: grid;
    grid-template-rows: 1.6em 1fr;
    gap: 0.4em;
}

#participants_list {
    min-height: 7em;
}

#markdown-preview {
    border: grey 1px solid;
    border-radius: 2px;
    height: 100%;
    overflow-wrap: anywhere;
    min-height: 10em;
}

#alerts {
    color: red;
    font-weight: bolder;
}

#valid {
    color: green;
    font-weight: bold;
}

textarea {
    width: 100%;
    height: 100%;
}
</style>
