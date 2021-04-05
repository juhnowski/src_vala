using GLib;
using n9m.orbita.Param;
using n9m.orbita.Constants;
using n9m.orbita.DeviceType;
using n9m.orbita.Message;
using n9m.orbita.Modules;

namespace n9m.orbita.conseq{

/**
 * Сообщение операции Conseq
 */
 public class Conseq extends Message{

    public Conseq(){
        super(Modules.NAT, "", new Operation(), new Parameter(CURRENT_VERSION), new Response());
    }
  }
}
