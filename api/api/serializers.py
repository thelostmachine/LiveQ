from liveqapi.api.models import Room, Guest, Song, Service
from django.contrib.auth.models import User
from rest_framework import serializers

class RoomSerializer():
    class Meta:
        model = Room
        fields = 

class GuestSerializer():

class SongSerializer():

class ServiceSerializer():