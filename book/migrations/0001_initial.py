# Generated by Django 5.0.6 on 2024-06-26 10:09

from django.db import migrations, models


class Migration(migrations.Migration):

    initial = True

    dependencies = [
    ]

    operations = [
        migrations.CreateModel(
            name='Book',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('title', models.TextField(max_length=50)),
                ('author', models.TextField(max_length=25)),
                ('published_date', models.DateField()),
                ('isbn', models.CharField(max_length=15)),
                ('copies_available', models.IntegerField(default=0)),
            ],
            options={
                'db_table': 'book',
            },
        ),
    ]
