using GLib;
using n9m.orbita.Param;
using n9m.orbita.Constants;
using n9m.orbita.DeviceType;
using n9m.orbita.Message;
using n9m.orbita.Modules;

namespace n9m.orbita.getconstateorinfo{

/**
 * Сообщение операции GetConstateorinfo
 */
 public class GetConstateorinfo extends Message{

    public GetConstateorinfo(){
        super(Modules.NWSM, "", new Operation(), new Parameter(CURRENT_VERSION), new Response());
    }
  }
}
