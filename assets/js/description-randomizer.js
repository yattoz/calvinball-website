// import { debounce } from './helpers.js'
// import { debounce } from './helpers.js'

export class DescriptionRandomizer {

    constructor() {
        // console.log("description randomizer start!")
        let description = document.getElementsByClassName("description")[0];

        let source = `Nous sommes faisant des podcasts pour écouter
Au Calvinball Consortium, on n’est pas que sortium
nous sommes faisant pros des podcasts pour écouter
Calvinball Consortium : garantis sans balles
Le premier* réseau de podcast au MONDE (*dans le coeur de ses auditeurs)
Calvin Quoi qu’on sort truc ?
Hey c’est moi Imoën, c’est bon de vous revoir !
Le berceau du fameux Mishima contre le caca
Calvinball le podcast des Héros… Calvinball le podcast des Héros
Incubateur de bizarreries auditives depuis plus d’un lustre
On n’a rien à dire, mais on le fait bien
Maman regarde je suis dans l’internet !
Si ju podcaste, c’est Calvinball ! 
Hey ! Listen !
Enfin de quoi discuter chez le coiffeur
Sur les épaules du néant
Premiers sur la shittyflute
Toujours faim à 11h
Hmm les bons podcasts de l’amitier
Plus de mille heures de son pour vos bonnes oreilles
Parce que ce sont vous. Parce que ce sommes nous.
Barrez-vous !
Non approuvé par Bill Watterson
L’aristocratie de la podcasterie réunie
Des popcasses pour toute la famille (sauf tonton Jean-Mich’)
Est-ce que vous nous entendez hey ho ?
Des podcasts moins pires que les plus mauvais
Garanti sans trop d’effets secondaires
Le bon podcast bien de chez nous (enfin par là)
Et je pense que ce jeu devrait faire partie de votre Ludographie.
Qu’as-tu lu ?
BONJOUREUH
Azul, c’est joli !
Et surtout, restez cool !
Crousti n’est pas financé par l’association des producteurs de croûtons à l’ail
Vous connaissez Shining Force II ?
On n’y comprend rien, venez nous expliquer sur Discord
JEREMY !!!!
“Ce soir-là, le reflet d’un chien humanoïde lui avait annoncé que la Fin du Monde aurait lieu ici, pendant cette année scolaire qui devait débuter dans quelques jours.”
Pour dix milliards d’euros sur le Patreon, on fait une comédie musicale.
Avec l’airbag de série
Avec de vrais morceaux dedans
Premier sur les grobatos
Comme son nom l’indique
Les huîtres c’est surfait
La force tranquille
Ce pocdast n’est pas un pocdast sur le cyclimse
Six saisons et un light novel
Si Avrelle revient j’annule tout
Shar-Teel se barre, comme ça, avec mon loot ? Sérieux ?
Keep calm and Wololo
Si vis pacem, para bailar la bamba
Pioche
Au format généreusement aléatoire`
        let source_split = source.split("\n");
        let random_number = Math.floor(Math.random() * source_split.length);
        description.innerHTML = source_split[random_number]
    }

}

new DescriptionRandomizer();
