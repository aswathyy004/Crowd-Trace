# from _pydatetime import datetime
# from django.contrib.auth.models import User
# from django.contrib import messages
# from django.http import JsonResponse
# from django.shortcuts import render, get_object_or_404
# from django.contrib.auth.decorators import login_required
# from django.contrib.auth import authenticate, login as auth_login
# from django.contrib.auth.models import Group
# from django.views.decorators.csrf import csrf_exempt
# from django.shortcuts import redirect
# from django.urls import reverse
# from myapp.models import *
# import math
#
#
# def home(request):
#     return render(request,'index.html')
#
#
#
# def login(request):
#     if request.method == "POST":
#         A = request.POST.get("u")
#         B = request.POST.get("p")
#
#         user = authenticate(request, username=A, password=B)
#
#         if user is not None:
#             auth_login(request, user)
#             request.session['user_id'] = user.id
#
#             if user.groups.filter(name="admin").exists():
#                 return redirect("admin_home")
#
#             elif user.groups.filter(name="police").exists():
#                 Police = police.objects.get(USER=user)
#                 request.session['police_id'] = Police.id
#                 return redirect("police_home")
#
#             else:
#                 return redirect("login")
#
#         else:
#             messages.error(request,'Invalid username or password')
#             return redirect('login')
#
#     return render(request, "login.html")
#
#
#
# def admin_add_station(request):
#     if request.method=='POST':
#         s=request.POST['staion_name']
#         p = request.POST['place']
#         station=request.POST['station_Head']
#         Phone= request.POST['Phone']
#         latitude = request.POST['lati']
#         longitude = request.POST['longi']
#
#         policestation.objects.create(station_name=s,place=p,station_head=station,phone=Phone,latitude=latitude,longitude=longitude)
#         return redirect(admin_home)
#
#     police=policestation.objects.all()
#
#
#
#     return render(request,'admin_add_station.html',{ 'police':police })
#
#
# def register(request):
#     return render(request,'register.html')
#
# def admin_home(request):
#     from myapp.models import UserProfile, Complaint, Missing_person, criminal, policestation, police
#     total_users      = UserProfile.objects.count()
#     total_missing    = Missing_person.objects.count()
#     total_criminals  = criminal.objects.count()
#     total_stations   = policestation.objects.count()
#     total_police     = police.objects.count()
#     total_complaints = Complaint.objects.count()
#     pending_complaints = Complaint.objects.filter(status__iexact='pending').count()
#     replied_complaints = Complaint.objects.filter(status__iexact='replied').count()
#     missing_persons  = Missing_person.objects.all().order_by('-id')
#     criminals        = criminal.objects.all().order_by('-id')
#     stations         = policestation.objects.all().order_by('station_name')
#     recent_users     = UserProfile.objects.all().order_by('-id')[:6]
#     recent_complaints = Complaint.objects.all().order_by('-id')[:6]
#
#     return render(request, 'admin_home.html', {
#         'total_users':         total_users,
#         'total_missing':       total_missing,
#         'total_criminals':     total_criminals,
#         'total_stations':      total_stations,
#         'total_police':        total_police,
#         'total_complaints':    total_complaints,
#         'pending_complaints':  pending_complaints,
#         'replied_complaints':  replied_complaints,
#         'missing_persons':     missing_persons,
#         'criminals':           criminals,
#         'stations':            stations,
#         'recent_users':        recent_users,
#         'recent_complaints':   recent_complaints,
#     })
#
# def admin_sidebar(request):
#     return render(request,'admin_sidebar.html')
# def casefile(request):
#     return render(request,'casefile.html')
# # def profile_card(request):
# #     from myapp.models import Missing_person, criminal
# #     missing_persons = Missing_person.objects.all().order_by('-id')
# #     criminals       = criminal.objects.all().order_by('-id')
# #     return render(request, 'profile_card.html', {
# #         'missing_persons': missing_persons,
# #         'criminals':       criminals,
# #     })
#
#
# def profile_card(request):
#     from myapp.models import Missing_person, criminal, Case_file
#     missing_persons = Missing_person.objects.all().order_by('-id')
#     criminals = criminal.objects.all().order_by('-id')
#
#     # Build a Missing_person id → Case_file map from approved cases (most recent per person)
#     approved_cases = Case_file.objects.filter(status='Approved').order_by('-id')
#     case_map = {}
#     for case in approved_cases:
#         # Primary: match by FK relationship (Missing_person_id)
#         if hasattr(case, 'Missing_person_id') and case.Missing_person_id:
#             key = case.Missing_person_id
#             if key not in case_map:
#                 case_map[key] = case
#         # Fallback: match by name string if no FK present
#         elif hasattr(case, 'name') and case.name:
#             key = ('name', (case.name or '').strip().lower())
#             if key not in case_map:
#                 case_map[key] = case
#
#     # Attach the matching case file to each missing person
#     for person in missing_persons:
#         # Try FK match first
#         case = case_map.get(person.id)
#         if case is None:
#             # Try name fallback
#             name_key = ('name', (person.name or '').strip().lower())
#             case = case_map.get(name_key)
#         person.case_data = case
#
#     return render(request, 'profile_card.html', {
#         'missing_persons': missing_persons,
#         'criminals': criminals,
#     })
#
#
#
# def admin_viewUsers (request):
#     a = UserProfile.objects.all()
#     print(a)
#     return render(request,'admin_viewUsers.html',{'a':a})
#
#
#
# def send_reply(request, id):
#     if request.method == 'POST':
#         r = request.POST.get('reply', '').strip()
#         if r:
#             c = get_object_or_404(Complaint, id=id)
#             c.reply = r
#             c.status = "Replied"
#             c.save()
#     return redirect(reverse("admin_viewComplaints"))
#
#
#
# def admin_viewComplaints (request):
#     a=Complaint.objects.all()
#     print(a)
#     return render(request,'admin_viewComplaints.html',{'a':a})
#
#
# #
# # def admin_add_police(request, station_id):
# #     station = get_object_or_404(policestation, id=station_id)
# #     police_list = police.objects.filter(policestation=station)
# #
# #     if request.method == "POST":
# #         user = User.objects.create_user(
# #             username=request.POST['username'],
# #             password=request.POST['password']
# #         )
# #
# #         police_group, _ = Group.objects.get_or_create(name="police")
# #         user.groups.add(police_group)
# #
# #         police.objects.create(
# #             USER=user,
# #             policestation=station,
# #             full_name=request.POST['full_name'],
# #             address=request.POST['address'],
# #             phone=request.POST['phone'],
# #             designation=request.POST['designation'],
# #             photo=request.FILES['photo']
# #         )
# #
# #         return redirect("admin_add_police", station_id=station.id)
# #
# #     return render(request, "admin_addpolice.html", {
# #         "station": station,
# #         "police_list": police_list
# #     })
#
# def admin_add_police(request, station_id):
#
#     station = get_object_or_404(policestation, id=station_id)
#     police_list = police.objects.filter(policestation=station)
#
#     if request.method == "POST":
#
#         username = request.POST['username']
#         password = request.POST['password']
#         email = request.POST['email']
#         full_name = request.POST['full_name']
#         address = request.POST['address']
#         phone = request.POST['phone']
#         designation = request.POST['designation']
#         photo = request.FILES['photo']
#
#         # Create Auth User
#         user = User.objects.create_user(
#             username=username,
#             email=email,
#             password=password
#         )
#
#         # Add user to police group
#         police_group, created = Group.objects.get_or_create(name="police")
#         user.groups.add(police_group)
#
#         # Create Police profile
#         police.objects.create(
#             USER=user,
#             policestation=station,
#             full_name=full_name,
#             address=address,
#             phone=phone,
#             designation=designation,
#             photo=photo
#         )
#
#         messages.success(request, "Officer registered successfully!")
#
#         return redirect("admin_add_police", station_id=station.id)
#
#     return render(request, "admin_addpolice.html", {
#         "station": station,
#         "police_list": police_list
#     })
#
#
# def manage_station(request):
#     from myapp.models import policestation, police, Missing_person, criminal
#
#     stations        = policestation.objects.all().order_by('station_name')
#     total_stations  = stations.count()
#     total_police    = police.objects.count()
#     total_missing   = Missing_person.objects.count()
#     total_criminals = criminal.objects.count()
#
#     missing_persons = Missing_person.objects.select_related(
#         'POLICE__policestation'
#     ).all().order_by('-id')
#
#     return render(request, 'manage_station.html', {
#         'stations':        stations,
#         'total_stations':  total_stations,
#         'total_police':    total_police,
#         'total_missing':   total_missing,
#         'total_criminals': total_criminals,
#         'missing_persons': missing_persons,
#     })
#
#
#
# def _get_police(request):
#     try:
#         from myapp.models import police as Police
#         return Police.objects.select_related('policestation').get(
#             id=request.session.get('police_id')
#         )
#     except Exception:
#         return None
#
# @login_required
# def view_police_profile(request):
#     officer = get_object_or_404(police, USER=request.user)
#     return render(request, 'police/police_profile.html', {'police': officer})
#
#
# def police_casefile(request):
#     return render(request,'police/police_casefile.html')
#
# # def manage_casefile(request):
# #     officer = _get_police(request)
# #     person  = Missing_person.objects.filter(POLICE=request.session['police_id'])
# #     return render(request, 'police/police_view_missing_person.html', {
# #         'person': person,
# #         'police': officer,
# #     })
#
#
# # AFTER
# def manage_casefile(request):
#     police_id = request.session.get('police_id')
#     if not police_id:
#         return redirect('login')
#     officer = _get_police(request)
#     person  = Missing_person.objects.filter(POLICE=police_id)
#     ...
#
# # AFTER
# def view_missing_criminal(request):
#     police_id = request.session.get('police_id')
#     if not police_id:
#         return redirect('login')
#     officer = _get_police(request)
#     person  = criminal.objects.filter(POLICE=police_id)
#     return render(request, 'police/police_view_missing_criminals.html', {
#         'person': person,
#         'police': officer,
#     })
#
# def police_send_complaint(request):
#     officer    = _get_police(request)
#     Police_usr = User.objects.get(id=request.session['user_id'])
#     complaint  = Complaint.objects.filter(USER=request.session['user_id'])
#     if request.method == 'POST':
#         description = request.POST['message']
#         Complaint.objects.create(
#             USER=Police_usr,
#             description=description,
#             reply='pending',
#             date=datetime.now().strftime('%d/%m/%Y %I:%M %p'),
#             status='pending'
#         )
#         return redirect('police_send_complaint')
#     return render(request, 'police/police_send_complaint.html', {
#         'complaints': complaint,
#         'police':     officer,
#     })
#
# def police_home(request):
#     from myapp.models import police as Police, Missing_person, criminal, Complaint
#     from django.contrib.auth.models import User
#     from _pydatetime import datetime
#
#     officer = _get_police(request)   # uses the helper defined earlier
#
#     police_id = request.session.get('police_id')
#     user_id   = request.session.get('user_id')
#
#     # ── counts ──────────────────────────────────────────────
#     total_missing   = Missing_person.objects.filter(POLICE=police_id).count()
#     total_criminals = criminal.objects.filter(POLICE=police_id).count()
#     total_complaints = Complaint.objects.filter(USER=user_id).count()
#     pending_complaints = Complaint.objects.filter(USER=user_id, status__iexact='pending').count()
#     replied_complaints = Complaint.objects.filter(USER=user_id, status__iexact='replied').count()
#
#     # ── gender breakdown (missing) ───────────────────────────
#     missing_male   = Missing_person.objects.filter(POLICE=police_id, gender__iexact='male').count()
#     missing_female = Missing_person.objects.filter(POLICE=police_id, gender__iexact='female').count()
#
#     # ── gender breakdown (criminal) ──────────────────────────
#     criminal_male   = criminal.objects.filter(POLICE=police_id, gender__iexact='male').count()
#     criminal_female = criminal.objects.filter(POLICE=police_id, gender__iexact='female').count()
#
#     # ── recent records ───────────────────────────────────────
#     recent_missing   = Missing_person.objects.filter(POLICE=police_id).order_by('-id')[:5]
#     recent_criminals = criminal.objects.filter(POLICE=police_id).order_by('-id')[:5]
#     recent_complaints = Complaint.objects.filter(USER=user_id).order_by('-id')[:4]
#
#     # ── age distribution for missing persons ─────────────────
#     missing_all = Missing_person.objects.filter(POLICE=police_id)
#     age_0_18  = sum(1 for p in missing_all if p.age and int(p.age) <= 18)
#     age_19_35 = sum(1 for p in missing_all if p.age and 19 <= int(p.age) <= 35)
#     age_36_60 = sum(1 for p in missing_all if p.age and 36 <= int(p.age) <= 60)
#     age_60p   = sum(1 for p in missing_all if p.age and int(p.age) > 60)
#
#     return render(request, 'police/police_home.html', {
#         'police':             officer,
#         'total_missing':      total_missing,
#         'total_criminals':    total_criminals,
#         'total_complaints':   total_complaints,
#         'pending_complaints': pending_complaints,
#         'replied_complaints': replied_complaints,
#         'missing_male':       missing_male,
#         'missing_female':     missing_female,
#         'criminal_male':      criminal_male,
#         'criminal_female':    criminal_female,
#         'recent_missing':     recent_missing,
#         'recent_criminals':   recent_criminals,
#         'recent_complaints':  recent_complaints,
#         'age_0_18':           age_0_18,
#         'age_19_35':          age_19_35,
#         'age_36_60':          age_36_60,
#         'age_60p':            age_60p,
#         'current_date':       datetime.now().strftime('%A, %d %B %Y'),
#     })
#
# # from .train import FaceRecognitionTrainer
# #
# # def police_addmissingCase(request):
# #     officer = _get_police(request)
# #     if request.method == 'POST':
# #         n     = request.POST['name']
# #         a     = request.POST['age']
# #         g     = request.POST['gender']
# #         d     = request.POST['details']
# #         photo = request.FILES['photo']
# #         Missing_person.objects.create(POLICE=officer, name=n, age=a, gender=g, details=d, photo=photo)
# #     return render(request, 'police/police_addmissingCase.html', {'police': officer})
# #
# #
# # def police_addCriminalCase(request):
# #     officer = _get_police(request)
# #     if request.method == 'POST':
# #         n     = request.POST['name']
# #         a     = request.POST['age']
# #         g     = request.POST['gender']
# #         d     = request.POST['details']
# #         photo = request.FILES['photo']
# #         criminal.objects.create(POLICE=officer, name=n, age=a, gender=g, details=d, photo=photo)
# #     return render(request, 'police/police_addCriminalCase.html', {'police': officer})
#
#
#
#
# @csrf_exempt
# def user_register(request):
#     if request.method == 'POST':
#         name = request.POST['name']
#         address = request.POST['address']
#         place = request.POST['place']
#         phone = request.POST['phone']
#         email = request.POST['email']
#         aadhar = request.POST['aadhar']
#         username = request.POST['username']
#         password = request.POST['password']
#
#         user = User.objects.create_user(username=username, password=password,email=email)
#         group = Group.objects.get(name='user')
#         user.groups.add(group)
#         user.save()
#
#
#         obj = UserProfile()
#         obj.USER = user
#         obj.name = name
#         obj.address = address
#         obj.phone = phone
#         obj.email = email
#         obj.place = place
#         obj.aadhar = aadhar
#         obj.save()
#
#         return JsonResponse({'status': 'ok'})
#
#     return JsonResponse({'status': 'error', 'message': 'Invalid request'}, status=400)
#
# # -----------------------------------------------------------------------------------------------------------------------------
#
#
# def user_login(request):
#     username = request.POST['username']
#     password = request.POST['password']
#
#     user = authenticate(request, username=username, password=password)
#
#     if user is not None:
#         auth_login(request, user)
#
#
#         if user.groups.filter(name='user').exists():
#             return JsonResponse({'status': 'ok', 'lid': str(user.id)})
#
#
#         else:
#             return JsonResponse({'status': 'error'})
#
#
#     else:
#         return JsonResponse({'status': 'error'})
#
#
# @csrf_exempt
# def user_send_complaint(request):
#     if request.method == 'POST':
#         user_id = request.POST['lid']
#         user = User.objects.get(id=user_id)
#         description = request.POST['complaint']
#         complaint = Complaint.objects.create(
#             USER=user,
#             description=description,
#             date=datetime.now().strftime("%d/%m/%Y %I:%M %p"),
#             reply ='pending',
#             status ='pending'
#         )
#         complaint.save()
#         return JsonResponse({'status': 'ok', 'message': 'Complaint sent successfully'})
#     else:
#         return JsonResponse({'status': 'error', 'message': 'Only POST method allowed'})
#
#
# @csrf_exempt
# def user_view_complaints(request):
#     if request.method == 'POST':
#         lid = request.POST['lid']
#         user = User.objects.get(id=lid)
#         complaint = Complaint.objects.filter(USER=user)
#
#         data = []
#         for c in complaint:
#             data.append({
#                 'id': c.id,
#                 'complaint': c.description,
#                 'date': datetime.now().strftime("%d/%m/%Y %I:%M %p"),
#                 'reply': c.reply or '',
#             })
#
#         return JsonResponse({'status': 'ok', 'data': data})
#     else:
#         return JsonResponse({'status': 'error', 'message': 'Only POST method allowed'})
#
#
#
#
#
# @csrf_exempt
# def user_send_feedback(request):
#     if request.method == 'POST':
#         user_id = request.POST['lid']
#         user = User.objects.get(id=user_id)
#         description = request.POST['complaint']
#         complaint = feedback.objects.create(
#             USER=user,
#             message=description,
#             date=datetime.now().strftime("%d/%m/%Y %I:%M %p"),
#
#         )
#         complaint.save()
#         return JsonResponse({'status': 'ok', 'message': 'Complaint sent successfully'})
#     else:
#         return JsonResponse({'status': 'error', 'message': 'Only POST method allowed'})
#
#
# @csrf_exempt
# def user_view_feedback(request):
#     if request.method == 'POST':
#         lid = request.POST['lid']
#         user = User.objects.get(id=lid)
#         complaint = feedback.objects.filter(USER=user)
#
#         data = []
#         for c in complaint:
#             data.append({
#                 'id': c.id,
#                 'complaint': c.message,
#                 'date': c.date,
#             })
#
#         return JsonResponse({'status': 'ok', 'data': data})
#     else:
#         return JsonResponse({'status': 'error', 'message': 'Only POST method allowed'})
#
#
#
# def ViewPolice(request):
#     station_id = request.POST['station_id']
#
#     l = []
#     data = police.objects.filter(policestation_id=station_id)
#
#     for i in data:
#         l.append({
#             'id': i.id,
#             'full_name': i.full_name,
#             'address': i.address,
#             'designation': i.designation,
#             'phone': i.phone,
#         })
#
#     return JsonResponse({'status': 'ok', 'data': l})
#
#
#
#
# def View_Police_Station(request):
#     lid = request.POST['lid']
#
#     l = []
#     data = policestation.objects.all()
#
#     for i in data:
#         l.append({
#             'id':i.id,
#             'station_name': i.station_name,
#             'place': i.place,
#             'station_head': i.station_head,
#             'latitude': i.latitude,
#             'longitude': i.longitude,
#             'phone': i.phone,
#         })
#
#     return JsonResponse({'status': 'ok', 'data': l})
#
#
#
# @csrf_exempt
# def user_view_missing_persons(request):
#     if request.method == "POST":
#         stylists = Missing_person.objects.all()
#         data = []
#         for s in stylists:
#             data.append({
#                 "id": s.id,
#                 "name": s.name,
#                 "phone": s.age,
#                 # "email": s.email,
#                 "gender": s.gender,
#                 "experience": s.details,
#                 # "specialization": s.specialization,
#                 "photo": s.photo.url if s.photo else "",
#             })
#         return JsonResponse({"status": "ok", "data": data})
#     return JsonResponse({"status": "error"})\
#
#
# @csrf_exempt
# def user_view_criminals(request):
#     if request.method == "POST":
#         stylists = criminal.objects.all()
#         data = []
#         for s in stylists:
#             data.append({
#                 "id": s.id,
#                 "name": s.name,
#                 "phone": s.age,
#                 "gender": s.gender,
#                 "experience": s.details,
#                 "photo": s.photo.url if s.photo else "",
#             })
#         print(data)
#         return JsonResponse({"status": "ok", "data": data})
#     return JsonResponse({"status": "error"})
#
#
#
# #////////////USER////////////////////////////////////////////////////////////////////////////////////////////////////////
#
# def forgot_password(request):
#
#     if request.method == "POST":
#
#         username = request.POST.get("username")
#         current_password = request.POST.get("current_password")
#         new_password = request.POST.get("new_password")
#         confirm_password = request.POST.get("confirm_password")
#
#         user = authenticate(username=username, password=current_password)
#
#         if user is not None:
#
#             if user.groups.filter(name="admin").exists() or user.groups.filter(name="police").exists():
#
#                 if new_password == confirm_password:
#
#                     user.set_password(new_password)
#                     user.save()
#
#                     messages.success(request, "Password changed successfully")
#                     return redirect("login")
#
#                 else:
#                     messages.error(request, "New password and confirm password do not match")
#
#             else:
#                 messages.error(request, "Unauthorized user")
#
#         else:
#             messages.error(request, "Invalid username or current password")
#
#     return render(request, "forgot_password.html")
#
#
#
#
# @csrf_exempt
# def user_forgot_password(request):
#
#     if request.method == "POST":
#
#         username = request.POST['username']
#         email = request.POST['email']
#         password = request.POST['password']
#         confirm_password = request.POST['confirm_password']
#
#         # check password match
#         if password != confirm_password:
#             return JsonResponse({
#                 'status': 'error',
#                 'message': 'Password mismatch'
#             })
#
#         try:
#             user = User.objects.get(username=username, email=email)
#
#             # change password
#             user.set_password(password)
#             user.save()
#
#             return JsonResponse({
#                 'status': 'ok'
#             })
#
#         except User.DoesNotExist:
#             return JsonResponse({
#                 'status': 'error',
#                 'message': 'Invalid username or email'
#             })
#
#     return JsonResponse({'status': 'error'})
#
#
#
# def distance(lat1, lon1, lat2, lon2):
#     return math.sqrt((lat1 - lat2)**2 + (lon1 - lon2)**2)
#
#
#
#
# # REPORT CASE
#
# # REPORT CASE
# @csrf_exempt
# def user_report_case(request):
#
#     print("----- REPORT CASE API CALLED -----")
#
#     if request.method == "POST":
#
#         lid = request.POST.get('lid')
#         description = request.POST.get('description')
#         latitude = float(request.POST.get('latitude'))
#         longitude = float(request.POST.get('longitude'))
#         photo = request.FILES.get('photo')
#
#         # NEW FIELDS
#         name = request.POST.get('name')
#         phone = request.POST.get('phone')
#         email = request.POST.get('email')
#         address = request.POST.get('address')
#
#         missing_place = request.POST.get('missing_place')
#         age = request.POST.get('age')
#         date_of_birth = request.POST.get('date_of_birth')
#         gender = request.POST.get('gender')
#         parent_name = request.POST.get('parent_name')
#         items_carried = request.POST.get('items_carried')
#         height = request.POST.get('height')
#         identification_marks = request.POST.get('identification_marks')
#         clothes_ornaments = request.POST.get('clothes_ornaments')
#
#         try:
#             user = UserProfile.objects.get(USER_id=lid)
#         except UserProfile.DoesNotExist:
#             return JsonResponse({"status": "error", "message": "User not found"})
#
#         stations = policestation.objects.all()
#
#         nearest_station = None
#         min_distance = 999999
#
#         for s in stations:
#
#             try:
#                 lat2 = float(s.latitude)
#                 lon2 = float(s.longitude)
#             except:
#                 continue
#
#             dist = distance(latitude, longitude, lat2, lon2)
#
#             if dist < min_distance:
#                 min_distance = dist
#                 nearest_station = s
#
#         if nearest_station is None:
#             return JsonResponse({
#                 "status": "error",
#                 "message": "No station found"
#             })
#
#         case = Case_file.objects.create(
#             USER=user,
#             police_station=nearest_station,
#             description=description,
#             photo=photo,
#             progress="pending",
#             status="Not Viewed",
#             date=datetime.now().strftime("%Y-%m-%d %H:%M:%S"),
#
#             name=name,
#             phone=phone,
#             email=email,
#             address=address,
#             Missing_place=missing_place,
#             age=age,
#             date_of_birth=date_of_birth,
#             Gender=gender,
#             parent_name=parent_name,
#             items_carried=items_carried,
#             Height=height,
#             identification_marks=identification_marks,
#             clothes_ornaments=clothes_ornaments
#         )
#
#         return JsonResponse({
#             "status": "ok",
#             "station": nearest_station.station_name
#         })
#
#     return JsonResponse({"status": "error"})
#
# # @csrf_exempt
# # def user_report_case(request):
# #
# #     print("----- REPORT CASE API CALLED -----")
# #
# #     if request.method == "POST":
# #
# #         lid = request.POST.get('lid')
# #         description = request.POST.get('description')
# #         latitude = float(request.POST.get('latitude'))
# #         longitude = float(request.POST.get('longitude'))
# #         photo = request.FILES.get('photo')
# #
# #         print("User Login ID:", lid)
# #         print("Description:", description)
# #         print("Latitude:", latitude)
# #         print("Longitude:", longitude)
# #         print("Photo:", photo)
# #
# #         try:
# #             user = UserProfile.objects.get(USER_id=lid)
# #         except UserProfile.DoesNotExist:
# #             print("User profile not found")
# #             return JsonResponse({"status": "error", "message": "User not found"})
# #
# #         print("User Found:", user)
# #
# #         stations = policestation.objects.all()
# #
# #         nearest_station = None
# #         min_distance = 999999
# #
# #         print("Checking nearest police station...")
# #
# #         for s in stations:
# #
# #             print("Station:", s.station_name)
# #
# #             try:
# #                 lat2 = float(s.latitude)
# #                 lon2 = float(s.longitude)
# #             except:
# #                 print("Invalid coordinates for station:", s.station_name)
# #                 continue
# #
# #             dist = distance(latitude, longitude, lat2, lon2)
# #
# #             print("Distance:", dist)
# #
# #             if dist < min_distance:
# #                 min_distance = dist
# #                 nearest_station = s
# #
# #         if nearest_station is None:
# #             print("No valid station found")
# #             return JsonResponse({
# #                 "status": "error",
# #                 "message": "No station found"
# #             })
# #
# #         print("Nearest Station:", nearest_station.station_name)
# #
# #         case = Case_file.objects.create(
# #             USER=user,
# #             police_station=nearest_station,
# #             description=description,
# #             photo=photo,
# #             progress="pending",
# #             status="Not Viewed",
# #             date=datetime.now().strftime("%Y-%m-%d %H:%M:%S")
# #         )
# #
# #         print("Case Created:", case.id)
# #
# #         return JsonResponse({
# #             "status": "ok",
# #             "station": nearest_station.station_name
# #         })
# #
# #     return JsonResponse({"status": "error"})
#
#
# # VIEW USER CASES
#
#
#
# @csrf_exempt
# def user_view_cases(request):
#
#     print("----- USER VIEW CASES API CALLED -----")
#
#     if request.method == "POST":
#
#         lid = request.POST.get("lid")
#
#         try:
#             user = UserProfile.objects.get(USER_id=lid)
#         except UserProfile.DoesNotExist:
#             return JsonResponse({
#                 "status": "error",
#                 "message": "User not found"
#             })
#
#         cases = Case_file.objects.filter(USER=user).order_by('-id')
#
#         data = []
#
#         for c in cases:
#
#             try:
#                 photo_url = request.build_absolute_uri(c.photo.url)
#             except:
#                 photo_url = ""
#
#             data.append({
#                 "id": c.id,
#                 "description": c.description,
#                 "progress": c.progress,
#                 "status": c.status,
#                 "date": c.date,
#                 "station": c.police_station.station_name if c.police_station else "Not Assigned",
#                 "photo": photo_url,
#
#                 "name": c.name,
#                 "phone": c.phone,
#                 "email": c.email,
#                 "address": c.address,
#                 "missing_place": c.Missing_place,
#                 "age": c.age,
#                 "date_of_birth": c.date_of_birth,
#                 "gender": c.Gender,
#                 "parent_name": c.parent_name,
#                 "items_carried": c.items_carried,
#                 "height": c.Height,
#                 "identification_marks": c.identification_marks,
#                 "clothes_ornaments": c.clothes_ornaments
#             })
#
#         return JsonResponse({
#             "status": "ok",
#             "data": data
#         })
#
#     return JsonResponse({"status": "error"})
# # def user_view_cases(request):
# #
# #     print("----- USER VIEW CASES API CALLED -----")
# #
# #     if request.method == "POST":
# #
# #         lid = request.POST.get("lid")
# #         print("Login ID:", lid)
# #
# #         try:
# #             user = UserProfile.objects.get(USER_id=lid)
# #         except UserProfile.DoesNotExist:
# #             print("User profile not found")
# #             return JsonResponse({
# #                 "status": "error",
# #                 "message": "User not found"
# #             })
# #
# #         print("UserProfile ID:", user.id)
# #
# #         cases = Case_file.objects.filter(USER=user).order_by('-id')
# #
# #         data = []
# #
# #         for c in cases:
# #
# #             try:
# #                 photo_url = request.build_absolute_uri(c.photo.url)
# #             except:
# #                 photo_url = ""
# #
# #             data.append({
# #                 "id": c.id,
# #                 "description": c.description,
# #                 "progress": c.progress,
# #                 "status": c.status,
# #                 "date": c.date,
# #                 "station": c.police_station.station_name if c.police_station else "Not Assigned",
# #                 "photo": photo_url
# #             })
# #
# #         print("Total Cases:", len(data))
# #
# #         return JsonResponse({
# #             "status": "ok",
# #             "data": data
# #         })
# #
# #     return JsonResponse({"status": "error"})
#
#
#
#
#
#
# #////////////POLICE////////////////////////////////////////////////////////////////////////////////////////////////////////
#
# # @login_required
# # def police_view_cases(request):
# #
# #     print("----- POLICE VIEW CASES FUNCTION CALLED -----")
# #
# #     police_id = request.session.get('police_id')
# #     print("Police ID from session:", police_id)
# #
# #     if not police_id:
# #         print("ERROR: Police ID not found in session")
# #         return redirect("login")
# #
# #     officer = police.objects.select_related('policestation').get(id=police_id)
# #     print("Officer Name:", officer.full_name)
# #
# #     station = officer.policestation
# #     print("Officer Station:", station.station_name)
# #
# #     cases = Case_file.objects.filter(police_station=station).order_by('-id')
# #
# #     print("Total Cases Found:", cases.count())
# #
# #     for c in cases:
# #         print("Case ID:", c.id,
# #               "| Description:", c.description,
# #               "| Status:", c.status,
# #               "| Progress:", c.progress)
# #
# #     return render(request, "police/police_view_cases.html", {
# #         "cases": cases,
# #         "police": officer
# #     })
# #
# # def police_view_cases(request):
# #     police_id = request.session.get('police_id')
# #     if not police_id:
# #         return redirect("login")
# #
# #     officer = police.objects.select_related('policestation').get(id=police_id)
# #     station = officer.policestation
# #     cases = Case_file.objects.filter(
# #         police_station=station,
# #         progress__in=["pending", "In Progress"]
# #     ).order_by('-id')
# #
# #     pending_count = cases.filter(status="Not Viewed").count()
# #     viewed_count = cases.filter(status="Viewed").count()
# #     approved_count = cases.filter(status="Approved").count()
# #
# #     return render(request, "police/police_view_cases.html", {
# #         "cases": cases,
# #         "police": officer,
# #         "pending_count": pending_count,
# #         "viewed_count": viewed_count,
# #         "approved_count": approved_count,
# #     })
#
# from django.core.files import File
#
#
# import cv2
# import os
# import shutil
#
#
# def detect_face_with_rotation(image_path):
#     img = cv2.imread(image_path)
#     if img is None:
#         print(f"[ERROR] Image not found at {image_path}")
#         return False, None
#
#     rotations = [
#         (None, "Original"),
#         (cv2.ROTATE_90_CLOCKWISE, "90 CW"),
#         (cv2.ROTATE_180, "180"),
#         (cv2.ROTATE_90_COUNTERCLOCKWISE, "90 CCW")
#     ]
#     face_cascade = cv2.CascadeClassifier(cv2.data.haarcascades + 'haarcascade_frontalface_default.xml')
#
#     for rotate_code, label in rotations:
#         current_img = img if rotate_code is None else cv2.rotate(img, rotate_code)
#
#         gray = cv2.cvtColor(current_img, cv2.COLOR_BGR2GRAY)
#         faces = face_cascade.detectMultiScale(gray, 1.1, 4)
#
#         if len(faces) > 0:
#             print(f"[SUCCESS] Face found in {label} position.")
#             cv2.imwrite(image_path, current_img)
#             return True, current_img
#
#     return False, None
#
#
#
# def police_view_cases(request):
#     police_id = request.session.get('police_id')
#     if not police_id:
#         if request.method == 'POST':
#             return JsonResponse({'status': 'error', 'message': 'Not authenticated'})
#         return redirect("login")
#
#     officer = police.objects.select_related('policestation').get(id=police_id)
#     station = officer.policestation
#
#     # ── POST: mark_viewed (AJAX from View button) ──────────────────
#     if request.method == 'POST' and request.POST.get('action') == 'mark_viewed':
#         case_id = request.POST.get('case_id')
#         try:
#             case = Case_file.objects.get(id=case_id, police_station=station)
#             if case.status == 'Not Viewed':
#                 case.status = 'Viewed'
#                 case.save()
#                 print(f"[INFO] Case {case_id} marked Viewed")
#             return JsonResponse({'status': 'ok'})
#         except Case_file.DoesNotExist:
#             return JsonResponse({'status': 'error', 'message': 'Case not found'})
#
#     # ── POST: approve ──────────────────────────────────────────────
#     if request.method == 'POST' and request.POST.get('action') == 'approve':
#
#         case_id = request.POST.get('case_id')
#         case = get_object_or_404(Case_file, id=case_id, police_station=station)
#
#         db_type = request.POST.get('db_type', 'missing')
#         name = request.POST.get('name', '').strip()
#         age = request.POST.get('age', '')
#         gender = request.POST.get('gender', '')
#         details = request.POST.get('details', '')
#
#         uploaded_file = request.FILES.get('photo')
#         selected_photo_url = request.POST.get('selected_photo_url', '')
#
#         print("&"*100)
#         print("uploaded_file : ",uploaded_file)
#         print("selected_photo_url : ",selected_photo_url)
#         print("case.photo : ",case.photo)
#         print("&"*100)
#         a=request.session.get('police_id')
#         p = police.objects.get(pk=a)
#
#
#
#         rt = police_addmissingCase_new(p,case_id,case,db_type,name,age,gender,details,uploaded_file,selected_photo_url)
#
#         case.status = 'Approved'
#         case.progress = 'Found'
#         case.save()
#         return redirect('/police_view_cases?approved=1')
#         #
#         # trainer = FaceRecognitionTrainer()
#         # iimm=""
#         #
#         #
#         #
#         # # ── Resolve photo & write temp file for MTCNN ──────────────
#         # if uploaded_file:
#         #     # Write to disk for MTCNN to read
#         #     temp_path = os.path.join(settings.MEDIA_ROOT, uploaded_file.name)
#         #     iimm = temp_path
#         #     # print("temp_path : ",temp_path)
#         #     with open(temp_path, 'wb+') as f:
#         #         for chunk in uploaded_file.chunks():
#         #             f.write(chunk)
#         #     # uploaded_file pointer is now at EOF — do NOT pass it to Django.
#         #     # We open the temp file fresh below using File().
#         #     using_temp = True
#         #     print(f"[APPROVE] External upload written to: {temp_path}")
#         #
#         #
#         # if (selected_photo_url and case.photo) or case.photo:
#         #     temp_path = os.path.join(settings.MEDIA_ROOT, str(case.photo))
#         #
#         #     face_found, rotated_img = detect_face_with_rotation(temp_path)
#         #
#         #     if face_found:
#         #         print(f"[APPROVE] Face found: {temp_path}")
#         #
#         #         missing_dir = os.path.join(settings.MEDIA_ROOT, 'missing')
#         #         print("missing_dir : ",missing_dir)
#         #
#         #
#         #         print("abcd : ",temp_path)
#         #
#         #         if not os.path.exists(missing_dir):
#         #             os.makedirs(missing_dir)
#         #
#         #         file_name = os.path.basename(temp_path)
#         #         print("file_name : ",file_name)
#         #         new_path = os.path.join(missing_dir, file_name)
#         #         print("New Path : ",new_path)
#         #         iimm = "missing/"+file_name
#         #
#         #         cv2.imwrite(new_path, rotated_img)
#         #
#         #         print(f"[SUCCESS] Image moved to: {new_path}")
#         #
#         #         temp_path = new_path
#         #         using_temp = False
#         #     else:
#         #         print(f"[WARNING] No face found even after all rotations.")
#         #         using_temp = True
#         #
#         #
#         # # elif case.photo:
#         # #     temp_path = os.path.join(settings.MEDIA_ROOT, str(case.photo))
#         # #     is_face, _ = detect_face_with_rotation(temp_path)
#         # #     using_temp = False
#         #
#         # else:
#         #     messages.error(request, "No photo available. Please upload an external photo.")
#         #     return redirect('police_view_cases')
#         #
#         # # ── MTCNN: extract face embedding ──────────────────────────
#         # print("temp_path : ",temp_path)
#         # emb = trainer.extract_embedding(temp_path)
#         # # emb =""
#         #
#         # if emb is None:
#         #     print("NNNNNNNNNNNNNNNNN")
#         #     if using_temp and os.path.exists(temp_path):
#         #         print("IIIIIIIIIIIIIIIII")
#         #         # os.remove(temp_path)
#         #     messages.warning(request, "No face detected in the photo. Please upload a clearer image.")
#         #     return redirect('police_view_cases')
#         #
#         # # ── Duplicate check (same threshold as addmissingCase) ─────
#         # duplicate = False
#         # for key, value in trainer.database.items():
#         #     db_emb = np.array(value)
#         #     similarity = np.dot(emb, db_emb) / (
#         #         np.linalg.norm(emb) * np.linalg.norm(db_emb)
#         #     )
#         #     if similarity > 0.70:
#         #         duplicate = True
#         #         print(f"[WARN] Duplicate: key={key}, similarity={similarity:.3f}")
#         #         break
#         #
#         # if duplicate:
#         #     if using_temp and os.path.exists(temp_path):
#         #         os.remove(temp_path)
#         #     messages.warning(request, "This person already exists in the database.")
#         #     return redirect('police_view_cases')
#         #
#         # # ── Save to DB ─────────────────────────────────────────────
#         # # For external uploads: open temp file FRESH with File() — pointer at byte 0.
#         # # For case.photo: pass the ImageFieldFile directly — already readable.
#         #
#         # photo_file = None
#         # print("iimm : ",iimm)
#         # try:
#         #     if using_temp:
#         #         # photo_file = open(temp_path, 'rb')  # fresh pointer
#         #         photo_file = open(iimm, 'rb')  # fresh pointer
#         #         print("photo_file : ",photo_file)
#         #         # django_photo = File(photo_file, name=os.path.basename(temp_path))
#         #         django_photo = File(photo_file, name=os.path.basename(iimm))
#         #     else:
#         #         # django_photo = case.photo  # ImageFieldFile
#         #         django_photo = iimm  # ImageFieldFile
#         #
#         #     if db_type == 'missing':
#         #
#         #         obj = Missing_person.objects.create(
#         #             POLICE=officer,
#         #             name=name, age=age, gender=gender, details=details,
#         #             photo=django_photo
#         #         )
#         #         print(f"[INFO] Missing person saved: {obj.name}, photo path: {obj.photo}")
#         #
#         #         # Extract embedding from the path Django actually saved to
#         #         # img_path = os.path.join(settings.MEDIA_ROOT, str(obj.photo))
#         #         # print("img_path - emb2 - : ",img_path)
#         #         # emb2 = trainer.extract_embedding(img_path)
#         #         emb2 = emb
#         #         # print("emb2 : ",emb2)
#         #         if emb2 is not None:
#         #             key = f"MISSING|{obj.id}|{obj.name}"
#         #             for i in range(5):
#         #                 trainer.database[f"{key}_{i}"] = emb2.tolist()
#         #             trainer.save_model()
#         #             print(f"[TRAINED] Missing: {obj.name} → {key}")
#         #         else:
#         #             print(f"[WARN] Re-extract failed for saved path: {img_path}")
#         #
#         #     else:  # criminal
#         #
#         #         crime_type = request.POST.get('crime_type', '')
#         #         severity = request.POST.get('severity', 'Medium')
#         #
#         #         obj = criminal.objects.create(
#         #             POLICE=officer,
#         #             name=name, age=age, gender=gender, details=details,
#         #             photo=django_photo,
#         #             crime_type=crime_type,
#         #             severity=severity
#         #         )
#         #         print(f"[INFO] Criminal saved: {obj.name}, photo path: {obj.photo}")
#         #
#         #         img_path = os.path.join(settings.MEDIA_ROOT, str(obj.photo))
#         #         emb2 = trainer.extract_embedding(img_path)
#         #         if emb2 is not None:
#         #             key = f"CRIMINAL|{obj.id}|{obj.name}"
#         #             for i in range(5):
#         #                 trainer.database[f"{key}_{i}"] = emb2.tolist()
#         #             trainer.save_model()
#         #             print(f"[TRAINED] Criminal: {obj.name} → {key}")
#         #         else:
#         #             print(f"[WARN] Re-extract failed for saved path: {img_path}")
#         #
#         # finally:
#         #     if photo_file:
#         #         photo_file.close()
#         #     # Clean up temp file only for external uploads
#         #     if using_temp and os.path.exists(temp_path):
#         #         os.remove(temp_path)
#         #
#         # # ── Mark case Approved — user app sees this on next poll ───
#         # case.status = 'Approved'
#         # case.progress = 'Found'
#         # case.save()
#         # print(f"[INFO] Case {case_id} marked Approved")
#         #
#         # messages.success(request, f"{name} added to database. Case #{case_id} approved.")
#         # return redirect('police_view_cases')
#
#     # ── GET ────────────────────────────────────────────────────────
#     cases = Case_file.objects.filter(police_station=station).order_by('-id')
#
#     pending_count = cases.filter(status='Not Viewed').count()
#     viewed_count = cases.filter(status='Viewed').count()
#     approved_count = cases.filter(status='Approved').count()
#
#     return render(request, 'police/police_view_cases.html', {
#         'cases': cases,
#         'police': officer,
#         'pending_count': pending_count,
#         'viewed_count': viewed_count,
#         'approved_count': approved_count,
#     })
#
#
#
#
# @login_required
# def police_update_case(request, id):
#
#     print("----- POLICE UPDATE CASE FUNCTION CALLED -----")
#
#     print("Case ID received:", id)
#
#     case = get_object_or_404(Case_file, id=id)
#
#     print("Case Description:", case.description)
#     print("Current Status:", case.status)
#     print("Current Progress:", case.progress)
#
#     if case.status != "Viewed":
#         case.status = "Viewed"
#         case.save()
#         print("Case status updated to VIEWED")
#
#     if request.method == "POST":
#
#         progress = request.POST.get("progress")
#
#         print("New Progress Received:", progress)
#
#         case.progress = progress
#         case.save()
#
#         print("Case progress updated successfully")
#
#         messages.success(request, "Case progress updated")
#
#         return redirect("police_view_cases")
#
#         # Get user uploads from the same user who filed this case
#         user_uploads = User_upload.objects.filter(USER=case.USER).order_by('-id')
#
#         return render(request, "police/police_update_case.html", {
#             "case": case,
#             "user_uploads": user_uploads,
#         })
#
#
# # def police_update_case(request, id):
# #     police_id = request.session.get('police_id')
# #     if not police_id:
# #         return redirect("login")
# #
# #     case = get_object_or_404(Case_file, id=id)
# #     officer = _get_police(request)
# #
# #     # Auto-mark as Viewed when police opens the case
# #     if case.status == "Not Viewed":
# #         case.status = "Viewed"
# #         case.save()
# #         print(f"[INFO] Case {id} marked Viewed")
# #
# #     approve_message = None
# #     approve_ok = False
# #     approve_warn = False
# #
# #     if request.method == "POST":
# #
# #         action = request.POST.get("action", "update_progress")
# #
# #         # ── UPDATE PROGRESS ────────────────────────────────────────
# #         if action == "update_progress":
# #             progress = request.POST.get("progress")
# #             case.progress = progress
# #             case.save()
# #             messages.success(request, "Case progress updated.")
# #             return redirect("police_update_case", id=id)
# #
# #         # ── APPROVE ────────────────────────────────────────────────
# #         elif action == "approve":
# #
# #             db_type = request.POST.get("db_type", "missing")
# #             name = request.POST.get("name", "").strip()
# #             age = request.POST.get("age", "")
# #             gender = request.POST.get("gender", "")
# #             details = request.POST.get("details", "")
# #
# #             # ── Resolve the photo ───────────────────────────────────
# #             # Three possible sources (priority order):
# #             # 1. Police uploaded a new external file (request.FILES['photo'])
# #             # 2. Police selected the case's own photo (use_case_photo = URL)
# #             # 3. Fallback: use case.photo directly
# #
# #             uploaded_file = request.FILES.get("photo")
# #             use_case_photo = request.POST.get("use_case_photo", "")
# #
# #             trainer = FaceRecognitionTrainer()
# #
# #             if uploaded_file:
# #                 # ── Path 1: new file uploaded by police ───────────
# #                 temp_path = os.path.join(settings.MEDIA_ROOT, uploaded_file.name)
# #                 with open(temp_path, "wb+") as f:
# #                     for chunk in uploaded_file.chunks():
# #                         f.write(chunk)
# #                 photo_for_model = uploaded_file
# #                 print(f"[APPROVE] Using uploaded file: {uploaded_file.name}")
# #
# #             elif use_case_photo and case.photo:
# #                 # ── Path 2: police selected the user's case photo ──
# #                 temp_path = os.path.join(settings.MEDIA_ROOT, str(case.photo))
# #                 photo_for_model = case.photo  # ImageFieldFile — Django handles storage
# #                 print(f"[APPROVE] Using case photo: {case.photo}")
# #
# #             elif case.photo:
# #                 # ── Path 3: fallback to case photo ─────────────────
# #                 temp_path = os.path.join(settings.MEDIA_ROOT, str(case.photo))
# #                 photo_for_model = case.photo
# #                 print(f"[APPROVE] Fallback to case photo: {case.photo}")
# #
# #             else:
# #                 approve_message = "No photo available. Please upload an external photo."
# #                 approve_warn = True
# #                 return render(request, "police/police_update_case.html", {
# #                     "case": case,
# #                     "approve_message": approve_message,
# #                     "approve_warn": True,
# #                 })
# #
# #             # ── MTCNN: extract embedding ────────────────────────────
# #             emb = trainer.extract_embedding(temp_path)
# #
# #             if emb is None:
# #                 # Clean up temp file only if we created it from an upload
# #                 if uploaded_file and os.path.exists(temp_path):
# #                     os.remove(temp_path)
# #                 approve_message = "No face detected in the photo. Please upload a clearer image with a visible face."
# #                 approve_warn = True
# #
# #             else:
# #                 # ── Duplicate check ─────────────────────────────────
# #                 duplicate = False
# #                 for key, value in trainer.database.items():
# #                     db_emb = np.array(value)
# #                     similarity = np.dot(emb, db_emb) / (
# #                         np.linalg.norm(emb) * np.linalg.norm(db_emb)
# #                     )
# #                     if similarity > 0.70:
# #                         duplicate = True
# #                         print(f"[WARN] Duplicate found for key: {key}, similarity: {similarity:.3f}")
# #                         break
# #
# #                 if duplicate:
# #                     if uploaded_file and os.path.exists(temp_path):
# #                         os.remove(temp_path)
# #                     approve_message = "This person already exists in the database (duplicate face detected)."
# #                     approve_warn = True
# #
# #                 else:
# #                     # ── Save to DB ───────────────────────────────────
# #                     if db_type == "missing":
# #
# #                         obj = Missing_person.objects.create(
# #                             POLICE=officer,
# #                             name=name,
# #                             age=age,
# #                             gender=gender,
# #                             details=details,
# #                             photo=photo_for_model
# #                         )
# #                         print(f"[INFO] Missing person saved: {obj.name}")
# #
# #                         # Re-extract from saved path (same pattern as police_addmissingCase)
# #                         img_path = os.path.join(settings.MEDIA_ROOT, str(obj.photo))
# #                         emb2 = trainer.extract_embedding(img_path)
# #                         if emb2 is not None:
# #                             key = f"MISSING|{obj.id}|{obj.name}"
# #                             for i in range(5):
# #                                 trainer.database[f"{key}_{i}"] = emb2.tolist()
# #                             trainer.save_model()
# #                             print(f"[TRAINED] Missing: {obj.name}")
# #
# #                         approve_message = f"{name} added to the Missing Persons database. Face trained into the model."
# #
# #                     else:  # criminal
# #
# #                         crime_type = request.POST.get("crime_type", "")
# #                         severity = request.POST.get("severity", "Medium")
# #
# #                         obj = criminal.objects.create(
# #                             POLICE=officer,
# #                             name=name,
# #                             age=age,
# #                             gender=gender,
# #                             details=details,
# #                             photo=photo_for_model,
# #                             crime_type=crime_type,
# #                             severity=severity
# #                         )
# #                         print(f"[INFO] Criminal saved: {obj.name}")
# #
# #                         img_path = os.path.join(settings.MEDIA_ROOT, str(obj.photo))
# #                         emb2 = trainer.extract_embedding(img_path)
# #                         if emb2 is not None:
# #                             key = f"CRIMINAL|{obj.id}|{obj.name}"
# #                             for i in range(5):
# #                                 trainer.database[f"{key}_{i}"] = emb2.tolist()
# #                             trainer.save_model()
# #                             print(f"[TRAINED] Criminal: {obj.name}")
# #
# #                         approve_message = f"{name} added to the Criminal database. Face trained into the model."
# #
# #                     # ── Mark case Approved — user app sees this ──────
# #                     # user_view_cases() returns case.status + case.progress
# #                     # So when user's mobile app next polls, it will show "Approved"
# #                     case.status = "Approved"
# #                     case.progress = "Found"
# #                     case.save()
# #                     approve_ok = True
# #                     print(f"[INFO] Case {id} marked Approved.")
# #
# #                     # Refresh case object for template
# #                     case.refresh_from_db()
# #
# #     return render(request, "police/police_update_case.html", {
# #         "case": case,
# #         "approve_message": approve_message,
# #         "approve_ok": approve_ok,
# #         "approve_warn": approve_warn,
# #     })
# #
#
#
#
# #////////////////TRAINING//////////////////////////////////////////////////////////////////////////////////////////////
# from .train import FaceRecognitionTrainer
# import numpy as np
# from django.core.files.storage import FileSystemStorage
# from .detect import FaceDetector
#
#
#
# def police_addmissingCase(request):
#     officer = _get_police(request)
#     message = None
#
#     if request.method == "POST":
#
#         name = request.POST['name']
#         age = request.POST['age']
#         gender = request.POST['gender']
#         details = request.POST['details']
#         photo = request.FILES['photo']
#         trainer = FaceRecognitionTrainer()
#         temp_path = os.path.join(settings.MEDIA_ROOT, photo.name)
#
#         with open(temp_path, "wb+") as f:
#             for chunk in photo.chunks():
#                 f.write(chunk)
#
#         emb = trainer.extract_embedding(temp_path)
#
#         if emb is None:
#
#             message = "No face detected"
#             os.remove(temp_path)
#
#         else:
#
#             duplicate = False
#
#             for key, value in trainer.database.items():
#
#                 db_emb = np.array(value)
#
#                 similarity = np.dot(emb, db_emb) / (
#                         np.linalg.norm(emb) * np.linalg.norm(db_emb)
#                 )
#
#                 if similarity > 0.70:
#                     duplicate = True
#                     break
#
#             if duplicate:
#
#                 message = "Person already exists"
#                 os.remove(temp_path)
#
#             else:
#
#                 obj = Missing_person.objects.create(
#                     POLICE=officer,
#                     name=name,
#                     age=age,
#                     gender=gender,
#                     details=details,
#                     photo=photo
#                 )
#
#                 print("[INFO] Missing person saved:", obj.name)
#
#                 img_path = os.path.join(settings.MEDIA_ROOT, str(obj.photo))
#
#                 emb = trainer.extract_embedding(img_path)
#
#                 if emb is not None:
#
#                     key = f"MISSING|{obj.id}|{obj.name}"
#
#                     for i in range(5):
#                         trainer.database[f"{key}_{i}"] = emb.tolist()
#
#                     trainer.save_model()
#
#                     print("[TRAINED] Missing person:", obj.name)
#
#                 message = "Missing person added successfully"
#
#     return render(
#         request,
#         "police/police_addmissingCase.html",
#         {
#             "police": officer,
#             "message": message
#         }
#     )
#
#
#
#
# #####################################################################################################
#
#
# def police_addmissingCase_new(polid,case_id, case, db_type, name, age, gender, details, uploaded_file, selected_photo_url):
#     # officer = _get_police(request)
#     # message = None
#
#     # if request.method == "POST":
#
#     name = name
#     age = age
#     gender = gender
#     details = details
#     photo = "C:/crowdtraceproject"+selected_photo_url
#     trainer = FaceRecognitionTrainer()
#     print("photo : ",photo)
#     print("os.path.join(settings.MEDIA_ROOT, selected_photo_url) : ",os.path.join(settings.MEDIA_ROOT))
#     # temp_path = os.path.join(settings.MEDIA_ROOT, selected_photo_url)
#     temp_path=photo
#
#     # temp_path = os.path.join(settings.MEDIA_ROOT, str(case.photo))
#
#
#
#     face_found, rotated_img = detect_face_with_rotation(temp_path)
#
#
#
#     if face_found:
#
#         print(f"[APPROVE] Face found: {temp_path}")
#
#
#
#         missing_dir = os.path.join(settings.MEDIA_ROOT, 'missing')
#
#         print("missing_dir : ",missing_dir)
#
#
#
#
#
#         print("abcd : ",temp_path)
#
#
#
#         if not os.path.exists(missing_dir):
#
#             os.makedirs(missing_dir)
#
#
#
#         file_name = os.path.basename(temp_path)
#
#         print("file_name : ",file_name)
#
#         new_path = os.path.join(missing_dir, file_name)
#
#         print("New Path : ",new_path)
#
#         iimm = "missing/"+file_name
#
#
#
#         cv2.imwrite(new_path, rotated_img)
#
#
#
#         print(f"[SUCCESS] Image moved to: {new_path}")
#
#
#
#         temp_path = new_path
#
#         using_temp = False
#
#     else:
#
#         print(f"[WARNING] No face found even after all rotations.")
#
#         using_temp = True
#
#
#
#
#
#     # with open(temp_path, "wb+") as f:
#     #     for chunk in photo.chunks():
#     #         f.write(chunk)
#
#     emb = trainer.extract_embedding(temp_path)
#
#     if emb is None:
#
#         message = "No face detected"
#         # os.remove(temp_path)
#
#     else:
#
#         duplicate = False
#
#         for key, value in trainer.database.items():
#
#             db_emb = np.array(value)
#
#             similarity = np.dot(emb, db_emb) / (
#                     np.linalg.norm(emb) * np.linalg.norm(db_emb)
#             )
#
#             if similarity > 0.70:
#                 duplicate = True
#                 break
#
#         if duplicate:
#
#             message = "Person already exists"
#             os.remove(temp_path)
#
#         else:
#
#             obj = Missing_person.objects.create(
#                 POLICE=polid,
#                 name=name,
#                 age=age,
#                 gender=gender,
#                 details=details,
#                 photo=iimm
#             )
#
#             print("[INFO] Missing person saved:", obj.name)
#
#             img_path = os.path.join(settings.MEDIA_ROOT, str(obj.photo))
#
#             emb = trainer.extract_embedding(img_path)
#
#             if emb is not None:
#
#                 key = f"MISSING|{obj.id}|{obj.name}"
#
#                 for i in range(5):
#                     trainer.database[f"{key}_{i}"] = emb.tolist()
#
#                 trainer.save_model()
#
#                 print("[TRAINED] Missing person:", obj.name)
#
#             message = "Missing person added successfully"
#             case.status = 'Approved'
#             case.progress = 'Found'
#             case.save()
#
#     return  redirect("police_view_cases")
#     # return render(
#     #     # request,
#     #     "police/police_addmissingCase.html",
#     #     {
#     #         "police": polid,
#     #         "message": message
#     #     }
#     # )
#
#
#
#
# #####################################################################################################
#
# def police_addCriminalCase(request):
#
#     officer = _get_police(request)
#     message = None
#
#     if request.method == "POST":
#
#         name = request.POST['name']
#         age = request.POST['age']
#         gender = request.POST['gender']
#         details = request.POST['details']
#         photo = request.FILES['photo']
#
#         trainer = FaceRecognitionTrainer()
#
#         # temporary save
#         temp_path = os.path.join(settings.MEDIA_ROOT, photo.name)
#
#         with open(temp_path, "wb+") as f:
#             for chunk in photo.chunks():
#                 f.write(chunk)
#
#         emb = trainer.extract_embedding(temp_path)
#
#         if emb is None:
#
#             message = "No face detected"
#             os.remove(temp_path)
#
#         else:
#
#             duplicate = False
#
#             for key, value in trainer.database.items():
#
#                 db_emb = np.array(value)
#
#                 similarity = np.dot(emb, db_emb) / (
#                         np.linalg.norm(emb) * np.linalg.norm(db_emb)
#                 )
#
#                 if similarity > 0.70:
#                     duplicate = True
#                     break
#
#             if duplicate:
#
#                 message = "Person already exists"
#                 os.remove(temp_path)
#
#             else:
#
#                 obj = criminal.objects.create(
#                     POLICE=officer,
#                     name=name,
#                     age=age,
#                     gender=gender,
#                     details=details,
#                     photo=photo
#                 )
#
#                 print("[INFO] Criminal saved:", obj.name)
#
#                 img_path = os.path.join(settings.MEDIA_ROOT, str(obj.photo))
#
#                 emb = trainer.extract_embedding(img_path)
#
#                 if emb is not None:
#
#                     key = f"CRIMINAL|{obj.id}|{obj.name}"
#
#                     for i in range(5):
#                         trainer.database[f"{key}_{i}"] = emb.tolist()
#
#                     trainer.save_model()
#
#                     print("[TRAINED] Criminal:", obj.name)
#
#                 message = "Criminal added successfully"
#
#     return render(
#         request,
#         "police/police_addCriminalCase.html",
#         {
#             "police": officer,
#             "message": message
#         }
#     )
# #/////////////PREDICTION////////////////////////////////////////////////////////////////////////////////////////////////
#
#
# #
# # def police_detect_person(request):
# #
# #     result = None
# #     file_url = None
# #     file_type = None
# #
# #     if request.method == "POST":
# #
# #         uploaded_file = request.FILES.get("file")
# #
# #         if uploaded_file:
# #
# #             upload_folder = os.path.join(settings.MEDIA_ROOT, "detect_uploads")
# #
# #             if not os.path.exists(upload_folder):
# #                 os.makedirs(upload_folder)
# #
# #             fs = FileSystemStorage(location=upload_folder)
# #
# #             filename = fs.save(uploaded_file.name, uploaded_file)
# #
# #             file_path = fs.path(filename)
# #
# #             file_url = settings.MEDIA_URL + "detect_uploads/" + filename
# #
# #             detector = FaceDetector(
# #                 model_path=os.path.join(settings.BASE_DIR, "face_model.pkl")
# #             )
# #
# #             file_name = uploaded_file.name.lower()
# #
# #             try:
# #
# #                 if file_name.endswith((".jpg", ".jpeg", ".png")):
# #
# #                     file_type = "image"
# #                     result = detector.detect_from_image(file_path)
# #
# #                 elif file_name.endswith((".mp4", ".avi", ".mov")):
# #
# #                     file_type = "video"
# #                     result = detector.detect_from_video(file_path)
# #
# #                 else:
# #
# #                     result = [{"status": "error", "message": "Unsupported file type"}]
# #
# #             except Exception as e:
# #
# #                 result = [{"status": "error", "message": str(e)}]
# #
# #     return render(
# #         request,
# #         "police/police_detect_person.html",
# #         {
# #             "result": result,
# #             "file_url": file_url,
# #             "file_type": file_type
# #         }
# #     )
#
#
#
#
# def police_detect_person(request):
#
#     officer      = _get_police(request)
#     police_id    = request.session.get('police_id')
#
#     total_missing   = Missing_person.objects.filter(POLICE=police_id).count()
#     total_criminals = criminal.objects.filter(POLICE=police_id).count()
#     total_scans     = Live_detection.objects.count()
#     detections      = Live_detection.objects.all().order_by('-id')[:12]
#
#     result    = None
#     file_url  = None
#     file_type = None
#
#     if request.method == "POST":
#         selected_url = request.POST.get("selected_url")
#         uploaded_file = request.FILES.get("file")
#
#
#         if selected_url and not uploaded_file:
#             relative_path = selected_url.replace(settings.MEDIA_URL, "", 1)
#             file_path = os.path.join(settings.MEDIA_ROOT, relative_path)
#             file_url = selected_url
#             file_type = "image"
#             detector = FaceDetector(model_path=os.path.join(settings.BASE_DIR, "face_model.pkl"))
#             try:
#                 result = detector.detect_from_image(file_path)
#                 print("RESSSSSSSSSSSSSSS : ",result)
#                 if result:
#                     for r in result:
#                         if r.get('confidence') and r['confidence'] <= 1:
#                             r['confidence'] = round(r['confidence'] * 100, 1)
#             except Exception as e:
#                 result = [{"status": "error", "message": str(e)}]
#
#         elif uploaded_file:
#             upload_folder = os.path.join(settings.MEDIA_ROOT, "detect_uploads")
#             if not os.path.exists(upload_folder):
#                 os.makedirs(upload_folder)
#
#             fs        = FileSystemStorage(location=upload_folder)
#             filename  = fs.save(uploaded_file.name, uploaded_file)
#             file_path = fs.path(filename)
#             file_url  = settings.MEDIA_URL + "detect_uploads/" + filename
#
#             detector = FaceDetector(
#                 model_path=os.path.join(settings.BASE_DIR, "face_model.pkl")
#             )
#
#             try:
#                 if uploaded_file.name.lower().endswith((".jpg", ".jpeg", ".png", ".webp")):
#                     file_type = "image"
#                     result = detector.detect_from_image(file_path)
#                     print("TTTTTTTTTTTTTTTTTTT : ", result)
#                     if result:
#                         for r in result:
#                             if r.get('confidence') and r['confidence'] <= 1:
#                                 r['confidence'] = round(r['confidence'] * 100, 1)
#
#                 elif uploaded_file.name.lower().endswith((".mp4", ".avi", ".mov")):
#                     file_type = "video"
#                     result = detector.detect_from_video(file_path)
#                     if result:
#                         for r in result:
#                             if r.get('confidence') and r['confidence'] <= 1:
#                                 r['confidence'] = round(r['confidence'] * 100, 1)
#             except Exception as e:
#                 result = [{"status": "error", "message": str(e)}]
#
#     return render(request, "police/police_detect_person.html", {
#         "result":          result,
#         "file_url":        file_url,
#         "file_type":       file_type,
#         "police":          officer,
#         "total_missing":   total_missing,
#         "total_criminals": total_criminals,
#         "total_scans":     total_scans,
#         "detections":      detections,
#     })
# #///////////////LIVE CAMERA DETECTION///////////////////////////////////////////////////////////////////////////////////
# import os
# import cv2
# import uuid
# import time
# from datetime import datetime
#
# from django.shortcuts import render
# from django.http import StreamingHttpResponse, JsonResponse
# from django.views.decorators.csrf import csrf_exempt
# from django.conf import settings
#
# from .live_predict import LiveFaceDetector
# from .detect import FaceDetector
#
# from .models import Live_detection, User_upload, Missing_person, criminal, UserProfile
#
#
# # =====================================================
# # LOAD AI MODELS
# # =====================================================
#
# MODEL_PATH = os.path.join(settings.BASE_DIR, "face_model.pkl")
#
#
# live_detector = LiveFaceDetector(
#     model_path=MODEL_PATH,
#     threshold=0.9
# )
#
#
# file_detector = FaceDetector(
#     model_path=MODEL_PATH
# )
#
#
# # =====================================================
# # DETECTION CACHE (avoid duplicates)
# # =====================================================
#
# last_detected_times = {}
#
#
# # =====================================================
# # ADMIN LIVE CAMERA PAGE
# # =====================================================
#
# def admin_live_camera(request):
#
#     return render(request, "live_camera.html")
#
#
# # =====================================================
# # GENERATE LIVE CAMERA FRAMES
# # =====================================================
#
# def generate_frames():
#
#     cap = cv2.VideoCapture(0)
#
#     if not cap.isOpened():
#         raise RuntimeError("Webcam not accessible")
#
#     while True:
#
#         success, frame = cap.read()
#
#         if not success:
#             break
#
#         # Detect faces
#         frame, detections = live_detector.detect_and_draw(frame)
#
#         for det in detections:
#
#             if det["status"] != "matched":
#                 continue
#
#             name = det["name"]
#             category = det["category"]
#             confidence = det["confidence"]
#
#             current_time = time.time()
#
#             last_time = last_detected_times.get(name, 0)
#
#             # Skip duplicate detection within 10 seconds
#             if current_time - last_time < 10:
#                 continue
#
#             last_detected_times[name] = current_time
#
#             # =====================================
#             # SAVE SCREENSHOT
#             # =====================================
#
#             filename = f"{uuid.uuid4()}.jpg"
#
#             save_dir = os.path.join(settings.MEDIA_ROOT, "live_detections")
#
#             os.makedirs(save_dir, exist_ok=True)
#
#             filepath = os.path.join(save_dir, filename)
#
#             cv2.imwrite(filepath, frame)
#
#             # =====================================
#             # SAVE TO DATABASE
#             # =====================================
#
#             Live_detection.objects.create(
#
#                 name=name,
#                 category=category,
#                 confidence=str(confidence),
#
#                 photo=f"live_detections/{filename}",
#
#                 date=datetime.now().strftime("%H:%M:%S")
#             )
#
#             print("Stored detection:", name)
#
#         # Convert frame to JPEG
#         ret, buffer = cv2.imencode('.jpg', frame)
#
#         frame = buffer.tobytes()
#
#         yield (b'--frame\r\n'
#                b'Content-Type: image/jpeg\r\n\r\n' + frame + b'\r\n')
#
#     cap.release()
#
#
# # =====================================================
# # VIDEO STREAM
# # =====================================================
#
# def video_feed(request):
#
#     return StreamingHttpResponse(
#         generate_frames(),
#         content_type='multipart/x-mixed-replace; boundary=frame'
#     )
#
# #///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#
# def admin_view_live_detections(request):
#
#     print("===== ADMIN VIEW LIVE DETECTIONS =====")
#
#     detections = Live_detection.objects.all().order_by('-id')
#
#     context = {
#         "detections": detections
#     }
#
#     return render(
#         request,
#         "admin_live_detections.html",
#         context
#     )
#
#
# def police_live_detections(request):
#
#     print("===== POLICE VIEW LIVE DETECTIONS =====")
#
#     detections = Live_detection.objects.all().order_by('-id')
#
#     context = {
#         "detections": detections
#     }
#
#     return render(
#         request,
#         "police/police_live_detections.html",
#         context
#     )
#
#
#
#
# # USER DETECT PERSON (UPLOAD IMAGE / VIDEO)
# @csrf_exempt
# def user_detect_person(request):
#
#     print("========== USER DETECT API CALLED ==========")
#
#     if request.method == "POST":
#
#         uid = request.POST.get("uid")
#         latitude = request.POST.get("latitude")
#         longitude = request.POST.get("longitude")
#         uploaded_file = request.FILES.get("file")
#
#         if not uploaded_file:
#             return JsonResponse({
#                 "status": "error",
#                 "message": "No file uploaded"
#             })
#
#         # ===============================
#         # GET USER PROFILE
#         # ===============================
#
#         try:
#             user_profile = UserProfile.objects.get(USER_id=uid)
#         except UserProfile.DoesNotExist:
#             return JsonResponse({
#                 "status": "error",
#                 "message": "User profile not found"
#             })
#
#         # ===============================
#         # SAVE FILE
#         # ===============================
#
#         upload_folder = os.path.join(settings.MEDIA_ROOT, "user_uploads")
#         os.makedirs(upload_folder, exist_ok=True)
#
#         filename = str(uuid.uuid4()) + "_" + uploaded_file.name
#         file_path = os.path.join(upload_folder, filename)
#
#         with open(file_path, "wb+") as destination:
#             for chunk in uploaded_file.chunks():
#                 destination.write(chunk)
#
#         print("File saved:", file_path)
#
#         # ===============================
#         # RUN DETECTION
#         # ===============================
#
#         ext = filename.split(".")[-1].lower()
#
#         if ext in ["jpg", "jpeg", "png"]:
#             results = file_detector.detect_from_image(file_path)
#         else:
#             results = file_detector.detect_from_video(file_path)
#
#         print("Detection results:", results)
#
#         if not results:
#             return JsonResponse({
#                 "status": "ok",
#                 "result": []
#             })
#
#         # ===============================
#         # SAVE RESULTS
#         # ===============================
#
#         response_data = []
#         seen = set()
#
#         for r in results:
#
#             category = r["category"]
#             pid = r["id"]
#             name = r["name"]
#
#             key = f"{name}-{category}"
#
#             if key in seen:
#                 continue
#
#             seen.add(key)
#
#             missing_obj = None
#             criminal_obj = None
#
#             if category == "Missing Person":
#
#                 try:
#                     missing_obj = Missing_person.objects.get(id=pid)
#                 except Missing_person.DoesNotExist:
#                     continue
#
#             elif category == "Criminal":
#
#                 try:
#                     criminal_obj = criminal.objects.get(id=pid)
#                 except criminal.DoesNotExist:
#                     continue
#
#             # SAVE TO DATABASE
#             User_upload.objects.create(
#                 USER=user_profile,
#                 Missing_person=missing_obj,
#                 criminal=criminal_obj,
#                 category=category,
#                 date=datetime.now().strftime("%H:%M:%S"),
#                 latitude=latitude,
#                 longitude=longitude,
#                 photo="user_uploads/" + filename
#             )
#
#             response_data.append({
#                 "name": name,
#                 "category": category
#             })
#
#         return JsonResponse({
#             "status": "ok",
#             "result": response_data
#         })
#
#     return JsonResponse({
#         "status": "invalid request"
#     })
#
#
#
# #USER VIEW DETECTION
# @csrf_exempt
# def user_view_detections(request):
#
#     print("\n========== USER VIEW DETECTIONS API CALLED ==========")
#
#     if request.method == "POST":
#
#         uid = request.POST.get("uid")
#         print("Received UID:", uid)
#
#         # ===============================
#         # GET USER PROFILE
#         # ===============================
#
#         try:
#             user_profile = UserProfile.objects.get(USER_id=uid)
#             print("User found:", user_profile.name)
#
#         except UserProfile.DoesNotExist:
#
#             print("User profile not found")
#
#             return JsonResponse({
#                 "status": "error",
#                 "message": "User not found"
#             })
#
#         # ===============================
#         # FETCH USER UPLOADS
#         # ===============================
#
#         uploads = User_upload.objects.filter(USER=user_profile).order_by("-id")
#
#         print("Total uploads found:", uploads.count())
#
#         data = []
#
#         for u in uploads:
#
#             name = ""
#
#             if u.Missing_person:
#                 name = u.Missing_person.name
#                 print("Missing person detected:", name)
#
#             elif u.criminal:
#                 name = u.criminal.name
#                 print("Criminal detected:", name)
#
#             # ===============================
#             # GET MEDIA PATH
#             # ===============================
#
#             photo_url = ""
#
#             if u.photo:
#                 photo_url = u.photo.url
#                 print("Media file:", photo_url)
#
#             # ===============================
#             # ADD DATA
#             # ===============================
#
#             data.append({
#
#                 "id": u.id,
#                 "name": name,
#                 "category": u.category,
#                 "date": u.date,
#                 "latitude": u.latitude,
#                 "longitude": u.longitude,
#                 "photo": photo_url
#
#             })
#
#         print("Returning", len(data), "records to Flutter")
#         print("========== END USER VIEW DETECTIONS ==========\n")
#
#         return JsonResponse({
#             "status": "ok",
#             "data": data
#         })
#
#     print("Invalid request method")
#
#     return JsonResponse({"status": "error"})
#
#
# # USER VIEW DETECTIONS
# @csrf_exempt
# def user_view_detections(request):
#
#     print("\n========== USER VIEW DETECTIONS API CALLED ==========")
#
#     if request.method == "POST":
#
#         uid = request.POST.get("uid")
#         print("Received UID:", uid)
#
#         # ===============================
#         # GET USER PROFILE
#         # ===============================
#
#         try:
#             user_profile = UserProfile.objects.get(USER_id=uid)
#             print("User found:", user_profile.name)
#
#         except UserProfile.DoesNotExist:
#
#             print("User profile not found")
#
#             return JsonResponse({
#                 "status": "error",
#                 "message": "User not found"
#             })
#
#         # ===============================
#         # FETCH USER UPLOADS
#         # ===============================
#
#         uploads = User_upload.objects.filter(USER=user_profile).order_by("-id")
#
#         print("Total uploads found:", uploads.count())
#
#         data = []
#
#         for u in uploads:
#
#             name = ""
#
#             if u.Missing_person:
#                 name = u.Missing_person.name
#                 print("Missing person detected:", name)
#
#             elif u.criminal:
#                 name = u.criminal.name
#                 print("Criminal detected:", name)
#
#             # ===============================
#             # GET MEDIA PATH
#             # ===============================
#
#             photo_url = ""
#
#             if u.photo:
#                 photo_url = u.photo.url
#                 print("Media file:", photo_url)
#
#             # ===============================
#             # ADD DATA
#             # ===============================
#
#             data.append({
#
#                 "id": u.id,
#                 "name": name,
#                 "category": u.category,
#                 "date": u.date,
#                 "latitude": u.latitude,
#                 "longitude": u.longitude,
#                 "photo": photo_url
#
#             })
#
#         print("Returning", len(data), "records to Flutter")
#         print("========== END USER VIEW DETECTIONS ==========\n")
#
#         return JsonResponse({
#             "status": "ok",
#             "data": data
#         })
#
#     print("Invalid request method")
#
#     return JsonResponse({"status": "error"})
#
#
#
# def police_view_uploads(request):
#
#     user_uploads = User_upload.objects.all().order_by("-id")
#     public_uploads = Public_Upload.objects.all().order_by("-id")
#
#     context = {
#         "user_uploads": user_uploads,
#         "public_uploads": public_uploads
#     }
#
#     return render(request, "police/police_view_uploads.html", context)
#
#
#
#
#
# # PUBLIC DETECT PERSON (GUEST UPLOAD)
#
# @csrf_exempt
# def public_detect_person(request):
#
#     print("========== PUBLIC DETECT API CALLED ==========")
#
#     if request.method == "POST":
#
#         latitude = request.POST.get("latitude")
#         longitude = request.POST.get("longitude")
#         description = request.POST.get("description", "")
#
#         uploaded_file = request.FILES.get("file")
#
#         if not uploaded_file:
#             return JsonResponse({
#                 "status": "error",
#                 "message": "No file uploaded"
#             })
#
#         # ===============================
#         # SAVE FILE
#         # ===============================
#
#         upload_folder = os.path.join(settings.MEDIA_ROOT, "public_uploads")
#         os.makedirs(upload_folder, exist_ok=True)
#
#         filename = str(uuid.uuid4()) + "_" + uploaded_file.name
#         file_path = os.path.join(upload_folder, filename)
#
#         with open(file_path, "wb+") as destination:
#             for chunk in uploaded_file.chunks():
#                 destination.write(chunk)
#
#         print("File saved:", file_path)
#
#         # ===============================
#         # RUN DETECTION
#         # ===============================
#
#         ext = filename.split(".")[-1].lower()
#
#         if ext in ["jpg", "jpeg", "png"]:
#             results = file_detector.detect_from_image(file_path)
#         else:
#             results = file_detector.detect_from_video(file_path)
#
#         print("Detection results:", results)
#
#         if not results:
#             return JsonResponse({
#                 "status": "ok",
#                 "result": []
#             })
#
#         response_data = []
#         seen = set()
#
#         for r in results:
#
#             category = r["category"]
#             pid = r["id"]
#             name = r["name"]
#
#             key = f"{name}-{category}"
#
#             if key in seen:
#                 continue
#
#             seen.add(key)
#
#             missing_obj = None
#             criminal_obj = None
#
#             if category == "Missing Person":
#
#                 try:
#                     missing_obj = Missing_person.objects.get(id=pid)
#                 except Missing_person.DoesNotExist:
#                     continue
#
#             elif category == "Criminal":
#
#                 try:
#                     criminal_obj = criminal.objects.get(id=pid)
#                 except criminal.DoesNotExist:
#                     continue
#
#             # SAVE TO PUBLIC_UPLOAD
#
#             Public_Upload.objects.create(
#
#                 Missing_person=missing_obj,
#                 criminal=criminal_obj,
#                 description=description,
#                 date=datetime.now().strftime("%H:%M:%S"),
#                 latitude=latitude,
#                 longitude=longitude,
#                 photo="public_uploads/" + filename
#
#             )
#
#             response_data.append({
#                 "name": name,
#                 "category": category
#             })
#
#         return JsonResponse({
#             "status": "ok",
#             "result": response_data
#         })
#
#     return JsonResponse({
#         "status": "invalid request"
#     })





