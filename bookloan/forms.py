from django.forms import ModelForm
from django import forms
from django.utils import timezone
from .models import BookLoan, Book, Member, Librarian

class BookLoanForm(ModelForm):
    class Meta:
        model = BookLoan
        fields = '__all__'
        widgets = {
            'book': forms.Select(attrs={'class': 'form-control'}),
            'member': forms.Select(attrs={'class': 'form-control'}),
            'librarian': forms.Select(attrs={'class': 'form-control'}),
            'loan_date': forms.DateInput(attrs={'type': 'date', 'class': 'form-control'}),
            'due_date': forms.DateInput(attrs={'type': 'date', 'class': 'form-control'}),
            'return_date': forms.DateInput(attrs={'type': 'date', 'class': 'form-control'}),
        }

#script for make loan start day today
# , 'min':timezone.now().date().strftime('%Y-%m-%d')

   
