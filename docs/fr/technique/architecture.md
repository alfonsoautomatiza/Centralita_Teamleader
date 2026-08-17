---
title: Architecture de Centralita ia Teamleader
description: Vue technique des composants de détection, enregistrement, traitement ia, récupération et intégration Teamleader.
lang: fr
tags:
  - contexto/proyecto/manual

---

# Architecture du Système

## Contexte de l'Application

### Description
Système de gestion des appels avec IA qui intègre la téléphonie, l'enregistrement audio, la transcription automatique avec intelligence artificielle et la synchronisation avec les CRMs comme Teamleader. Il centralise la gestion des appels entrants/sortants, automatise le résumé des conversations et maintient un enregistrement structuré de toutes les interactions.

### Stack Technologique
- **OBS Studio** : Enregistrement audio du système (optionnel)
- **OpenRouter API** : Transcription avec IA (Google Gemini)
- **Teamleader API** : Intégration avec CRM

### Public Cible
PME françaises qui utilisent Teamleader comme CRM et ont besoin d'automatiser la gestion des appels téléphoniques avec transcription IA, particulièrement les entreprises de services, centres d'appels et équipes commerciales.

---

## Architecture Frame-Driven

Le système utilise une architecture de "frames" dans `FRAMES/` qui permet différentes implémentations par intégration CRM (Teamleader, Sage 50, etc.).

### Concept de Frames
Les fichiers à la racine (`conf.py`, `cuadro.py`, `procesos.py`) sont des shims qui délèguent au frame actif résolu par :
- Variable d'environnement `CENTRALITA_FRAME`
- Branche git active
- Configuration dans `config.ini`

### Structure des Frames
```
FRAMES/
├── main/              # Frame principal (Teamleader)
│   ├── conf.py        # Configuration Teamleader
│   ├── cuadro.py      # Tableau de bord
│   └── procesos.py    # Processus spécifiques TL
├── sage50/            # Frame Sage 50 (si existe)
│   ├── conf.py
│   ├── cuadro.py
│   └── procesos.py
└── README.md          # Documentation des frames
```

### Avantages
- **Même base de code** pour plusieurs produits
- **Maintenance facile** des intégrations spécifiques
- **Switch dynamique** sans recompiler
- **Isolement** de la logique de chaque CRM

---

## Composants Principaux

### 1. Initialisation du Système

**Responsabilité** : Point d'entrée principal et validation de l'environnement

**Fonctionnalités clés** :
- Validation de l'environnement et des dépendances
- Logging structuré avec niveaux DEBUG/INFO/WARNING/ERROR
- Initialisation du système

---

### 2. Moteur Principal

**Responsabilité** : Orchestration de tous les composants

**Composants gérés** :
- **Core** : Configuration et état global
- **API** : Client Teamleader/OAuth
- **Recording** : Enregistrement audio (interne/OBS)
- **TaskManager** : Système de gestion de tâches
- **CallProcessor** : Détection des états d'appel
- **GUI** : Barre des tâches et menus

**Flux de travail** :
1. Détection de l'état d'appel
2. Démarrage automatique de l'enregistrement
3. Recherche dans le CRM
4. Ouverture de la fiche client
5. Traitement avec IA à la fin
6. Création automatique de note dans le CRM

---

### 3. Système de Tâches

**Responsabilité** : CŒUR du système - gestion de l'enregistrement, IA, backup et modèles

**Fonctionnalités principales** :
- **Enregistrement en arrière-plan** sans bloquer l'interface
- **Traitement avec IA** des transcriptions
- **Backup automatique** des enregistrements
- **Traitement des modèles** personnalisés

**Caractéristiques** :
- **Exécution simultanée** sans bloquer l'interface
- **Validation audio** pré-IA (évite le gaspillage de crédits)
- **Récupération post-coupure** depuis CSV
- **A/B testing** des prompts IA

### GestorCSV
Persistance de l'état dans `hojatiempo.csv` :
- Enregistrement de tous les appels
- État du traitement (audio, IA, CRM)
- URLs des notes créées
- **Récupération automatique** après coupure de courant

---

### 4. Configuration Unifiée

**Responsabilité** : Configuration centralisée avec rechargement à chaud

**Fonctionnalités** :
- Teamleader API (OAuth2, tokens)
- Système multi-langue
- Gestion des licences
- **Rechargement à chaud** sans redémarrer

**Rechargement dynamique** :
- Détecte les changements dans config.ini
- Recharge les variables automatiquement
- Redémarre le traducteur
- Met à jour la configuration d'enregistrement

---

### 5. Tableau de Bord

**Responsabilité** : Gestion des interfaces de configuration

**Interfaces disponibles** :
- **Configuration** : Panneau de configuration général
- **Feuille de temps** : Registre des appels
- **Pré-notes** : Gestion des notes prédéfinies
- **Notes** : Création et gestion des notes

**Caractéristiques** :
- Interfaces web de gestion
- Superviseur pour éviter les instances multiples
- Fermeture par inactivité

---

## Système de Récupération

