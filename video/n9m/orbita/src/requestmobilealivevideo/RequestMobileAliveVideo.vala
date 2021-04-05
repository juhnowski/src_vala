using GLib;
using n9m.orbita.Param;
using n9m.orbita.Constants;
using n9m.orbita.DeviceType;
using n9m.orbita.Message;
using n9m.orbita.Modules;

namespace n9m.orbita.requestmobilealivevideo{

/**
 * Сообщение операции RequestMobileAliveVideo
 */
 public class RequestMobileAliveVideo extends Message{

    public RequestMobileAliveVideo(){
        super(Modules.MEDIASTREAMMODEL, "", new Operation(), new Parameter(CURRENT_VERSION), new Response());
    }
  }
}
