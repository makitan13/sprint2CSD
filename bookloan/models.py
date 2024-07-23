from django.db import models
from book.models import Book
from member.models import Member
from librarian.models import Librarian
# Create your models here.

class BookLoan(models.Model):
    book = models.ForeignKey(to=Book , on_delete=models.SET_NULL, null=True)
    member = models.ForeignKey(to=Member, on_delete=models.SET_NULL, null=True)
    librarian = models.ForeignKey(to=Librarian, on_delete=models.SET_NULL, null=True)
    loan_date = models.DateField()
    due_date = models.DateField()
    return_date = models.DateField(null=True, blank=True)

    def __str__(self):
        return f'{self.book} loaned to {self.member}'
        
    class Meta:
        db_table = 'book_loans'

       
   