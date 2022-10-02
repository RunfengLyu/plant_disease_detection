import os
import logging
import tensorflow as tf
from PIL import Image
from io import BytesIO
import numpy as np
import base64
import json


class Model:
    def __init__(self, model_filepath):
        self.graph_def = tf.compat.v1.GraphDef()
        self.graph_def.ParseFromString(model_filepath)

        input_names, self.output_names = self._get_graph_inout(self.graph_def)
        assert len(input_names) == 1 and len(self.output_names) == 3
        self.input_name = input_names[0]
        self.input_shape = self._get_input_shape(self.graph_def, self.input_name)

    def predict(self, image):
        input_array = np.array(image, dtype=np.float32)[np.newaxis, :, :, 0:3]

        with tf.compat.v1.Session() as sess:
            tf.import_graph_def(self.graph_def, name='')
            out_tensors = [sess.graph.get_tensor_by_name(o + ':0') for o in self.output_names]
            outputs = sess.run(out_tensors, {self.input_name + ':0': input_array})
            return {name: outputs[i][np.newaxis, ...] for i, name in enumerate(self.output_names)}

    @staticmethod
    def _get_graph_inout(graph_def):
        input_names = []
        inputs_set = set()
        outputs_set = set()

        for node in graph_def.node:
            if node.op == 'Placeholder':
                input_names.append(node.name)

            for i in node.input:
                inputs_set.add(i.split(':')[0])
            outputs_set.add(node.name)

        output_names = list(outputs_set - inputs_set)
        return input_names, output_names

    @staticmethod
    def _get_input_shape(graph_def, input_name):
        for node in graph_def.node:
            if node.name == input_name:
                return [dim.size for dim in node.attr['shape'].shape.dim][1:3]



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


def init():
    global model
    model_path = os.path.join(
        os.getenv("AZUREML_MODEL_DIR"),
        "model.h5"
    )
    model = tf.keras.models.load_model(model_path)

    global box_model
    box_model = Model(open("saved_model.pb", "rb").read())

    logging.info("Init complete")


def run(raw_data):
    logging.info("request received")

    decoded = base64.b64decode(raw_data)
    image = Image.open(BytesIO(decoded))
    image_box_detect = image.resize(box_model.input_shape)

    data = Image.open(BytesIO(decoded)).resize((112, 112))
    data = np.asarray(data)[None, :, :, 0:3]
    result = model.predict(data)[0]
    result_dict = dict([(a, str(b)) for a, b in zip(labels, result)])
    logging.info("Request processed")
    return json.dumps(result_dict)
