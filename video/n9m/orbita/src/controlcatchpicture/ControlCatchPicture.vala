using GLib;
using n9m.orbita.Param;
using n9m.orbita.Constants;
using n9m.orbita.DeviceType;
using n9m.orbita.Message;
using n9m.orbita.Modules;

namespace n9m.orbita.controlcatchpicture{

/**
 * Сообщение операции ControlCatchPicture
 */
 public class ControlCatchPicture extends Message{

    public ControlCatchPicture(){
        super(Modules.MEDIASTREAMMODEL, "", new Operation(), new Parameter(CURRENT_VERSION), new Response());
    }
  }
}
