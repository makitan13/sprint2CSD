from django.contrib import admin
from book.models import Book
from member.models import Member
from librarian.models import Librarian, LoginHistory
from bookloan.models import BookLoan
# Register your models here.

admin.site.register(Librarian)
admin.site.register(LoginHistory)
admin.site.register(Book)
admin.site.register(Member)
admin.site.register(BookLoan)

