from rest_framework import viewsets, status, generics
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework_simplejwt.tokens import RefreshToken
from rest_framework.permissions import IsAuthenticated
from rest_framework.decorators import api_view
from rest_framework.pagination import PageNumberPagination
from book.models import Book, Category
from member.models import Member
from librarian.models import Librarian, LoginHistory
from bookloan.models import BookLoan
from .serializers import LibrarianLoginHistorySerializer, BookSerializer, ChangePasswordSerializer, MemberSerializer, MemberLoginSerializer, BookLoanSerializer, LibrarianSerializer, CategorySerializer, LibrarianLoginSerializer
from .filters import BookFilter
from django_filters.rest_framework import DjangoFilterBackend
from django.db.models import Q
from django.utils import timezone
from django.contrib.auth.hashers import check_password, make_password

from datetime import timedelta

###CATEGORYY###
class CategoryViewSet(viewsets.ModelViewSet):
    queryset = Category.objects.all()
    serializer_class = CategorySerializer

###BOOK###
class BookViewSet(viewsets.ModelViewSet):
    queryset = Book.objects.all()
    serializer_class = BookSerializer

class BookListFilterYear(generics.ListAPIView):
    queryset = Book.objects.all()
    def get(self, request, query, format=None):
        books = Book.objects.filter(published_date__icontains=query)
        serializer = BookSerializer(books, many=True)
        return Response(serializer.data, status=status.HTTP_200_OK)

class BookListFilterCategory(generics.ListAPIView):
    queryset = Book.objects.all()
    def get(self, request, query, format=None):
        books = Book.objects.filter(Q(category__id__icontains=query)|Q(category__category_name__icontains=query))
        serializer = BookSerializer(books, many=True)
        return Response(serializer.data, status=status.HTTP_200_OK)

class BookSearchView(APIView):
    def get(self, request, query, format=None):
        books = Book.objects.filter(Q(title__icontains=query)|Q(author__icontains=query))
        serializer = BookSerializer(books, many=True)
        return Response(serializer.data, status=status.HTTP_200_OK)

###MEMBER###
class MemberViewSet(viewsets.ModelViewSet):
    queryset = Member.objects.all()
    serializer_class = MemberSerializer

class MemberLogin(generics.GenericAPIView): 
    serializer_class = MemberLoginSerializer
    
    def post(self, request):
        username = request.data.get('username')
        password = request.data.get('password')
        print (username, password)
        if not username or not password:
            return Response({"error": "Please provide both username and password of Member"}, status=status.HTTP_400_BAD_REQUEST)

        try:
            member = Member.objects.get(username=username)
        except Member.DoesNotExist:
            return Response({"error": "Invalid username or password"}, status=status.HTTP_400_BAD_REQUEST)

        if password == member.password:
            refresh = RefreshToken.for_user(member)
            member_data = MemberSerializer(member).data
            return Response({
                "message": "Login Member successful",
                "refresh": str(refresh),
                "access": str(refresh.access_token),
                "member": member_data

            }, status=status.HTTP_200_OK)
        else:
            return Response({"error": "Invalid username or password"}, status=status.HTTP_400_BAD_REQUEST)
    
class MemberLogoutView(generics.GenericAPIView):
    permission_classes = [IsAuthenticated]

    def post(self, request):
        try:
            refresh_token = request.data["refresh_token"]
            token = RefreshToken(refresh_token)
            #token.blacklist()
            return Response({"message": "Member Logout berhasil"}, status=status.HTTP_200_OK)
        except Exception as e:
            return Response({"error": "Gagal logout"}, status=status.HTTP_400_BAD_REQUEST) 

class MemberChangePasswordView(APIView):
   
    serializer_class = ChangePasswordSerializer
    
    def post(self, request, query):
        old_password = request.data.get('old_password')
        new_password = request.data.get('new_password')
        member = Member.objects.get(username__icontains=query)
       
        if not old_password or not new_password:
            return Response({"error": "Both old and new passwords are required."}, status=status.HTTP_400_BAD_REQUEST)
        if not old_password ==  member.password:
            return Response({"error": "Old password is incorrect."}, status=status.HTTP_400_BAD_REQUEST)
        else:
            member.password = new_password
            member.save()
        return Response({"message": "Password successfully changed."}, status=status.HTTP_200_OK)

