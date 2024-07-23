
from django.contrib import messages
from django.shortcuts import render, redirect
from django.conf import settings
from .forms import FormLogin, FormRegister
from .models import Librarian, LoginHistory
import secrets, requests


# Create your views here.
def librarian_list(request):
    response = requests.get(f'{settings.API_BASE_URL}/librarians/')
    librarian_list = response.json()
    context = {
        'librarian_list':librarian_list
        }
    return render(request, 'librarian_list.html',context)
    
def librarian_register(request):
    if request.method == 'POST':
        form = FormRegister(request.POST)
        if form.is_valid():
           
            requests.post(f'{settings.API_BASE_URL}/librarians/', form.data)
            return redirect('librarian_login')
    else:
        form = FormRegister()
        print("GAGAL")
    return render(request, 'librarian_register.html', {'form':form})



def librarian_login(request):
    form = FormLogin()
    if request.method == 'POST':
        form = FormLogin(request.POST)
        if form.is_valid():
            username = form.cleaned_data['username']
            password = form.cleaned_data['password']

            try:
                auth_response = requests.post(f'{settings.API_BASE_URL}/login/librarian', data={'username': username, 'password': password})
                auth_response.raise_for_status()  # Raise error if the status code is not 200
                
                if auth_response.status_code == 200:
                    # Store the username in the session
                    request.session['username'] = username
                    print("LOGIN SUCCESS")
                    return redirect('librarian_profile')
            except requests.exceptions.RequestException as e:
                messages.error(request, 'Unable to authenticate. Please try again later.')
                print(f'Error during authentication: {e}')
        else:
            form = FormLogin()
            messages.error(request, 'Invalid form input.')

    return render(request, 'librarian_login.html', {'form':form})


def librarian_profile(request):
    if 'username' in request.session:
        username = request.session['username']
      
    else: 
        return redirect('librarian_login')
    
    response =  requests.get(f'{settings.API_BASE_URL}/librarians/')
    librarians_data =  response.json()
    librarian_data = next((librarian for librarian in librarians_data if librarian['username'] == username), None)
    context = {
        'librarian' : librarian_data}
    return render(request, 'librarian_profile.html', context)



def librarian_logout(request):
    # Clear token and username from session
    if 'username' in request.session:
        del request.session['username']
        requests.post(f'{settings.API_BASE_URL}/logout/librarian')
        print('deleting token')
    return redirect('librarian_login') 


def librarian_edit(request, librarian_id):
    response = requests.get(f'{settings.API_BASE_URL}/librarians/{librarian_id}')
    librarian = response.json()
    if request.method == "POST":
        form = FormRegister(request.POST)
        if form.is_valid():
            requests.put(f'{settings.API_BASE_URL}/librarians/{librarian_id}/', form.data)
            token = secrets.token_hex(20)
            request.session['token'] = token
            request.session['username'] = librarian.get('username')
            return redirect('librarian_profile')
    else:
        form = FormRegister(initial=librarian)

    context = {
        'form':form,
        'librarian':librarian
    }
    return render(request, 'edit_librarian.html', context)



def librarian_delete(request, librarian_id):
    response = requests.get(f'{settings.API_BASE_URL}/librarians/{librarian_id}')
    librarian = response.json()
    if request.method == 'POST':
        requests.delete(f'{settings.API_BASE_URL}/librarians/{librarian_id}')
        del request.session['token']
        del request.session['username']
        print('deleting token')
        return redirect('librarian_login')
    
    context = {
        'librarian':librarian

    }
    return render(request, 'delete_librarian.html', context)

def librarian_login_history(request):
    page_number = request.GET.get('page', 1)
    if not isinstance(page_number, str) or not page_number.isdigit():  # Check if page_number is not a digit
        page_number = '1'  # Default to page 1 if not a valid number
    
    username = request.session['username']
    response = requests.get(f'{settings.API_BASE_URL}/login-history/{username}', params={'page': page_number}).json()
    
     ##OVERDUE PAGING
    librarian_login_history = response.get('results', [])
    next_page = response.get('next')
    previous_page = response.get('previous')
    total_data = response.get('count')
    
    context = {
        'librarian_login_history':librarian_login_history,
        'next_page':next_page,
        'previous_page':previous_page,
        'total_data':total_data,
        'current_page':page_number
        }
    return render(request, 'login_history.html', context)
