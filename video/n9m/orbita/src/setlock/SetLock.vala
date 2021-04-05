using GLib;
using n9m.orbita.Param;
using n9m.orbita.Constants;
using n9m.orbita.DeviceType;
using n9m.orbita.Message;
using n9m.orbita.Modules;

namespace n9m.orbita.setlock{

/**
 * Сообщение операции SetLock
 */
 public class SetLock extends Message{

    public SetLock(){
        super(Modules.STORM, "", new Operation(), new Parameter(CURRENT_VERSION), new Response());
    }
  }
}
