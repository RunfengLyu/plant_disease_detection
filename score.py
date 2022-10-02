import os
import logging
import tensorflow as tf
from PIL import Image
from io import BytesIO
import numpy as np
import base64
import json
import onnxruntime as ort


labels = [
    "Tomato___Bacterial_spot",
    "Tomato___Early_blight",
    "Tomato___Late_blight",
    "Tomato___Leaf_Mold",
    "Tomato___Septoria_leaf_spot",
    "Tomato___Spider_mites Two-spotted_spider_mite",
    "Tomato___Target_Spot",
    "Tomato___Tomato_Yellow_Leaf_Curl_Virus",
    "Tomato___Tomato_mosaic_virus",
    "Tomato___healthy"
]


def get_bound_box(tensor):
    scores = tensor[2][0]
    boxes = tensor[0][0]
    return np.clip(boxes[scores.argmax()], a_min=0.0, a_max=1.0)


def init():
    global model
    model_path = os.path.join(
        os.getenv("AZUREML_MODEL_DIR"),
        "model.h5"
    )
    model = tf.keras.models.load_model(model_path)

    global box_model
    box_model_path = os.path.join(
        os.getenv("AZUREML_MODEL_DIR"),
        "box_model.onnx"
    )
    box_model = ort.InferenceSession(box_model_path)

    logging.info("Init complete")


def run(raw_data):
    logging.info("request received")

    decoded = base64.b64decode(raw_data)
    image = Image.open(BytesIO(decoded)).resize((320, 320))
    data = np.asarray(image)[None, :, :, 0:3].astype(np.float32).reshape((1, 3, 320, 320))
    box_tensor = box_model.run(None, {'image_tensor': data})
    box = get_bound_box(box_tensor)

    boxed_image = image.crop(box).resize((112, 112))
    data = np.asarray(boxed_image)[None, :, :, 0:3]
    result = model.predict(data)[0]
    result_dict = dict([(a, str(b)) for a, b in zip(labels, result)])
    logging.info("Request processed")
    return json.dumps(result_dict)
