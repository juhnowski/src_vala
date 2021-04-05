using GLib;
using n9m.orbita.Param;
using n9m.orbita.Constants;
using n9m.orbita.DeviceType;
using n9m.orbita.Message;
using n9m.orbita.Modules;

namespace n9m.orbita.mediataskstart{

/**
 * Сообщение операции MediaTaskStart
 */
 public class MediaTaskStart extends Message{

    public MediaTaskStart(){
        super(Modules.MEDIASTREAMMODEL, "", new Operation(), new Parameter(), new Response());
    }
  }
}
