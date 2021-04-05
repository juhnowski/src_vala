using GLib;
using n9m.orbita.Param;
using n9m.orbita.Constants;
using n9m.orbita.DeviceType;
using n9m.orbita.Message;
using n9m.orbita.Modules;

namespace n9m.orbita.controlstream{

/**
 * Сообщение операции ControlStream
 */
 public class ControlStream extends Message{

    public ControlStream(){
        super(Modules.MEDIASTREAMMODEL, "", new Operation(), new Parameter(), new Response());
    }
  }
}
