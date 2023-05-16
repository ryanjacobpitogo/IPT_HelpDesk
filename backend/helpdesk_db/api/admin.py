from django.contrib import admin
from .models import User, Category, Topic, Comment, Reply

# Register your models here.
admin.site.register(User)
admin.site.register(Category)
admin.site.register(Topic)
admin.site.register(Comment)
admin.site.register(Reply)