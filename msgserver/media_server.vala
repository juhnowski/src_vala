	int headerLen = 12;
public static int json_send(string message,Socket conn){
	uint8 header[12];
	header = {0x08,0x00,0x00,0x00,0x00,0x00,0x00,(uint8)message.size(),0x52,0x00,0x00,0x00};
	stdout.printf("\n----\nMessage send: %s\n",message);
	conn.send (header);
	conn.send (message.data);
	return 0;
}
public static string json_receive(Socket conn){
	uchar ret[12];
	uint64 payloadLen;
	uint8 buffer[100000];
	string resp;
	//do{
		conn.receive(buffer);
		stdout.printf("\nHeader:");
		for(uint j=0;j<headerLen;j=j+1){
				ret[j]=buffer[j];
				stdout.printf("%p ",(string)buffer[j]);
		}
	//}while(ret[1]==0x16);
	payloadLen = ret[7] + ret[6]*0x100 + ret[5]*0x10000 + ret[4]*0x1000000;
	resp = (string)buffer[headerLen:payloadLen+headerLen];
	stdout.printf("PayloadLen: %" + uint64.FORMAT + "\n",payloadLen);
	if ((ret[1]==0x16)||(ret[0]==0x0)) return "error";
	return resp;
}
public static void media_server(SocketAddress address) throws Error {
  stdout.puts("----------media_server--------------\n");
  Socket socket = new Socket (SocketFamily.IPV4, SocketType.STREAM, SocketProtocol.TCP);
	assert (socket != null);

	socket.bind (address, true);
	socket.set_listen_backlog (10);
	socket.listen ();
	for (int i = 0; true ; i = (i + 1) % 10) {
    string response;
		Socket connection = socket.accept ();
    string ses;

		stdout.printf ("accepted (%d)\n", i);
    response = json_receive(connection);
    stdout.printf("Response:%s\n",response);

    var parser = new Json.Parser ();
    parser.load_from_data (response,response.length);
    Json.Node node = parser.get_root ();
    ses = node.get_object ().get_string_member ("SESSION");

    string create = @"{\"MODULE\":\"CERTIFICATE\",\"OPERATION\":\"CREATESTREAM\",\"PARAMETER\":{\"ERRORCODE\":0,\"ERRORCAUSE\":\"SUCCESS\"},\"SESSION\":\"$ses\"}\r\n";
    json_send(create,connection);
    for(int j=0;j<5;j++){
      response = json_receive(connection);
      stdout.printf("Response 2:%s\n",response);
    }//while(response=="error");

  }

}
public static int main (string[] args) {
	if (!Thread.supported()) {
			stderr.printf("Cannot run without threads.\n");
			return 1;
	}
	//InetAddress address = new InetAddress.loopback (SocketFamily.IPV4);
	InetAddress media_server_address = new InetAddress.from_string ("10.0.0.3");
	InetSocketAddress media_address = new InetSocketAddress (media_server_address, 5557);
	media_server (media_address);
	//Thread.create<void>(server (address),false);
	//Thread.create<void>(media_server (media_address),false);
	return 0;
}