### Persistance en CSV
`hojatiempo.csv` est le **MÉCANISME DE RÉCUPÉRATION** du système :

| Colonne | Description |
|---------|-------------|
| telefono | Numéro téléphonique |
| fichero | Chemin de l'audio enregistré |
| entidad | Contact/Entreprise trouvé |
| tiempo | Durée de l'appel |
| estado | Audio terminé, IA disponible, etc. |
| url | URL de la note dans le CRM |

### Récupération Post-Coupure
Le système récupère automatiquement les appels non traités :
1. Lecture du CSV
2. Filtrage des enregistrements sans IA
3. Validation des fichiers existants
4. Retraitement avec IA
5. Notification de l'utilisateur

---

## Système de Validation

### Nettoyage Audio (`libwertyaudiolimpieza.py`)

**AudioCleaner.prepare_wav_for_ia()** :
- **Taille minimum** : 4096 bytes
- **Durée minimum** : 0.8 secondes
- **Format valide** : WAV/MP4
- **Checksum SHA256** : Intégrité du fichier

**Réessais automatiques** :
- 6 réessais avec 350ms de délai
- Pour les fichiers nouvellement créés
- Évite le traitement prématuré

---

## Intégrations

### Teamleader API
**OAuth2 Flow** :
- `client_id`, `client_secret`
- `tl_access_token`, `tl_refresh_token`
- Rafraîchissement automatique des tokens

**Opérations** :
- Recherche de contacts/entreprises
- Création de notes/pré-notes
- Lookup par numéro téléphonique

### OBS Studio (WebSocket)
**Contrôle distant** :
- Contrôle d'enregistrement distant
- Enregistrement audio du système

**Configuration** :
- Hôte OBS configurable
- Port OBS configurable
- Mode audio sélectionnable

---

## Circuit Breaker

### Isolement des Pannes

**Système d'isolement** :
- Détecte les défaillances des services externes
- Isole les services problématiques
- Réessaie les connexions automatiquement

**Services surveillés** :
- OBS Studio
- Teamleader API
- OpenRouter API

---

## Health Checks

### Surveillance

**Système de surveillance** :
- Vérifications périodiques de l'état
- Métriques de performance
- Endpoints pour monitoring

**Composants vérifiés** :
- OBS Studio connecté
- API CRM répondant
- Système de fichiers accessible

---

## Logs et Debugging

### Logging Structuré
**Niveaux** :
- `DEBUG` : Détails de l'exécution
- `INFO` : Événements importants
- `WARNING` : Alertes non critiques
- `ERROR` : Erreurs avec traceback

**Fichier** : `log_centralita.log`

**Limite actuelle** : Sans rotation des logs. Pour une production de longue durée, recommander `RotatingFileHandler`.

---

## Fichiers de Configuration

### config.ini
Fichier MONOLITHIQUE qui contrôle TOUT :

```ini
[API]
client_id=...
client_secret=...

[AUDIO]
inicio=d:\centralita_ia\rec

[MODULOS]
buscar=1
audio=1
ia=1

[IA]
api_key=...
intrucciones=...

[OBS]
obs_activo=True
obs_host=localhost

[BACKUP]
tiempo_backup=24
dirbackup=d:\backups

[WINDOWS]
idioma=fr
tema=DarkBlue16
```

---

## Observations Importantes

1. **CSV comme base de données distribuée** : `hojatiempo.csv` n'est pas seulement un log - c'est le MÉCANISME DE RÉCUPÉRATION. S'il est corrompu ou supprimé, la capacité de récupérer les appels après coupures est perdue.

2. **Configuration en temps réel** : Le système permet de recharger la configuration SANS REDÉMARRER, crucial pour les utilisateurs qui ajustent fréquemment les prompts.

3. **Système de licences** : La licence contrôle quels modules sont actifs. Les fonctions vérifient la licence avant d'exécuter.

4. **Menu dynamique** : Le menu est construit selon la licence et la configuration - les modules non autorisés n'apparaissent pas.

5. **Nettoyage audio obligatoire** : Le système valide TOUS les audios avant de les envoyer à l'IA, prévenant le gaspillage de crédits API.

---

## Composants Clés du Système

| Composant | Responsabilité |
|-----------|----------------|
| Moteur Principal | Orchestration du système |
| Système de Tâches | Gestion de l'enregistrement et IA |
| Configuration Unifiée | Configuration centralisée |
| Tableau de Bord | Interfaces de gestion |
| Processus CRM | Lookup CRM et effets |
| Validation Audio | Validation des fichiers |
| Isolement des Pannes | Gestion des erreurs |
| Surveillance | Health checks |
| config.ini | Configuration principale |

---

## Prochaines Étapes

- [ ] Lire [[../../tecnica/funcionalidades-core]] pour详细了解 les fonctionnalités principales
- [ ] Revoir [[../../tecnica/funcionalidades-avanzadas]] pour les caractéristiques v2
- [ ] Consulter [[../../tecnica/integraciones]] pour详细了解 les intégrations disponibles
- [ ] Voir [[../../tecnica/casos-de-uso]] pour des exemples pratiques