###LIBRARIAN###
class LibrarianViewSet(viewsets.ModelViewSet):
    queryset = Librarian.objects.all()
    serializer_class = LibrarianSerializer

class LibrarianLogin(generics.GenericAPIView): 
    serializer_class = LibrarianLoginSerializer
    
    def post(self, request):
        username = request.data.get('username')
        password = request.data.get('password')
        print (username, password)
        if not username or not password:
            return Response({"error": "Please provide both username and password"}, status=status.HTTP_400_BAD_REQUEST)

        try:
            librarian = Librarian.objects.get(username=username)
        except Librarian.DoesNotExist:
            return Response({"error": "Invalid username or password"}, status=status.HTTP_400_BAD_REQUEST)

        if password == librarian.password:
            refresh = RefreshToken.for_user(librarian)
            librarian_data = LibrarianSerializer(librarian).data
            request.session['username'] = username
            return Response({
                "message": "Login Librarian successful",
                "refresh": str(refresh),
                "access": str(refresh.access_token),
                "librarian": librarian_data,
            }, status=status.HTTP_200_OK)
        else:
            return Response({"error": "Invalid username or password"}, status=status.HTTP_400_BAD_REQUEST)

class LibrarianLogoutView(generics.GenericAPIView):
    permission_classes = [IsAuthenticated]

    def post(self, request):
        try:
            refresh_token = request.data["refresh_token"]
            token = RefreshToken(refresh_token)
            #request.user.auth_token.delete()
            #token.blacklist()
            if 'username' in request.session:
                del request.session['username']
            return Response({"message": "Librarian Logout berhasil"}, status=status.HTTP_200_OK)
        except Exception as e:
            return Response({"error": "Gagal logout"}, status=status.HTTP_400_BAD_REQUEST) 

class LibrarianChangePasswordView(APIView):
    #permission_classes = [IsAuthenticated]
    serializer_class = ChangePasswordSerializer
    def post(self, request, query):
        old_password = request.data.get('old_password')
        new_password = request.data.get('new_password')
        librarian = Librarian.objects.get(username__icontains=query)
       
        if not old_password or not new_password:
            return Response({"error": "Both old and new passwords are required."}, status=status.HTTP_400_BAD_REQUEST)
        if not old_password ==  librarian.password:
            return Response({"error": "Old password is incorrect."}, status=status.HTTP_400_BAD_REQUEST)
        else:
            librarian.password = new_password
            librarian.save()
        return Response({"message": "Password successfully changed."}, status=status.HTTP_200_OK)
    
####BOOK LOANN SYSTEMMM ####
class BookLoanViewSet(viewsets.ModelViewSet):
    queryset = BookLoan.objects.all()
    serializer_class = BookLoanSerializer
    
class BooksPagination(PageNumberPagination):
    page_size = 5
    page_size_query_param = 'page_size'
    max_page_size = 100
    
     
class MemberOverdueBookLoan(APIView):
    
    def get(self, request, query, format=None):
        today =  timezone.now().date()
        
        books = BookLoan.objects.filter(Q(Q(due_date__lt=today) &  Q(return_date__isnull = True)) & Q(member__full_name__icontains=query))
        serializer = BookLoanSerializer(books, many=True)
        return Response(serializer.data, status=status.HTTP_200_OK)
    
class OutstandingBookLoanViewSet(BookLoanViewSet):
    today =  timezone.now().date()
    h3day = today + timedelta(days=3)
    
    queryset =  BookLoan.objects.filter(due_date__range=(today, h3day))
    pagination_class = BooksPagination
    

class OverdueBookLoanViewSet(BookLoanViewSet):
    today =  timezone.now().date()
    queryset =  BookLoan.objects.filter(Q(due_date__lt=today) &  Q(return_date__isnull = True))
    pagination_class = BooksPagination


class LoginHistoryLibrarianViewSet(APIView, BooksPagination):
    def get(self, request, query, format=None):
        loginhistory = LoginHistory.objects.filter(librarian__username__icontains=query)
        
        results = self.paginate_queryset(loginhistory, request, view=self)
        serializer = LibrarianLoginHistorySerializer(results, many=True)
        return self.get_paginated_response(serializer.data)