using GLib;
using n9m.orbita.Param;
using n9m.orbita.Constants;
using n9m.orbita.DeviceType;
using n9m.orbita.Message;
using n9m.orbita.Modules;

namespace n9m.orbita.getsupportframe{

/**
 * Сообщение операции GetSupportFrame
 */
 public class GetSupportFrame extends Message{

    public GetSupportFrame(){
        super(Modules.AVSM, "", new Operation(), new Parameter(CURRENT_VERSION), new Response());
    }
  }
}
