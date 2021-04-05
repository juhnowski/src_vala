using GLib;
using n9m.orbita.Message;
using n9m.orbita.Statable;

namespace n9m.orbita.client{

/**
 * Сервер создал видеопоток для клиента
 * Возможные операции:
 *  - requestStream
 * Переходы:
 *  - StreamSessionCreated -> StreamRequested
 */
 public class StreamSessionCreatedState extends Statable{
    public void response(Message response){

    };
    public void notify(Message notify){

    };
    public void onRequest(Message request){

    };
  }
}
