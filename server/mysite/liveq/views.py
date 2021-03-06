from rest_framework import viewsets, filters
from .models import Room, Guest, Song, Service
from .serializers import RoomSerializer, GuestSerializer, SongSerializer, ServiceSerializer

# Create your views here.

class RoomViewSet(viewsets.ModelViewSet):
    search_fields = ['room_key']
    filter_backends = (filters.SearchFilter,)
    queryset = Room.objects.all()
    serializer_class = RoomSerializer
    lookup_field = 'room_key'

class GuestViewSet(viewsets.ModelViewSet):
    queryset = Guest.objects.all()
    serializer_class = GuestSerializer

class SongViewSet(viewsets.ModelViewSet):
    search_fields = ['room__room_key']
    filter_backends = (filters.SearchFilter,)
    queryset = Song.objects.all()
    serializer_class = SongSerializer

class ServiceViewSet(viewsets.ModelViewSet):
    search_fields = ['room__room_key']
    filter_backends = (filters.SearchFilter,)
    queryset = Service.objects.all()
    serializer_class = ServiceSerializer

