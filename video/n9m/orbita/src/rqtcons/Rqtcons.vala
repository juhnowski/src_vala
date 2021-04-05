using GLib;
using n9m.orbita.Param;
using n9m.orbita.Constants;
using n9m.orbita.DeviceType;
using n9m.orbita.Message;
using n9m.orbita.Modules;

namespace n9m.orbita.rqtcons{

/**
 * Сообщение операции Rqtcons
 */
 public class Rqtcons extends Message{

    public Rqtcons(){
        super(Modules.NAT, "", new Operation(), new Parameter(CURRENT_VERSION), new Response());
    }
  }
}