import os
import uuid
import cv2
from datetime import datetime
from django.conf import settings
from django.http import JsonResponse

from datetime import datetime
from django.contrib.auth.models import User
from django.contrib import messages
from django.http import JsonResponse
from django.shortcuts import render, get_object_or_404
from django.contrib.auth.decorators import login_required
from django.contrib.auth import authenticate, login as auth_login
from django.contrib.auth.models import Group
from django.views.decorators.csrf import csrf_exempt
from django.shortcuts import redirect
from django.urls import reverse
from myapp.models import *
import math


def home(request):
    return render(request,'index.html')



def login(request):
    if request.method == "POST":
        A = request.POST.get("u")
        B = request.POST.get("p")

        user = authenticate(request, username=A, password=B)

        if user is not None:
            auth_login(request, user)
            request.session['user_id'] = user.id

            if user.groups.filter(name="admin").exists():
                return redirect("admin_home")

            elif user.groups.filter(name="police").exists():
                Police = police.objects.get(USER=user)
                request.session['police_id'] = Police.id
                return redirect("police_home")

            else:
                return redirect("login")

        else:
            messages.error(request,'Invalid username or password')
            return redirect('login')

    return render(request, "login.html")



def admin_add_station(request):
    if request.method=='POST':
        s=request.POST['staion_name']
        p = request.POST['place']
        station=request.POST['station_Head']
        Phone= request.POST['Phone']
        latitude = request.POST['lati']
        longitude = request.POST['longi']

        policestation.objects.create(station_name=s,place=p,station_head=station,phone=Phone,latitude=latitude,longitude=longitude)
        return redirect('admin_home')

    police=policestation.objects.all()



    return render(request,'admin_add_station.html',{ 'police':police })


