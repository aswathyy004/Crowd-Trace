"""
URL configuration for crowdtraceproject project.

The `urlpatterns` list routes URLs to views. For more information please see:
    https://docs.djangoproject.com/en/5.2/topics/http/urls/
Examples:
Function views
    1. Add an import:  from my_app import views
    2. Add a URL to urlpatterns:  path('', views.home, name='home')
Class-based views
    1. Add an import:  from other_app.views import Home
    2. Add a URL to urlpatterns:  path('', Home.as_view(), name='home')
Including another URLconf
    1. Import the include() function: from django.urls import include, path
    2. Add a URL to urlpatterns:  path('blog/', include('blog.urls'))
"""
from django.contrib import admin
from django.urls import path

from myapp import views

urlpatterns = [

    path('',views.home,name='home'),
    path('login/',views.login,name='login'),
    path('register/',views.register,name='register'),
    path('admin_home/',views.admin_home,name='admin_home'),
    path('admin_sidebat/',views.admin_sidebar,name='admin_sidebar'),
    path('casefile/',views.casefile,name='casefile'),
    path('profile_card/',views.profile_card,name='profile_card'),
    path('police_station/',views.admin_add_station,name='police_station'),
    path('manage_station/',views.manage_station,name='manage_station'),
    path('admin_add_station/',views.admin_add_station,name='admin_add_station'),
    path('admin_add_police/<int:station_id>/', views.admin_add_police, name='admin_add_police'),
    path('admin_viewUsers/', views.admin_viewUsers, name='admin_viewUsers'),
    path('admin_viewComplaints/', views.admin_viewComplaints, name='admin_viewComplaints'),
    path('police_home/', views.police_home, name='police_home'),
    path('police_casefile/', views.police_casefile, name='police_casefile'),
    path('manage_casefile/', views.manage_casefile, name='manage_casefile'),
    path('view_missing_criminal/', views.view_missing_criminal, name='view_missing_criminal'),
    path('police_profile/', views.view_police_profile, name='view_police_profile'),
    path('police_addmissingCase/', views.police_addmissingCase, name='police_addmissingCase'),
    path('police_addCriminalCase/', views.police_addCriminalCase, name='police_addCriminalCase'),
    path('police_send_complaint/', views.police_send_complaint, name='police_send_complaint'),
    path('user_register/', views.user_register, name='user_register'),
    path('user_login/', views.user_login, name='user_login'),
    path('user_view_complaints/', views.user_view_complaints, name='user_view_complaints'),
    path('user_send_complaint/', views.user_send_complaint, name='user_luser_send_complaintogin'),
    path('send_reply/<int:id>', views.send_reply, name='send_reply'),
    path('user_view_feedback/', views.user_view_feedback, name='user_view_feedback'),
    path('user_send_feedback/', views.user_send_feedback, name='user_luser_send_feedbackogin'),
    path('ViewPolice/', views.ViewPolice, name='ViewPolice'),
    path('View_Police_Station/', views.View_Police_Station,name="View_Police_Station"),
    path('user_view_missing_persons/', views.user_view_missing_persons,name="user_view_missing_persons"),
    path('user_view_criminals/', views.user_view_criminals,name="user_view_criminals"),
    path('forgot_password/', views.forgot_password, name='forgot_password'),
    path('user_forgot_password/', views.user_forgot_password, name='user_forgot_password'),

    path('user_report_case/', views.user_report_case),
    path('user_view_cases/', views.user_view_cases),

    path('police_view_cases', views.police_view_cases, name='police_view_cases'),

    path('police_view_user_case/<int:id>/', views.police_view_user_case, name='police_view_user_case'),
    path('police_update_case/<int:id>', views.police_update_case, name='police_update_case'),
    path("police_detect_person/",views.police_detect_person,name="police_detect_person"),

    path("admin_live_camera/",views.admin_live_camera,name="admin_live_camera"),
    path("video_feed/",views.video_feed,name="video_feed"),
    path('admin_live_detections/', views.admin_view_live_detections, name='admin_live_detections'),

    path("user_detect_person/", views.user_detect_person),
    path("user_view_detections/", views.user_view_detections),

    path('police_live_detections/', views.police_live_detections, name='police_live_detections'),

    path("police_view_uploads/", views.police_view_uploads, name="police_view_uploads"),

    path('public_detect_person/', views.public_detect_person),

    path('get_alerts/', views.get_alerts, name='get_alerts'),



]

