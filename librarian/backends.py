from django.contrib.auth.backends import BaseBackend
from .models import Librarian

class LibrarianBackend(BaseBackend):
    def authenticate(self, request, username=None, password=None, **kwargs):
        try:
            librarian = Librarian.objects.get(username=username)
            if librarian.check_password(password):
                return librarian
        except Librarian.DoesNotExist:
            return None

    def get_user(self, user_id):
        try:
            return Librarian.objects.get(pk=user_id)
        except Librarian.DoesNotExist:
            return None