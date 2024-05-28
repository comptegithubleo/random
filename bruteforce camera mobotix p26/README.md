# Description
This scripts bruteforces a Mobotix P26 camera credentials over HTTP Digest Authentification
It has been tailored to work for a specific model.
Below are explanations to help me remember how it works a few years down the line.

## Découverte - HTTP Digest Authentification
---
L'interface web de la caméra demande un login, et utilise une authentification [HTTP Digest](https://en.wikipedia.org/wiki/Digest_access_authentication).
Fonctionnement générale de l'authentification :
1. Le client demande une ressource
2. Le serveur envoie un identifiant unique **nonce**, des informations d'authentifications, et s'attends à recevoir les identifiants
3. Le client utilise l'identifiant unique serveur **nonce**, et créé également son propre identifiant unique **cnonce**, combine toutes les informations, y compris ses identifiants, en un hash. Il envoie au serveur le hash final, et l'identifiant unique du client **cnonce**.
4. Le serveur compare et calcule le hash des identifiants stockés dans sa base de données

## Methode
---
Le but est de créer un script python qui :
1. Envoie une 1ère requête et récupère les informations d'authentification (**nonce**, etc...)
2. Créée son propre hash avec un mot de passe d'une liste de mots de passes (avec un **cnonce** généré de façon arbitraire)
3. Envoie une 2nde requête avec tout ces éléments aux serveurs, pour qu'il puisse procéder à la vérification et nous laisser entrer ou non

La création du hash **response** est l'étape clé du programme.
On respecte au mieux la documentation officielle :
```python
HA1 = hashlib.md5(f"{username}:{realm}:{password}".encode())
HA2 = hashlib.md5(f"GET:{uri}".encode())
HA1 = HA1.hexdigest()
HA2 = HA2.hexdigest()
response = hashlib.md5(f'{HA1}:{nonce}:{nc}:{cnonce}:{qop}:{HA2}'.encode()).hexdigest()
```
