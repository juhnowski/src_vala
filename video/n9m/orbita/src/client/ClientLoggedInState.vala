using GLib;
using n9m.orbita.Message;
using n9m.orbita.Statable;

namespace n9m.orbita.client{

/**
 * Сервер авторизовал клиента
 * Возможные операции:
 *  - CreateStreamSession
 * Переходы:
 *  - StreamSessionCreated -> StreamRequested
 */
 public class ClientLoggedInState extends Statable{
    public void response(Message response){

    };
    public void notify(Message notify){

    };
    public void onRequest(Message request){

    };
  }
}
