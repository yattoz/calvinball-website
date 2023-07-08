import { debounce } from './helpers.js'

export class WebForm {

    constructor() {
        this.is_download = true
        this.author_key_to_name = {
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
            pegase: "Pegase",
            framboise: "Framboise",
            ttol: "Ttol",
            gru: "Gru",
            jok: "JoK",
            milanmorales: "Milan Morales",
            nady: "Nady",
            samuelleveque: "Samuel Lévèque"
        }

        document.getElementById("podcast_key").addEventListener( 
            'change', () => { this.update_participants(); });
        document.getElementById("write_doc").addEventListener(
            'click', () => { this.write_doc(); });
        document.getElementById("download").addEventListener(
            'click', () => { this.download_file(); });
        document.getElementById("clear_storage").addEventListener(
            'click', () => { this.clear_storage(); });
        document.getElementById("datetime").addEventListener(
            'change', () => { this.update_datetime(); });
        document.getElementById("is_explicit").addEventListener(
            'click', () => { this.periodic_save(); });
        document.getElementById("title").addEventListener(
            'keyup', () => { this.periodic_save(); });
        document.getElementById("duration").addEventListener(
            'keyup', () => { this.periodic_save(); });
        document.getElementById("participants_list").addEventListener(
            'keyup', () => { this.periodic_save(); });
        document.getElementById("description").addEventListener(
            'keyup', () => { this.markdown_render(); });
        document.getElementById("reset-datetime").addEventListener(
             'click', () => { this.reset_datetime(); });
                
        this.load_storage();
        this.sanitize();
    }

    setComputedIsDownload(bool) {
        this.is_download = bool;
        let valid = document.getElementById("valid");
        let download = document.getElementById("download");

        if (!this.computedIsDownload()) {
            valid.setAttribute('hidden', !this.computedIsDownload());
            download.setAttribute('disabled', !this.computedIsDownload());
        } else {
            valid.removeAttribute('hidden');
            download.removeAttribute('disabled');
        }
    }

    computedIsDownload() {
        return this.is_download;
    }

    save_storage() {
        let podcast_key_ = document.getElementById("podcast_key").value
        let title_ = document.getElementById("title").value
        // let image_filename_ = document.getElementById("image_filename").value
        // let audio_filename_ =  document.getElementById("audio_filename").value
        let date_ = document.getElementById("datetime").value
        let duration_ = document.getElementById("duration").value
        let description_ = document.getElementById("description").value
        let people_link_ = document.getElementById("participants_list").value
        let is_explicit_ = document.getElementById("is_explicit").checked

        let localStorage = window.localStorage
        localStorage.setItem("podcast_key", podcast_key_)
        localStorage.setItem("title", title_)
        // localStorage.setItem("image_filename", image_filename_)
        // localStorage.setItem("audio_filename", audio_filename_)
        // localStorage.setItem("date", date_)
        localStorage.setItem("duration", duration_)
        localStorage.setItem("description", description_)
        localStorage.setItem("people_link", people_link_)
        localStorage.setItem("is_explicit", is_explicit_)
    }
    load_storage() {
        let podcast_key_ = document.getElementById("podcast_key")
        let title_ = document.getElementById("title")
        // let image_filename_ = document.getElementById("image_filename")
        // let audio_filename_ =  document.getElementById("audio_filename")
        let date_ = document.getElementById("datetime")
        let duration_ = document.getElementById("duration")
        let description_ = document.getElementById("description")
        let people_link_ = document.getElementById("participants_list")
        let is_explicit_ = document.getElementById("is_explicit")

        let localStorage = window.localStorage
        let podcast_key = localStorage.getItem("podcast_key")
        let title = localStorage.getItem("title")
        // let image_filename = localStorage.getItem("image_filename")
        // let audio_filename = localStorage.getItem("audio_filename")
        let date = localStorage.getItem("date")
        let duration = localStorage.getItem("duration")
        let description = localStorage.getItem("description")
        let people_link = localStorage.getItem("people_link")
        let is_explicit = localStorage.getItem("is_explicit")

        podcast_key_.value = podcast_key
        title_.value = title
        // image_filename_.value = image_filename
        // audio_filename_.value = audio_filename
        date_.value = date
        duration_.value = duration
        description_.value = description
        people_link_.value = people_link
        is_explicit_.checked = (is_explicit == "true" ? true : false)

        // initialize fields that may be empty        
        let resopt = new Intl.DateTimeFormat("default").resolvedOptions();
        document.getElementById("timezone").innerHTML = resopt["timeZone"];
        /* if (document.getElementById("datetime").value == "") */
        // default behaviour: set time to NOW. Makes much, much more sense.
        this.reset_datetime()
        this.update_datetime()

        if (document.getElementById("podcast_key").value == "")
            document.getElementById("podcast_key").value = "calvinball"

        if (document.getElementById("participants_list").value == "")
            this.update_participants();


        this.markdown_render()
    }
    clear_storage() {
        let c = window.confirm("Êtes-vous sûr.sure de vouloir supprimer toutes les informations sur cette page ?");
        if (c) {
            // I don't use localStorage.clear() because a lot of other stuff is stored, like dark theme or play position for podcast
            localStorage.setItem("podcast_key", "")
            localStorage.setItem("title", "")
            // localStorage.setItem("image_filename", image_filename_)
            // localStorage.setItem("audio_filename", audio_filename_)
            localStorage.setItem("date", "")
            localStorage.setItem("duration", "")
            localStorage.setItem("description", "")
            localStorage.setItem("people_link", "")
            localStorage.setItem("is_explicit", "")

            this.load_storage()
            this.update_datetime();
        } else {

        }
    }

