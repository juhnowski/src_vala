using GLib;
using n9m.orbita.Param;
using n9m.orbita.Constants;
using n9m.orbita.DeviceType;
using n9m.orbita.Message;
using n9m.orbita.Modules;

namespace n9m.orbita.ctrlpush{

/**
 * Сообщение операции CtrlPush
 */
 public class CtrlPush extends Message{

    public CtrlPush(){
        super(Modules.NWSM, "", new Operation(), new Parameter(CURRENT_VERSION), new Response());
    }
  }
}
