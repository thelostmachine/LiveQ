from django.db import models
from django.contrib.auth.models import User
# Create your models here.


class Guest(models.Model):
    room = models.ForeignKey('Room', on_delete=models.CASCADE)
    user = models.OneToOneField(User, on_delete=models.CASCADE)

# Room DB model
class Room(models.Model):
    room_key = models.CharField(max_length=30)
    room_name = models.CharField(max_length=30)
    host = models.OneToOneField(User, on_delete=models.CASCADE)
   
# Song DB model
class Song(models.Model):
    room = models.ForeignKey(Room, on_delete=models.CASCADE)
    time = models.DateTimeField(auto_now_add=True)
    song_id = models.CharField(max_length=30)
    service = models.ForeignKey('Service', on_delete=models.CASCADE)

    def save(self):
        super(Song, self).save()
        #notify of change

# Service DB model
class Service(models.Model):
    class ServiceType(models.IntegerChoices):
        SPOTIFY = '0'
        SOUNDCLOUD = '1'
    room = models.ForeignKey(Room, on_delete=models.CASCADE)
    api_key = models.CharField(max_length=30)
    service_type = models.IntegerField(choices=ServiceType.choices)
 