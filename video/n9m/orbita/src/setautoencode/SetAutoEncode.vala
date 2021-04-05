using GLib;
using n9m.orbita.Param;
using n9m.orbita.Constants;
using n9m.orbita.DeviceType;
using n9m.orbita.Message;
using n9m.orbita.Modules;

namespace n9m.orbita.setautoencode{

/**
 * Сообщение операции SetAutoEncode
 */
 public class SetAutoEncode extends Message{

    public SetAutoEncode(){
        super(Modules.AVSM, "", new Operation(), new Parameter(CURRENT_VERSION), new Response());
    }
  }
}
