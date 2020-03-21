from django.contrib import admin
from .models import Room, Guest, Song, Service
# Register your models here.
admin.site.register(Room)
admin.site.register(Guest)
admin.site.register(Song)
admin.site.register(Service)