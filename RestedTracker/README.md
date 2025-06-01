# RestedTracker

## by Kyrine

## Description / Description

**French :**
RestedTracker est un addon simple et léger pour WoW Classic qui vous permet de suivre facilement l’état de l’XP de repos de tous vos personnages, y compris vos rerolls. Grâce à une icône pratique près de la minimap, vous pouvez rapidement voir le pourcentage d’XP de repos de chaque personnage et basculer entre l’affichage des personnages du royaume actuel ou de tous les royaumes. L’addon estime également automatiquement l’augmentation d’XP de repos pendant vos déconnexions et sauvegarde vos données entre les sessions.

**English :**
RestedTracker is a lightweight and simple addon for WoW Classic that lets you easily track the rested XP status of all your characters, including your alts. With a convenient icon near the minimap, you can quickly see each character’s rested XP percentage and toggle between showing characters from your current realm or all realms. The addon also automatically estimates rested XP gain during offline time and saves your data across sessions.

## Fonctionnalités / Features

- Affichage clair et simple du pourcentage d’XP de repos / Clear and simple display of rested XP percentages
- Toggle pour afficher uniquement les personnages du royaume actuel ou de tous les royaumes / Toggle between showing only current realm or all realms
- Estimation automatique de la progression du repos hors ligne / Automatic offline rested XP gain estimation
- Sauvegarde automatique des données entre les sessions / Automatic data saving between sessions
- Compatible WoW Classic, léger, sans dépendances lourdes / Compatible with WoW Classic, lightweight, no heavy dependencies

## Installation / Installation

1. Placez le dossier `RestedTracker` dans le dossier `Interface/AddOns/` de WoW / Place the `RestedTracker` folder into your WoW `Interface/AddOns/` folder
2. Assurez-vous que `LibDataBroker-1.1` et `LibDBIcon-1.0` sont installés, nécessaires pour l’icône minimap / Make sure `LibDataBroker-1.1` and `LibDBIcon-1.0` are installed, required for the minimap icon
3. Activez l’addon dans la liste des addons au lancement du jeu / Enable the addon in your addons list on game launch
4. Profitez du suivi facile de votre XP de repos / Enjoy easy tracking of your rested XP

## Licence / License

MIT License - Free to use and modify
Développé par Kyrine

## Suggestion/feature

### 🔧 Suggestions techniques

1. Affichage dynamique dans le tooltip
➡️ Ajout de la classe ou d’une icône de classe (comme Interface\\Icons\\ClassIcon_Mage, etc.)
👉 Ça rendrait le tooltip visuellement plus clair, surtout si on a beaucoup de rerolls.

2. Support de session multi-compte
➡️ Actuellement, les données sont enregistrées par Nom-Royaume, mais si tu joues avec plusieurs comptes sur un même client, tu pourrais ajouter GetAccountExpansionLevel() ou un suffixe par compte.
👉 Ça évite d’écraser des données si tu joues avec plusieurs Battle.net.

3. Couleur personnalisable dans le tooltip
➡️ Laisser l’utilisateur configurer les seuils de couleur via une commande slash ou un petit fichier config.

4. Ajout d’un slash command
➡️ Exemple : /restedtracker showall on|off
👉 C’est une manière rapide de modifier le comportement sans clic droit.

5. Compression du stockage
➡️ Enregistrer restedXP et logoutTime, et calculer à l’affichage au lieu de sauvegarder des restedPercent fixes.
👉 Évite d’avoir à "mettre à jour" les valeurs de tous les persos à chaque session.

### 🧠 UX / Idées côté joueur

6. Mini notification lors de la connexion
➡️ Afficher dans le chat : "Vous avez 5 rerolls à 150% XP de repos"
👉 Un rappel sympa pour optimiser son temps de jeu.

7. Ajout d’un tri dans le tooltip
➡️ Exemple : afficher en haut les rerolls ayant le plus d’XP reposée, ou les moins avancés.
👉 Pratique pour prioriser qui jouer.

8. Intégration avec d’autres addons
➡️ Si tu utilises un gestionnaire de personnages (genre Altoholic), tu pourrais lire leurs données pour enrichir le tooltip.

### ✨ Futur éventuel (non essentiel)
Interface de configuration (Interface Options Addon Panel)

Export JSON ou texte des stats (pour ceux qui font du suivi externe)

Affichage mobile (si tu veux un companion via WeakAura ou autre)
