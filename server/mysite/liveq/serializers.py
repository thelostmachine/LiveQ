# serializers.py

from rest_framework import serializers
from .models import Room, Guest, Song, Service

class RoomSerializer(serializers.ModelSerializer):
    class Meta:
        model = Room
        fields = ['room_name', 'room_key']

class GuestSerializer(serializers.ModelSerializer):
    class Meta:
        model = Guest
        fields = ['id']

class SongSerializer(serializers.ModelSerializer):
    class Meta:
        model = Song
        fields = '__all__'

class ServiceSerializer(serializers.ModelSerializer):
    class Meta:
        model = Service
        fields = '__all__'