def register(request):
    return render(request,'register.html')

def admin_home(request):
    from myapp.models import UserProfile, Complaint, Missing_person, criminal, policestation, police
    total_users      = UserProfile.objects.count()
    total_missing    = Missing_person.objects.count()
    total_criminals  = criminal.objects.count()
    total_stations   = policestation.objects.count()
    total_police     = police.objects.count()
    total_complaints = Complaint.objects.count()
    pending_complaints = Complaint.objects.filter(status__iexact='pending').count()
    replied_complaints = Complaint.objects.filter(status__iexact='replied').count()
    missing_persons  = Missing_person.objects.all().order_by('-id')
    criminals        = criminal.objects.all().order_by('-id')
    stations         = policestation.objects.all().order_by('station_name')
    recent_users     = UserProfile.objects.all().order_by('-id')[:6]
    recent_complaints = Complaint.objects.all().order_by('-id')[:6]

    return render(request, 'admin_home.html', {
        'total_users':         total_users,
        'total_missing':       total_missing,
        'total_criminals':     total_criminals,
        'total_stations':      total_stations,
        'total_police':        total_police,
        'total_complaints':    total_complaints,
        'pending_complaints':  pending_complaints,
        'replied_complaints':  replied_complaints,
        'missing_persons':     missing_persons,
        'criminals':           criminals,
        'stations':            stations,
        'recent_users':        recent_users,
        'recent_complaints':   recent_complaints,
    })