    sanitize() {
        //this checks input with basic testing to ensure it corresponds to what we're expecting.
        let title = document.getElementById("title").value;
        let image_filename_withext = document
            .getElementById("image_filename")
            .value.replace(/^.*\\/, "")
        let audio_filename = document
            .getElementById("audio_filename")
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
        let begin_pplk_rgx = /^- name: *|^  key: |^\s*$/
        let name_pplk_rgx = /^- name: */
        let key_pplk_rgx = /^  key: */

        let is_explicit = document.getElementById("is_explicit").checked;
        let duration_regex = /\d{2}:\d{2}:\d{2}/

        let alerts = []
        people_link.split("\n").forEach((line, index, fullarray) => {
            if (!(begin_pplk_rgx.test(line))) {
                alerts.push(`Erreur: la ligne ${index + 1} de la liste des participants ne commence pas par: <code>- name: \n</code> ou par <code>&nbsp;&nbsp;key: </code> (deux espaces suivies du mot <code>key</code>).`)
            } else if (name_pplk_rgx.test(line)) {
                // it's a "-name:" line. We check that it's immediately followed by a "key" line.
                if (index + 1 <= fullarray.length - 1) {
                    let next_line = fullarray[index + 1]
                    if (!key_pplk_rgx.test(next_line)) {
                        alerts.push(`Erreur: la ligne ${index + 1} est une ligne avec <code>- name:</code> et doit impérativement être suivie d'une ligne avec <code>&nbsp;&nbsp;key=...</code>`)
                    }
                } else {
                    alerts.push(`Erreur: la ligne ${index + 1} est une ligne avec <code>- name:</code> et doit impérativement être suivie d'une ligne avec <code>&nbsp;&nbsp;key: ...</code>`)
                }
            } else if (key_pplk_rgx.test(line)) {
                // it's a "- key:" line. We check that it's followed by either a "- name" line or a blank line
                if (index + 1 <= fullarray.length - 1) {
                    let next_line = fullarray[index + 1]
                    let blank_rgx = /^\s*$/
                    if (!name_pplk_rgx.test(next_line) && !blank_rgx.test(next_line)) {
                        alerts.push(`Erreur: la ligne ${index + 1} est une ligne avec <code>&nbsp;&nbsp;key: </code> et ne peut être suivie que d'une ligne vide ou d'une ligne  avec <code>- name: ...</code>`)
                    }
                }
            }
            if (key_pplk_rgx.test(line)) {
                let valid_key_site_rgx = /^\s*key:\s*site=http/
                let valid_key_twitter_rgx = /^\s*key:\s*twitter=/
                let valid_key_none_rgx = /^\s*key:\s*none\s*/
                let entered_user = line.replaceAll(/^\s*key:\s*/g, "").replace("\n", "")
                let valid_names = Object.getOwnPropertyNames(this.author_key_to_name)
                valid_names.pop(valid_names.findIndex(x => x == "__ob__"))

                if (!(this.author_key_to_name.hasOwnProperty(entered_user)) && !valid_key_none_rgx.test(line) && !valid_key_site_rgx.test(line) && !valid_key_twitter_rgx.test(line)) {
                    alerts.push(`Erreur: la ligne ${index + 1} de la liste des participants a un valeur key invalide: <code>${entered_user}</code>.<ul><li>Les valeurs acceptées sont : ${valid_names.map(x => { return `<code>${x}</code>` })},<code>none</code>.</li><li>Sont aussi acceptés : <code>&nbsp;&nbsp;key: site=https://unsite.com</code> et <code>&nbsp;&nbsp;key: twitter=un_identifiant_twitter</code></li></ul>`)
                }
            }
        })
        if (title.replaceAll(/\s/g, "").length == 0)
            alerts.push("Erreur: titre vide")
        if (description.replaceAll(/\s/g, "").length == 0)
            alerts.push("Erreur: description vide")
        if (people_link.replaceAll(/\s/g, "").length == 0)
            alerts.push("Erreur: liste des participants vide")
        if (!duration_regex.test(duration)) {
            alerts.push("Erreur: durée incorrecte.")
        } else if (duration.split(":").map(x => { return (parseInt(x) > 59) }).reduce((prev, cur) => { return prev | cur })) {
            alerts.push("Erreur: durée incorrecte - les valeurs HH:MM:SS de la durée doivent être compris entre 00 et 59.")
        }
        let ext = image_filename_withext.replaceAll(/.*\./g, "")
        let valid_ext = ["jpg", "jpeg", "png", "webp"]
        let filename_rgx = /^[a-zA-Z0-9\s\_\-\.=]*$/
        if (image_filename_withext.length == 0)
            alerts.push("Erreur: fichier image manquant.")
        else if (!valid_ext.includes(ext))
            alerts.push("Erreur: fichier image non pris en charge. Valeurs acceptées: JPG, PNG, WEBP")
        else if (!filename_rgx.test(image_filename_withext))
            alerts.push("Erreur: caractères non valides dans le nom du fichier image. Les caractères admis sont: <code>a-z A-Z 0-9 _ - = . [espaces]</code>")

        let audio_ext = audio_filename.replaceAll(/.*\./g, "")
        let valid_audio_ext = ["mp3", "ogg", "flac", "wav"]
        if (audio_filename.length == 0)
            alerts.push("Erreur: fichier audio manquant.")
        else if (!valid_audio_ext.includes(audio_ext))
            alerts.push("Erreur: fichier audio non pris en charge. Valeurs acceptées: MP3, OGG, FLAC, WAV")
        else if (!filename_rgx.test(audio_filename))
            alerts.push("Erreur: caractères non valides dans le nom du fichier audio. Les caractères admis sont: <code>a-z A-Z 0-9 _ - = . [espaces]</code>")


        let alertHtmlBlock = document.getElementById("alerts")
        alertHtmlBlock.innerHTML = ""
        alerts.forEach(a => {
            let alert = `<span>${a}</span><br/>`
            alertHtmlBlock.innerHTML = `${alertHtmlBlock.innerHTML}${alert}`
        })

        let download_button = document.getElementById("download")
        this.setComputedIsDownload(alerts.length == 0);
    }
    add_participant() {
        let timestamp = new Date().getTime(); // poor man's unique id
        let node = document.getElementById("participants");
        let contentHTML = `
        <div>
        <label for="${timestamp}">Nom</label>
        <input type="text" name="${timestamp}" class="people_link" placeholder="Entrez le nom..." required />
        </div>
        `;
        node.innerHTML = node.innerHTML + contentHTML;
    }
    default_participants() {
        let key_to_author_key = {
            recommande: "yattoz",
            lesreglesdujeu: "jok",
            mjee: "zalifalcam,jok",
            lesfrancobelges: "lyonsbanner,sonneper,milanmorales,capycec",
            lebestiairedesbesties: "capycec,lucile",
            ksdd: "ashki",
            ludographie: "mathieugoux",
            calvinball: "zalifalcam",
            lappeldekathulu: "zalifalcam,bob",
            capycast: "capycec",
            leretourdujeudi: "kalkulmatriciel,juuniper",
            calweebball: "zalifalcam,pegase",
            crousti: "framboise",
            variantepourdeux: "ttol",
            potirongeur: "gru",
            lesreglesdujeu: "jok",
            maitrechien: "zalifalcam",
            histoiresvisuelles: "nady",
            cecinestpasungroupe: "zalifalcam",
            labandeapixel: "zalifalcam",
            intppodcasts: "samuelleveque"
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
    }
    reset_datetime() {
        let dateHtml = document.getElementById("datetime");
        let datenow = new Date()
        let resopt = new Intl.DateTimeFormat("default").resolvedOptions();
        document.getElementById("timezone").innerHTML = resopt["timeZone"];
        let formatter = new Intl.DateTimeFormat("fr-FR", { dateStyle: 'full', timeStyle: 'long' });
        let human_datetime = formatter.format(datenow);

        datenow.setHours(datenow.getHours() - ( datenow.getTimezoneOffset() / 60) )
        let datenow_str = datenow.toISOString().replace(/:\d{2}.\d{3}Z/, "");
        
        console.log(datenow_str);
        dateHtml.value = datenow_str;
        this.update_datetime();
    }
    update_datetime() {
        let date = new Date(document.getElementById("datetime").value);
        let formatter = new Intl.DateTimeFormat("fr-FR", { dateStyle: 'full', timeStyle: 'long' });
        let human_datetime = formatter.format(date);
        document.getElementById("human-datetime").innerHTML = human_datetime;
        let current_date = new Date();
        let days_in_the_past = Math.floor(((current_date - date)/1000) / (24*60*60));
        console.log(days_in_the_past);
        if (days_in_the_past < 1)
        {
            document.getElementById("warning-datetime").innerHTML = "";
        } else {
            document.getElementById("warning-datetime").innerHTML = `Attention: la date entrée est : ${human_datetime}. C'est ${days_in_the_past} jours dans le passé !<br/>Êtes vous sûr de vouloir publier un épisode à une date dans le passé ?`;
        }
        
        this.periodic_save();
    }
    update_participants() {
        let res = this.default_participants();
        document.getElementById("participants_list").value =
            res["people_link"];
        this.periodic_save();
    }
    periodic_save = debounce(() =>
            {
            this.save_storage()
            let s = "Data savec at " + (new Date)
            console.log(s)
        }, 1500)

    markdown_render = debounce(() => {

            let description = document.getElementById("description").value;
            let md_options = {
                html: true,
                breaks: true,
                linkify: true,
                typographer: true,
            };
            let md = window.markdownit(md_options); // imported from a CDN
            let res = md.render(description);
            document.getElementById("markdown-preview").innerHTML = res;
            this.periodic_save();
            return res;
        }, 200)

    download_file() {
        // Start file download.
        // Generate download of hello.txt file with some content
        let content = this.write_doc();
        const toKebabCase = function(str) {
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
    }
    write_doc() {
        let page_template = `---
title: "{{title}}"
image: "/images/{{podcast_key}}/thumbnail/{{image_filename}}"
date: {{datetime}}

episode_mp3: "/audio/{{podcast_key}}/{{audio_filename}}"
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

        this.save_storage()

        let title = document.getElementById("title").value;
        let image_filename = document
            .getElementById("image_filename")
            .value.replace(/^.*\\/, "")
            .replace(/\..*$/, ".jpg");
        let audio_filename = document
            .getElementById("audio_filename")
            .value.replace(/^.*\\/, "");

        let date = new Date(document.getElementById("datetime").value);
        let datetime = date.toISOString().replace(/\.000Z$/, "+00:00");

        let duration = document.getElementById("duration").value;
        let description = document.getElementById("description").value;

        let podcast_key = document.getElementById("podcast_key").value;
        // I fucked up when naming a podcastkey with a dash. I shouldn't have done that. I won't in the future.

        let res = this.default_participants();
        let author = res["author"];
        let people_link = document
            .getElementById("participants_list")
            .value.replaceAll(/- name:/g, "  - name:")
            .replaceAll(/key:/g, "  key:");

        let is_explicit = document.getElementById("is_explicit").checked;

        // this is an old handmade UUID generator, maybe use NPM package "uuid"
        const uuidv4 = function() {
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
            .replace("{{audio_filename}}", audio_filename)
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
    }
}

new WebForm();
