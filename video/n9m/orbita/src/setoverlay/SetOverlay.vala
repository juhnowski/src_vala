using GLib;
using n9m.orbita.Param;
using n9m.orbita.Constants;
using n9m.orbita.DeviceType;
using n9m.orbita.Message;
using n9m.orbita.Modules;

namespace n9m.orbita.setoverlay{

/**
 * Сообщение операции SetOverlay
 */
 public class SetOverlay extends Message{

    public SetOverlay(){
        super(Modules.AVSM, "", new Operation(), new Parameter(CURRENT_VERSION), new Response());
    }
  }
}
