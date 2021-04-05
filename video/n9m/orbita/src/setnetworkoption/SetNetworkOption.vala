using GLib;
using n9m.orbita.Param;
using n9m.orbita.Constants;
using n9m.orbita.DeviceType;
using n9m.orbita.Message;
using n9m.orbita.Modules;

namespace n9m.orbita.setnetworkoption{

/**
 * Сообщение операции SetNetworkOption
 */
 public class SetNetworkOption extends Message{

    public SetNetworkOption(){
        super(Modules.DISCOVERY, "", new Operation(), new Parameter(CURRENT_VERSION), new Response());
    }
  }
}
