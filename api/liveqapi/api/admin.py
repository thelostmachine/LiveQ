from django.contrib import admin
from .models import Room, Queue, Song, Service
# Register your models here.
admin.site.register(Room)
admin.site.register(Queue)
admin.site.register(Song)
admin.site.register(Service)