def admin_sidebar(request):
    return render(request,'admin_sidebar.html')
def casefile(request):
    return render(request,'casefile.html')
# def profile_card(request):
#     from myapp.models import Missing_person, criminal
#     missing_persons = Missing_person.objects.all().order_by('-id')
#     criminals       = criminal.objects.all().order_by('-id')
#     return render(request, 'profile_card.html', {
#         'missing_persons': missing_persons,
#         'criminals':       criminals,
#     })


def profile_card(request):
    from myapp.models import Missing_person, criminal, Case_file
    missing_persons_all = Missing_person.objects.all().order_by('-id')
    criminals = criminal.objects.all().order_by('-id')

    # Build a name → Case_file map from ALL cases (not just Approved)
    # A case is resolved when progress is 'Found' (case-insensitive)
    all_cases = Case_file.objects.exclude(name=None).exclude(name='').order_by('-id')
    case_map = {}
    for case in all_cases:
        key = (case.name or '').strip().lower()
        if key and key not in case_map:
            case_map[key] = case

    # Attach the matching case file to each missing person
    for person in missing_persons_all:
        name_key = (person.name or '').strip().lower()
        person.case_data = case_map.get(name_key)

    # Split: resolved = progress is 'Found', active = everything else
    def is_found(person):
        return (
            person.case_data is not None and
            str(getattr(person.case_data, 'progress', '') or '').strip().lower() == 'found'
        )

    missing_persons  = [p for p in missing_persons_all if not is_found(p)]
    resolved_persons = [p for p in missing_persons_all if is_found(p)]

    return render(request, 'profile_card.html', {
        'missing_persons':  missing_persons,
        'criminals':        criminals,
        'resolved_persons': resolved_persons,
    })



