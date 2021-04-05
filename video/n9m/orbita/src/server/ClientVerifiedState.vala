using GLib;
using n9m.orbita.Message;
using n9m.orbita.Statable;

namespace n9m.orbita.server{

/**
 * Сервер проверил клиента
 * Возможные операции:
 *  - ClientLogin
 * Переходы:
 *  ClientVerified -> ClientLoggedIn
 */
 public class ClientVerifiedState extends Statable{
    public void response(Message response){

    };
    public void notify(Message notify){

    };
    public void onRequest(Message request){

    };
  }
}
