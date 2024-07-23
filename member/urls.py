from unicodedata import name
from django.urls import path
from . import views

urlpatterns = [
    path('member/add', views.add_member, name = 'add_member'),
    path('member/list', views.member_list, name = 'member_list'),
    path('member/register', views.member_register, name = 'member_register'),
    path('member/login',views.member_login, name = 'member_login'),
    path('member/register', views.member_register, name = 'member_register'), 
    path('member/edit/<int:member_id>', views.edit_member, name = 'edit_member'),
    path('member/delete/<int:member_id>', views.delete_member, name = 'delete_member')

]