def admin_viewUsers (request):
    a = UserProfile.objects.all()
    print(a)
    return render(request,'admin_viewUsers.html',{'a':a})



def send_reply(request, id):
    if request.method == 'POST':
        r = request.POST.get('reply', '').strip()
        if r:
            c = get_object_or_404(Complaint, id=id)
            c.reply = r
            c.status = "Replied"
            c.save()
    return redirect(reverse("admin_viewComplaints"))



def admin_viewComplaints (request):
    a=Complaint.objects.all()
    print(a)
    return render(request,'admin_viewComplaints.html',{'a':a})


#
# def admin_add_police(request, station_id):
#     station = get_object_or_404(policestation, id=station_id)
#     police_list = police.objects.filter(policestation=station)
#
#     if request.method == "POST":
#         user = User.objects.create_user(
#             username=request.POST['username'],
#             password=request.POST['password']
#         )
#
#         police_group, _ = Group.objects.get_or_create(name="police")
#         user.groups.add(police_group)
#
#         police.objects.create(
#             USER=user,
#             policestation=station,
#             full_name=request.POST['full_name'],
#             address=request.POST['address'],
#             phone=request.POST['phone'],
#             designation=request.POST['designation'],
#             photo=request.FILES['photo']
#         )
#
#         return redirect("admin_add_police", station_id=station.id)
#
#     return render(request, "admin_addpolice.html", {
#         "station": station,
#         "police_list": police_list
#     })

def admin_add_police(request, station_id):

    station = get_object_or_404(policestation, id=station_id)
    police_list = police.objects.filter(policestation=station)

    if request.method == "POST":

        username = request.POST['username']
        password = request.POST['password']
        email = request.POST['email']
        full_name = request.POST['full_name']
        address = request.POST['address']
        phone = request.POST['phone']
        designation = request.POST['designation']
        photo = request.FILES['photo']

        # Create Auth User
        user = User.objects.create_user(
            username=username,
            email=email,
            password=password
        )

        # Add user to police group
        police_group, created = Group.objects.get_or_create(name="police")
        user.groups.add(police_group)

        # Create Police profile
        police.objects.create(
            USER=user,
            policestation=station,
            full_name=full_name,
            address=address,
            phone=phone,
            designation=designation,
            photo=photo
        )

        messages.success(request, "Officer registered successfully!")

        return redirect("admin_add_police", station_id=station.id)

    return render(request, "admin_addpolice.html", {
        "station": station,
        "police_list": police_list
    })


def manage_station(request):
    from myapp.models import policestation, police, Missing_person, criminal

    stations        = policestation.objects.all().order_by('station_name')
    total_stations  = stations.count()
    total_police    = police.objects.count()
    total_missing   = Missing_person.objects.count()
    total_criminals = criminal.objects.count()

    missing_persons = Missing_person.objects.select_related(
        'POLICE__policestation'
    ).all().order_by('-id')

    return render(request, 'manage_station.html', {
        'stations':        stations,
        'total_stations':  total_stations,
        'total_police':    total_police,
        'total_missing':   total_missing,
        'total_criminals': total_criminals,
        'missing_persons': missing_persons,
    })



def _get_police(request):
    try:
        from myapp.models import police as Police
        return Police.objects.select_related('policestation').get(
            id=request.session.get('police_id')
        )
    except Exception:
        return None

@login_required
def view_police_profile(request):
    officer = get_object_or_404(police, USER=request.user)
    return render(request, 'police/police_profile.html', {'police': officer})


def police_casefile(request):
    return render(request,'police/police_casefile.html')

# def manage_casefile(request):
#     officer = _get_police(request)
#     person  = Missing_person.objects.filter(POLICE=request.session['police_id'])
#     return render(request, 'police/police_view_missing_person.html', {
#         'person': person,
#         'police': officer,
#     })


# AFTER
# def manage_casefile(request):
#     police_id = request.session.get('police_id')
#     if not police_id:
#         return redirect('login')
#     officer = _get_police(request)
#     person  = Missing_person.objects.filter(POLICE=police_id)
#     return render(request, 'police/police_view_missing_person.html', {
#         'person': person,
#         'police': officer,
#     })


def manage_casefile(request):
    from myapp.models import Case_file
    police_id = request.session.get('police_id')
    if not police_id:
        return redirect('login')
    officer  = _get_police(request)
    persons  = Missing_person.objects.filter(POLICE=police_id)

    # Build name → most-recent Case_file map for this station
    case_map = {}
    if officer and officer.policestation:
        station_cases = Case_file.objects.filter(
            police_station=officer.policestation
        ).order_by('-id')
        for case in station_cases:
            key = (case.name or '').strip().lower()
            if key and key not in case_map:
                case_map[key] = case

    # Attach matching case file to each person
    for person in persons:
        name_key = (person.name or '').strip().lower()
        person.case_data = case_map.get(name_key)

    return render(request, 'police/police_view_missing_person.html', {
        'person':  persons,
        'police':  officer,
    })

# AFTER
def view_missing_criminal(request):
    police_id = request.session.get('police_id')
    if not police_id:
        return redirect('login')
    officer = _get_police(request)
    person  = criminal.objects.filter(POLICE=police_id)
    return render(request, 'police/police_view_missing_criminals.html', {
        'person': person,
        'police': officer,
    })

def police_send_complaint(request):
    officer    = _get_police(request)
    user_id    = request.session.get('user_id')
    if not user_id:
        return redirect('login')
    Police_usr = User.objects.get(id=user_id)
    complaint  = Complaint.objects.filter(USER=user_id)
    if request.method == 'POST':
        description = request.POST['message']
        Complaint.objects.create(
            USER=Police_usr,
            description=description,
            reply='pending',
            date=datetime.now().strftime('%d/%m/%Y %I:%M %p'),
            status='pending'
        )
        return redirect('police_send_complaint')
    return render(request, 'police/police_send_complaint.html', {
        'complaints': complaint,
        'police':     officer,
    })

def police_home(request):
    from myapp.models import police as Police, Missing_person, criminal, Complaint
    from django.contrib.auth.models import User

    officer = _get_police(request)   # uses the helper defined earlier

    police_id = request.session.get('police_id')
    user_id   = request.session.get('user_id')

    # ── counts ──────────────────────────────────────────────
    total_missing   = Missing_person.objects.filter(POLICE=police_id).count()
    total_criminals = criminal.objects.filter(POLICE=police_id).count()
    total_complaints = Complaint.objects.filter(USER=user_id).count()
    pending_complaints = Complaint.objects.filter(USER=user_id, status__iexact='pending').count()
    replied_complaints = Complaint.objects.filter(USER=user_id, status__iexact='replied').count()

    # ── gender breakdown (missing) ───────────────────────────
    missing_male   = Missing_person.objects.filter(POLICE=police_id, gender__iexact='male').count()
    missing_female = Missing_person.objects.filter(POLICE=police_id, gender__iexact='female').count()

    # ── gender breakdown (criminal) ──────────────────────────
    criminal_male   = criminal.objects.filter(POLICE=police_id, gender__iexact='male').count()
    criminal_female = criminal.objects.filter(POLICE=police_id, gender__iexact='female').count()

    # ── recent records ───────────────────────────────────────
    recent_missing   = Missing_person.objects.filter(POLICE=police_id).order_by('-id')[:5]
    recent_criminals = criminal.objects.filter(POLICE=police_id).order_by('-id')[:5]
    recent_complaints = Complaint.objects.filter(USER=user_id).order_by('-id')[:4]

    # ── age distribution for missing persons ─────────────────
    missing_all = Missing_person.objects.filter(POLICE=police_id)

    def _safe_age(p):
        try:
            return int(p.age)
        except (ValueError, TypeError):
            return None

    age_0_18  = sum(1 for p in missing_all if _safe_age(p) is not None and _safe_age(p) <= 18)
    age_19_35 = sum(1 for p in missing_all if _safe_age(p) is not None and 19 <= _safe_age(p) <= 35)
    age_36_60 = sum(1 for p in missing_all if _safe_age(p) is not None and 36 <= _safe_age(p) <= 60)
    age_60p   = sum(1 for p in missing_all if _safe_age(p) is not None and _safe_age(p) > 60)

    return render(request, 'police/police_home.html', {
        'police':             officer,
        'total_missing':      total_missing,
        'total_criminals':    total_criminals,
        'total_complaints':   total_complaints,
        'pending_complaints': pending_complaints,
        'replied_complaints': replied_complaints,
        'missing_male':       missing_male,
        'missing_female':     missing_female,
        'criminal_male':      criminal_male,
        'criminal_female':    criminal_female,
        'recent_missing':     recent_missing,
        'recent_criminals':   recent_criminals,
        'recent_complaints':  recent_complaints,
        'age_0_18':           age_0_18,
        'age_19_35':          age_19_35,
        'age_36_60':          age_36_60,
        'age_60p':            age_60p,
        'current_date':       datetime.now().strftime('%A, %d %B %Y'),
    })

# from .train import FaceRecognitionTrainer
#
# def police_addmissingCase(request):
#     officer = _get_police(request)
#     if request.method == 'POST':
#         n     = request.POST['name']
#         a     = request.POST['age']
#         g     = request.POST['gender']
#         d     = request.POST['details']
#         photo = request.FILES['photo']
#         Missing_person.objects.create(POLICE=officer, name=n, age=a, gender=g, details=d, photo=photo)
#     return render(request, 'police/police_addmissingCase.html', {'police': officer})
#
#
# def police_addCriminalCase(request):
#     officer = _get_police(request)
#     if request.method == 'POST':
#         n     = request.POST['name']
#         a     = request.POST['age']
#         g     = request.POST['gender']
#         d     = request.POST['details']
#         photo = request.FILES['photo']
#         criminal.objects.create(POLICE=officer, name=n, age=a, gender=g, details=d, photo=photo)
#     return render(request, 'police/police_addCriminalCase.html', {'police': officer})




@csrf_exempt
def user_register(request):
    if request.method == 'POST':
        name = request.POST['name']
        address = request.POST['address']
        place = request.POST['place']
        phone = request.POST['phone']
        email = request.POST['email']
        aadhar = request.POST['aadhar']
        username = request.POST['username']
        password = request.POST['password']

        user = User.objects.create_user(username=username, password=password,email=email)
        group = Group.objects.get(name='user')
        user.groups.add(group)
        user.save()


        obj = UserProfile()
        obj.USER = user
        obj.name = name
        obj.address = address
        obj.phone = phone
        obj.email = email
        obj.place = place
        obj.aadhar = aadhar
        obj.save()

        return JsonResponse({'status': 'ok'})

    return JsonResponse({'status': 'error', 'message': 'Invalid request'}, status=400)

# -----------------------------------------------------------------------------------------------------------------------------


@csrf_exempt
def user_login(request):
    if request.method != 'POST':
        return JsonResponse({'status': 'error', 'message': 'Only POST method allowed'})
    username = request.POST['username']
    password = request.POST['password']

    user = authenticate(request, username=username, password=password)

    if user is not None:
        auth_login(request, user)


        if user.groups.filter(name='user').exists():
            return JsonResponse({'status': 'ok', 'lid': str(user.id)})


        else:
            return JsonResponse({'status': 'error'})


    else:
        return JsonResponse({'status': 'error'})


@csrf_exempt
def user_send_complaint(request):
    if request.method == 'POST':
        user_id = request.POST['lid']
        user = User.objects.get(id=user_id)
        description = request.POST['complaint']
        complaint = Complaint.objects.create(
            USER=user,
            description=description,
            date=datetime.now().strftime("%d/%m/%Y %I:%M %p"),
            reply ='pending',
            status ='pending'
        )
        complaint.save()
        return JsonResponse({'status': 'ok', 'message': 'Complaint sent successfully'})
    else:
        return JsonResponse({'status': 'error', 'message': 'Only POST method allowed'})


@csrf_exempt
def user_view_complaints(request):
    if request.method == 'POST':
        lid = request.POST['lid']
        user = User.objects.get(id=lid)
        complaint = Complaint.objects.filter(USER=user)

        data = []
        for c in complaint:
            data.append({
                'id': c.id,
                'complaint': c.description,
                'date': c.date,
                'reply': c.reply or '',
            })

        return JsonResponse({'status': 'ok', 'data': data})
    else:
        return JsonResponse({'status': 'error', 'message': 'Only POST method allowed'})





@csrf_exempt
def user_send_feedback(request):
    if request.method == 'POST':
        user_id = request.POST['lid']
        user = User.objects.get(id=user_id)
        description = request.POST['complaint']
        complaint = feedback.objects.create(
            USER=user,
            message=description,
            date=datetime.now().strftime("%d/%m/%Y %I:%M %p"),

        )
        complaint.save()
        return JsonResponse({'status': 'ok', 'message': 'Complaint sent successfully'})
    else:
        return JsonResponse({'status': 'error', 'message': 'Only POST method allowed'})


@csrf_exempt
def user_view_feedback(request):
    if request.method == 'POST':
        lid = request.POST['lid']
        user = User.objects.get(id=lid)
        complaint = feedback.objects.filter(USER=user)

        data = []
        for c in complaint:
            data.append({
                'id': c.id,
                'complaint': c.message,
                'date': c.date,
            })

        return JsonResponse({'status': 'ok', 'data': data})
    else:
        return JsonResponse({'status': 'error', 'message': 'Only POST method allowed'})



def ViewPolice(request):
    if request.method != 'POST':
        return JsonResponse({'status': 'error', 'message': 'Only POST method allowed'})
    station_id = request.POST['station_id']

    l = []
    data = police.objects.filter(policestation_id=station_id)

    for i in data:
        l.append({
            'id': i.id,
            'full_name': i.full_name,
            'address': i.address,
            'designation': i.designation,
            'phone': i.phone,
        })

    return JsonResponse({'status': 'ok', 'data': l})




