# Generated by Django 5.0.6 on 2024-07-09 06:33

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('book', '0018_alter_book_cover_image'),
    ]

    operations = [
        migrations.AlterField(
            model_name='book',
            name='cover_image',
            field=models.ImageField(upload_to='book_cover/'),
        ),
    ]
