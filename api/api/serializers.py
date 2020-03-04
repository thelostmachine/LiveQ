from liveqapi.api.models import Room, Guest, Song, Service
from django.contrib.auth.models import User
from rest_framework import serializers

class RoomSerializer(serializers.ModelSerializer):
    class Meta:
        model = Room
        fields = ['room_name']

class GuestSerializer(serializers.ModelSerializer):
    class Meta:
        model = Guest
        fields = ['name']

class SongSerializer(serializers.ModelSerializer):
    class Meta:
        model = Song
        fields = ['song_id']

class ServiceSerializer(serializers.ModelSerializer):
    class Meta:
        model = Service
        fields = ['service_type']