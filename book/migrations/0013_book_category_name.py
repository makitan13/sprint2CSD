# Generated by Django 5.0.6 on 2024-07-08 09:01

import django.db.models.deletion
from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('book', '0012_remove_book_category_name'),
    ]

    operations = [
        migrations.AddField(
            model_name='book',
            name='category_name',
            field=models.ForeignKey(null=True, on_delete=django.db.models.deletion.SET_NULL, to='book.category'),
        ),
    ]
