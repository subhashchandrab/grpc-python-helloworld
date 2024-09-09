from concurrent import futures
import os

import grpc

from hello_world_pb2 import HelloReply
import hello_world_pb2_grpc

class HelloWorldService(
    hello_world_pb2_grpc.Greeter
):
    def SayHello(self, request, context):
        reply_msg = "Hello " + request.name + " from grpc pod " + os.environ['POD_NAME'] + "!"
        return HelloReply(message=reply_msg)
    
def serve():
    server = grpc.server(futures.ThreadPoolExecutor(max_workers=10))
    hello_world_pb2_grpc.add_GreeterServicer_to_server(
        HelloWorldService(), server
    )
    server.add_insecure_port("[::]:50051")
    server.start()
    server.wait_for_termination()

if __name__ == "__main__":
    serve()    