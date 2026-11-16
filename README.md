# 🛡️ Hébergement d'un serveur de jeu dédié & économe — Valheim sur Dell OptiPlex 3020

Projet d'auto-hébergement et d'administration système d'un serveur privé multijoueur pour le jeu **Valheim** sur un PC de bureau reconditionné (**Dell OptiPlex 3020** de 2014) issu d'une opération de recyclage informatique de mon département **BUT Réseaux & Télécommunications**, sous **Debian 13**. L'objectif est d'offrir un serveur de jeu à mon groupe d'amis en garantissant la sécurité réseau et en diminuant la consommation électrique.

---

## 🎯 Pourquoi ce projet ? (Contexte & Objectifs)

Louer un serveur de jeu en ligne représente un coût mensuel récurrent et limite le contrôle sur l'infrastructure. J'ai choisi d'auto-héberger ce service chez moi autour de trois axes :
1. **Valorisation matérielle (Green IT) :** Donner une seconde vie utile à un ancien poste Dell OptiPlex du département BUT R&T, récupéré dans le cadre du recyclage du parc informatique de l'université.
2. **Sobriété énergétique :** Éviter qu'un serveur tourne inutilement la nuit et le matin grâce à un cycle d'allumage et d'extinction automatisé.
3. **Sécurité et exposition réseau :** Permettre à mes amis distants de se connecter depuis Internet sans exposer le reste de mon réseau domestique.

---

## 🏗️ Architecture matérielle et logicielle

| Composant | Choix technique | Vulgarisation (Pourquoi ce choix ?) |
| :--- | :--- | :--- |
| **Machine hôte** | **Dell OptiPlex 3020** (Intel Core i5-4570 @ 3.20 GHz, 8 Go RAM) | Ancien poste de salle de TP (BUT R&T) compact, silencieux et robuste, capable d'absorber la charge du serveur de jeu sans ralentissement. |
| **Système (OS)** | **Debian 13 (Trixie)** sans interface graphique (*Headless*) | Aucun bureau graphique affiché à l'écran : 100 % de la mémoire vive et du processeur sont dédiés au jeu. |
| **Automatisation** | Service **systemd** (`valheim.service`) | Dès que l'ordinateur s'allume, le serveur de jeu démarre automatiquement en arrière-plan sans aucune action manuelle. |
| **Pare-feu local** | **UFW** (*Uncomplicated Firewall*) | Bloque toutes les connexions entrantes par défaut et n'autorise que le trafic du jeu (`2456-2458/udp`) et l'accès administrateur (`22/tcp` SSH). |
---

## ⚡ Gestion intelligente de l'énergie (Cycle 12h00 / 00h00)

Un serveur de jeu personnel n'a aucune utilité la nuit ou en matinée pendant les cours. Pour réduire l'empreinte énergétique et la facture d'électricité, j'ai combiné deux mécanismes :

1. **Réveil matériel via le BIOS (RTC Wake) à 12h00 :** L'horloge interne de la carte mère démarre automatiquement l'ordinateur chaque midi. Le service `systemd` lance immédiatement le monde Valheim.
2. **Extinction logicielle via `crontab` à 00h00 :** Une tâche planifiée ordonne l'arrêt propre du système (`/sbin/shutdown -h now`).
3. **Sauvegarde garantie à l'arrêt (`KillSignal=SIGINT`) :** Lors de l'extinction du PC, `systemd` envoie un signal d'interruption doux au serveur de jeu pour forcer la sauvegarde complète du monde avant la coupure électrique.

> **Bilan énergétique :** Le serveur est éteint **12 heures par jour** pendant les périodes d'inactivité, divisant par deux sa consommation électrique quotidienne.

---

## 🌐 Architecture Réseau & Sécurité (Freebox OS + UFW)

Pour rendre le serveur accessible depuis Internet tout en protégeant le réseau local :
- **IP locale fixe :** Le Dell OptiPlex dispose d'une adresse IP statique sur le réseau domestique (`192.168.1.179`).
- **Redirection de ports (NAT/PAT) :** Sur l'interface **Freebox OS**, seuls les ports **UDP 2456 à 2458** sont redirigés vers le serveur.
- **Durcissement système :** La mise en veille automatique de Debian est désactivée (`sleep.target` masqué) pour éviter toute déconnexion des joueurs en pleine partie, et le serveur tourne sous un utilisateur Linux non-privilégié.

---

## 📁 Contenu du dépôt

- `README.md` : Présentation vulgarisée et architecture du projet.
- `scripts/valheim.service` : Définition du service `systemd` (démarrage automatique, redémarrage en cas de crash, arrêt propre).
- `scripts/start_valheim.sh` : Script de lancement du binaire serveur (version anonymisée).
- `scripts/crontab.txt` : Planification de l'extinction nocturne automatique à minuit.
- `docs/` : Captures d'écran de validation (configuration pare-feu `ufw`, redirection NAT Freebox OS et informations système).
