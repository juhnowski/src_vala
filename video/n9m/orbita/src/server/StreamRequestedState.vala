using GLib;
using n9m.orbita.Message;
using n9m.orbita.Statable;

namespace n9m.orbita.server{

/**
 * Сервер создал видеопоток для клиента
 * Возможные операции:
 *  - requestStream
 * Переходы:
 *  - StreamRequested -> StreamSessionCreated
 */
 public class StreamRequestedState extends Statable{
    public void response(Message response){

    };

    public void notify(Message notify){

    };

    public void onRequest(Message request){

    };
  }
}
