import os
from dotenv import load_dotenv
from azure.ai.vision.imageanalysis import ImageAnalysisClient
from azure.ai.vision.imageanalysis.models import VisualFeatures
from azure.core.credentials import AzureKeyCredential

load_dotenv()

def extract_text_from_bytes(image_bytes: bytes) -> dict:
    endpoint = os.environ["VISION_ENDPOINT"]
    key = os.environ["VISION_KEY"]

    client = ImageAnalysisClient(endpoint=endpoint, credential=AzureKeyCredential(key))
    result = client.analyze(image_data=image_bytes, visual_features=[VisualFeatures.READ])

    lines = []
    if result.read:
        for block in result.read.blocks:
            for line in block.lines:
                lines.append(line.text)

    text = "\n".join(lines).strip()

    return {
        "status": "success",
        "extractedText": text,
        "linesCount": len(lines),
    }

#Test local
if __name__ == "__main__":
    image_path = os.path.join("img", "test.png")

    if not os.path.exists(image_path):
        raise SystemExit(f"Image introuvable: {image_path}")

    with open(image_path, "rb") as f:
        data = f.read()

    result = extract_text_from_bytes(data)

    print("OCR terminé")
    print("Lignes:", result["linesCount"])
    print("----- TEXTE -----")
    print(result["extractedText"] if result["extractedText"] else "(aucun texte détecté)")