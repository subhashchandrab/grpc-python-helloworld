FROM python

RUN mkdir /service
COPY protobufs/ /service/protobufs/
COPY *.py /service/helloworld/
WORKDIR /service/helloworld
RUN python -m pip install --upgrade pip
RUN python -m pip install -r requirements.txt
RUN python -m grpc_tools.protoc -I ../protobufs --python_out=. \
           --grpc_python_out=. ../protobufs/hello-world.proto

EXPOSE 50051
ENTRYPOINT [ "python", "hello-world.py" ]