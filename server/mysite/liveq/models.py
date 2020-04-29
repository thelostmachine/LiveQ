from django.db import models, IntegrityError
from django.contrib.auth.models import User
from django.utils.crypto import get_random_string

import uuid
import random, string

# Create your models here.

class Guest(models.Model):
    room = models.ForeignKey('Room', on_delete=models.CASCADE)
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)

class Room(models.Model):
    room_key = models.CharField(max_length=8, blank=True, unique=True)
    room_name = models.CharField(max_length=30, default='')
    #host = models.OneToOneField(User, on_delete=models.CASCADE)

    def save(self, *args, **kwargs):
        if not self.room_key:
            self.room_key = get_random_string(length=8)
        success = False
        failures = 0
        while not success:
            try:
                super(Room, self).save(*args, **kwargs)
            except IntegrityError:
                failures += 1
                if failures > 10:
                    raise
                else:
                    self.room_key = get_random_string(length=8)
            else:
                success = True


class Song(models.Model):
    room = models.ForeignKey(Room, to_field='room_key', on_delete=models.CASCADE)

    track_id = models.CharField(max_length=50)
    uri = models.CharField(max_length=50)
    track_name = models.CharField(max_length=100)
    artists = models.CharField(max_length=30)
    duration = models.IntegerField(default=0)
    image_uri = models.CharField(max_length=200)
    service = models.CharField(max_length=15)

class Service(models.Model):
    SERVICES = (
        ('Spotify', 'Spotify'),
        ('SoundCloud', 'SoundCloud'),
    )

    room = models.ForeignKey(Room, to_field='room_key', on_delete=models.CASCADE)
    service_type = models.CharField(max_length=20, choices=SERVICES)


