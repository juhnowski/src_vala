using GLib;
using n9m.orbita.Param;
using n9m.orbita.Constants;
using n9m.orbita.DeviceType;
using n9m.orbita.Message;
using n9m.orbita.Modules;

namespace n9m.orbita.setcontrolstorage{

/**
 * Сообщение операции SetControlStorage
 */
 public class SetControlStorage extends Message{

    public SetControlStorage(){
        super(Modules.STORM, "", new Operation(), new Parameter(CURRENT_VERSION), new Response());
    }
  }
}
