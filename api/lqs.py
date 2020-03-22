import grpc
import interface_pb2
import interface_pb2_grpc
import server_resources
class LiveQSevicer(interface_pb2_grpc.LiveQServicer):
    def __init__(self):

    def CreateRoom(self, request, context):
