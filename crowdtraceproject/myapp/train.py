


import os
import django
import torch
import numpy as np
import pickle
from PIL import Image
from facenet_pytorch import MTCNN, InceptionResnetV1
from sklearn.metrics.pairwise import cosine_similarity

# ==========================================
# DJANGO SETUP
# ==========================================

os.environ.setdefault("DJANGO_SETTINGS_MODULE", "crowdtraceproject.settings")
django.setup()

from django.conf import settings
from myapp.models import Missing_person, criminal


# ==========================================
# FACE TRAINER
# ==========================================

class FaceRecognitionTrainer:

    def __init__(self, model_path="face_model.pkl"):

        self.model_path = os.path.join(settings.BASE_DIR, model_path)

        # DEVICE
        self.device = torch.device(
            "cuda" if torch.cuda.is_available() else "cpu"
        )

        print("\n[INFO] Device:", self.device)

        # FACE DETECTOR
        self.mtcnn = MTCNN(
            image_size=160,
            margin=20,
            keep_all=False,
            device=self.device
        )

        # FACENET MODEL
        self.resnet = InceptionResnetV1(
            pretrained="vggface2"
        ).eval().to(self.device)

        # DATABASE
        self.database = {}

        # LOAD EXISTING MODEL
        if os.path.exists(self.model_path):

            print("[INFO] Loading existing face database...")

            with open(self.model_path, "rb") as f:
                self.database = pickle.load(f)

            print("[INFO] Existing faces:", len(self.database))

        else:
            print("[INFO] No previous model found. Creating new database.")


    # ==========================================
    # EXTRACT EMBEDDING
    # ==========================================

    def extract_embedding(self, image_path):

        try:

            img = Image.open(image_path).convert("RGB")

            img = img.resize((640, 640))

            face = self.mtcnn(img)

            if face is None:

                print("[WARNING] No face detected:", image_path)
                return None

            face = face.unsqueeze(0).to(self.device)

            with torch.no_grad():

                emb = self.resnet(face)

            return emb.cpu().numpy()[0]

        except Exception as e:

            print("[ERROR] Face extraction failed:", e)
            return None


    # ==========================================
    # CHECK DUPLICATE
    # ==========================================

    def check_duplicate(self, new_embedding, threshold=0.70):

        if len(self.database) == 0:
            return False

        new_embedding = np.array(new_embedding).reshape(1, -1)

        for key, emb in self.database.items():

            emb = np.array(emb).reshape(1, -1)

            similarity = cosine_similarity(new_embedding, emb)[0][0]

            print("Similarity:", round(similarity, 3))

            if similarity > threshold:

                print("[DUPLICATE FOUND]", key)
                return True

        return False


    # ==========================================
    # ADD FACE
    # ==========================================

    def add_face(self, key, embedding):

        if key not in self.database:

            self.database[key] = embedding.tolist()

            print("[ADDED]", key)


    # ==========================================
    # TRAIN MISSING PERSON
    # ==========================================

    def train_missing_persons(self):

        persons = Missing_person.objects.all()

        print("\n[INFO] Missing persons:", persons.count())

        for p in persons:

            if not p.photo:
                continue

            img_path = os.path.join(settings.MEDIA_ROOT, str(p.photo))

            if not os.path.exists(img_path):

                print("[WARNING] Image not found:", img_path)
                continue

            emb = self.extract_embedding(img_path)

            if emb is None:
                continue

            if self.check_duplicate(emb):

                print("[SKIPPED] Duplicate Missing:", p.name)
                continue

            key = f"MISSING|{p.id}|{p.name}"

            self.add_face(key, emb)


    # ==========================================
    # TRAIN CRIMINAL
    # ==========================================

    def train_criminals(self):

        persons = criminal.objects.all()

        print("\n[INFO] Criminals:", persons.count())

        for p in persons:

            if not p.photo:
                continue

            img_path = os.path.join(settings.MEDIA_ROOT, str(p.photo))

            if not os.path.exists(img_path):

                print("[WARNING] Image not found:", img_path)
                continue

            emb = self.extract_embedding(img_path)

            if emb is None:
                continue

            if self.check_duplicate(emb):

                print("[SKIPPED] Duplicate Criminal:", p.name)
                continue

            key = f"CRIMINAL|{p.id}|{p.name}"

            self.add_face(key, emb)


    # ==========================================
    # SAVE MODEL
    # ==========================================

    def save_model(self):

        with open(self.model_path, "wb") as f:

            pickle.dump(self.database, f)

        print("\n[✓] Model saved:", self.model_path)
        print("[✓] Total faces:", len(self.database))


    # ==========================================
    # TRAIN ALL
    # ==========================================

    def train_all(self):

        print("\n==============================")
        print("     FACE TRAINING STARTED")
        print("==============================")

        self.train_missing_persons()

        self.train_criminals()

        self.save_model()

        print("\n==============================")
        print("     TRAINING COMPLETED")
        print("==============================")
        print("Total embeddings:", len(self.database))


# ==========================================
# RUN TRAINING
# ==========================================

if __name__ == "__main__":

    trainer = FaceRecognitionTrainer()

    trainer.train_all()