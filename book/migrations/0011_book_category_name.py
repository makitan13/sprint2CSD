# Generated by Django 5.0.6 on 2024-07-08 08:41

import django.db.models.deletion
from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('book', '0010_category'),
    ]

    operations = [
        migrations.AddField(
            model_name='book',
            name='category_name',
            field=models.ForeignKey(default=1, on_delete=django.db.models.deletion.CASCADE, related_name='books', to='book.category'),
            preserve_default=False,
        ),
    ]
