
using GLib;
	int headerLen = 12;
public class Response:GLib.Object{
	public string resp;
	public size_t len;
	public 	Response(string resp,size_t len){
		this.resp = resp;
		this.len = len;
	}
}
public static Response h264_receive(Socket conn,uint8[] buffer){
	//uint8 buffer[100000];
	uchar ret[12];
	size_t len = conn.receive(buffer);
	for(uint j=0;j<headerLen;j=j+1){
			ret[j]=buffer[j];
	}
	string result = "ok";
	if((ret[0]==0x8)&&(ret[1]==0x2)) result = "header";
	Response r = new Response(result,len);
	return r;
}
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
	if((ret[0]==0x8)&&(ret[1]==0x2)) return "h264";
	if ((ret[1]==0x16)||(ret[0]!=0x8)) return "error";
	return resp;
}

public static void media_server(SocketAddress address)  {//throws Error
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
		uint8 buffer[2000000];
		var file = File.new_for_path ("out.h264");
		if (file.query_exists ()) {
				file.delete ();
		}
		var dos = new DataOutputStream (file.create (FileCreateFlags.REPLACE_DESTINATION));
		long written = 0;
		Response r;
		/*InetAddress server_address = new InetAddress.from_string ("10.0.0.3");
		InetSocketAddress address = new InetSocketAddress (server_address, 5556);*/

		stdout.printf ("accepted (%d)\n", i);
    response = json_receive(connection);
    stdout.printf("Response:%s\n",response);

    var parser = new Json.Parser ();
    parser.load_from_data (response,response.length);
    Json.Node node = parser.get_root ();
    ses = node.get_object ().get_string_member ("SESSION");

    string create = @"{\"MODULE\":\"CERTIFICATE\",\"OPERATION\":\"CREATESTREAM\",\"PARAMETER\":{\"ERRORCODE\":0,\"ERRORCAUSE\":\"1\"},\"SESSION\":\"$ses\"}\r\n";
		string controlstream = @"{\"PARAMETER\":{\"SSRC\":0,\"STREAMTYPE\":0,\"PT\":2,\"STREAMNAME\":\"STREAM-9\",\"AUDIOVALID\":1,\"CMD\":\"0\"},\"OPERATION\":\"CONTROLSTREAM\",\"SESSION\":\"$ses\",\"MODULE\":\"MEDIASTREAMMODEL\"}\r\n";
    json_send(create,connection);
		response = json_receive(connection);
		if(response=="h264"){
			while(true){
				r= h264_receive(connection,buffer);
				while(r.resp=="header"){
					r = h264_receive(connection,buffer);
				}
				stdout.printf("DATA:%s\n",(string)buffer);
				stdout.printf ("Buffer len: %" + size_t.FORMAT + "\n", r.len);
        while (written < r.len) {
            // sum of the bytes of 'text' that already have been written to the stream
            written += dos.write (buffer[written:r.len]);//[written:buffer.length]
        }

				written = 0;
				stdout.puts("Receive h.264 data\n");
			}
		}
		//json_send(controlstream,connection);
    for(int j=0;j<5;j++){
      response = json_receive(connection);
      stdout.printf("Response 2:%s\n",response);

    }//while(true);//response=="error"
		connection.close();
		dos.close();
		return;
  }

}

