import os
import cv2
import torch
import numpy as np
import pickle
from PIL import Image
from facenet_pytorch import MTCNN, InceptionResnetV1


class LiveFaceDetector:

    def __init__(self, model_path, threshold=0.9, on_detect=None):

        if not os.path.exists(model_path):
            raise FileNotFoundError(f"Model not found: {model_path}")

        self.threshold = threshold
        self.on_detect = on_detect

        self.device = torch.device(
            "cuda" if torch.cuda.is_available() else "cpu"
        )

        print("[INFO] Device:", self.device)

        # =====================================================
        # FACE DETECTOR
        # =====================================================
        self.mtcnn = MTCNN(
            image_size=160,
            margin=14,
            keep_all=True,
            device=self.device
        )

        # =====================================================
        # FACENET MODEL
        # =====================================================
        self.resnet = InceptionResnetV1(
            pretrained="vggface2"
        ).eval().to(self.device)

        # =====================================================
        # LOAD TRAINED FACE DATABASE
        # =====================================================
        with open(model_path, "rb") as f:
            self.database = pickle.load(f)

        print("[OK] Loaded faces:", len(self.database))


    # =====================================================
    # EXTRACT EMBEDDING
    # =====================================================

    def extract_embedding(self, face_tensor):

        with torch.no_grad():

            face_tensor = face_tensor.unsqueeze(0).to(self.device)

            embedding = self.resnet(face_tensor)

        return embedding.cpu().numpy()[0]


    # =====================================================
    # CLEAN NAME (REMOVE _0, _1, _2 ETC)
    # =====================================================

    def clean_name(self, name):

        if "_" in name:
            name = name.split("_")[0]

        return name.strip().title()


    # =====================================================
    # IDENTIFY FACE
    # =====================================================

    def identify_face(self, embedding):

        best_dist = float("inf")
        best_key = None

        for key, db_emb in self.database.items():

            dist = np.linalg.norm(
                embedding - np.array(db_emb)
            )

            if dist < best_dist:
                best_dist = dist
                best_key = key

        if best_key and best_dist < self.threshold:

            role, pid, name = best_key.split("|")

            # Fix name issue (dq_0 → dq)
            name = self.clean_name(name)

            confidence = max(0.0, 1 - best_dist)

            return {
                "status": "matched",
                "category": "Criminal" if role == "CRIMINAL" else "Missing Person",
                "name": name,
                "confidence": round(confidence, 2)
            }

        return {"status": "unknown"}


    # =====================================================
    # DETECT + DRAW + RETURN RESULTS
    # =====================================================

    def detect_and_draw(self, frame):

        results = []

        rgb_frame = cv2.cvtColor(frame, cv2.COLOR_BGR2RGB)

        pil_image = Image.fromarray(rgb_frame)

        faces, probs = self.mtcnn(
            pil_image,
            return_prob=True
        )

        boxes, _ = self.mtcnn.detect(pil_image)

        if faces is not None and boxes is not None:

            if faces.dim() == 3:
                faces = faces.unsqueeze(0)

            for i in range(len(faces)):

                face = faces[i]
                box = boxes[i]

                embedding = self.extract_embedding(face)

                result = self.identify_face(embedding)

                x1, y1, x2, y2 = map(int, box)

                if result["status"] == "matched":

                    label = (
                        f"{result['category']} : "
                        f"{result['name']} "
                        f"{result['confidence']}"
                    )

                    color = (0, 0, 255)

                    results.append(result)

                    if self.on_detect:
                        self.on_detect(result)

                else:

                    label = "Unknown"

                    color = (120, 120, 120)

                # Draw rectangle
                cv2.rectangle(
                    frame,
                    (x1, y1),
                    (x2, y2),
                    color,
                    2
                )

                # Draw label
                cv2.putText(
                    frame,
                    label,
                    (x1, y1 - 10),
                    cv2.FONT_HERSHEY_SIMPLEX,
                    0.6,
                    color,
                    2
                )

        return frame, results


    # =====================================================
    # LOCAL CAMERA TEST
    # =====================================================

    def start_live_detection(self):

        cap = cv2.VideoCapture(0)

        if not cap.isOpened():
            raise RuntimeError("Webcam not accessible")

        print("\n[INFO] Live detection started")
        print("[INFO] Press Q to stop\n")

        while True:

            ret, frame = cap.read()

            if not ret:
                break

            frame, results = self.detect_and_draw(frame)

            cv2.imshow(
                "LIVE FACE DETECTION",
                frame
            )

            if cv2.waitKey(1) & 0xFF in (ord("q"), ord("Q")):
                break

        cap.release()
        cv2.destroyAllWindows()

        print("\n[INFO] Live detection stopped")


# =====================================================
# CALLBACK
# =====================================================

def on_person_detected(data):

    print("\n[ALERT] DETECTED")
    print("Category :", data["category"])
    print("Name     :", data["name"])
    print("Confidence:", data["confidence"])


# =====================================================
# MAIN TEST
# =====================================================

if __name__ == "__main__":

    MODEL_PATH = r"D:\PROJECTS\NEHRU(btech)\MISSING PERON AND CRIMINAL\project\face_model.pkl"

    detector = LiveFaceDetector(
        model_path=MODEL_PATH,
        threshold=0.9,
        on_detect=on_person_detected
    )

    detector.start_live_detection()