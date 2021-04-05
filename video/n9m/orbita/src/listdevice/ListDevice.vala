using GLib;
using n9m.orbita.Param;
using n9m.orbita.Constants;
using n9m.orbita.DeviceType;
using n9m.orbita.Message;
using n9m.orbita.Modules;

namespace n9m.orbita.listdevice{

/**
 * Сообщение операции ListDevice
 */
 public class ListDevice extends Message{

    public ListDevice(){
        super(Modules.DISCOVERY, "", new Operation(), new Parameter(CURRENT_VERSION,CURRENT_VERSION,CURRENT_VERSION,CURRENT_VERSION,CURRENT_VERSION,CURRENT_VERSION,CURRENT_VERSION,CURRENT_VERSION,CURRENT_VERSION,CURRENT_VERSION,CURRENT_VERSION), new Response());
    }
  }
}
