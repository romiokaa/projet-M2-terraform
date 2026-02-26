import azure.functions as func
import logging
import os
from azure.identity import DefaultAzureCredential
from azure.storage.blob import BlobServiceClient

app = func.FunctionApp(http_auth_level=func.AuthLevel.FUNCTION)

@app.route(route="read_blob")
def http_trigger(req: func.HttpRequest) -> func.HttpResponse:
    logging.info('Traitement d\'une requête pour lire un Blob.')

    # 1. Récupérer le nom du fichier via l'URL (ex: ?file=image.jpg)
    blob_name = req.params.get('file')
    
    # 2. Récupérer les infos de connexion via les variables d'environnement (Terraform les a créées)
    # Maaissa devra te donner l'URL du compte de stockage 
    account_url = os.environ.get("BLOB_ACCOUNT_URL")
    container_name = "images" # Nom du conteneur créé par ta camarade

    if not blob_name:
        return func.HttpResponse("Merci de préciser un nom de fichier via ?file=...", status_code=400)

    try:
        # Authentification sans mot de passe (via l'identité managée configurée en Terraform)
        credential = DefaultAzureCredential()
        blob_service_client = BlobServiceClient(account_url, credential=credential)
        
        # Accès au blob
        blob_client = blob_service_client.get_blob_client(container=container_name, blob=blob_name)
        
        # Lecture du contenu
        blob_data = blob_client.download_blob().readall()
        
        return func.HttpResponse(f"Succès ! Le fichier {blob_name} contient {len(blob_data)} octets.")

    except Exception as e:
        logging.error(f"Erreur : {str(e)}")
        return func.HttpResponse(f"Erreur lors de la lecture du blob : {str(e)}", status_code=500)