using GLib;
using n9m.orbita.Param;
using n9m.orbita.Constants;
using n9m.orbita.DeviceType;
using n9m.orbita.Message;
using n9m.orbita.Modules;

namespace n9m.orbita.defaultparam{

/**
 * Сообщение операции DefaultParam
 */
 public class DefaultParam extends Message{

    public DefaultParam(){
        super(Modules.DISCOVERY, "", new Operation(), new Parameter(), new Response());
    }
  }
}
