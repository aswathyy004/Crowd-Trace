# import os
# import torch
# import numpy as np
# import pickle
# import cv2
# from PIL import Image
# from facenet_pytorch import MTCNN, InceptionResnetV1
#
#
# class FaceDetector:
#
#     def __init__(self, model_path="face_model.pkl", threshold=0.9):
#
#         if not os.path.exists(model_path):
#             raise FileNotFoundError("Model not found: " + model_path)
#
#         self.threshold = threshold
#
#         self.device = torch.device(
#             "cuda" if torch.cuda.is_available() else "cpu"
#         )
#
#         print("[INFO] Device:", self.device)
#
#         # FACE DETECTOR
#         self.mtcnn = MTCNN(
#             image_size=160,
#             margin=10,
#             keep_all=True,
#             device=self.device
#         )
#
#         # FACENET MODEL
#         self.resnet = InceptionResnetV1(
#             pretrained="vggface2"
#         ).eval().to(self.device)
#
#         # LOAD DATABASE
#         with open(model_path, "rb") as f:
#             self.database = pickle.load(f)
#
#         print("[OK] Loaded faces:", len(self.database))
#
#
#     # =====================================================
#     # EXTRACT EMBEDDING
#     # =====================================================
#
#     def extract_embedding(self, face_tensor):
#
#         with torch.no_grad():
#
#             face_tensor = face_tensor.unsqueeze(0).to(self.device)
#
#             emb = self.resnet(face_tensor)
#
#         return emb.cpu().numpy()[0]
#
#
#     # =====================================================
#     # IDENTIFY FACE
#     # =====================================================
#
#     def identify(self, embedding):
#
#         best_dist = float("inf")
#         best_key = None
#
#         for key, db_emb in self.database.items():
#
#             dist = np.linalg.norm(
#                 embedding - np.array(db_emb)
#             )
#
#             if dist < best_dist:
#                 best_dist = dist
#                 best_key = key
#
#         if best_key and best_dist < self.threshold:
#
#             parts = best_key.split("|")
#
#             role = parts[0]
#             pid = parts[1]
#             name = parts[2]
#
#             confidence = round(max(0.0, 1 - best_dist), 2)
#
#             return {
#                 "status": "matched",
#                 "category": "Missing Person" if role == "MISSING" else "Criminal",
#                 "id": pid,
#                 "name": name,
#                 "confidence": confidence
#             }
#
#         return {"status": "unknown"}
#
#
#     # =====================================================
#     # IMAGE DETECTION
#     # =====================================================
#
#     def detect_from_image(self, image_path):
#
#         img = Image.open(image_path).convert("RGB")
#
#         faces, probs = self.mtcnn(img, return_prob=True)
#
#         if faces is None:
#             return []
#
#         results = []
#         detected_people = {}
#
#         if faces.dim() == 3:
#             faces = faces.unsqueeze(0)
#
#         for face in faces:
#
#             emb = self.extract_embedding(face)
#
#             result = self.identify(emb)
#
#             if result["status"] == "matched":
#
#                 key = result["name"]
#
#                 if key not in detected_people:
#                     detected_people[key] = result
#
#         return list(detected_people.values())
#
#
#     # =====================================================
#     # VIDEO FILE DETECTION
#     # =====================================================
#
#     def detect_from_video(self, video_path):
#
#         cap = cv2.VideoCapture(video_path)
#
#         detected_people = {}
#
#         while True:
#
#             ret, frame = cap.read()
#
#             if not ret:
#                 break
#
#             rgb = cv2.cvtColor(frame, cv2.COLOR_BGR2RGB)
#
#             img = Image.fromarray(rgb)
#
#             faces, probs = self.mtcnn(img, return_prob=True)
#             boxes, _ = self.mtcnn.detect(img)
#
#             if faces is None or boxes is None:
#                 continue
#
#             if faces.dim() == 3:
#                 faces = faces.unsqueeze(0)
#
#             for i in range(len(faces)):
#
#                 face = faces[i]
#                 box = boxes[i]
#
#                 emb = self.extract_embedding(face)
#
#                 result = self.identify(emb)
#
#                 x1, y1, x2, y2 = map(int, box)
#
#                 if result["status"] == "matched":
#
#                     label = f"{result['name']} ({result['category']})"
#                     color = (0, 255, 0)
#
#                     key = result["name"]
#
#                     if key not in detected_people:
#                         detected_people[key] = result
#
#                 else:
#
#                     label = "Unknown"
#                     color = (0, 0, 255)
#
#                 cv2.rectangle(frame, (x1, y1), (x2, y2), color, 2)
#
#                 cv2.putText(
#                     frame,
#                     label,
#                     (x1, y1 - 10),
#                     cv2.FONT_HERSHEY_SIMPLEX,
#                     0.7,
#                     color,
#                     2
#                 )
#
#             cv2.imshow("Face Detection", frame)
#
#             if cv2.waitKey(1) & 0xFF == ord("q"):
#                 break
#
#         cap.release()
#         cv2.destroyAllWindows()
#
#         return list(detected_people.values())
#
#
#     # =====================================================
#     # LIVE WEBCAM DETECTION
#     # =====================================================
#
#     def detect_live(self):
#
#         cap = cv2.VideoCapture(0)
#
#         detected_people = {}
#
#         print("[INFO] Live camera started (press Q to exit)")
#
#         while True:
#
#             ret, frame = cap.read()
#
#             if not ret:
#                 break
#
#             rgb = cv2.cvtColor(frame, cv2.COLOR_BGR2RGB)
#
#             img = Image.fromarray(rgb)
#
#             faces, probs = self.mtcnn(img, return_prob=True)
#             boxes, _ = self.mtcnn.detect(img)
#
#             if faces is None or boxes is None:
#
#                 cv2.imshow("Live Detection", frame)
#
#                 if cv2.waitKey(1) & 0xFF == ord("q"):
#                     break
#
#                 continue
#
#             if faces.dim() == 3:
#                 faces = faces.unsqueeze(0)
#
#             for i in range(len(faces)):
#
#                 face = faces[i]
#                 box = boxes[i]
#
#                 emb = self.extract_embedding(face)
#
#                 result = self.identify(emb)
#
#                 x1, y1, x2, y2 = map(int, box)
#
#                 if result["status"] == "matched":
#
#                     label = f"{result['name']} ({result['category']})"
#                     color = (0, 255, 0)
#
#                     key = result["name"]
#
#                     if key not in detected_people:
#                         detected_people[key] = result
#
#                 else:
#
#                     label = "Unknown"
#                     color = (0, 0, 255)
#
#                 cv2.rectangle(frame, (x1, y1), (x2, y2), color, 2)
#
#                 cv2.putText(
#                     frame,
#                     label,
#                     (x1, y1 - 10),
#                     cv2.FONT_HERSHEY_SIMPLEX,
#                     0.7,
#                     color,
#                     2
#                 )
#
#             cv2.imshow("Live Detection", frame)
#
#             if cv2.waitKey(1) & 0xFF == ord("q"):
#                 break
#
#         cap.release()
#         cv2.destroyAllWindows()
#
#         return list(detected_people.values())
#
#
# # =====================================================
# # TESTING
# # =====================================================
#
# if __name__ == "__main__":
#
#     detector = FaceDetector("face_model.pkl")
#
#     print("\nIMAGE TEST")
#     print(detector.detect_from_image("test.jpg"))
#
#     # detector.detect_from_video("video.mp4")
#
#     detector.detect_live()
#


