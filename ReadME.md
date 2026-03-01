# 📘 Projet M2 – Infrastructure as Code & IA  
## Plateforme OCR sécurisée sur Microsoft Azure

## 🎯 Objectif du projet

Ce projet a pour objectif de concevoir et déployer une plateforme OCR (Reconnaissance Optique de Caractères) sur Microsoft Azure en utilisant les principes d’Infrastructure as Code avec Terraform.

L’application permet :

- L’upload d’images  
- L’extraction automatique du texte via Azure AI Vision  
- Le stockage des résultats dans Azure Blob Storage  
- Une gestion sécurisée des secrets via Azure Key Vault  
- Une authentification sécurisée via Managed Identity  


## 🏗 Architecture globale

Utilisateur
   ↓
Upload image → Azure Blob Storage (container images)
   ↓ (trigger)
Azure Function (Python)
   ↓
Azure AI Vision (OCR - Read API)
   ↓
Texte extrait → Blob Storage (container ocr-results)

## 👩‍💻 Organisation de l’équipe

Le projet a été divisé en trois parties :

- 👤 Membre 1(Maissaa) : Mise en place d’Azure Blob Storage  
- 👤 Membre 2(Jovick) : Déploiement et configuration d’Azure Functions  
- 👤 Moi(Brassica) : Azure AI Vision + Key Vault + Sécurité (Managed Identity & RBAC)  

Chaque partie a été développée indépendamment puis intégrée dans une architecture commune.

## 📂 Structure du projet

projet-M2-terraform/
│
├── main.tf
├── provider.tf
├── variables.tf
├── outputs.tf
│
├── modules/
│   ├── storage/
│   ├── functions/
│   ├── cognitive_service/
│   └── key_vault/
│
└── README.md

---

# ⚙️ Infrastructure as Code – Terraform

## Backend distant

Le state Terraform est stocké dans :

- Un Storage Account dédié  
- Un container `tfstate`  
- Backend `azurerm`  

Cela permet :

- Le travail en équipe  
- La centralisation du state  
- La gestion propre des environnements  

---

## Gestion des environnements

Les environnements sont gérés via :

```bash
terraform workspace new dev
terraform workspace new prod

```

Les ressources intègrent :

```sh
env = terraform.workspace
```

## 📦 Azure Blob Storage

Le module storage déploie :

Un Storage Account sécurisé

Trois containers :

- images

- -ocr-results

- tfstate

Sécurité appliquée :

- HTTPS only

- TLS 1.2 minimum

- Règles réseau (IP autorisée)

- RBAC minimal

- Monitoring avec alerte sur la capacité

## ⚡ Azure Functions

La Function App est déployée :

- Linux

- Python 3.11

La fonction :

- Lit un blob image

- Appelle Azure AI Vision

- Retourne le texte extrait

## 🤖 Azure AI Vision

Déployé via :

```sh
resource "azurerm_cognitive_account"
```

Configuration :

- Type : ComputerVision

- SKU : S1

- Région : Switzerland North

Utilisation :

- API Read (OCR)

- Extraction ligne par ligne

- Retour JSON structuré

## 🔐 Sécurité
### Key Vault

La clé Azure AI Vision est stockée dans Azure Key Vault :

```sh
VISION-KEY
```
Elle n’est pas stockée en clair dans le code.

## 2️⃣ Managed Identity

La Function App utilise une identité managée :

```sh
identity {
  type = "SystemAssigned"
}
```
Cela permet :

- D’éviter les secrets en dur

- Une authentification sécurisée

- Une intégration propre avec RBAC

## 3️⃣ RBAC minimal

Permissions configurées :

| Ressource       | Rôle                          |
| --------------- | ----------------------------- |
| Storage images  | Storage Blob Data Reader      |
| Storage results | Storage Blob Data Contributor |
| Key Vault       | Key Vault Secrets User        |

Principe appliqué :
Donner uniquement les droits nécessaires.

## 🧪 Test local Azure AI Vision

Un script Python permet de tester l’OCR localement.

Variables nécessaires :

```sh
VISION_ENDPOINT
VISION_KEY
```
```sh
py test.py
```

## 🚀 Déploiement

Initialisation

```sh
terraform init  
```

Plan 
```sh
terraform plan
```

Apply
```sh
terraform apply
```
## 🛠 Problèmes rencontrés

- Conflits de noms globaux (Storage / Key Vault)

- Problèmes de backend Terraform

- Dépendances circulaires entre modules

- Gestion des outputs inter-modules

Solutions mises en place :

- Utilisation de random_string

- Séparation des role assignments

- Reconfiguration du backend

- Gestion propre des outputs

## 🎓 Compétences mobilisées

- Terraform (Infrastructure as Code)

- Architecture Cloud Azure

- Azure AI Vision (OCR)

- Sécurité Cloud (Managed Identity, RBAC, Key Vault)

- Gestion d’environnements

- Collaboration Git


## Le plus gros problème rencontré.
Le plus gros problème que nous avons rencontré, et le plus complexe à résoudre, a été le blocage du pare-feu du Storage Account lors du provisionnement de la Function App.

Bien que le sujet demande une sécurité stricte en interdisant les accès publics inutiles, cela a créé un conflit technique majeur :

Le "Cercle Vicieux" du Déploiement

Le besoin de la Function : Pour se créer, une Azure Function sous Linux a impérativement besoin de générer un partage de fichiers interne (File Share) dans le compte de stockage pour y déposer son code.


Le blocage du Storage : Comme nous avions configuré le stockage avec une règle default_action = "Deny" pour respecter les consignes de sécurité , Azure rejetait la création de ce partage, même avec l'option bypass = ["AzureServices"] activée.
+1


L'erreur résultante : Cela générait une erreur 403 Forbidden (BadRequest) systématique, empêchant la finalisation du module compute.

La Solution Stratégique
Pour résoudre ce problème tout en restant conforme aux exigences du projet M2, nous avons dû procéder en deux temps :

Phase de Provisioning : Basculer temporairement le stockage sur default_action = "Allow" pour permettre à Azure de lier la Function App au Storage.


Phase de Sécurisation : Une fois la ressource créée, réactiver le Deny. Grâce à l'Identité Managée  et au paramètre de bypass, la fonction a pu conserver son accès interne tout en bloquant le reste du monde.