def View_Police_Station(request):
    if request.method != 'POST':
        return JsonResponse({'status': 'error', 'message': 'Only POST method allowed'})
    lid = request.POST['lid']

    l = []
    data = policestation.objects.all()

    for i in data:
        l.append({
            'id':i.id,
            'station_name': i.station_name,
            'place': i.place,
            'station_head': i.station_head,
            'latitude': i.latitude,
            'longitude': i.longitude,
            'phone': i.phone,
        })

    return JsonResponse({'status': 'ok', 'data': l})



@csrf_exempt
def user_view_missing_persons(request):
    if request.method == "POST":
        stylists = Missing_person.objects.select_related('POLICE__policestation').all()

        # Build name-based case map from ALL cases (not just Approved)
        # Cases marked Found can have status='closed' or status='Approved'
        all_cases = Case_file.objects.exclude(name=None).exclude(name='').order_by('-id')
        case_map = {}
        for case in all_cases:
            key = (case.name or '').strip().lower()
            if key and key not in case_map:
                case_map[key] = case

        data = []
        for s in stylists:
            try:
                photo_url = request.build_absolute_uri(s.photo.url)
            except:
                photo_url = ""
            try:
                station_name = s.POLICE.policestation.station_name
            except:
                station_name = ""

            # Check if this person has a resolved case
            linked_case = case_map.get((s.name or '').strip().lower())
            is_resolved = False
            progress = "active"
            case_report = ""
            if linked_case:
                prog = str(getattr(linked_case, 'progress', '') or '').strip().lower()
                is_resolved = (prog == 'found')
                progress = linked_case.progress or "active"
                case_report = linked_case.report or ""

            data.append({
                "id":          s.id,
                "name":        s.name,
                "age":         s.age,
                "gender":      s.gender,
                "details":     s.details,
                "photo":       photo_url,
                "station":     station_name,
                "is_resolved": is_resolved,
                "progress":    progress,
                "report":      case_report,
            })
        return JsonResponse({"status": "ok", "data": data})
    return JsonResponse({"status": "error"})


@csrf_exempt
def user_view_criminals(request):
    if request.method == "POST":
        stylists = criminal.objects.all()
        data = []
        for s in stylists:
            try:
                photo_url = request.build_absolute_uri(s.photo.url)
            except:
                photo_url = ""
            data.append({
                "id":      s.id,
                "name":    s.name,
                "age":     s.age,
                "gender":  s.gender,
                "details": s.details,
                "photo":   photo_url,
            })
        return JsonResponse({"status": "ok", "data": data})
    return JsonResponse({"status": "error"})



#////////////USER////////////////////////////////////////////////////////////////////////////////////////////////////////

def forgot_password(request):

    if request.method == "POST":

        username = request.POST.get("username")
        current_password = request.POST.get("current_password")
        new_password = request.POST.get("new_password")
        confirm_password = request.POST.get("confirm_password")

        user = authenticate(username=username, password=current_password)

        if user is not None:

            if user.groups.filter(name="admin").exists() or user.groups.filter(name="police").exists():

                if new_password == confirm_password:

                    user.set_password(new_password)
                    user.save()

                    messages.success(request, "Password changed successfully")
                    return redirect("login")

                else:
                    messages.error(request, "New password and confirm password do not match")

            else:
                messages.error(request, "Unauthorized user")

        else:
            messages.error(request, "Invalid username or current password")

    return render(request, "forgot_password.html")




@csrf_exempt
def user_forgot_password(request):

    if request.method == "POST":

        username = request.POST['username']
        email = request.POST['email']
        password = request.POST['password']
        confirm_password = request.POST['confirm_password']

        # check password match
        if password != confirm_password:
            return JsonResponse({
                'status': 'error',
                'message': 'Password mismatch'
            })

        try:
            user = User.objects.get(username=username, email=email)

            # change password
            user.set_password(password)
            user.save()

            return JsonResponse({
                'status': 'ok'
            })

        except User.DoesNotExist:
            return JsonResponse({
                'status': 'error',
                'message': 'Invalid username or email'
            })

    return JsonResponse({'status': 'error'})



def distance(lat1, lon1, lat2, lon2):
    return math.sqrt((lat1 - lat2)**2 + (lon1 - lon2)**2)




# REPORT CASE

# REPORT CASE
@csrf_exempt
def user_report_case(request):

    print("----- REPORT CASE API CALLED -----")

    if request.method == "POST":

        lid = request.POST.get('lid')
        description = request.POST.get('description')
        try:
            latitude  = float(request.POST.get('latitude', 0))
            longitude = float(request.POST.get('longitude', 0))
        except (ValueError, TypeError):
            return JsonResponse({"status": "error", "message": "Invalid coordinates"})
        photo = request.FILES.get('photo')

        # NEW FIELDS
        name = request.POST.get('name')
        phone = request.POST.get('phone')
        email = request.POST.get('email')
        address = request.POST.get('address')

        missing_place = request.POST.get('missing_place')
        age = request.POST.get('age')
        date_of_birth = request.POST.get('date_of_birth')
        gender = request.POST.get('gender')
        parent_name = request.POST.get('parent_name')
        items_carried = request.POST.get('items_carried')
        height = request.POST.get('height')
        identification_marks = request.POST.get('identification_marks')
        clothes_ornaments = request.POST.get('clothes_ornaments')

        try:
            user = UserProfile.objects.get(USER_id=lid)
        except UserProfile.DoesNotExist:
            return JsonResponse({"status": "error", "message": "User not found"})

        stations = policestation.objects.all()

        nearest_station = None
        min_distance = 999999

        for s in stations:

            try:
                lat2 = float(s.latitude)
                lon2 = float(s.longitude)
            except (ValueError, TypeError):
                continue

            dist = distance(latitude, longitude, lat2, lon2)

            if dist < min_distance:
                min_distance = dist
                nearest_station = s

        if nearest_station is None:
            return JsonResponse({
                "status": "error",
                "message": "No station found"
            })

        case = Case_file.objects.create(
            USER=user,
            police_station=nearest_station,
            description=description,
            photo=photo,
            progress="pending",
            status="Not Viewed",
            date=datetime.now().strftime("%Y-%m-%d %H:%M:%S"),

            name=name,
            phone=phone,
            email=email,
            address=address,
            Missing_place=missing_place,
            age=age,
            date_of_birth=date_of_birth,
            Gender=gender,
            parent_name=parent_name,
            items_carried=items_carried,
            Height=height,
            identification_marks=identification_marks,
            clothes_ornaments=clothes_ornaments
        )

        return JsonResponse({
            "status": "ok",
            "station": nearest_station.station_name
        })

    return JsonResponse({"status": "error"})

# @csrf_exempt
# def user_report_case(request):
#
#     print("----- REPORT CASE API CALLED -----")
#
#     if request.method == "POST":
#
#         lid = request.POST.get('lid')
#         description = request.POST.get('description')
#         latitude = float(request.POST.get('latitude'))
#         longitude = float(request.POST.get('longitude'))
#         photo = request.FILES.get('photo')
#
#         print("User Login ID:", lid)
#         print("Description:", description)
#         print("Latitude:", latitude)
#         print("Longitude:", longitude)
#         print("Photo:", photo)
#
#         try:
#             user = UserProfile.objects.get(USER_id=lid)
#         except UserProfile.DoesNotExist:
#             print("User profile not found")
#             return JsonResponse({"status": "error", "message": "User not found"})
#
#         print("User Found:", user)
#
#         stations = policestation.objects.all()
#
#         nearest_station = None
#         min_distance = 999999
#
#         print("Checking nearest police station...")
#
#         for s in stations:
#
#             print("Station:", s.station_name)
#
#             try:
#                 lat2 = float(s.latitude)
#                 lon2 = float(s.longitude)
#             except:
#                 print("Invalid coordinates for station:", s.station_name)
#                 continue
#
#             dist = distance(latitude, longitude, lat2, lon2)
#
#             print("Distance:", dist)
#
#             if dist < min_distance:
#                 min_distance = dist
#                 nearest_station = s
#
#         if nearest_station is None:
#             print("No valid station found")
#             return JsonResponse({
#                 "status": "error",
#                 "message": "No station found"
#             })
#
#         print("Nearest Station:", nearest_station.station_name)
#
#         case = Case_file.objects.create(
#             USER=user,
#             police_station=nearest_station,
#             description=description,
#             photo=photo,
#             progress="pending",
#             status="Not Viewed",
#             date=datetime.now().strftime("%Y-%m-%d %H:%M:%S")
#         )
#
#         print("Case Created:", case.id)
#
#         return JsonResponse({
#             "status": "ok",
#             "station": nearest_station.station_name
#         })
#
#     return JsonResponse({"status": "error"})


# VIEW USER CASES



@csrf_exempt
def user_view_cases(request):

    print("----- USER VIEW CASES API CALLED -----")

    if request.method == "POST":

        lid = request.POST.get("lid")

        try:
            user = UserProfile.objects.get(USER_id=lid)
        except UserProfile.DoesNotExist:
            return JsonResponse({
                "status": "error",
                "message": "User not found"
            })

        cases = Case_file.objects.filter(USER=user).order_by('-id')

        data = []

        for c in cases:

            try:
                photo_url = request.build_absolute_uri(c.photo.url)
            except:
                photo_url = ""

            data.append({
                "id": c.id,
                "description": c.description,
                "progress": c.progress,
                "status": c.status,
                "date": c.date,
                "station": c.police_station.station_name if c.police_station else "Not Assigned",
                "photo": photo_url,

                "name": c.name,
                "phone": c.phone,
                "email": c.email,
                "address": c.address,
                "missing_place": c.Missing_place,
                "age": c.age,
                "date_of_birth": c.date_of_birth,
                "gender": c.Gender,
                "parent_name": c.parent_name,
                "items_carried": c.items_carried,
                "height": c.Height,
                "identification_marks": c.identification_marks,
                "clothes_ornaments": c.clothes_ornaments,
                "report": c.report if c.report else "",
            })

        return JsonResponse({
            "status": "ok",
            "data": data
        })

    return JsonResponse({"status": "error"})
# def user_view_cases(request):
#
#     print("----- USER VIEW CASES API CALLED -----")
#
#     if request.method == "POST":
#
#         lid = request.POST.get("lid")
#         print("Login ID:", lid)
#
#         try:
#             user = UserProfile.objects.get(USER_id=lid)
#         except UserProfile.DoesNotExist:
#             print("User profile not found")
#             return JsonResponse({
#                 "status": "error",
#                 "message": "User not found"
#             })
#
#         print("UserProfile ID:", user.id)
#
#         cases = Case_file.objects.filter(USER=user).order_by('-id')
#
#         data = []
#
#         for c in cases:
#
#             try:
#                 photo_url = request.build_absolute_uri(c.photo.url)
#             except:
#                 photo_url = ""
#
#             data.append({
#                 "id": c.id,
#                 "description": c.description,
#                 "progress": c.progress,
#                 "status": c.status,
#                 "date": c.date,
#                 "station": c.police_station.station_name if c.police_station else "Not Assigned",
#                 "photo": photo_url
#             })
#
#         print("Total Cases:", len(data))
#
#         return JsonResponse({
#             "status": "ok",
#             "data": data
#         })
#
#     return JsonResponse({"status": "error"})






#////////////POLICE////////////////////////////////////////////////////////////////////////////////////////////////////////

# @login_required
# def police_view_cases(request):
#
#     print("----- POLICE VIEW CASES FUNCTION CALLED -----")
#
#     police_id = request.session.get('police_id')
#     print("Police ID from session:", police_id)
#
#     if not police_id:
#         print("ERROR: Police ID not found in session")
#         return redirect("login")
#
#     officer = police.objects.select_related('policestation').get(id=police_id)
#     print("Officer Name:", officer.full_name)
#
#     station = officer.policestation
#     print("Officer Station:", station.station_name)
#
#     cases = Case_file.objects.filter(police_station=station).order_by('-id')
#
#     print("Total Cases Found:", cases.count())
#
#     for c in cases:
#         print("Case ID:", c.id,
#               "| Description:", c.description,
#               "| Status:", c.status,
#               "| Progress:", c.progress)
#
#     return render(request, "police/police_view_cases.html", {
#         "cases": cases,
#         "police": officer
#     })
#
# def police_view_cases(request):
#     police_id = request.session.get('police_id')
#     if not police_id:
#         return redirect("login")
#
#     officer = police.objects.select_related('policestation').get(id=police_id)
#     station = officer.policestation
#     cases = Case_file.objects.filter(
#         police_station=station,
#         progress__in=["pending", "In Progress"]
#     ).order_by('-id')
#
#     pending_count = cases.filter(status="Not Viewed").count()
#     viewed_count = cases.filter(status="Viewed").count()
#     approved_count = cases.filter(status="Approved").count()
#
#     return render(request, "police/police_view_cases.html", {
#         "cases": cases,
#         "police": officer,
#         "pending_count": pending_count,
#         "viewed_count": viewed_count,
#         "approved_count": approved_count,
#     })

from django.core.files import File


import cv2
import os
import shutil


def detect_face_with_rotation(image_path):
    img = cv2.imread(image_path)
    if img is None:
        print(f"[ERROR] Image not found at {image_path}")
        return False, None

    rotations = [
        (None, "Original"),
        (cv2.ROTATE_90_CLOCKWISE, "90 CW"),
        (cv2.ROTATE_180, "180"),
        (cv2.ROTATE_90_COUNTERCLOCKWISE, "90 CCW")
    ]
    face_cascade = cv2.CascadeClassifier(cv2.data.haarcascades + 'haarcascade_frontalface_default.xml')

    for rotate_code, label in rotations:
        current_img = img if rotate_code is None else cv2.rotate(img, rotate_code)

        gray = cv2.cvtColor(current_img, cv2.COLOR_BGR2GRAY)
        faces = face_cascade.detectMultiScale(gray, 1.1, 4)

        if len(faces) > 0:
            print(f"[SUCCESS] Face found in {label} position.")
            cv2.imwrite(image_path, current_img)
            return True, current_img

    return False, None



def police_view_cases(request):
    police_id = request.session.get('police_id')
    if not police_id:
        if request.method == 'POST':
            return JsonResponse({'status': 'error', 'message': 'Not authenticated'})
        return redirect("login")

    officer = police.objects.select_related('policestation').get(id=police_id)
    station = officer.policestation

    # ── POST: mark_viewed (AJAX from View button) ──────────────────
    if request.method == 'POST' and request.POST.get('action') == 'mark_viewed':
        case_id = request.POST.get('case_id')
        try:
            case = Case_file.objects.get(id=case_id, police_station=station)
            if case.status == 'Not Viewed':
                case.status = 'Viewed'
                case.save()
                print(f"[INFO] Case {case_id} marked Viewed")
            return JsonResponse({'status': 'ok'})
        except Case_file.DoesNotExist:
            return JsonResponse({'status': 'error', 'message': 'Case not found'})

    # ── POST: approve ──────────────────────────────────────────────
    if request.method == 'POST' and request.POST.get('action') == 'approve':

        case_id = request.POST.get('case_id')
        case = get_object_or_404(Case_file, id=case_id, police_station=station)

        db_type = request.POST.get('db_type', 'missing')
        name = request.POST.get('name', '').strip()
        age = request.POST.get('age', '')
        gender = request.POST.get('gender', '')
        details = request.POST.get('details', '')

        uploaded_file = request.FILES.get('photo')
        selected_photo_url = request.POST.get('selected_photo_url', '')

        print("&"*100)
        print("uploaded_file : ",uploaded_file)
        print("selected_photo_url : ",selected_photo_url)
        print("case.photo : ",case.photo)
        print("&"*100)
        a=request.session.get('police_id')
        p = police.objects.get(pk=a)



        rt = police_addmissingCase_new(p,case_id,case,db_type,name,age,gender,details,uploaded_file,selected_photo_url)

        case.status = 'Approved'
        case.progress = 'Found'
        case.save()
        return redirect(reverse('police_view_cases') + '?approved=1')
        #
        # trainer = FaceRecognitionTrainer()
        # iimm=""
        #
        #
        #
        # # ── Resolve photo & write temp file for MTCNN ──────────────
        # if uploaded_file:
        #     # Write to disk for MTCNN to read
        #     temp_path = os.path.join(settings.MEDIA_ROOT, uploaded_file.name)
        #     iimm = temp_path
        #     # print("temp_path : ",temp_path)
        #     with open(temp_path, 'wb+') as f:
        #         for chunk in uploaded_file.chunks():
        #             f.write(chunk)
        #     # uploaded_file pointer is now at EOF — do NOT pass it to Django.
        #     # We open the temp file fresh below using File().
        #     using_temp = True
        #     print(f"[APPROVE] External upload written to: {temp_path}")
        #
        #
        # if (selected_photo_url and case.photo) or case.photo:
        #     temp_path = os.path.join(settings.MEDIA_ROOT, str(case.photo))
        #
        #     face_found, rotated_img = detect_face_with_rotation(temp_path)
        #
        #     if face_found:
        #         print(f"[APPROVE] Face found: {temp_path}")
        #
        #         missing_dir = os.path.join(settings.MEDIA_ROOT, 'missing')
        #         print("missing_dir : ",missing_dir)
        #
        #
        #         print("abcd : ",temp_path)
        #
        #         if not os.path.exists(missing_dir):
        #             os.makedirs(missing_dir)
        #
        #         file_name = os.path.basename(temp_path)
        #         print("file_name : ",file_name)
        #         new_path = os.path.join(missing_dir, file_name)
        #         print("New Path : ",new_path)
        #         iimm = "missing/"+file_name
        #
        #         cv2.imwrite(new_path, rotated_img)
        #
        #         print(f"[SUCCESS] Image moved to: {new_path}")
        #
        #         temp_path = new_path
        #         using_temp = False
        #     else:
        #         print(f"[WARNING] No face found even after all rotations.")
        #         using_temp = True
        #
        #
        # # elif case.photo:
        # #     temp_path = os.path.join(settings.MEDIA_ROOT, str(case.photo))
        # #     is_face, _ = detect_face_with_rotation(temp_path)
        # #     using_temp = False
        #
        # else:
        #     messages.error(request, "No photo available. Please upload an external photo.")
        #     return redirect('police_view_cases')
        #
        # # ── MTCNN: extract face embedding ──────────────────────────
        # print("temp_path : ",temp_path)
        # emb = trainer.extract_embedding(temp_path)
        # # emb =""
        #
        # if emb is None:
        #     print("NNNNNNNNNNNNNNNNN")
        #     if using_temp and os.path.exists(temp_path):
        #         print("IIIIIIIIIIIIIIIII")
        #         # os.remove(temp_path)
        #     messages.warning(request, "No face detected in the photo. Please upload a clearer image.")
        #     return redirect('police_view_cases')
        #
        # # ── Duplicate check (same threshold as addmissingCase) ─────
        # duplicate = False
        # for key, value in trainer.database.items():
        #     db_emb = np.array(value)
        #     similarity = np.dot(emb, db_emb) / (
        #         np.linalg.norm(emb) * np.linalg.norm(db_emb)
        #     )
        #     if similarity > 0.70:
        #         duplicate = True
        #         print(f"[WARN] Duplicate: key={key}, similarity={similarity:.3f}")
        #         break
        #
        # if duplicate:
        #     if using_temp and os.path.exists(temp_path):
        #         os.remove(temp_path)
        #     messages.warning(request, "This person already exists in the database.")
        #     return redirect('police_view_cases')
        #
        # # ── Save to DB ─────────────────────────────────────────────
        # # For external uploads: open temp file FRESH with File() — pointer at byte 0.
        # # For case.photo: pass the ImageFieldFile directly — already readable.
        #
        # photo_file = None
        # print("iimm : ",iimm)
        # try:
        #     if using_temp:
        #         # photo_file = open(temp_path, 'rb')  # fresh pointer
        #         photo_file = open(iimm, 'rb')  # fresh pointer
        #         print("photo_file : ",photo_file)
        #         # django_photo = File(photo_file, name=os.path.basename(temp_path))
        #         django_photo = File(photo_file, name=os.path.basename(iimm))
        #     else:
        #         # django_photo = case.photo  # ImageFieldFile
        #         django_photo = iimm  # ImageFieldFile
        #
        #     if db_type == 'missing':
        #
        #         obj = Missing_person.objects.create(
        #             POLICE=officer,
        #             name=name, age=age, gender=gender, details=details,
        #             photo=django_photo
        #         )
        #         print(f"[INFO] Missing person saved: {obj.name}, photo path: {obj.photo}")
        #
        #         # Extract embedding from the path Django actually saved to
        #         # img_path = os.path.join(settings.MEDIA_ROOT, str(obj.photo))
        #         # print("img_path - emb2 - : ",img_path)
        #         # emb2 = trainer.extract_embedding(img_path)
        #         emb2 = emb
        #         # print("emb2 : ",emb2)
        #         if emb2 is not None:
        #             key = f"MISSING|{obj.id}|{obj.name}"
        #             for i in range(5):
        #                 trainer.database[f"{key}_{i}"] = emb2.tolist()
        #             trainer.save_model()
        #             print(f"[TRAINED] Missing: {obj.name} → {key}")
        #         else:
        #             print(f"[WARN] Re-extract failed for saved path: {img_path}")
        #
        #     else:  # criminal
        #
        #         crime_type = request.POST.get('crime_type', '')
        #         severity = request.POST.get('severity', 'Medium')
        #
        #         obj = criminal.objects.create(
        #             POLICE=officer,
        #             name=name, age=age, gender=gender, details=details,
        #             photo=django_photo,
        #             crime_type=crime_type,
        #             severity=severity
        #         )
        #         print(f"[INFO] Criminal saved: {obj.name}, photo path: {obj.photo}")
        #
        #         img_path = os.path.join(settings.MEDIA_ROOT, str(obj.photo))
        #         emb2 = trainer.extract_embedding(img_path)
        #         if emb2 is not None:
        #             key = f"CRIMINAL|{obj.id}|{obj.name}"
        #             for i in range(5):
        #                 trainer.database[f"{key}_{i}"] = emb2.tolist()
        #             trainer.save_model()
        #             print(f"[TRAINED] Criminal: {obj.name} → {key}")
        #         else:
        #             print(f"[WARN] Re-extract failed for saved path: {img_path}")
        #
        # finally:
        #     if photo_file:
        #         photo_file.close()
        #     # Clean up temp file only for external uploads
        #     if using_temp and os.path.exists(temp_path):
        #         os.remove(temp_path)
        #
        # # ── Mark case Approved — user app sees this on next poll ───
        # case.status = 'Approved'
        # case.progress = 'Found'
        # case.save()
        # print(f"[INFO] Case {case_id} marked Approved")
        #
        # messages.success(request, f"{name} added to database. Case #{case_id} approved.")
        # return redirect('police_view_cases')

    # ── GET ────────────────────────────────────────────────────────
    cases = Case_file.objects.filter(police_station=station).order_by('-id')

    pending_count = cases.filter(status='Not Viewed').count()
    viewed_count = cases.filter(status='Viewed').count()
    approved_count = cases.filter(status='Approved').count()

    return render(request, 'police/police_view_cases.html', {
        'cases': cases,
        'police': officer,
        'pending_count': pending_count,
        'viewed_count': viewed_count,
        'approved_count': approved_count,
    })