import os
import torch
import numpy as np
import pickle
import cv2
from PIL import Image
from facenet_pytorch import MTCNN, InceptionResnetV1
from sklearn.metrics.pairwise import cosine_similarity


class FaceDetector:

    def __init__(self, model_path="face_model.pkl", threshold=0.65):

        if not os.path.exists(model_path):
            raise FileNotFoundError("Model not found: " + model_path)

        self.threshold = threshold

        self.device = torch.device(
            "cuda" if torch.cuda.is_available() else "cpu"
        )

        print("[INFO] Device:", self.device)

        # FACE DETECTOR
        self.mtcnn = MTCNN(
            image_size=160,
            margin=10,
            keep_all=True,
            device=self.device
        )

        # FACENET MODEL
        self.resnet = InceptionResnetV1(
            pretrained="vggface2"
        ).eval().to(self.device)

        # LOAD FACE DATABASE
        with open(model_path, "rb") as f:
            self.database = pickle.load(f)

        print("[OK] Loaded faces:", len(self.database))


    # =====================================================
    # EXTRACT EMBEDDING
    # =====================================================

    def extract_embedding(self, face_tensor):

        with torch.no_grad():

            face_tensor = face_tensor.unsqueeze(0).to(self.device)

            emb = self.resnet(face_tensor)

        return emb.cpu().numpy()[0]


    # =====================================================
    # IDENTIFY FACE
    # =====================================================

    def identify(self, embedding):

        if len(self.database) == 0:
            return {"status": "unknown"}

        best_score = -1
        best_key = None

        embedding = embedding.reshape(1, -1)

        for key, db_emb in self.database.items():

            db_emb = np.array(db_emb).reshape(1, -1)

            score = cosine_similarity(embedding, db_emb)[0][0]

            if score > best_score:
                best_score = score
                best_key = key

        if best_key and best_score > self.threshold:

            parts = best_key.split("|")

            role = parts[0]
            pid = parts[1]
            name = parts[2]

            return {
                "status": "matched",
                "category": "Missing Person" if role == "MISSING" else "Criminal",
                "id": pid,
                "name": name,
                "confidence": round(float(best_score), 2)
            }

        return {"status": "unknown"}


    # =====================================================
    # IMAGE DETECTION
    # =====================================================

    def detect_from_image(self, image_path):

        img = Image.open(image_path).convert("RGB")

        faces, probs = self.mtcnn(img, return_prob=True)

        if faces is None:
            return []

        results = []
        detected_people = {}

        if faces.dim() == 3:
            faces = faces.unsqueeze(0)

        for face in faces:

            emb = self.extract_embedding(face)

            result = self.identify(emb)

            if result["status"] == "matched":

                key = result["name"]

                if key not in detected_people:
                    detected_people[key] = result

        return list(detected_people.values())


    # =====================================================
    # VIDEO FILE DETECTION
    # =====================================================

    def detect_from_video(self, video_path):

        cap = cv2.VideoCapture(video_path)

        detected_people = {}

        while True:

            ret, frame = cap.read()

            if not ret:
                break

            rgb = cv2.cvtColor(frame, cv2.COLOR_BGR2RGB)

            img = Image.fromarray(rgb)

            faces, probs = self.mtcnn(img, return_prob=True)
            boxes, _ = self.mtcnn.detect(img)

            if faces is None or boxes is None:
                continue

            if faces.dim() == 3:
                faces = faces.unsqueeze(0)

            for i in range(len(faces)):

                face = faces[i]
                box = boxes[i]

                emb = self.extract_embedding(face)

                result = self.identify(emb)

                x1, y1, x2, y2 = map(int, box)

                if result["status"] == "matched":

                    label = f"{result['name']} ({result['category']})"
                    color = (0, 255, 0)

                    key = result["name"]

                    if key not in detected_people:
                        detected_people[key] = result

                else:

                    label = "Unknown"
                    color = (0, 0, 255)

                cv2.rectangle(frame, (x1, y1), (x2, y2), color, 2)

                cv2.putText(
                    frame,
                    label,
                    (x1, y1 - 10),
                    cv2.FONT_HERSHEY_SIMPLEX,
                    0.7,
                    color,
                    2
                )

            cv2.imshow("Face Detection", frame)

            if cv2.waitKey(1) & 0xFF == ord("q"):
                break

        cap.release()
        cv2.destroyAllWindows()

        return list(detected_people.values())


    # =====================================================
    # LIVE WEBCAM DETECTION
    # =====================================================

    def detect_live(self):

        cap = cv2.VideoCapture(0)

        detected_people = {}

        print("[INFO] Live camera started (press Q to exit)")

        while True:

            ret, frame = cap.read()

            if not ret:
                break

            rgb = cv2.cvtColor(frame, cv2.COLOR_BGR2RGB)

            img = Image.fromarray(rgb)

            faces, probs = self.mtcnn(img, return_prob=True)
            boxes, _ = self.mtcnn.detect(img)

            if faces is None or boxes is None:

                cv2.imshow("Live Detection", frame)

                if cv2.waitKey(1) & 0xFF == ord("q"):
                    break

                continue

            if faces.dim() == 3:
                faces = faces.unsqueeze(0)

            for i in range(len(faces)):

                face = faces[i]
                box = boxes[i]

                emb = self.extract_embedding(face)

                result = self.identify(emb)

                x1, y1, x2, y2 = map(int, box)

                if result["status"] == "matched":

                    label = f"{result['name']} ({result['category']})"
                    color = (0, 255, 0)

                    key = result["name"]

                    if key not in detected_people:
                        detected_people[key] = result

                else:

                    label = "Unknown"
                    color = (0, 0, 255)

                cv2.rectangle(frame, (x1, y1), (x2, y2), color, 2)

                cv2.putText(
                    frame,
                    label,
                    (x1, y1 - 10),
                    cv2.FONT_HERSHEY_SIMPLEX,
                    0.7,
                    color,
                    2
                )

            cv2.imshow("Live Detection", frame)

            if cv2.waitKey(1) & 0xFF == ord("q"):
                break

        cap.release()
        cv2.destroyAllWindows()

        return list(detected_people.values())


# =====================================================
# TESTING
# =====================================================

if __name__ == "__main__":

    detector = FaceDetector("face_model.pkl")

    print("\nIMAGE TEST")
    print(detector.detect_from_image("test.jpg"))

    # detector.detect_from_video("video.mp4")

    detector.detect_live()