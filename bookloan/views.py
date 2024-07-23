from django.shortcuts import render, redirect, get_object_or_404
from .models import BookLoan
from .forms import BookLoanForm
from django.conf import settings
import requests

# Create your views here.

def display_bookloan(request):
    response = requests.get(f'{settings.API_BASE_URL}/bookloans/')
    bookloan_list = response.json()
    context = {
        'bookloan_list':bookloan_list
        }
    return render(request, 'bookloan_list.html',context)



###OUTSTAND SCRIPTING###
def display_outstand(request):
    page_number = request.GET.get('page', 1)
    if not isinstance(page_number, str) or not page_number.isdigit():  # Check if page_number is not a digit
        page_number = '1'  # Default to page 1 if not a valid number
    
    response =  requests.get(f'{settings.API_BASE_URL}/outstanding-book-loan/', params={'page': page_number}).json()
    
     ##OVERDUE PAGING
    bookloan_outstand = response.get('results', [])
    outstand_next_page = response.get('next')
    outstand_previous_page = response.get('previous')
    total_outstand_data = response.get('count')
    
    context = {
        'outstand_next_page':outstand_next_page,
        'outstand_previous_page':outstand_previous_page,
        'bookloan_outstand':bookloan_outstand,
        'current_page': int(page_number),
        'total_outstand_data':total_outstand_data
        }
    return render(request, 'bookloan_outstand.html',context)

###OVERDUE SCRIPTING###
def display_overdue(request):
    page_number = request.GET.get('page', 1)
    if not isinstance(page_number, str) or not page_number.isdigit():  # Check if page_number is not a digit
        page_number = '1'  # Default to page 1 if not a valid number
    
    response =  requests.get(f'{settings.API_BASE_URL}/overdue-book-loan/', params={'page': page_number}).json()
    
     ##OVERDUE PAGING
    bookloan_overdue = response.get('results', [])
    overdue_next_page = response.get('next')
    overdue_previous_page = response.get('previous')
    total_overdue_data = response.get('count')
    
    context = {
        'overdue_previous_page':overdue_previous_page,
        'overdue_next_page':overdue_next_page,
        'bookloan_overdue':bookloan_overdue,
        'current_page': int(page_number),
        'total_overdue_data':total_overdue_data
        }
    return render(request, 'bookloan_overdue.html',context)


def add_bookloan(request):  
    if request.method == 'POST':
        form = BookLoanForm(request.POST, request.FILES)
        if form.is_valid():
           
            requests.post(f'{settings.API_BASE_URL}/bookloans/', form.data)
            return redirect('bookloan_list')
    else:
        form = BookLoanForm()
        print("GAGAL")
    return render(request, 'add_bookloan.html', {'form':form})

def edit_bookloan(request, bookloan_id):
    response = requests.get(f'{settings.API_BASE_URL}/bookloans/{bookloan_id}')
    bookloan_data = response.json()
    form = BookLoanForm(request.POST)
    if request.method == 'POST':
        if form.is_valid():
            # Prepare the files for the API
            requests.put(f'{settings.API_BASE_URL}/bookloans/{bookloan_id}/', form.data)
            return redirect('bookloan_list')
    else:
        form = BookLoanForm(initial=bookloan_data)
        print("GAGAL")
    return render(request, 'edit_bookloan.html', {'form':form})
    

def delete_bookloan(request, bookloan_id):
    response = requests.get(f'{settings.API_BASE_URL}/bookloans/{bookloan_id}')
    bookloan = response.json()
    if request.method == 'POST':
        requests.delete(f'{settings.API_BASE_URL}/bookloans/{bookloan_id}')
        return redirect('bookloan_list')
    return render(request, 'delete_bookloan.html', {'bookloan':bookloan})