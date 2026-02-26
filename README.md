# 📂 Module Storage OCR

Ce module déploie l'infrastructure de stockage sécurisée, le monitoring et la gestion des accès.

## 🚀 Fonctionnalités

* **Compte de Stockage** : Configuré en TLS 1.2 avec accès réseau restreint.
* **Containers** : `images` (Entrée), `ocr-results` (Sortie), `tfstate` (Backend Terraform).
* **Monitoring** : Alerte automatique par mail si le stockage dépasse 1 Go.
* **Sécurité** : Firewall IP strict et RBAC prêt pour la future Azure Function.

---

## RBAC (Sécurité)

J'ai ajouté une option pour donner les droits à la Azure Function.
Dès que vous avez le `principal_id` de la Function, il suffit de le passer à la variable `function_app_id` et ça lui donnera automatiquement le droit de lire les images.


## ⚠️ TRÈS IMPORTANT : Accès Réseau (Firewall)

Le stockage est protégé par un firewall. **Si vous ne mettez pas votre IP actuelle, vous recevrez une erreur 403 (Forbidden).**

### Comment trouver votre IP ?

Tapez `curl ifconfig.me` dans votre terminal. C'est cette adresse qu'il faut mettre dans la variable `allowed_ip` du main.tf de la racine.

> **Note :** Si vous changez de lieu (Wi-Fi maison vs Wi-Fi école), vous devrez mettre à jour cette valeur dans votre `main.tf` et relancer un `terraform apply`.

---

## 📊 Monitoring & Alertes

Une alerte de métrique est configurée. Dès l'application du module :

1. Vous recevrez un mail d'Azure vous confirmant l'ajout au groupe **"critical-alerts"**.
2. Si le stockage cumulé dépasse **1 Go**, un mail d'alerte sera envoyé à l'adresse configurée dans `admin_email`.

---

## 🛠 Utilisation

Copiez ce bloc dans votre `main.tf` à la racine.

```hcl
resource "azurerm_resource_group" "rg" {
  name     = "rg-ia"
  location = "Switzerland North"
}

module "storage" {
  source              = "./modules/storage"
  prefix              = "projetm2"
  environment         = terraform.workspace
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location

  # --- CONFIGURATION INDIVIDUELLE ---
  # 1. Tapez `curl ifconfig.me` dans votre terminal pour trouver votre IP
  allowed_ip          = "VOTRE_IP_ICI" 
  
  # 2. Votre mail pour recevoir les alertes de monitoring
  admin_email         = "votre.email@etudiant.fr"

  # --- OPTIONNEL ---
  # function_app_id   = "ID-DE-LA-FUNCTION"

  tags = {
    project = "ia-ocr"
    owner   = "admin"
    env     = terraform.workspace
  }
}

```

---

## 🛠 Dépannage (Erreur 403 au Terraform Plan)

Si Terraform affiche une erreur `403 AuthorizationFailure` lors du rafraîchissement de l'état :

1. Allez sur le Portail Azure > Votre Storage Account > Mise en réseau.
2. Cliquez sur **"Enabled from selected networks"**.
3. Cliquez sur **"Ajouter votre adresse IP client"**.
4. Cliquez sur **Enregistrer**.
5. Relancez le `terraform plan`.
