import socket
import sys
HOST = sys.argv[1]
PORT = 22    # Arbitrary non-privileged port
s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
print 'Socket created'
try:
    s.bind((HOST, PORT))
except socket.error , msg:
    print 'Bind failed. Error code: ' + str(msg[0]) + 'Error message: ' + msg[1]
    sys.exit()
print 'Socket bind complete'
s.listen(1)
print 'Socket now listening'

# Accept the connection
(conn, addr) = s.accept()
print 'Server: got connection from client ' + addr[0] + ':' + str(addr[1])
