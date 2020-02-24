from django.db import models
from django.contrib.auth.models import User
# Create your models here.

# Room DB model
class Room(models.Model):
    room_key = models.CharField(max_length=30)
    room_name = models.CharField(max_length=30)
    host = models.ForeignKey(User, on_delete=models.CASCADE)
    guests = models.ManyToManyField(User)
    queue = models.OneToOneField('Queue', on_delete=models.CASCADE)
    services = models.ManyToManyField('Service')

# Queue DB model
class Queue(models.Model):
    songs = models.ManyToManyField('Song')

# Song DB model
class Song(models.Model):
    song_id = models.CharField(max_length=30)
    service = models.ForeignKey('Service', on_delete=models.CASCADE)

# Service DB model
class Service(models.Model):
    class ServiceType(models.TextChoices):
        SPOTIFY = 'SP'
        SOUNDCLOUD = 'SC'
    
    api_key = models.CharField(max_length=30)
    service_type = models.CharField(
        max_length=2,
        choices=ServiceType.choices,
        default=ServiceType.SPOTIFY)
 