using GLib;
using n9m.orbita.Param;
using n9m.orbita.Constants;
using n9m.orbita.DeviceType;
using n9m.orbita.Message;
using n9m.orbita.Modules;

namespace n9m.orbita.setgpsinfo{

/**
 * Сообщение операции SetGpsInfo
 */
 public class SetGpsInfo extends Message{

    public SetGpsInfo(){
        super(Modules.EVEM, "", new Operation(), new Parameter(CURRENT_VERSION), new Response());
    }
  }
}
