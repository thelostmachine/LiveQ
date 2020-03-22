import grpc
import interface_pb2
import interface_pb2_grpc
import server_resources
import uuid

_ONE_DAY_IN_SECONDS = 60 * 60 * 24


class LiveQSevicer(interface_pb2_grpc.LiveQServicer):
    def __init__(self):
        self.db = server_resources.RoomDB()

    def CreateRoom(self, request, context):
        reply_info = self.db.AddRoom(request.room_name)
        return interface_pb2.CreateReply(room_key=reply_info[0], host_id=reply_info[1])

    def JoinRoom(self, request, context):
        reply_info = str(self.db.JoinRoom(request.room_key))
        return interface_pb2.JoinReply(guest_id=reply_info)

    def UpdateQueue(self, request, context):

    def AddSong(self, request, context):

    def DeleteSong(self, request, context):

def serve():
    server = grpc.server(futures.ThreadPoolExecutor(max_workers=10))
    interface_pb2_grpc.add_LiveQServicer_to_server(LiveQSevicer(), server)
    server.add_insecure_port('[::]:50051')
    server.start()
    try:
        while True:
            time.sleep(_ONE_DAY_IN_SECONDS)
    except KeyboardInterrupt:
        server.stop(0)

if __name__ == '__main__':
    logging.basicConfig()
    serve()