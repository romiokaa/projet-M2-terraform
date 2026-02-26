# Module Storage OCR

Ce module crée un compte de stockage sécurisé avec :

* Firewall restreint à l'IP du développeur.
* Container `images` (Entrée).
* Container `ocr-results` (Sortie).
* Container `tfstate` (Backend).

## RBAC (Sécurité)

J'ai ajouté une option pour donner les droits à la Azure Function.
Dès que vous avez le `principal_id` de la Function, il suffit de le passer à la variable `function_app_id` et ça lui donnera automatiquement le droit de lire les images.

## Utilisation

Voici comment appeler le module dans le `main.tf` à la racine de votre branche :

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

  # IMPORTANT : Remplacez par votre IP pour ne pas être bloqué par le firewall
  allowed_ip          = "37.169.128.201" 

  # Optionnel : Mettre l'ID de la fonction ici
  # function_app_id   = "ID-DE-LA-FUNCTION"

  tags = {
    project = "ia-ocr"
    owner   = "admin"
    env     = terraform.workspace
  }
}

```