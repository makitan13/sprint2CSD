import requests
from django.shortcuts import render, redirect, get_object_or_404
from django.conf import settings
from .models import Book
from .forms import BookForm
# Create your views here.

def display_book(request):
   response = requests.get(f'{settings.API_BASE_URL}/books/')
   book_list = response.json()
   context = {
  
       'book_list': book_list
   }
   return render (request, 'book_list.html', context)
   
   
def add_book(request):  
    if request.method == 'POST':
        form = BookForm(request.POST, request.FILES)
        print(request.FILES)
        if form.is_valid():
            files = {'cover_image': request.FILES.get('cover_image')}
            requests.post(f'{settings.API_BASE_URL}/books/', form.data, files=files)
            return redirect('book_list')
    else:
        form = BookForm()
        print("GAGAL")
    return render(request, 'add_book.html', {'form':form})


def edit_book(request, book_id):
    response = requests.get(f'{settings.API_BASE_URL}/books/{book_id}')
    book_data = response.json()
    form = BookForm(request.POST, request.FILES)
    if request.method == 'POST':
        if form.is_valid():
            
            # Prepare the files for the API
            files = {'cover_image': request.FILES.get('cover_image')}
            requests.put(f'{settings.API_BASE_URL}/books/{book_id}/', form.data, files = files)
            return redirect('book_list')
    else:
        form = BookForm(initial=book_data)
    return render(request, 'edit_book.html', {'form':form})

def delete_book(request, book_id):
    response = requests.get(f'{settings.API_BASE_URL}/books/{book_id}')
    book = response.json()
    if request.method == 'POST':
        requests.delete(f'{settings.API_BASE_URL}/books/{book_id}')
        return redirect('book_list')
    return render(request, 'delete_book.html', {'book':book})

def detail_book(request, book_id):
    response = requests.get(f'{settings.API_BASE_URL}/books/{book_id}')
    book_detail = response.json()
    context = {
       'book_detail': book_detail
    }
    return render (request, 'detail_book.html', context)
    

    