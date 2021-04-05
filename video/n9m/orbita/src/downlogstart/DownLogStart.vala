using GLib;
using n9m.orbita.Param;
using n9m.orbita.Constants;
using n9m.orbita.DeviceType;
using n9m.orbita.Message;
using n9m.orbita.Modules;

namespace n9m.orbita.downlogstart{

/**
 * Сообщение операции DownLogStart
 */
 public class DownLogStart extends Message{

    public DownLogStart(){
        super(Modules.MEDIASTREAMMODEL, "", new Operation(), new Parameter(CURRENT_VERSION), new Response());
    }
  }
}
