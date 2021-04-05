using GLib;
using n9m.orbita.Message;
using n9m.orbita.Statable;

namespace n9m.orbita.client{

/**
 * Клиент соединился с сервером
 * Возможные операции:
 *  - ClientVerify
 * Переходы:
 *  - ClientConnected -> ClientVerified -> ClientLoggedIn
 */
 public class ClientConnectedState extends Statable{
    public void response(Message response){

    };
    public void notify(Message notify){

    };
    public void onRequest(Message request){

    };
  }
}
