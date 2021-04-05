using GLib;
using n9m.orbita.Param;
using n9m.orbita.Constants;
using n9m.orbita.DeviceType;
using n9m.orbita.Message;
using n9m.orbita.Modules;

namespace n9m.orbita.rqtcond{

/**
 * Сообщение операции Rqtcond
 */
 public class Rqtcond extends Message{

    public Rqtcond(){
        super(Modules.NAT, "", new Operation(), new Parameter(CURRENT_VERSION), new Response());
    }
  }
}
