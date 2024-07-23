from django.core.paginator import Paginator, PageNotAnInteger
from django.shortcuts import render, redirect
from django.utils import timezone
from django.db.models import Q
from django.conf import settings
from turtle import title
from book.models import Book
from member.models import Member
from bookloan.models import BookLoan
from datetime import timedelta
import requests
# Create your views here.

def lobby(request):
    context = {
        'title' : title
    }
    return render(request, 'index.html', context)

def home(request):
    page_number = request.GET.get('page', 1)
    if not isinstance(page_number, str) or not page_number.isdigit():  # Check if page_number is not a digit
        page_number = '1'  # Default to page 1 if not a valid number
    
    book_data =  requests.get(f'{settings.API_BASE_URL}/books/').json()
    member_data = requests.get(f'{settings.API_BASE_URL}/members/').json()
    bookloan_data = requests.get(f'{settings.API_BASE_URL}/bookloans/').json()
    overdue_loans =  requests.get(f'{settings.API_BASE_URL}/overdue-book-loan/', params={'page': page_number}).json()
    outstand_loans = requests.get(f'{settings.API_BASE_URL}/outstanding-book-loan/', params={'page': page_number}).json()
    
    count_book = len(book_data)
    count_member = len(member_data)
    count_bookloan = len(bookloan_data)
    count_overdue =  overdue_loans.get('count')
    count_outstand = outstand_loans.get('count')
    
    
    
    ##OUTSTANDING PAGING
    outstand_data = outstand_loans.get('results', [])
    outstand_next_page = outstand_loans.get('next')
    outstand_previous_page = outstand_loans.get('previous')
    
    ##OVERDUE PAGING
    overdue_data = overdue_loans.get('results', [])
    overdue_next_page = overdue_loans.get('next')
    overdue_previous_page = overdue_loans.get('previous')
    
    
    
    if 'username' in request.session:
        username = request.session['username']
        librarian_user = username
        
    else: 
        return redirect('librarian_login')
    
    context = {
        'librarian_user': librarian_user,
        'overdue_data': overdue_data,
        'outstand_data': outstand_data,
        'count_book': count_book,
        'count_member': count_member,
        'count_bookloan': count_bookloan,
        'count_overdue':count_overdue,
         
        'outstand_next_page': outstand_next_page,
        'outstand_previous_page': outstand_previous_page,
        'current_page': int(page_number),
        
        'overdue_next_page': overdue_next_page,
        'overdue_previous_page': overdue_previous_page,
        'current_page': int(page_number),
        }
    return render(request, 'home.html',context)


def home_member(request):
    page_number = request.GET.get('page', 1)
    if not isinstance(page_number, str) or not page_number.isdigit():  # Check if page_number is not a digit
        page_number = '1'  # Default to page 1 if not a valid number
    
    book_data =  requests.get(f'{settings.API_BASE_URL}/books/').json()
    member_data = requests.get(f'{settings.API_BASE_URL}/members/').json()
    bookloan_data = requests.get(f'{settings.API_BASE_URL}/bookloans/').json()
    overdue_loans =  requests.get(f'{settings.API_BASE_URL}/overdue-book-loan/', params={'page': page_number}).json()
    outstand_loans = requests.get(f'{settings.API_BASE_URL}/outstanding-book-loan/', params={'page': page_number}).json()
    
    count_book = len(book_data)
    count_member = len(member_data)
    count_bookloan = len(bookloan_data)
    count_overdue =  overdue_loans.get('count')
    count_outstand = outstand_loans.get('count')
    
    
    
    ##OUTSTANDING PAGING
    outstand_data = outstand_loans.get('results', [])
    outstand_next_page = outstand_loans.get('next')
    outstand_previous_page = outstand_loans.get('previous')
    
    ##OVERDUE PAGING
    overdue_data = overdue_loans.get('results', [])
    overdue_next_page = overdue_loans.get('next')
    overdue_previous_page = overdue_loans.get('previous')
    
    
    
    if 'username' in request.session:
        username = request.session['username']
        librarian_user = username
        
    else: 
        return redirect('librarian_login')
    
    context = {
        'librarian_user': librarian_user,
        'overdue_data': overdue_data,
        'outstand_data': outstand_data,
        'count_book': count_book,
        'count_member': count_member,
        'count_bookloan': count_bookloan,
        'count_overdue':count_overdue,
         
        'outstand_next_page': outstand_next_page,
        'outstand_previous_page': outstand_previous_page,
        'current_page': int(page_number),
        
        'overdue_next_page': overdue_next_page,
        'overdue_previous_page': overdue_previous_page,
        'current_page': int(page_number),
        }
    return render(request, 'home_member.html',context)


