using GLib;
using n9m.orbita.Statable;
using n9m.orbita.Message;


namespace n9m.orbita.client{
/**
 * Интерфейс состояний клиента
 */
 public interface State extends Statable{
    public void onResponse(Message response);
    public void onNotify(Message notification);
    public void request(Message res);
  }
}