public static void server (SocketAddress address) {
	stdout.puts("----------server--------------\n");
	Socket socket = new Socket (SocketFamily.IPV4, SocketType.STREAM, SocketProtocol.TCP);
	assert (socket != null);

	socket.bind (address, true);
	socket.set_listen_backlog (10);
	socket.listen ();

	for (int i = 0; true ; i = (i + 1) % 10) {
		Socket connection = socket.accept ();
		stdout.printf ("accepted (%d)\n", i);
			string response;
			string ses,dsno,pro,operation="";
			string s0;

			response = json_receive(connection);
			stdout.printf("Response:%s\n",response);

			var parser = new Json.Parser ();
	    parser.load_from_data (response,response.length);
	    Json.Node node = parser.get_root ();
			ses = node.get_object ().get_string_member ("SESSION");
			var parameter = node.get_object ().get_object_member ("PARAMETER");
			dsno = parameter.get_string_member("DSNO");
			pro = parameter.get_string_member ("PRO");
			stdout.printf("Session:%s\n",ses);
			stdout.printf("DSNO:%s\n",dsno);
			stdout.printf("PRO:%s\n",pro);
			/*Checksum checksum = new Checksum (ChecksumType.MD5);
			s0 = checksum.compute_for_string(ChecksumType.MD5,ses,ses.length);
			stdout.printf("S0: %s\n",s0);*/
			string reboot = @"{\"MODULE\":\"DISCOVERY\",\"OPERATION\":\"REBOOT\",\"SESSION\":\"$ses\"}\r\n";
			string keepalive = @"{\"MODULE\":\"CERTIFICATE\",\"OPERATION\":\"KEEPALIVE\",\"SESSION\":\"$ses\"}\r\n";
			string connect = @"{\"MODULE\":\"CERTIFICATE\",\"OPERATION\":\"CONNECT\",\"RESPONSE\":{\"SO\":\"1234\"\"ERRORCODE\":0,\"ERRORCAUSE\":\"1\"},\"SESSION\":\"$ses\"}\r\n";
			string requestalivevideo = @"{\"PARAMETER\":{\"CHANNEL\":2,\"SERIAL\":0,\"STREAMTYPE\":0,\"IPANDPORT\":\"10.0.0.3:5557\",\"STREAMNAME\":\"STREAM-9\",\"AUDIOVALID\":1},\"OPERATION\":\"REQUESTALIVEVIDEO\",\"SESSION\":\"$ses\",\"MODULE\":\"MEDIASTREAMMODEL\"}\r\n";
			string controlstream = @"{\"PARAMETER\":{\"SSRC\":0,\"STREAMTYPE\":0,\"PT\":2,\"STREAMNAME\":\"STREAM-9\",\"AUDIOVALID\":1,\"CMD\":\"0\"},\"OPERATION\":\"CONTROLSTREAM\",\"SESSION\":\"$ses\",\"MODULE\":\"MEDIASTREAMMODEL\"}\r\n";
			string getcalendar = @"{\"PARAMETER\":{\"FILETYPE\":65535,\"CHANNEL\":4294967295,\"CALENDARTYPE\":2,\"SERIAL\":0,\"STREAMTYPE\":1},\"OPERATION\":\"GETCALENDAR\",\"SESSION\":\"$ses\",\"MODULE\":\"STORM\"}\r\n";

			json_send(connect,connection);
			json_receive(connection);
			//json_send(reboot,connection);
			//json_receive(connection);
			json_send(requestalivevideo,connection);

			/*for(int j=0;j<2;j++)*/do{
				response = json_receive(connection);
				stdout.printf("3 Response:%s\n",response);
			}while(response=="error");

			InetAddress media_server_address = new InetAddress.from_string ("10.0.0.3");
			InetSocketAddress media_address = new InetSocketAddress (media_server_address, 5557);
			media_server (media_address);
			//while(true){}
			/*do{
				response = json_receive(connection);
				stdout.printf("4 Response:%s\n",response);
				try{
					parser.load_from_data (response,response.length);
					node = parser.get_root ();
					operation = node.get_object().get_string_member("OPERATION");
					stdout.printf("operation: %s",operation);
				} catch (Error e){
					stdout.printf("\nError: %s\n", e.message);
				}
				if(operation=="KEEPALIVE"){
					json_send(keepalive,connection);
					operation = " ";
				}
			}while(true);*/


			//json_send(getcalendar,connection);
			for(int j=0;j<5;j++){
				response = json_receive(connection);
				stdout.printf("5 Response:%s\n",response);
			}//while(response=="error");
			connection.close();
			stdout.puts("\n---------------------------------------------------------------------------------------------------------------\n");


	}
}

public static int main (string[] args) {
	if (!Thread.supported()) {
			stderr.printf("Cannot run without threads.\n");
			return 1;
	}
	//InetAddress address = new InetAddress.loopback (SocketFamily.IPV4);
  InetAddress server_address = new InetAddress.from_string ("10.0.0.3");
	InetSocketAddress address = new InetSocketAddress (server_address, 5556);
	/*InetAddress media_server_address = new InetAddress.from_string ("10.0.0.3");
	InetSocketAddress media_address = new InetSocketAddress (media_server_address, 5557);*/
	server (address);
	//Thread.create<void>(server (address),false);
	//Thread.create<void>(media_server (media_address),false);
	return 0;
}
