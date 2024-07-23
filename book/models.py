from django.db import models

# Create your models here.

class Category(models.Model):
    category_name = models.CharField(max_length=50)
    def __str__(self):
        return self.category_name
    

class Book(models.Model):
    title = models.CharField(max_length=50)
    author = models.CharField(max_length=25)
    isbn = models.CharField(max_length=15)
    published_date = models.DateField()
    category = models.ForeignKey(to=Category, on_delete=models.SET_NULL, null = True)
    cover_image = models.ImageField(null= True, blank=True, upload_to="image/")
    description = models.TextField(max_length= 250, null = True, blank = True)
    def __str__(self):
        return self.title

    class Meta:
        db_table = 'book'
