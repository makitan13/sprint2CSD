from django.urls import path, include
from rest_framework.routers import DefaultRouter
from .views import LoginHistoryLibrarianViewSet, BookListFilterYear, BookListFilterCategory, LibrarianLogin, MemberLogoutView, MemberLogin, MemberChangePasswordView, LibrarianChangePasswordView, LibrarianLogoutView, BookViewSet, CategoryViewSet, MemberViewSet, LibrarianViewSet, BookLoanViewSet, BookSearchView, MemberOverdueBookLoan, OverdueBookLoanViewSet, OutstandingBookLoanViewSet

router = DefaultRouter()
router.register(r'books', BookViewSet)
router.register(r'category', CategoryViewSet)
router.register(r'members', MemberViewSet)
router.register(r'librarians', LibrarianViewSet)
router.register(r'bookloans', BookLoanViewSet)
router.register(r'outstanding-book-loan', OutstandingBookLoanViewSet, basename='outstanding-book-loan')
router.register(r'overdue-book-loan', OverdueBookLoanViewSet, basename='overdue-book-loan')

urlpatterns = [
    path('', include(router.urls)),
    path('books/filter/year/<str:query>', BookListFilterYear.as_view(), name='book-list'),
    path('books/filter/category/<str:query>', BookListFilterCategory.as_view(), name='book-list'),
    path('books/search/<str:query>', BookSearchView.as_view(), name='book-search'),
    path('member/bookloans_overdue/<str:query>', MemberOverdueBookLoan.as_view(), name = 'member-overdue' ),
    path('login/librarian', LibrarianLogin.as_view(), name = 'librarian_login' ),
    path('login/member', MemberLogin.as_view(), name = 'member_login' ),
    path('logout/librarian', LibrarianLogoutView.as_view(), name = 'librarian_logout' ),
    path('logout/member', MemberLogoutView.as_view(), name = 'member_logout'),
    path('change_password/librarian/<str:query>', LibrarianChangePasswordView.as_view(), name = 'librarian_change_password' ),
    path('change_password/member/<str:query>', MemberChangePasswordView.as_view(), name = 'member_change_password' ),
    path('login-history/<str:query>', LoginHistoryLibrarianViewSet.as_view(), name = 'login_history_librarian' ),
    
]