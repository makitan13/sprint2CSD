from unicodedata import name
from django.urls import path
from . import views

urlpatterns = [
    path('librarian/list', views.librarian_list, name = 'librarian_list'),
    path('librarian/login', views.librarian_login, name = 'librarian_login'),
    path('librarian/profile', views.librarian_profile, name = 'librarian_profile'),
    path('librarian/register', views.librarian_register, name = 'librarian_register'),
    path('librarian/login_history', views.librarian_login_history, name = 'librarian_login_history'),
    path('librarian/logout', views.librarian_logout, name = 'librarian_logout'),
    path('librarian/edit/<int:librarian_id>', views.librarian_edit, name = 'librarian_edit'),
    path('librarian/delete/<int:librarian_id>', views.librarian_delete, name = 'librarian_delete'),
    
]