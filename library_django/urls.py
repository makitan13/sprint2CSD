from unicodedata import name
from django.urls import path
from . import views

urlpatterns = [
    path('', views.lobby, name = 'lobby'),
    path('home', views.home, name = 'home'),
    path('homes', views.home_member, name = 'home_member'),
]