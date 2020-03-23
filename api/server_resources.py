import uuid
import string
import random
import queue
import asyncio


class RoomDB:
    def __init__(self):
        self.rooms = {}
     
    def generate_key(self):
        while True:
            lettersAndDigits = string.ascii_letters + string.digits
            key = ''.join(random.choice(lettersAndDigits) for i in range(8))
            if key not in self.rooms.keys():
                return key
    
    def AddRoom(self, name):
        new_room = Room(name, self.generate_key())
        self.rooms[new_room.room_key] = new_room
        return [new_room.room_key, str(new_room.host_id)]
    
    def JoinRoom(self, key):
        if key in self.rooms.keys():
            return self.rooms[key].AddGuest()
    
    def AddSong(self, key, song):
        if key in self.rooms.keys():
            self.rooms[key].AddSongToQ(song)
    
    def DeleteSong(self, key, song):
        if key in self.rooms.keys():
            self.rooms[key].DelSongQ(song)

class Room:
    def __init__(self, name, key):
        self.name = name
        self.room_key = key
        self.host_id = uuid.uuid1()
        self.guest_ids = []
        self.q = []

    def AddGuest(self):
        guest_id = uuid.uuid1()
        self.guest_ids.append(guest_id)
        return guest_id

    def AddSongToQ(self, song):
        q.append(song)
    
    def DelSongQ(self, song):
        for item in self.q:
            if item == song :
                del item

  