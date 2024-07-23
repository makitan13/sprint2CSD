from rest_framework import serializers
from book.models import Book
from book.models import Category
from member.models import Member
from librarian.models import Librarian, LoginHistory
from bookloan.models import BookLoan

class CategorySerializer(serializers.ModelSerializer):
    class Meta:
        model = Category
        fields = ['category_name']
    
class BookSerializer(serializers.ModelSerializer):
    category_name = serializers.StringRelatedField(source = 'category.category_name')
    class Meta:
        model = Book
        fields = '__all__'
        
class MemberSerializer(serializers.ModelSerializer):
    class Meta:
        model = Member
        fields = '__all__'

class LibrarianSerializer(serializers.ModelSerializer):
    class Meta:
        model = Librarian
        fields = '__all__'
        
class BookLoanSerializer(serializers.ModelSerializer):
    book_title = serializers.StringRelatedField(source = 'book.title')
    member_name = serializers.StringRelatedField(source = 'member.full_name')
    librarian_name = serializers.StringRelatedField(source = 'librarian.full_name')
    class Meta:
        model = BookLoan
        fields = '__all__'
        
        
####LOGIN SYSTEMM####
class LibrarianLoginSerializer(serializers.ModelSerializer):
    class Meta:
        model = Librarian
        fields = ['username', 'password']
        extra_kwargs = {'password': {'write_only': True}}
        

class LibrarianLoginHistorySerializer(serializers.ModelSerializer):
    librarian_name = serializers.StringRelatedField(source = 'librarian.full_name')
    class Meta:
        model = LoginHistory
        fields = '__all__'

class MemberLoginSerializer(serializers.ModelSerializer):
    class Meta:
        model = Member
        fields = ['username', 'password']
        extra_kwargs = {'password': {'write_only': True}}
        
#### CHANGE PASSWORD SYSTEM####
class ChangePasswordSerializer(serializers.Serializer):

    old_password = serializers.CharField(required = True)
    new_password = serializers.CharField(required = True)
        