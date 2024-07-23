from django.forms import ModelForm
from django import forms
from .models import Book

class BookForm(ModelForm):
    class Meta:
        model = Book
        fields = '__all__'
        widgets = {
            'title': forms.TextInput(attrs={'class':"form-control"}),
            'author': forms.TextInput(attrs={'class':"form-control"}),
            'isbn': forms.TextInput(attrs={'class':"form-control"}),
            'published_date': forms.DateInput(attrs={'type': 'date', 'class': 'form-control'}),
            'category': forms.Select(attrs={'class': 'form-control'}),
            'description': forms.Textarea(attrs={'class':'form-control'}),
        }


   
