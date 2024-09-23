#!/bin/bash

# Ce script est utilisé pour faciliter la prise de décision lorsqu'un ticket ITSM arrive.
# Il permet de gagner du temps et de garder ses cheveux encore quelques années.

###############################################
#   SECTION DROITS D'AUTEUR ET CONTRIBUTION   #
###############################################

# Ce script est sous licence WTFPL et est offert par Alexandre Coilier avec grande sympathie.
# Vous pouvez l'utiliser, le modifier et le distribuer à votre guise.
# Licence WFTPL : https://fr.wikipedia.org/wiki/WTFPL
# Vous pouvez participer à l'amélioration de ce script en soumettant une pull request sur le dépôt GitHub.
# Dépôt GitHub : https://github.com/acoilier/KeepCalmAndSendTheTicket
# Wiki du projet : https://github.com/acoilier/KeepCalmAndSendTheTicket/wiki

###############################################
#                SECTION UTILISATION          #
###############################################

# Fonction d'aide pour afficher l'utilisation
utilisation() {
  echo "Utilisation : $0 [contenu_du_ticket]"
  echo
  echo "Arguments :"
  echo "  contenu_du_ticket  Le contenu du ticket ITSM à analyser"
  echo
  echo "Options :"
  echo "  -h, --help         Affiche ce message d'aide"
}

# Vérifie si l'utilisateur a passé -h ou --help
if [[ "$1" == "-h" || "$1" == "--help" ]]; then
  utilisation
  exit 0
fi

# Vérifie si un contenu de ticket est fourni en argument
if [[ -z "$1" ]]; then
  echo -e "\e[31mErreur : Aucun contenu de ticket fourni. Veuillez fournir le contenu en tant qu'argument.\e[0m"
  utilisation
  exit 1
fi

###############################################
#              SECTION FONCTIONS              #
###############################################

# Fonction pour vérifier si "celui-dont-on-ne-doit-pas-prononcer-le-nom" est présent
celui_dont_on_ne_doit_pas_prononcer_le_nom() {
  read -p "Est-ce que 'celui_dont_on_ne_doit_pas_prononcer_le_nom' est présent ? [O/n] " reponse
  reponse=${reponse:-O}
  if [[ "$reponse" =~ ^[Oo]$ ]]; then
    return 0  # Retourne 0 pour vrai s'il est présent
  else
    return 1  # Retourne 1 pour faux s'il n'est pas présent
  fi
}

# Fonction pour suggérer des tâches de procrastination
procrastiner() {
  taches=("Prendre une pause café" "Regarder des vidéos de chats" "Passer au support N1 pour dire que votre PC chauffe" "Envoyer des GIF à vos collègues" "Travailer sur des dashboard Grafana")
  echo "Tâche de procrastination suggérée : ${taches[$RANDOM % ${#taches[@]}]}"
}

# Liste des sujets blackbox à rechercher dans le ticket
# Cette liste n'est pas exhaustive, la vie est pleine de surprises
BLACKBOX_SUJET=("k8s" "kub" "kubernetes" "NSX" "Checkpoint" "forti" "web_proxy")

# Convertir le contenu du ticket en minuscules et le diviser en mots
itsm=$(echo "$1" | tr '[:upper:]' '[:lower:]')
IFS=' ' read -r -a mots <<< "$itsm"

# On va considérer qu'il n'y a pas de sujet blackbox trouvé par défaut.
sujet_blackbox_trouve=false

# Vérifier chaque mot du ticket par rapport au sujet blackbox.
for mot in "${mots[@]}"; do
  for sujet in "${BLACKBOX_SUJET[@]}"; do
    if [[ "$mot" == "$sujet" ]]; then
      sujet_blackbox_trouve=true
      sujet_blackbox_trouve_mot=$mot
      break 2  # Sort des deux boucles si une correspondance est trouvée
    fi
  done
done

###############################################
#               SECTION SCRIPT                #
###############################################

# Si un sujet blackbox est trouvé, afficher un message approprié
if $sujet_blackbox_trouve; then
  doc="null" # On peut donc condidérer que la doc n'est pas présente par défaut.
  mode_archeologie="true" # Et considérer également que le mode archéologie est a activé par défaut.
  echo -e "Sujet blackbox détecté dans le ticket : \e[31m$sujet_blackbox_trouve_mot\e[0m"
  # Vérifier si celui_dont_on_ne_doit_pas_prononcer_le_nom est présent
  if celui_dont_on_ne_doit_pas_prononcer_le_nom; then
    echo "Il va gérer ça, pas de soucis."
    echo "Keep Calm and Send the Ticket"
  else
    echo "Gardez votre calme et armez vous de patience, l'enquête commence !"
    echo "n'oubliez pas de fouiller 'Le Grimoire des Savoirs Égarés'."
    echo "Après tout, même une horloge cassée a raison deux fois par jour !"
    echo "https://github.com/acoilier/KeepCalmAndSendTheTicket/wiki"
    procrastiner
  fi
  exit 0
fi

# Si aucun sujet blackbox n'est trouvé, sortie réussie
echo "Aucun sujet blackbox détecté, tout va bien."
exit 0
