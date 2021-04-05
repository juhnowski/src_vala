using GLib;
using n9m.orbita.Param;
using n9m.orbita.Constants;
using n9m.orbita.DeviceType;
using n9m.orbita.Message;
using n9m.orbita.Modules;

namespace n9m.orbita.listserver{

/**
 * Сообщение операции ListServer
 */
 public class ListServer extends Message{

    public ListServer(){
        super(Modules.DISCOVERY, "", new Operation(), new Parameter(), new Response());
    }
  }
}
