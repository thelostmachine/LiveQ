import uuid
import string
import random

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
        if new_room.room_key in self.rooms.keys():
            return [new_room.room_key, str(new_room.host_id)]
        else:
            return ['-1', '0']
    
    def JoinRoom(self, key):
        if key in self.rooms.keys():
            return [self.rooms[key].name, str(self.rooms[key].AddGuest())]
        else:
            return ['-1', '0']
    
    def DelRoom(self, key):
        if key in self.rooms.keys():
            del self.roooms[key]
            return 0
        return -1

    def RemoveFromRoom(self, key, id):
        if key in self.rooms.keys():
            for i in range(len(self.rooms[key].guest_ids)):
                if uuid.UUID(id) == self.rooms[key].guest_ids[i]:
                    del self.rooms[key].guest_ids[i]
                    return 0
        return -1
        
    def AddServiceToRoom(self, key, service):
        if key in self.rooms.keys():
            self.rooms[key].AddService(service)
            return 0
        else:
            return -1

    def AddSongToRoom(self, key, song):
        if key in self.rooms.keys():
            self.rooms[key].AddSongToQ(song)
            return 0
        return -1
    
    def DeleteSongFromRoom(self, key, song):
        if key in self.rooms.keys():
            self.rooms[key].DelSongQ(song)
            return 0
        return -1

class Room:
    def __init__(self, name, key):
        self.name = name
        self.room_key = key
        self.host_id = uuid.uuid1()
        self.guest_ids = []
        self.services = []
        self.q = []

    def AddGuest(self):
        guest_id = uuid.uuid1()
        self.guest_ids.append(guest_id)
        return guest_id

    def AddService(self, service):
        self.services.append(service)

    def AddSongToQ(self, song):
        self.q.append(song)
    
    def DelSongQ(self, song):
        for i in range(len(self.q)):
            if self.q[i] == song :
               del self.q[i]

  