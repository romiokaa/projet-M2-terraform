import os
from azure.ai.vision.imageanalysis import ImageAnalysisClient
from azure.ai.vision.imageanalysis.models import VisualFeatures
from azure.core.credentials import AzureKeyCredential

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