@login_required
def police_update_case(request, id):

    print("----- POLICE UPDATE CASE FUNCTION CALLED -----")

    print("Case ID received:", id)

    case = get_object_or_404(Case_file, id=id)

    print("Case Description:", case.description)
    print("Current Status:", case.status)
    print("Current Progress:", case.progress)

    # Only mark as Viewed if it hasn't been seen yet — don't overwrite Approved
    if case.status == "Not Viewed":
        case.status = "Viewed"
        case.save()
        print("Case status updated to VIEWED")

    if request.method == "POST":

        progress = request.POST.get("progress")

        print("New Progress Received:", progress)

        case.progress = progress
        case.save()

        print("Case progress updated successfully")

        messages.success(request, "Case progress updated")

        return redirect("police_view_cases")

    # GET: render the update page with user uploads
    user_uploads = User_upload.objects.filter(USER=case.USER).order_by('-id')

    return render(request, "police/police_update_case.html", {
        "case": case,
        "user_uploads": user_uploads,
    })




#////////////////TRAINING//////////////////////////////////////////////////////////////////////////////////////////////
from .train import FaceRecognitionTrainer
import numpy as np
from django.core.files.storage import FileSystemStorage
from .detect import FaceDetector



def police_addmissingCase(request):
    officer = _get_police(request)
    message = None

    if request.method == "POST":

        name = request.POST['name']
        age = request.POST['age']
        gender = request.POST['gender']
        details = request.POST['details']
        photo = request.FILES['photo']
        trainer = FaceRecognitionTrainer()
        temp_path = os.path.join(settings.MEDIA_ROOT, photo.name)

        with open(temp_path, "wb+") as f:
            for chunk in photo.chunks():
                f.write(chunk)

        emb = trainer.extract_embedding(temp_path)

        if emb is None:

            message = "No face detected"
            os.remove(temp_path)

        else:

            duplicate = False

            for key, value in trainer.database.items():

                db_emb = np.array(value)

                similarity = np.dot(emb, db_emb) / (
                        np.linalg.norm(emb) * np.linalg.norm(db_emb)
                )

                if similarity > 0.70:
                    duplicate = True
                    break

            if duplicate:

                message = "Person already exists"
                os.remove(temp_path)

            else:

                obj = Missing_person.objects.create(
                    POLICE=officer,
                    name=name,
                    age=age,
                    gender=gender,
                    details=details,
                    photo=photo
                )

                os.remove(temp_path)

                print("[INFO] Missing person saved:", obj.name)

                img_path = os.path.join(settings.MEDIA_ROOT, str(obj.photo))

                emb = trainer.extract_embedding(img_path)

                if emb is not None:

                    key = f"MISSING|{obj.id}|{obj.name}"

                    for i in range(5):
                        trainer.database[f"{key}_{i}"] = emb.tolist()

                    trainer.save_model()

                    print("[TRAINED] Missing person:", obj.name)

                message = "Missing person added successfully"

    return render(
        request,
        "police/police_addmissingCase.html",
        {
            "police": officer,
            "message": message
        }
    )




#####################################################################################################


def police_addmissingCase_new(polid,case_id, case, db_type, name, age, gender, details, uploaded_file, selected_photo_url):
    # officer = _get_police(request)
    # message = None

    # if request.method == "POST":

    name = name
    age = age
    gender = gender
    details = details
    photo = "C:/crowdtraceproject"+selected_photo_url
    trainer = FaceRecognitionTrainer()
    print("photo : ",photo)
    print("os.path.join(settings.MEDIA_ROOT, selected_photo_url) : ",os.path.join(settings.MEDIA_ROOT))
    # temp_path = os.path.join(settings.MEDIA_ROOT, selected_photo_url)
    temp_path=photo

    # temp_path = os.path.join(settings.MEDIA_ROOT, str(case.photo))



    face_found, rotated_img = detect_face_with_rotation(temp_path)



    if face_found:

        print(f"[APPROVE] Face found: {temp_path}")



        missing_dir = os.path.join(settings.MEDIA_ROOT, 'missing')

        print("missing_dir : ",missing_dir)





        print("abcd : ",temp_path)



        if not os.path.exists(missing_dir):

            os.makedirs(missing_dir)



        file_name = os.path.basename(temp_path)

        print("file_name : ",file_name)

        new_path = os.path.join(missing_dir, file_name)

        print("New Path : ",new_path)

        iimm = "missing/"+file_name



        cv2.imwrite(new_path, rotated_img)



        print(f"[SUCCESS] Image moved to: {new_path}")



        temp_path = new_path

        using_temp = False

    else:

        print(f"[WARNING] No face found even after all rotations.")

        using_temp = True





    # with open(temp_path, "wb+") as f:
    #     for chunk in photo.chunks():
    #         f.write(chunk)

    emb = trainer.extract_embedding(temp_path)

    if emb is None:

        message = "No face detected"
        # os.remove(temp_path)

    else:

        duplicate = False

        for key, value in trainer.database.items():

            db_emb = np.array(value)

            similarity = np.dot(emb, db_emb) / (
                    np.linalg.norm(emb) * np.linalg.norm(db_emb)
            )

            if similarity > 0.70:
                duplicate = True
                break

        if duplicate:

            message = "Person already exists"
            os.remove(temp_path)

        else:

            obj = Missing_person.objects.create(
                POLICE=polid,
                name=name,
                age=age,
                gender=gender,
                details=details,
                photo=iimm
            )

            print("[INFO] Missing person saved:", obj.name)

            img_path = os.path.join(settings.MEDIA_ROOT, str(obj.photo))

            emb = trainer.extract_embedding(img_path)

            if emb is not None:

                key = f"MISSING|{obj.id}|{obj.name}"

                for i in range(5):
                    trainer.database[f"{key}_{i}"] = emb.tolist()

                trainer.save_model()

                print("[TRAINED] Missing person:", obj.name)

            message = "Missing person added successfully"
            case.status = 'Approved'
            case.progress = 'Found'
            case.save()

    return  redirect("police_view_cases")
    # return render(
    #     # request,
    #     "police/police_addmissingCase.html",
    #     {
    #         "police": polid,
    #         "message": message
    #     }
    # )




#####################################################################################################

def police_addCriminalCase(request):

    officer = _get_police(request)
    message = None

    if request.method == "POST":

        name       = request.POST['name']
        age        = request.POST['age']
        gender     = request.POST['gender']
        details    = request.POST['details']
        photo      = request.FILES['photo']
        crime_type = request.POST.get('crime_type', '')
        severity   = request.POST.get('severity', 'Medium')

        trainer = FaceRecognitionTrainer()

        # temporary save
        temp_path = os.path.join(settings.MEDIA_ROOT, photo.name)

        with open(temp_path, "wb+") as f:
            for chunk in photo.chunks():
                f.write(chunk)

        emb = trainer.extract_embedding(temp_path)

        if emb is None:

            message = "No face detected"
            os.remove(temp_path)

        else:

            duplicate = False

            for key, value in trainer.database.items():

                db_emb = np.array(value)

                similarity = np.dot(emb, db_emb) / (
                        np.linalg.norm(emb) * np.linalg.norm(db_emb)
                )

                if similarity > 0.70:
                    duplicate = True
                    break

            if duplicate:

                message = "Person already exists"
                os.remove(temp_path)

            else:

                obj = criminal.objects.create(
                    POLICE=officer,
                    name=name,
                    age=age,
                    gender=gender,
                    details=details,
                    photo=photo,
                    crime_type=crime_type,
                    severity=severity,
                )

                os.remove(temp_path)

                print("[INFO] Criminal saved:", obj.name)

                img_path = os.path.join(settings.MEDIA_ROOT, str(obj.photo))

                emb = trainer.extract_embedding(img_path)

                if emb is not None:

                    key = f"CRIMINAL|{obj.id}|{obj.name}"

                    for i in range(5):
                        trainer.database[f"{key}_{i}"] = emb.tolist()

                    trainer.save_model()

                    print("[TRAINED] Criminal:", obj.name)

                message = "Criminal added successfully"

    return render(
        request,
        "police/police_addCriminalCase.html",
        {
            "police": officer,
            "message": message
        }
    )
#/////////////PREDICTION////////////////////////////////////////////////////////////////////////////////////////////////


#
# def police_detect_person(request):
#
#     result = None
#     file_url = None
#     file_type = None
#
#     if request.method == "POST":
#
#         uploaded_file = request.FILES.get("file")
#
#         if uploaded_file:
#
#             upload_folder = os.path.join(settings.MEDIA_ROOT, "detect_uploads")
#
#             if not os.path.exists(upload_folder):
#                 os.makedirs(upload_folder)
#
#             fs = FileSystemStorage(location=upload_folder)
#
#             filename = fs.save(uploaded_file.name, uploaded_file)
#
#             file_path = fs.path(filename)
#
#             file_url = settings.MEDIA_URL + "detect_uploads/" + filename
#
#             detector = FaceDetector(
#                 model_path=os.path.join(settings.BASE_DIR, "face_model.pkl")
#             )
#
#             file_name = uploaded_file.name.lower()
#
#             try:
#
#                 if file_name.endswith((".jpg", ".jpeg", ".png")):
#
#                     file_type = "image"
#                     result = detector.detect_from_image(file_path)
#
#                 elif file_name.endswith((".mp4", ".avi", ".mov")):
#
#                     file_type = "video"
#                     result = detector.detect_from_video(file_path)
#
#                 else:
#
#                     result = [{"status": "error", "message": "Unsupported file type"}]
#
#             except Exception as e:
#
#                 result = [{"status": "error", "message": str(e)}]
#
#     return render(
#         request,
#         "police/police_detect_person.html",
#         {
#             "result": result,
#             "file_url": file_url,
#             "file_type": file_type
#         }
#     )




def police_detect_person(request):

    officer      = _get_police(request)
    police_id    = request.session.get('police_id')

    total_missing   = Missing_person.objects.filter(POLICE=police_id).count()
    total_criminals = criminal.objects.filter(POLICE=police_id).count()
    total_scans     = Live_detection.objects.count()
    detections      = Live_detection.objects.all().order_by('-id')[:12]

    result    = None
    file_url  = None
    file_type = None

    if request.method == "POST":
        selected_url = request.POST.get("selected_url")
        uploaded_file = request.FILES.get("file")


        if selected_url and not uploaded_file:
            relative_path = selected_url.replace(settings.MEDIA_URL, "", 1)
            file_path = os.path.join(settings.MEDIA_ROOT, relative_path)
            file_url = selected_url
            file_type = "image"
            detector = FaceDetector(model_path=os.path.join(settings.BASE_DIR, "face_model.pkl"))
            try:
                result = detector.detect_from_image(file_path)
                print("RESSSSSSSSSSSSSSS : ",result)
                if result:
                    for r in result:
                        if r.get('confidence') and r['confidence'] <= 1:
                            r['confidence'] = round(r['confidence'] * 100, 1)
            except Exception as e:
                result = [{"status": "error", "message": str(e)}]

        elif uploaded_file:
            upload_folder = os.path.join(settings.MEDIA_ROOT, "detect_uploads")
            if not os.path.exists(upload_folder):
                os.makedirs(upload_folder)

            fs        = FileSystemStorage(location=upload_folder)
            filename  = fs.save(uploaded_file.name, uploaded_file)
            file_path = fs.path(filename)
            file_url  = settings.MEDIA_URL + "detect_uploads/" + filename

            detector = FaceDetector(
                model_path=os.path.join(settings.BASE_DIR, "face_model.pkl")
            )

            try:
                if uploaded_file.name.lower().endswith((".jpg", ".jpeg", ".png", ".webp")):
                    file_type = "image"
                    result = detector.detect_from_image(file_path)
                    print("TTTTTTTTTTTTTTTTTTT : ", result)
                    if result:
                        for r in result:
                            if r.get('confidence') and r['confidence'] <= 1:
                                r['confidence'] = round(r['confidence'] * 100, 1)

                elif uploaded_file.name.lower().endswith((".mp4", ".avi", ".mov")):
                    file_type = "video"
                    result = detector.detect_from_video(file_path)
                    if result:
                        for r in result:
                            if r.get('confidence') and r['confidence'] <= 1:
                                r['confidence'] = round(r['confidence'] * 100, 1)
            except Exception as e:
                result = [{"status": "error", "message": str(e)}]

    return render(request, "police/police_detect_person.html", {
        "result":          result,
        "file_url":        file_url,
        "file_type":       file_type,
        "police":          officer,
        "total_missing":   total_missing,
        "total_criminals": total_criminals,
        "total_scans":     total_scans,
        "detections":      detections,
    })
#///////////////LIVE CAMERA DETECTION///////////////////////////////////////////////////////////////////////////////////

import os
import cv2
import uuid
import time
from datetime import datetime

from django.shortcuts import render
from django.http import StreamingHttpResponse, JsonResponse
from django.views.decorators.csrf import csrf_exempt
from django.conf import settings

from .live_predict import LiveFaceDetector
from .detect import FaceDetector

from .models import Live_detection, User_upload, Missing_person, criminal, UserProfile


# =====================================================
# LOAD AI MODELS
# =====================================================


#####111111111111111111111111111111111111111111111111111111111111111111111111111
MODEL_PATH = os.path.join(settings.BASE_DIR, "face_model.pkl")


live_detector = LiveFaceDetector(
    model_path=MODEL_PATH,
    threshold=0.9
)


file_detector = FaceDetector(
    model_path=MODEL_PATH
)


#####111111111111111111111111111111111111111111111111111111111111111111111111111
# =====================================================
# DETECTION CACHE (avoid duplicates)
# =====================================================

last_detected_times = {}


# =====================================================
# ADMIN LIVE CAMERA PAGE
# =====================================================

def admin_live_camera(request):

    return render(request, "live_camera.html")


# =====================================================
# GENERATE LIVE CAMERA FRAMES
# =====================================================

def generate_frames():

    cap = cv2.VideoCapture(0)

    if not cap.isOpened():
        raise RuntimeError("Webcam not accessible")

    while True:

        success, frame = cap.read()

        if not success:
            break

        # Detect faces
        frame, detections = live_detector.detect_and_draw(frame)

        for det in detections:

            if det["status"] != "matched":
                continue

            name = det["name"]
            category = det["category"]
            confidence = det["confidence"]

            current_time = time.time()

            last_time = last_detected_times.get(name, 0)

            # Skip duplicate detection within 10 seconds
            if current_time - last_time < 10:
                continue

            last_detected_times[name] = current_time

            # =====================================
            # SAVE SCREENSHOT
            # =====================================

            filename = f"{uuid.uuid4()}.jpg"

            save_dir = os.path.join(settings.MEDIA_ROOT, "live_detections")

            os.makedirs(save_dir, exist_ok=True)

            filepath = os.path.join(save_dir, filename)

            cv2.imwrite(filepath, frame)

            # =====================================
            # SAVE TO DATABASE
            # =====================================

            Live_detection.objects.create(

                name=name,
                category=category,
                confidence=str(confidence),

                photo=f"live_detections/{filename}",

                date=datetime.now().strftime("%H:%M:%S")
            )

            print("Stored detection:", name)

        # Convert frame to JPEG
        ret, buffer = cv2.imencode('.jpg', frame)

        frame = buffer.tobytes()

        yield (b'--frame\r\n'
               b'Content-Type: image/jpeg\r\n\r\n' + frame + b'\r\n')

    cap.release()


# =====================================================
# VIDEO STREAM
# =====================================================

