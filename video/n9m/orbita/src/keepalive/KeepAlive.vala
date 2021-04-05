using GLib;
using n9m.orbita.Param;
using n9m.orbita.Constants;
using n9m.orbita.DeviceType;
using n9m.orbita.Message;
using n9m.orbita.Modules;

namespace n9m.orbita.keepalive{

/**
 * Сообщение операции KeepAlive
 */
 public class KeepAlive extends Message{

    public KeepAlive(){
        super(Modules.CERTIFICATE, "", new Operation(), new Parameter(), new Response());
    }
  }
}
