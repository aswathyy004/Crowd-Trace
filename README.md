# CrowdTrace - Missing Person Identification System

## Overview

CrowdTrace is a web-based Missing Person Identification System designed to assist law enforcement agencies and communities in locating missing individuals more efficiently. The platform enables users to report missing persons, submit sightings with location information, and support investigations through digital evidence collection and AI-assisted facial recognition.

The system aims to improve communication between the public and authorities while reducing delays in missing person investigations.

---

## Features

### Missing Person Management
- Register missing person cases
- Store personal and identification details
- Track case status and investigation progress

### Facial Recognition
- AI-powered face matching using FaceNet
- Compare uploaded images against stored records
- Assist in identifying potential matches

### GPS-Based Evidence Collection
- Submit sightings with location information
- Upload supporting evidence and images
- Improve investigation accuracy through geolocation data

### Criminal Identification
- Maintain criminal records
- Support identification through image comparison
- Assist law enforcement during investigations

### Complaint & Feedback System
- Submit complaints and feedback
- Facilitate communication between users and authorities

### Police Investigation Workflow
- Review reported cases
- Update investigation progress
- Manage missing person and criminal records

---

## User Roles

### Administrator
- Manage users and police stations
- Monitor system activities
- Handle complaints and feedback

### Police Officer
- Review and verify cases
- Manage investigations
- Update case status
- Maintain records

### Registered User
- Report missing persons
- Track case progress
- Submit evidence and sightings

### Public User
- View public case information
- Submit anonymous sightings
- Assist in investigations

---

## Technology Stack

### Frontend
- HTML
- CSS
- Bootstrap

### Backend
- Django (Python)

### Database
- MySQL

### AI & Computer Vision
- OpenCV
- FaceNet-PyTorch
- Facial Recognition Models

### Additional Tools
- GPS Location Tracking
- Image Processing

---

## System Architecture

```text
Users / Public
       │
       ▼
  Web Interface
       │
       ▼
 Django Backend
       │
 ┌─────┴─────┐
 ▼           ▼
MySQL     Face Recognition
Database      Engine
       │
       ▼
 Investigation & Tracking
```

---

## Installation

### Clone the Repository

```bash
git clone https://github.com/your-username/CrowdTrace.git
cd CrowdTrace
```

### Create Virtual Environment

```bash
python -m venv .venv
```

### Activate Virtual Environment

Windows:

```bash
.venv\Scripts\activate
```

Linux/macOS:

```bash
source .venv/bin/activate
```

### Install Dependencies

```bash
pip install -r requirements.txt
```

### Configure Database

Update database settings in:

```python
settings.py
```

with your MySQL credentials.

### Apply Migrations

```bash
python manage.py migrate
```

### Run the Server

```bash
python manage.py runserver
```

Open:

```text
http://127.0.0.1:8000/
```

---

## Project Structure

```text
CrowdTrace/
│
├── crowdtraceproject/
│   ├── settings.py
│   ├── urls.py
│   ├── wsgi.py
│   └── asgi.py
│
├── templates/
├── static/
├── media/
├── requirements.txt
├── manage.py
└── README.md
```

---

## Future Enhancements

- Real-time notifications
- Advanced face recognition models
- Mobile application support
- Cloud deployment
- Investigation analytics dashboard
- Multi-language support

---

## Contributors

- Aswathy K R
- Abijith K
- Akash R
- Ashwin Biju
  
---

## License

This project was developed for academic and research purposes as part of a Computer Science and Engineering final-year project.
