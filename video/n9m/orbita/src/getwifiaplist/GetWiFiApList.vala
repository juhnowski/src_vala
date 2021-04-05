using GLib;
using n9m.orbita.Param;
using n9m.orbita.Constants;
using n9m.orbita.DeviceType;
using n9m.orbita.Message;
using n9m.orbita.Modules;

namespace n9m.orbita.getwifiaplist{

/**
 * Сообщение операции GetWiFiApList
 */
 public class GetWiFiApList extends Message{

    public GetWiFiApList(){
        super(Modules.NWSM, "", new Operation(), new Parameter(CURRENT_VERSION), new Response());
    }
  }
}
