from django.shortcuts import render, redirect, get_object_or_404
from .models import Member
from .forms import MemberForm, FormLogin
from django.conf import settings
from django.contrib import messages
import requests
# Create your views here.

def member_list(request):
    response = requests.get(f'{settings.API_BASE_URL}/members/')
    member_list = response.json()
    context = {
        'member_list':member_list
        }
    return render(request, 'member_list.html',context)

def add_member(request):  
    if request.method == 'POST':
        form = MemberForm(request.POST)
        if form.is_valid():
           
            requests.post(f'{settings.API_BASE_URL}/members/', form.data)
            return redirect('member_list')
    else:
        form = MemberForm()
        print("GAGAL")
    return render(request, 'add_member.html', {'form':form})



def edit_member(request, member_id):
    response = requests.get(f'{settings.API_BASE_URL}/members/{member_id}')
    member_data = response.json()
    form = MemberForm(request.POST)
    print("Form: ",form)
    print("Data: ", member_data)
    if request.method == 'POST':
        if form.is_valid():
            # Prepare the files for the API
            requests.put(f'{settings.API_BASE_URL}/members/{member_id}/', form.data)
            return redirect('member_list')
    else:
        form = MemberForm(initial=member_data)
        print("GAGAL")
    return render(request, 'edit_member.html', {'form':form})

def delete_member(request, member_id):
    response = requests.get(f'{settings.API_BASE_URL}/members/{member_id}')
    member = response.json()
    if request.method == 'POST':
        requests.delete(f'{settings.API_BASE_URL}/members/{member_id}')
        return redirect('member_list')
    return render(request, 'delete_member.html', {'member':member})

def member_register(request):
    form = MemberForm()
    if request.method == 'POST':
        form = MemberForm(request.POST)
        if form.is_valid():
           
            requests.post(f'{settings.API_BASE_URL}/members/', form.data)
            return redirect('member_login')
        else:
            form = MemberForm()
            print("GAGAL")
    return render(request, 'member_register.html', {'form':form})

def member_login(request):
    form = FormLogin()
    if request.method == 'POST':
        form = FormLogin(request.POST)
        if form.is_valid():
            username = form.cleaned_data['username']
            password = form.cleaned_data['password']

            try:
                auth_response = requests.post(f'{settings.API_BASE_URL}/login/member', data={'username': username, 'password': password})
                auth_response.raise_for_status()  # Raise error if the status code is not 200
                
                if auth_response.status_code == 200:
                    # Store the username in the session
                    request.session['username'] = username
                    print("LOGIN SUCCESS")
                    return redirect('home_member')
            except requests.exceptions.RequestException as e:
                messages.error(request, 'Unable to authenticate. Please try again later.')
                print(f'Error during authentication: {e}')
        else:
            form = FormLogin()
            messages.error(request, 'Invalid form input.')

    return render(request, 'member_login.html', {'form':form})


def member_profile(request):
    if 'username' in request.session:
        username = request.session['username']
      
    else: 
        return redirect('member_login')
    
    response =  requests.get(f'{settings.API_BASE_URL}/members/')
    members_data =  response.json()
    member_data = next((member for member in members_data if member['username'] == username), None)
    context = {
        'librarian' : member_data}
    return render(request, 'member_profile.html', context)


def member_logout(request):
    # Clear token and username from session
    if 'username' in request.session:
        del request.session['username']
        requests.post(f'{settings.API_BASE_URL}/logout/member')
        print('deleting token')
    return redirect('member_login') 
