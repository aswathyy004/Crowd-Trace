from django.db import models
from django.contrib.auth.models import User

class Category(models.Model):
    category_name = models.CharField(max_length=255)

class policestation(models.Model):
    station_name = models.CharField(max_length=255)
    place = models.CharField(max_length=255)
    station_head = models.CharField(max_length=255)
    latitude = models.CharField(max_length=255)
    longitude = models.CharField(max_length=255)
    phone = models.CharField(max_length=20)

class police(models.Model):
    USER = models.OneToOneField(User, on_delete=models.CASCADE)
    policestation = models.ForeignKey(policestation, on_delete=models.CASCADE)
    full_name = models.CharField(max_length=255)
    address = models.CharField(max_length=255)
    phone = models.CharField(max_length=20)
    designation = models.CharField(max_length=255)
    photo = models.FileField(upload_to="police")

class UserProfile(models.Model):
    USER = models.OneToOneField(User, on_delete=models.CASCADE)
    name = models.CharField(max_length=255)
    address = models.CharField(max_length=255)
    place = models.CharField(max_length=255)
    phone = models.CharField(max_length=20)
    email = models.EmailField()
    aadhar = models.CharField(max_length=255)
    last_notification_check = models.CharField(max_length=255,null=True,blank=True)

class Case_file(models.Model):
    USER = models.ForeignKey(UserProfile, on_delete=models.CASCADE)
    police_station = models.ForeignKey(policestation, on_delete=models.CASCADE,null=True,blank=True)
    description = models.CharField(max_length=255)
    progress = models.CharField(max_length=255,default="pending")
    status = models.CharField(max_length=255,default="pending")
    photo = models.FileField(upload_to="cases")
    date = models.CharField(max_length=255)

    phone = models.CharField(max_length=255,null=True,blank=True)
    name = models.CharField(max_length=255,null=True,blank=True)
    address = models.CharField(max_length=255,null=True,blank=True)
    phone = models.CharField(max_length=20,null=True,blank=True)
    email = models.EmailField(null=True,blank=True)
    Missing_place = models.CharField(max_length=255,null=True,blank=True)
    age = models.CharField(max_length=255,null=True,blank=True)
    date_of_birth=models.CharField(max_length=222,null=True,blank=True)
    Gender=models.CharField(max_length=222,null=True,blank=True)
    parent_name=models.CharField(max_length=222,null=True,blank=True)
    items_carried=models.CharField(max_length=222,null=True,blank=True)
    Height=models.CharField(max_length=222,null=True,blank=True)
    identification_marks =models.CharField(max_length=222,null=True,blank=True)
    clothes_ornaments =models.CharField(max_length=222,null=True,blank=True)
    report=models.CharField(max_length=2000,null=True,blank=True)



class Complaint(models.Model):
    USER = models.ForeignKey(User, on_delete=models.CASCADE)
    description = models.CharField(max_length=255)
    reply = models.CharField(max_length=255)
    date = models.CharField(max_length=255)
    status = models.CharField(max_length=255)

class feedback(models.Model):
    USER = models.ForeignKey(User, on_delete=models.CASCADE)
    message = models.CharField(max_length=255)
    date = models.CharField(max_length=255)

class criminal(models.Model):
    POLICE = models.ForeignKey(police, on_delete=models.CASCADE)
    name = models.CharField(max_length=255)
    age = models.CharField(max_length=255)
    gender = models.CharField(max_length=255)
    details = models.CharField(max_length=255)
    photo = models.FileField(upload_to="criminal")


class Missing_person(models.Model):
    POLICE = models.ForeignKey(police, on_delete=models.CASCADE)
    name = models.CharField(max_length=255)
    age = models.CharField(max_length=255)
    gender = models.CharField(max_length=255)
    details = models.CharField(max_length=255)
    photo = models.FileField(upload_to="missing")

class User_upload(models.Model):
    USER = models.ForeignKey(UserProfile, on_delete=models.CASCADE)
    Missing_person = models.ForeignKey(Missing_person, on_delete=models.CASCADE, null=True, blank=True)
    criminal = models.ForeignKey(criminal, on_delete=models.CASCADE, null=True, blank=True)
    category = models.CharField(max_length=255)
    date = models.CharField(max_length=255)
    latitude = models.CharField(max_length=255)
    longitude = models.CharField(max_length=255)
    photo = models.FileField(upload_to="criminal")

class Public_Upload(models.Model):
    Missing_person = models.ForeignKey(Missing_person, on_delete=models.CASCADE,null=True, blank=True)
    criminal = models.ForeignKey(criminal, on_delete=models.CASCADE,null=True, blank=True)
    description = models.CharField(max_length=255)
    date = models.CharField(max_length=255)
    latitude = models.CharField(max_length=255)
    longitude = models.CharField(max_length=255)
    photo = models.FileField(upload_to="criminal")

class Live_detection(models.Model):
    criminal = models.ForeignKey(criminal, on_delete=models.CASCADE, null=True, blank=True)
    Missing_person = models.ForeignKey(Missing_person, on_delete=models.CASCADE, null=True, blank=True)
    name = models.CharField(max_length=255)
    category = models.CharField(max_length=255)
    confidence = models.CharField(max_length=255)
    photo = models.FileField(upload_to="live_detections")
    date = models.CharField(max_length=255)
    status = models.CharField(max_length=255, default="detected")
