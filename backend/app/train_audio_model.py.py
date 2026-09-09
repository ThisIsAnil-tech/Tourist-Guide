# train_audio_model.py
import tensorflow as tf
import librosa
import numpy as np
import os

SR = 22050
N_MELS = 128
DURATION = 3  # seconds, matches your app's 3-second capture window

def load_and_preprocess(file_path):
    y, _ = librosa.load(file_path, sr=SR, duration=DURATION)
    y = librosa.util.fix_length(y, size=SR * DURATION)
    mel = librosa.feature.melspectrogram(y=y, sr=SR, n_mels=N_MELS)
    mel_db = librosa.power_to_db(mel, ref=np.max)
    return mel_db

def load_dataset(data_dir):
    X, y = [], []
    classes = ["scream", "glass_break", "background"]
    for label_idx, class_name in enumerate(classes):
        class_dir = os.path.join(data_dir, class_name)
        for fname in os.listdir(class_dir):
            spec = load_and_preprocess(os.path.join(class_dir, fname))
            X.append(spec)
            y.append(label_idx)
    return np.array(X), np.array(y)

X, y = load_dataset("dataset/")
X = X[..., np.newaxis]  # add channel dimension for CNN input

base_model = tf.keras.applications.MobileNetV2(
    input_shape=(N_MELS, X.shape[2], 1),
    include_top=False,
    weights=None,  # no ImageNet weights since input isn't RGB
)

model = tf.keras.Sequential([
    base_model,
    tf.keras.layers.GlobalAveragePooling2D(),
    tf.keras.layers.Dense(3, activation="softmax"),
])

model.compile(optimizer="adam", loss="sparse_categorical_crossentropy", metrics=["accuracy"])
model.fit(X, y, epochs=20, validation_split=0.2, batch_size=16)

converter = tf.lite.TFLiteConverter.from_keras_model(model)
converter.optimizations = [tf.lite.Optimize.DEFAULT]  # quantization, matches your paper's model-size claims
tflite_model = converter.convert()

with open("distress_audio_model.tflite", "wb") as f:
    f.write(tflite_model)

print("Model saved:", len(tflite_model) / 1024, "KB")