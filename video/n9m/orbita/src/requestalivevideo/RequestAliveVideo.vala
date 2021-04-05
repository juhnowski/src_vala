using GLib;
using n9m.orbita.Param;
using n9m.orbita.Constants;
using n9m.orbita.DeviceType;
using n9m.orbita.Message;
using n9m.orbita.Modules;

namespace n9m.orbita.requestalivevideo{

/**
 * Сообщение операции RequestAliveVideo
 */
 public class RequestAliveVideo extends Message{

    public RequestAliveVideo(){
        super(Modules.MEDIASTREAMMODEL, "", new Operation(), new Parameter(CURRENT_VERSION), new Response());
    }
  }
}
