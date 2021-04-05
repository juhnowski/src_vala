using GLib;
using n9m.orbita.Message;
using n9m.orbita.Statable;

namespace n9m.orbita.client{

/**
 * Исходное состояние клиента
 * Возможные операции:
 *  - Probe
 *  - SetNetworkOption
 * Переходы:
 *  - ClientConnected -> ClientVerified -> ClientLoggedIn
 */
 public class IdleState extends Statable{
    public void response(Message response){

    };
    public void notify(Message notify){

    };
    public void onRequest(Message request){

    };
  }
}
