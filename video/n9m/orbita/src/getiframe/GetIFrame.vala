using GLib;
using n9m.orbita.Param;
using n9m.orbita.Constants;
using n9m.orbita.DeviceType;
using n9m.orbita.Message;
using n9m.orbita.Modules;

namespace n9m.orbita.getiframe{

/**
 * Сообщение операции GetIFrame
 */
 public class GetIFrame extends Message{

    public GetIFrame(){
        super(Modules.AVSM, "", new Operation(), new Parameter(CURRENT_VERSION), new Response());
    }
  }
}
