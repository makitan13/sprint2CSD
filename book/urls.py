from unicodedata import name
from django.urls import path, include
from django.conf import settings
from django.conf.urls.static import static
from .views import display_book, add_book, edit_book, delete_book, detail_book

urlpatterns = [
    path('book/list', display_book, name = 'book_list'), 
    path('book/add', add_book, name = 'add_book'),
    path('book/edit/<int:book_id>/', edit_book, name = 'edit_book'),
    path('book/delete/<int:book_id>', delete_book, name = 'delete_book'),
    path('book/detail/<int:book_id>', detail_book, name = 'detail_book'),

] + static(settings.MEDIA_URL, document_root = settings.MEDIA_ROOT)