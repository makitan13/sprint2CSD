from django import forms
from django.contrib.auth.forms import AuthenticationForm, UserCreationForm
from .models import Librarian, LoginHistory

class FormLogin(forms.Form):
    username = forms.CharField(max_length=12)
    password = forms.CharField(widget=forms.PasswordInput)


class FormRegister(forms.ModelForm):
    class Meta:
        model = Librarian
        fields = "__all__"
        widgets = {
            'username': forms.TextInput(attrs={'placeholder': 'Username', 'class':"form-control"}),
            'first_name': forms.TextInput(attrs={'placeholder': 'First Name', 'class':"form-control"}),
            'last_name': forms.TextInput(attrs={'placeholder': 'Last Name', 'class':"form-control"}),
            'email': forms.EmailInput(attrs={'placeholder': 'Email', 'class':"form-control"}),
            'password': forms.TextInput(attrs={'id': 'password1', 'placeholder': 'Password', 'type': 'password', 'class':"form-control"}),
        }