def video_feed(request):

    return StreamingHttpResponse(
        generate_frames(),
        content_type='multipart/x-mixed-replace; boundary=frame'
    )

#///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

def admin_view_live_detections(request):

    print("===== ADMIN VIEW LIVE DETECTIONS =====")

    detections = Live_detection.objects.all().order_by('-id')

    context = {
        "detections": detections
    }

    return render(
        request,
        "admin_live_detections.html",
        context
    )


def police_live_detections(request):

    print("===== POLICE VIEW LIVE DETECTIONS =====")

    detections = Live_detection.objects.all().order_by('-id')

    context = {
        "detections": detections
    }

    return render(
        request,
        "police/police_live_detections.html",
        context
    )




# USER DETECT PERSON (UPLOAD IMAGE / VIDEO)
@csrf_exempt
# def user_detect_person(request):
#
#     print("========== USER DETECT API CALLED ==========")
#
#     if request.method == "POST":
#
#         uid = request.POST.get("uid")
#         latitude = request.POST.get("latitude")
#         longitude = request.POST.get("longitude")
#         uploaded_file = request.FILES.get("file")
#
#         if not uploaded_file:
#             return JsonResponse({
#                 "status": "error",
#                 "message": "No file uploaded"
#             })
#
#         # ===============================
#         # GET USER PROFILE
#         # ===============================
#
#         try:
#             user_profile = UserProfile.objects.get(USER_id=uid)
#         except UserProfile.DoesNotExist:
#             return JsonResponse({
#                 "status": "error",
#                 "message": "User profile not found"
#             })
#
#         # ===============================
#         # SAVE FILE
#         # ===============================
#
#         upload_folder = os.path.join(settings.MEDIA_ROOT, "user_uploads")
#         os.makedirs(upload_folder, exist_ok=True)
#
#         filename = str(uuid.uuid4()) + "_" + uploaded_file.name
#         file_path = os.path.join(upload_folder, filename)
#
#         with open(file_path, "wb+") as destination:
#             for chunk in uploaded_file.chunks():
#                 destination.write(chunk)
#
#         print("File saved:", file_path)
#
#         # ===============================
#         # RUN DETECTION
#         # ===============================
#
#         ext = filename.split(".")[-1].lower()
#
#         if ext in ["jpg", "jpeg", "png"]:
#             results = file_detector.detect_from_image(file_path)
#         else:
#             results = file_detector.detect_from_video(file_path)
#
#         print("Detection results:", results)
#
#         if not results:
#             return JsonResponse({
#                 "status": "ok",
#                 "result": []
#             })
#
#         # ===============================
#         # SAVE RESULTS
#         # ===============================
#
#         response_data = []
#         seen = set()
#
#         for r in results:
#
#             category = r["category"]
#             pid = r["id"]
#             name = r["name"]
#
#             key = f"{name}-{category}"
#
#             if key in seen:
#                 continue
#
#             seen.add(key)
#
#             missing_obj = None
#             criminal_obj = None
#
#             if category == "Missing Person":
#
#                 try:
#                     missing_obj = Missing_person.objects.get(id=pid)
#                 except Missing_person.DoesNotExist:
#                     continue
#
#             elif category == "Criminal":
#
#                 try:
#                     criminal_obj = criminal.objects.get(id=pid)
#                 except criminal.DoesNotExist:
#                     continue
#
#             # SAVE TO DATABASE
#             User_upload.objects.create(
#                 USER=user_profile,
#                 Missing_person=missing_obj,
#                 criminal=criminal_obj,
#                 category=category,
#                 date=datetime.now().strftime("%H:%M:%S"),
#                 latitude=latitude,
#                 longitude=longitude,
#                 photo="user_uploads/" + filename
#             )
#
#             response_data.append({
#                 "name": name,
#                 "category": category
#             })
#
#         return JsonResponse({
#             "status": "ok",
#             "result": response_data
#         })
#
#     return JsonResponse({
#         "status": "invalid request"
#     })



#
# def user_detect_person(request):
#     print("========== USER DETECT API CALLED ==========")
#
#     if request.method == "POST":
#         print("Request method is POST")
#
#         uid = request.POST.get("uid")
#         latitude = request.POST.get("latitude")
#         longitude = request.POST.get("longitude")
#         uploaded_file = request.FILES.get("file")
#
#         print(f"UID: {uid}, Latitude: {latitude}, Longitude: {longitude}")
#         print("Uploaded file:", uploaded_file)
#
#         if not uploaded_file:
#             print("No file uploaded")
#             return JsonResponse({
#                 "status": "error",
#                 "message": "No file uploaded"
#             })
#
#         # ===============================
#         # GET USER PROFILE
#         # ===============================
#         try:
#             user_profile = UserProfile.objects.get(USER_id=uid)
#             print("User profile found:", user_profile)
#         except UserProfile.DoesNotExist:
#             print("User profile not found for UID:", uid)
#             return JsonResponse({
#                 "status": "error",
#                 "message": "User profile not found"
#             })
#
#         # ===============================
#         # SAVE FILE
#         # ===============================
#         upload_folder = os.path.join(settings.MEDIA_ROOT, "user_uploads")
#         os.makedirs(upload_folder, exist_ok=True)
#
#         filename = str(uuid.uuid4()) + "_" + uploaded_file.name
#         file_path = os.path.join(upload_folder, filename)
#
#         with open(file_path, "wb+") as destination:
#             for chunk in uploaded_file.chunks():
#                 destination.write(chunk)
#
#         print("File saved at:", file_path)
#
#         # ===============================
#         # RUN DETECTION
#         # ===============================
#         ext = filename.split(".")[-1].lower()
#         print("File extension detected:", ext)
#
#         if ext in ["jpg", "jpeg", "png"]:
#             print("Running image detection...")
#             results = file_detector.detect_from_image(file_path)
#         else:
#             print("Running video detection...")
#             results = file_detector.detect_from_video(file_path)
#
#         print("Detection results:", results)
#
#         if not results:
#             print("No detection results found")
#             return JsonResponse({
#                 "status": "ok",
#                 "result": []
#             })
#
#         # ===============================
#         # SAVE RESULTS
#         # ===============================
#         response_data = []
#         seen = set()
#
#         for r in results:
#             category = r["category"]
#             pid = r["id"]
#             name = r["name"]
#
#             print(f"Processing result: Name={name}, Category={category}, ID={pid}")
#
#             key = f"{name}-{category}"
#             if key in seen:
#                 print("Duplicate result skipped:", key)
#                 continue
#             seen.add(key)
#
#             missing_obj = None
#             criminal_obj = None
#
#             if category == "Missing Person":
#                 try:
#                     missing_obj = Missing_person.objects.get(id=pid)
#                     print("Matched Missing Person:", missing_obj)
#                 except Missing_person.DoesNotExist:
#                     print("Missing Person not found for ID:", pid)
#                     continue
#
#             elif category == "Criminal":
#                 try:
#                     criminal_obj = criminal.objects.get(id=pid)
#                     print("Matched Criminal:", criminal_obj)
#                 except criminal.DoesNotExist:
#                     print("Criminal not found for ID:", pid)
#                     continue
#
#             # SAVE TO DATABASE
#             User_upload.objects.create(
#                 USER=user_profile,
#                 Missing_person=missing_obj,
#                 criminal=criminal_obj,
#                 category=category,
#                 date=datetime.now().strftime("%H:%M:%S"),
#                 latitude=latitude,
#                 longitude=longitude,
#                 photo="user_uploads/" + filename
#             )
#             print("Result saved to database")
#
#             response_data.append({
#                 "name": name,
#                 "category": category
#             })
#
#         print("Final response data:", response_data)
#         return JsonResponse({
#             "status": "ok",
#             "result": response_data
#         })
#
#     print("Invalid request method:", request.method)
#     return JsonResponse({
#         "status": "invalid request"
#     })


def user_detect_person(request):
    print("========== USER DETECT API CALLED ==========")

    if request.method == "POST":

        uid = request.POST.get("uid")
        latitude = request.POST.get("latitude")
        longitude = request.POST.get("longitude")
        uploaded_file = request.FILES.get("file")

        if not uploaded_file:
            return JsonResponse({
                "status": "error",
                "message": "No file uploaded"
            })

        # ===============================
        # GET USER PROFILE
        # ===============================
        try:
            user_profile = UserProfile.objects.get(USER_id=uid)
        except UserProfile.DoesNotExist:
            return JsonResponse({
                "status": "error",
                "message": "User profile not found"
            })

        # ===============================
        # SAVE FILE
        # ===============================
        upload_folder = os.path.join(settings.MEDIA_ROOT, "user_uploads")
        os.makedirs(upload_folder, exist_ok=True)

        filename = str(uuid.uuid4()) + "_" + uploaded_file.name
        file_path = os.path.join(upload_folder, filename)

        with open(file_path, "wb+") as destination:
            for chunk in uploaded_file.chunks():
                destination.write(chunk)

        ext = filename.split(".")[-1].lower()

        all_results = []

        # ===============================
        # IMAGE ROTATION DETECTION
        # ===============================
        if ext in ["jpg", "jpeg", "png"]:

            print("Running multi-rotation detection...")

            image = cv2.imread(file_path)

            rotations = [
                ("0", image),
                ("90", cv2.rotate(image, cv2.ROTATE_90_CLOCKWISE)),
                ("180", cv2.rotate(image, cv2.ROTATE_180)),
                ("270", cv2.rotate(image, cv2.ROTATE_90_COUNTERCLOCKWISE)),
            ]

            for angle, img in rotations:

                temp_path = os.path.join(upload_folder, f"temp_{angle}_{filename}")
                cv2.imwrite(temp_path, img)

                print(f"Detecting on rotation {angle}")

                results = file_detector.detect_from_image(temp_path)

                if results:
                    all_results.extend(results)

                # cleanup temp file
                if os.path.exists(temp_path):
                    os.remove(temp_path)

        else:
            print("Running video detection...")
            all_results = file_detector.detect_from_video(file_path)

        # ===============================
        # NO RESULTS
        # ===============================
        if not all_results:
            return JsonResponse({
                "status": "ok",
                "result": []
            })

        # ===============================
        # REMOVE DUPLICATES
        # ===============================
        response_data = []
        seen = set()

        for r in all_results:
            category = r["category"]
            pid = r["id"]
            name = r["name"]

            key = f"{name}-{category}"

            if key in seen:
                continue

            seen.add(key)

            missing_obj = None
            criminal_obj = None

            if category == "Missing Person":
                try:
                    missing_obj = Missing_person.objects.get(id=pid)
                except Missing_person.DoesNotExist:
                    continue

            elif category == "Criminal":
                try:
                    criminal_obj = criminal.objects.get(id=pid)
                except criminal.DoesNotExist:
                    continue

            # SAVE
            User_upload.objects.create(
                USER=user_profile,
                Missing_person=missing_obj,
                criminal=criminal_obj,
                category=category,
                date=datetime.now().strftime("%H:%M:%S"),
                latitude=latitude,
                longitude=longitude,
                photo="user_uploads/" + filename
            )

            response_data.append({
                "name": name,
                "category": category
            })

        return JsonResponse({
            "status": "ok",
            "result": response_data
        })

    return JsonResponse({
        "status": "invalid request"
    })

#USER VIEW DETECTION
@csrf_exempt
def user_view_detections(request):

    print("\n========== USER VIEW DETECTIONS API CALLED ==========")

    if request.method == "POST":

        uid = request.POST.get("uid")
        print("Received UID:", uid)

        # ===============================
        # GET USER PROFILE
        # ===============================

        try:
            user_profile = UserProfile.objects.get(USER_id=uid)
            print("User found:", user_profile.name)

        except UserProfile.DoesNotExist:

            print("User profile not found")

            return JsonResponse({
                "status": "error",
                "message": "User not found"
            })

        # ===============================
        # FETCH USER UPLOADS
        # ===============================

        uploads = User_upload.objects.filter(USER=user_profile).order_by("-id")

        print("Total uploads found:", uploads.count())

        data = []

        for u in uploads:

            name = ""

            if u.Missing_person:
                name = u.Missing_person.name
                print("Missing person detected:", name)

            elif u.criminal:
                name = u.criminal.name
                print("Criminal detected:", name)

            # ===============================
            # GET MEDIA PATH
            # ===============================

            photo_url = ""

            if u.photo:
                photo_url = u.photo.url
                print("Media file:", photo_url)

            # ===============================
            # ADD DATA
            # ===============================

            data.append({

                "id": u.id,
                "name": name,
                "category": u.category,
                "date": u.date,
                "latitude": u.latitude,
                "longitude": u.longitude,
                "photo": photo_url

            })

        print("Returning", len(data), "records to Flutter")
        print("========== END USER VIEW DETECTIONS ==========\n")

        return JsonResponse({
            "status": "ok",
            "data": data
        })

    print("Invalid request method")

    return JsonResponse({"status": "error"})


# USER VIEW DETECTIONS
@csrf_exempt
def user_view_detections(request):

    print("\n========== USER VIEW DETECTIONS API CALLED ==========")

    if request.method == "POST":

        uid = request.POST.get("uid")
        print("Received UID:", uid)

        # ===============================
        # GET USER PROFILE
        # ===============================

        try:
            user_profile = UserProfile.objects.get(USER_id=uid)
            print("User found:", user_profile.name)

        except UserProfile.DoesNotExist:

            print("User profile not found")

            return JsonResponse({
                "status": "error",
                "message": "User not found"
            })

        # ===============================
        # FETCH USER UPLOADS
        # ===============================

        uploads = User_upload.objects.filter(USER=user_profile).order_by("-id")

        print("Total uploads found:", uploads.count())

        data = []

        for u in uploads:

            name = ""

            if u.Missing_person:
                name = u.Missing_person.name
                print("Missing person detected:", name)

            elif u.criminal:
                name = u.criminal.name
                print("Criminal detected:", name)

            # ===============================
            # GET MEDIA PATH
            # ===============================

            photo_url = ""

            if u.photo:
                photo_url = u.photo.url
                print("Media file:", photo_url)

            # ===============================
            # ADD DATA
            # ===============================

            data.append({

                "id": u.id,
                "name": name,
                "category": u.category,
                "date": u.date,
                "latitude": u.latitude,
                "longitude": u.longitude,
                "photo": photo_url

            })

        print("Returning", len(data), "records to Flutter")
        print("========== END USER VIEW DETECTIONS ==========\n")

        return JsonResponse({
            "status": "ok",
            "data": data
        })

    print("Invalid request method")

    return JsonResponse({"status": "error"})



def police_view_uploads(request):

    user_uploads = User_upload.objects.all().order_by("-id")
    public_uploads = Public_Upload.objects.all().order_by("-id")

    context = {
        "user_uploads": user_uploads,
        "public_uploads": public_uploads
    }

    return render(request, "police/police_view_uploads.html", context)





# PUBLIC DETECT PERSON (GUEST UPLOAD)

@csrf_exempt
def public_detect_person(request):

    print("========== PUBLIC DETECT API CALLED ==========")

    if request.method == "POST":

        latitude = request.POST.get("latitude")
        longitude = request.POST.get("longitude")
        description = request.POST.get("description", "")

        uploaded_file = request.FILES.get("file")

        if not uploaded_file:
            return JsonResponse({
                "status": "error",
                "message": "No file uploaded"
            })

        # ===============================
        # SAVE FILE
        # ===============================

        upload_folder = os.path.join(settings.MEDIA_ROOT, "public_uploads")
        os.makedirs(upload_folder, exist_ok=True)

        filename = str(uuid.uuid4()) + "_" + uploaded_file.name
        file_path = os.path.join(upload_folder, filename)

        with open(file_path, "wb+") as destination:
            for chunk in uploaded_file.chunks():
                destination.write(chunk)

        print("File saved:", file_path)

        # ===============================
        # RUN DETECTION
        # ===============================

        ext = filename.split(".")[-1].lower()

        if ext in ["jpg", "jpeg", "png"]:
            results = file_detector.detect_from_image(file_path)
        else:
            results = file_detector.detect_from_video(file_path)

        print("Detection results:", results)

        if not results:
            return JsonResponse({
                "status": "ok",
                "result": []
            })

        response_data = []
        seen = set()

        for r in results:

            category = r["category"]
            pid = r["id"]
            name = r["name"]

            key = f"{name}-{category}"

            if key in seen:
                continue

            seen.add(key)

            missing_obj = None
            criminal_obj = None

            if category == "Missing Person":

                try:
                    missing_obj = Missing_person.objects.get(id=pid)
                except Missing_person.DoesNotExist:
                    continue

            elif category == "Criminal":

                try:
                    criminal_obj = criminal.objects.get(id=pid)
                except criminal.DoesNotExist:
                    continue

            # SAVE TO PUBLIC_UPLOAD

            Public_Upload.objects.create(

                Missing_person=missing_obj,
                criminal=criminal_obj,
                description=description,
                date=datetime.now().strftime("%H:%M:%S"),
                latitude=latitude,
                longitude=longitude,
                photo="public_uploads/" + filename

            )

            response_data.append({
                "name": name,
                "category": category
            })

        return JsonResponse({
            "status": "ok",
            "result": response_data
        })

    return JsonResponse({
        "status": "invalid request"
    })


def police_view_user_case(request, id):
    print("\n===== VIEW / UPDATE USER CASE =====")
    print("=> Case ID:", id)

    case = get_object_or_404(Case_file, id=id)

    # 🔥 HANDLE AJAX UPDATE
    if request.method == "POST":
        progress = request.POST.get("progress")
        report   = request.POST.get("report")

        print("=> Incoming Progress:", progress)
        print("=> Incoming Report:", report)

        if not progress:
            return JsonResponse({"error": "Progress required"}, status=400)

        case.progress = progress

        if progress.lower() == "found":
            if report and report.strip():
                case.report = report
                case.status = "closed"
                print("[OK] FOUND -> report saved + closed")
            else:
                print("[ERROR] Report missing")
                return JsonResponse({"error": "Report required when FOUND"}, status=400)

        case.save()

        return JsonResponse({
            "success": True,
            "progress": case.progress,
            "status": case.status,
            "report": case.report
        })

    return render(request, 'police/police_view_user_case.html', {"case": case})




from django.http import JsonResponse
from django.utils import timezone
from .models import Case_file, Complaint, UserProfile

def get_alerts(request):

    uid = request.POST.get("uid")
    print(uid)

    try:
        profile = UserProfile.objects.get(USER_id=uid)
    except:
        return JsonResponse({"status": "error"})

    last_check = profile.last_notification_check

    alerts = []

    # 🔹 CASE UPDATES
    cases = Case_file.objects.filter(USER=profile)

    if last_check:
        cases = cases.filter(date__gt=last_check)

    for c in cases:
        alerts.append({
            "type": "case",
            "title": "Case Update",
            "message": f"Status: {c.status}",
            "date": str(c.date)
        })

    # 🔹 COMPLAINT UPDATES
    complaints = Complaint.objects.filter(USER_id=uid)

    if last_check:
        complaints = complaints.filter(date__gt=last_check)

    for c in complaints:
        alerts.append({
            "type": "complaint",
            "title": "Complaint Reply",
            "message": f"{c.reply}",
            "date": str(c.date)
        })

    # SORT LATEST FIRST
    alerts = sorted(alerts, key=lambda x: x["date"], reverse=True)

    # ✅ VIEW ONCE
    profile.last_notification_check = timezone.now()
    profile.save()

    return JsonResponse({
        "status": "ok",
        "data": alerts
    })