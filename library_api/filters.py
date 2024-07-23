from django_filters import rest_framework as filters
from book.models import Book

class BookFilter(filters.FilterSet):
    publish_year = filters.NumberFilter(field_name='published_date', lookup_expr='year')
    category = filters.NumberFilter(field_name='category')

    class Meta:
        model = Book
        fields = ['publish_year', 'category']