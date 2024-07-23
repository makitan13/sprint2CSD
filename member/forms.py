from django.forms import ModelForm
from django import forms
from .models import Member

class FormLogin(forms.Form):
    username = forms.CharField(max_length=12)
    password = forms.CharField(widget=forms.PasswordInput)


class MemberForm(ModelForm):
    class Meta:
        model = Member
        fields = '__all__'
        widgets = {
            'first_name': forms.TextInput(attrs={'class':"form-control", 'placeholder':'First Name'}),
            'last_name': forms.TextInput(attrs={'class':"form-control", 'placeholder':'Last Name'}),
            'email': forms.TextInput(attrs={'class':"form-control", 'placeholder':'Email'}),
            'phone_number': forms.TextInput(attrs={'class': 'form-control', 'placeholder':'Phone Number'}),
            'username': forms.TextInput(attrs={'class':"form-control", 'placeholder':'Username'}),
            'password': forms.TextInput(attrs={'type': 'password', 'class':"form-control", 'placeholder':'Password'}),
        }
