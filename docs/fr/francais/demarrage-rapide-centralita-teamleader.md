---
title: Guide Complet d'Installation et de Configuration - Centralite Teamleader | Intégration crm avec ia
date: 2025-03-19
keywords:
  - centralite teamleader
  - installation teamleader
  - configurer teamleader
  - guide installation
  - intégration crm
  - openrouter ia
  - transcription appels
  - logiciel call center
  - google gemini
  - configuration pas à pas
  - installer centralite
  - guide rapide
description: Découvrez comment installer et configurer Centralite Teamleader en 20 minutes. Guide pas à pas pour intégrer Teamleader crm avec OpenRouter ia et automatiser vos appels. Téléchargement gratuit disponible.
tags:
  - contexto/proyecto/manual
  - installation
  - configuration
  - teamleader
  - crm
  - ia
  - openrouter
  - guide
status: published
---

# 🚀 Démarrage Rapide - Centralite Teamleader

Ce guide vous accompagnera étape par étape dans l'installation et la configuration initiale de Centralite Teamleader. En moins de 10 minutes, vous aurez le système opérationnel et prêt à optimiser vos appels.

---

## 📋 Prérequis

Avant de commencer, assurez-vous de respecter les conditions suivantes :

### Système d'Exploitation
- **Windows 10 ou supérieur** (Windows 11 recommandé)
- **Espace disque** : Minimum 50 MB
- **Mémoire RAM** : Minimum 2 GB (4 GB recommandé)
- **Connexion internet** : Pour l'intégration avec les APIs

### Comptes Requis
- [x] Compte **Teamleader Focus** actif
- [x] Identifiants API de Teamleader (voir étape 2)

---

## Étape 1 : Télécharger et Installer

### 1.1 Télécharger l'Application

!!! example "Téléchargement Gratuit"
    Téléchargez la dernière version de Centralite Teamleader :

    Demandez l'installateur actuel à votre fournisseur ou à l'administrateur de l'installation. Confirmez la version et l'origine du paquet avant de l'exécuter.

    *(Taille approximative : ~15 MB)*

### 1.2 Installer

