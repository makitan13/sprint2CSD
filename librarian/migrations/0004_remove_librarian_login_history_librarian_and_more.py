# Generated by Django 5.0.6 on 2024-06-26 07:01

from django.db import migrations


class Migration(migrations.Migration):

    dependencies = [
        ('librarian', '0003_librarian_date_login_bookload_transaction_and_more'),
    ]

    operations = [
        migrations.RemoveField(
            model_name='librarian_login_history',
            name='Librarian',
        ),
        migrations.DeleteModel(
            name='BookLoad_Transaction',
        ),
        migrations.DeleteModel(
            name='Librarian_Login_History',
        ),
    ]
