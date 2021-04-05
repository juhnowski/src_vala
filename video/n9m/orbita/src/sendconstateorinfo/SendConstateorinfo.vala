using GLib;
using n9m.orbita.Param;
using n9m.orbita.Constants;
using n9m.orbita.DeviceType;
using n9m.orbita.Message;
using n9m.orbita.Modules;

namespace n9m.orbita.sendconstateorinfo{

/**
 * Сообщение операции SendConstateorinfo
 */
 public class SendConstateorinfo extends Message{

    public SendConstateorinfo(){
        super(Modules.NWSM, "", new Operation(), new Parameter(CURRENT_VERSION), new Response());
    }
  }
}