1. **Décompresser le fichier** `.zip` dans un dossier de votre choix
   - Recommandé : `C:\Program Files\CentralitaIA\`
   - Éviter les dossiers avec espaces ou caractères spéciaux

2. **Exécuter l'installateur**
   - Double clic sur `Setup_Centralita_IA_Teamleader.exe`
   - Suivre les étapes de l'assistant d'installation

3. **Terminer l'installation**
   - Cocher "Exécuter l'application" à la fin
   - Cliquer sur "Terminer"

![](../../img/inicio_windows.gif)

### 1.3 Vérifier l'Installation

Après l'installation, vous devriez voir l'icône de Centralite dans la **barre des tâches** (coin inférieur droit) :

![](../../img/hola.png)

!!! success "✅ Installation Terminée"
    Si vous voyez l'icône dans la barre des tâches, l'installation s'est déroulée avec succès.

---

## Étape 2 : Configurer l'API Teamleader

!!! warning "⚠️ Requis"
    Sans les identifiants API de Teamleader, l'application ne pourra pas synchroniser les contacts ni créer des notes automatiquement.

### 2.1 Obtenir les Identifiants OAuth2

1. **Accéder au Marketplace Teamleader**
   - Visitez : [https://marketplace.focus.teamleader.eu/es/es/gestion](https://marketplace.focus.teamleader.eu/es/es/gestion)
   - Connectez-vous avec votre compte Teamleader

2. **Créer une nouvelle intégration**
   - Cliquez sur "**+ Nouvelle intégration**"
   - Remplissez les champs :
     - **Nom** : Centralite Teamleader
     - **Description** : Intégration de téléphonie automatique
     - **Type d'application** : Application web

3. **Configurer les URIs de redirection**
   - Dans "**Valider les URIs de redirection**" ajoutez exactement :
   ```
   http://127.0.0.1:5000/callback
   ```

    !!! danger "Important"
        Copiez l'URI exactement sans espaces ni caractères additionnels.

4. **Configurer les OAuth Scopes**
   - Cochez les permissions suivantes :
     - ✅ `contacts:read`
     - ✅ `contacts:write`
     - ✅ `companies:read`
     - ✅ `companies:write`
     - ✅ `notes:write`
     - ✅ `deals:read`
     - ✅ `deals:write`

   ![](../../img/api_scope.png)

5. **Enregistrer les identifiants**
   - Notez les données suivantes :
     - **Client ID** : `xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx`
     - **Client Secret** : `xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx`

    !!! tip "Conseil"
        Gardez ces identifiants dans un endroit sûr. Vous en aurez besoin à l'étape suivante.

??? info "📹 Voir le Tutoriel Vidéo"
    Si vous préférez un guide visuel, consultez notre vidéo :
    [ENREGISTREMENT API POUR TEAMLEADER - YouTube](https://www.youtube.com/watch?v=NtNTKFzflws)

### 2.2 Configurer les Identifiants dans Centralite

1. **Ouvrir la configuration**
   - Clic droit sur l'icône de Centralite dans la barre des tâches
   - Sélectionner "**Configuration**"

2. **Onglet API**
   - Naviguez vers l'onglet "**API**"
   - Copiez et collez les identifiants :
     - **Client ID** : Collez la valeur notée
     - **Client Secret** : Collez la valeur notée

3. **Autoriser l'application**
   - Cliquez sur "**Autoriser Teamleader**"
   - Une fenêtre de navigateur s'ouvrira
   - Connectez-vous à Teamleader (si nécessaire)
   - Cliquez sur "**Autoriser**"

4. **Vérifier la connexion**
   - Si tout est correct, vous verrez un message : "**✅ Connexion réussie avec Teamleader**"
   - Les tokens seront sauvegardés automatiquement

!!! success "✅ API Configurée"
    Votre Centralite est maintenant connectée avec Teamleader et peut synchroniser les contacts automatiquement.

---

## Étape 2.5 : Configurer OpenRouter (Transcription avec IA)

!!! info "ℹ️ Qu'est-ce qu'OpenRouter ?"
    **OpenRouter** est un service qui fournit l'accès à des modèles d'Intelligence Artificielle avancés (comme Google Gemini) pour transcrire automatiquement vos appels téléphoniques et générer des résumés structurés avec points clés, décisions et prochaines étapes.

### 2.5.1 Pourquoi avez-vous besoin d'OpenRouter ?

Sans OpenRouter, Centralite **ne pourra PAS** :
- ❌ Transcrire les appels automatiquement
- ❌ Générer des résumés structurés
- ❌ Extraire les points clés et décisions
- ❌ Créer des notes détaillées dans Teamleader

!!! tip "💡 Avantage de l'IA"
    Avec OpenRouter, chaque appel est transcrit et résumé automatiquement, vous faisant gagner des heures de notes manuelles et garantissant qu'aucun détail important ne soit oublié.

### 2.5.2 Obtenir la Clé API d'OpenRouter

1. **Créer un compte sur OpenRouter**
   - Visitez : [https://openrouter.ai/](https://openrouter.ai/)
   - Cliquez sur "Sign Up" ou "S'inscrire"
   - Remplissez vos données (nom, email, mot de passe)

2. **Vérifier l'email**
   - Vérifiez votre boîte de réception
   - Cliquez sur le lien de vérification

3. **Obtenir la Clé API**
   - Connectez-vous à OpenRouter
   - Naviguez vers "Settings" → "API Keys"
   - Cliquez sur "Create new key"
   - Copiez la Clé API générée

    !!! danger "⛔ Sauvegardez votre Clé API en toute sécurité"
        La Clé API est comme un mot de passe. Ne la partagez avec personne.

### 2.5.3 Configurer OpenRouter dans Centralite

1. **Ouvrir la configuration**
   - Clic droit sur l'icône de Centralite
   - Sélectionner "**Configuration**"

2. **Onglet Intelligence Artificielle**
   - Naviguez vers l'onglet "**IA**" ou "**Intelligence Artificielle**"

3. **Configurer la Clé API**
   - Collez la Clé API d'OpenRouter
   - Sélectionnez le modèle : `google/gemini-2.5-flash-lite` (recommandé)

4. **Personnaliser le prompt** (optionnel)
   - Vous pouvez personnaliser les instructions pour l'IA
   - Par exemple : "Transcrivez l'appel et concentrez-vous sur les décisions prises et les prochaines étapes"

5. **Enregistrer la configuration**
   - Cliquez sur "Enregistrer"
   - Vous verrez : "✅ OpenRouter configuré correctement"

!!! success "✅ IA Configurée"
    Votre Centralite transcrira maintenant automatiquement tous les appels avec intelligence artificielle.

### 2.5.4 Modèles d'IA Disponibles

| Modèle | Qualité | Coût | Vitesse | Recommandé pour |
|--------|---------|-------|-----------|------------------|
| **google/gemini-2.5-flash-lite** | Élevée | Faible | ⚡ Très rapide | ✅ Usage quotidien (recommandé) |
| **google/gemini-2.5-flash** | Très élevée | Moyen | ⚡ Rapide | Appels importants |
| **openai/gpt-4o** | Excellent | Élevé | 🐌 Lent | Réunions critiques |

??? info "💰 Coûts d'OpenRouter"
    Les coûts d'OpenRouter sont basés sur la consommation :
    - **Gemini 2.5 Flash Lite** : ~$0.07 par 1 million de tokens
    - **Appel moyen (5 min)** : ~200-300 tokens
    - **Coût par appel** : ~$0.02 - $0.03 (2-3 cents de dollar)
    - **100 appels/mois** : ~$2-3

    Vous pouvez définir une limite de dépense mensuelle sur OpenRouter pour contrôler les coûts.

---

## Étape 3 : Jumelage Android-Windows (Optionnel)

!!! abstract "ℹ️ Optionnel - Nécessite une Application Tiers"
    Cette étape est **optionnelle** mais **recommandée** si vous souhaitez la détection automatique des appels depuis votre téléphone Android.

### 3.1 Qu'est-ce que le jumelage ?

Le jumelage permet à Centralite de détecter automatiquement les appels entrants et sortants depuis votre téléphone Android, sans intervention manuelle.

**Conditions requises :**
- Appareil Android 6.0 ou supérieur
- Application **JustRemotePhone** installée
- Les deux appareils sur le même réseau WiFi

### 3.2 Installer l'Application de Jumelage

1. **Télécharger l'application**
   - Visitez : [https://www.justremotephone.com/v6.10/CallCenter.msi](https://www.justremotephone.com/v6.10/CallCenter.msi)
   - Téléchargez et installez sur votre Windows

2. **Installer l'application Android**
   - Sur votre Android, recherchez "**JustRemotePhone**" sur Google Play
   - Installez l'application

3. **Jumeler les appareils**
   - Ouvrez l'application sur Windows
   - Ouvrez l'application sur Android
   - Suivez les étapes de jumelage (un code sera affiché)

??? info "📖 Guide Détaillé de Jumelage"
    Pour des instructions étape par étape avec captures d'écran, consultez :
    [App-Call-remote - Guide Complet](../../es/castellano/App-Call-remoto.md)

![](../../img/pantalla_llamadas_windows.png)
![](../../img/pantalla_configuracion_remote_android.png)

### 3.3 Vérifier le Jumelage

1. **Effectuer un appel de test**
   - Appelez depuis votre Android vers n'importe quel numéro
   - Centralite devrait détecter l'appel automatiquement

2. **Vérifier la notification**
   - Vous devriez voir une notification sur Windows : "📞 Appel détecté : +34 XXX XXX XXX"
   - La fiche Teamleader devrait s'ouvrir automatiquement

!!! success "✅ Jumelage Terminé"
    Votre Centralite détecte maintenant automatiquement les appels depuis votre Android.

---

## Étape 4 : Enregistrer la Licence

!!! done "📝 Requis pour Usage Complet"
    L'enregistrement est gratuit et nécessaire pour activer toutes les fonctionnalités.

### 4.1 Formulaire d'Enregistrement

1. **Ouvrir le formulaire**
   - Visitez : [https://forms.office.com/r/5k9k54cugV](https://forms.office.com/r/5k9k54cugV)

2. **Remplir les données**
   - Nom complet
   - Entreprise
   - Email
   - Nombre de licences nécessaires
   - Cas d'usage

3. **Envoyer le formulaire**
   - Cliquez sur "Envoyer"
   - Vous recevrez votre licence par email dans 24-48 heures

### 4.2 Activer la Licence

1. **Ouvrir la configuration**
   - Clic droit sur l'icône de Centralite
   - Sélectionner "**Configuration**"

2. **Onglet Licence**
   - Naviguez vers l'onglet "**Licence**"
   - Collez la clé de licence reçue par email

3. **Activer**
   - Cliquez sur "**Activer la licence**"
   - Vous verrez un message : "**✅ Licence activée correctement**"

!!! success "✅ Enregistrement Terminé"
    Votre Centralite est complètement enregistrée et prête à être utilisée.

---

## ✅ Vérification Finale

### Liste de Vérification d'Installation

Avant de commencer à utiliser Centralite, vérifiez que toutes les étapes sont terminées :

- [ ] **Application installée** (icône visible dans la barre des tâches)
- [ ] **API Teamleader configurée** (identifiants OAuth2)
- [ ] **OpenRouter configuré** (Clé API et modèle IA)
- [ ] **Jumelage Android terminé** (optionnel mais recommandé)
- [ ] **Licence enregistrée et activée**
- [ ] **Connexion internet stable**

### Premier Appel de Test

1. **Effectuer un appel**
   - Appelez un numéro de test
   - Ou recevez un appel sur votre Android

2. **Vérifier le comportement**
   - ✅ Centralite détecte l'appel
   - ✅ La fiche Teamleader s'ouvre
   - ✅ L'enregistrement démarre
   - ✅ Une note est créée dans Teamleader après raccrocher

!!! success "🎉 Félicitations !"
    Votre Centralite Teamleader est complètement configurée et prête à optimiser vos appels.

---

## 🎓 Prochaines Étapes

Maintenant que vous avez Centralite installée et configurée, nous vous recommandons :

1. **Personnaliser la configuration**
   - [Configuration Avancée](../../es/castellano/pantalla-configuracion-centralita-teamleader.md)
   - Ajuster langue, thème, modules actifs

2. **Apprendre les fonctionnalités avancées**
   - [Transcription avec IA](centralite-crm-ia-teamleader.md)
   - [Gestion des Contacts](../../es/castellano/creacion-nuevo-registros-teamleader.md)

3. **Consulter la documentation technique**
   - [Documentation Technique](../technique/architecture.md)

---

## ❓ Besoin d'Aide ?

### Support Technique

- **Web** : [https://alca.co/](https://alca.co/)
- **Email** : soporte@alcatic.com
- **Horaires** : Lundi à Vendredi, 9:00 - 18:00 (CET)

### Ressources Additionnelles

- **Documentation complète** : [Wiki de Centralite](https://wertymsd.github.io/Centralita_Teamleader)
- **Vidéos tutorielles** : [Chaîne YouTube](https://www.youtube.com/@alcatic)
- **GitHub** : [Dépôt officiel](https://github.com/wertyMSD/Centralita_Teamleader)

---

## 📊 Résumé des Temps

| Étape | Temps Estimé | Difficulté |
|-------|--------------|------------|
| 1. Télécharger et installer | 3 minutes | ⭐ Facile |
| 2. Configurer l'API Teamleader | 5 minutes | ⭐⭐ Moyen |
| 2.5. Configurer OpenRouter | 3 minutes | ⭐ Facile |
| 3. Jumeler Android (optionnel) | 5 minutes | ⭐⭐ Moyen |
| 4. Enregistrer la licence | 2 minutes | ⭐ Facile |
| **Total** | **18 minutes** | |

!!! tip "Conseil"
    Si vous avez des doutes pendant l'installation, n'hésitez pas à consulter nos guides détaillés ou à contacter le support.
