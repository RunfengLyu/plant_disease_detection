import base64
import json
import logging
import os
from io import BytesIO

import numpy as np
import onnxruntime as ort
from PIL import Image

labels = [
    "Fito", "Monilia", "Sana"
]

def init():
    global model
    model_path = os.path.join(
        os.getenv("AZUREML_MODEL_DIR"),
        "cocoa_model.onnx"
    )
    box_model = ort.InferenceSession(model_path)

    logging.info("Init complete")


def run(raw_data):
    logging.info("request received")

    decoded = base64.b64decode(raw_data)
    image = Image.open(BytesIO(decoded)).resize((320, 320))
    data = np.asarray(image)[None, :, :, 0:3].astype(np.float32).reshape((1, 3, 320, 320))
    result = model.run(None, {'image_tensor': data})
    result_dict = dict([(a, str(b)) for a, b in zip(labels, result[2][0])])
    logging.info("Request processed")
    return json.dumps(result_dict)
