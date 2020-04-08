import grpc
import interface_pb2
import interface_pb2_grpc
import server_resources
import uuid
import time
import logging
from concurrent import futures

_ONE_DAY_IN_SECONDS = 60 * 60 * 24


class LiveQServicer(interface_pb2_grpc.LiveQServicer):
    def __init__(self):
        self.db = server_resources.RoomDB()
    
    def CreateRoom(self, request, context):
        reply_info = self.db.AddRoom(request.room_name)
        if reply_info[0] == '-1':
            status = interface_pb2.Status(status=-1)
        else
            status = interface_pb2.Status(status=0)
        return interface_pb2.CreateReply(status=status, room_key=reply_info[0], host_id=reply_info[1])

    def JoinRoom(self, request, context):
        reply_info = self.db.JoinRoom(request.room_key)
        if reply_info == ['-1', '0']:
            status = interface_pb2.Status(status=-1)
        else
            status = interface_pb2.Status(status=0)
        return interface_pb2.JoinReply(status=status, room_name=reply_info[0], guest_id=reply_info[1])

    def AddService(self, request, context):
        reply_info = self.db.AddServiceToRoom(request.room_key, request.service)
        return interface_pb2.Status(status=reply_info)

    def GetServices(self, request, context):
        if request.room_key in self.db.rooms.keys():
            for service in self.db.rooms[request.room_key].services:
                yield service

    def GetQueue(self, request, context):
        q = self.db.rooms[request.room_key].q
        for song in q:
            yield song

    def AddSong(self, request, context):
        self.db.AddSongToRoom(request.room_key, request.song)
        for song in self.db.rooms[request.room_key].q:
            yield song

    def DeleteSong(self, request, context):
        self.db.DeleteSongFromRoom(request.room_key, request.song)
        q = self.db.rooms[request.room_key].q
        for song in q:
            yield song
            
def serve():
    server = grpc.server(futures.ThreadPoolExecutor(max_workers=10))
    interface_pb2_grpc.add_LiveQServicer_to_server(LiveQServicer(), server)
    server.add_insecure_port('[::]:8080')
    server.start()
    try:
        while True:
            time.sleep(_ONE_DAY_IN_SECONDS)
    except KeyboardInterrupt:
        server.stop(0)

if __name__ == '__main__':
    logging.basicConfig()
    serve()