using GLib;
using n9m.orbita.Param;
using n9m.orbita.Constants;
using n9m.orbita.DeviceType;
using n9m.orbita.Message;
using n9m.orbita.Modules;

namespace n9m.orbita.ctrltransmit{

/**
 * Сообщение операции CtrlTransmit
 */
 public class CtrlTransmit extends Message{

    public CtrlTransmit(){
        super(Modules.NWSM, "", new Operation(), new Parameter(CURRENT_VERSION), new Response());
    }
  }
}
