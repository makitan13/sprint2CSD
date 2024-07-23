from django.db import models
from django.contrib.auth.models import AbstractBaseUser
from django.utils import timezone

# Create your models here.
class Librarian(models.Model):
    first_name = models.TextField(max_length=15)
    last_name = models.TextField(max_length=15)
    username = models.CharField(max_length=12)
    email = models.EmailField()
    password = models.CharField(max_length=128)
    
    def full_name(self):
        return f"{self.first_name} {self.last_name}"
    
    def __str__(self):
        return f"{self.first_name} {self.last_name}"
    
    class Meta:
        db_table = 'librarian'
    

    USERNAME_FIELD = 'username'
    REQUIRED_FIELDS = ['email']
    
class LoginHistory(models.Model):
    librarian = models.ForeignKey(Librarian, on_delete=models.CASCADE)
    date_login = models.DateTimeField(auto_now_add=True)
    def __str__(self):
        return f'{self.librarian.username} logged in at {self.date_login}'
    
    class Meta:
        db_table = 'Login_History'