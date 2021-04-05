using GLib;
using n9m.orbita.Param;
using n9m.orbita.Constants;
using n9m.orbita.DeviceType;
using n9m.orbita.Message;
using n9m.orbita.Modules;

namespace n9m.orbita.issuedalarminfo{

/**
 * Сообщение операции IssuedAlarmInfo
 */
 public class IssuedAlarmInfo extends Message{

    public IssuedAlarmInfo(){
        super(Modules.EVEM, "", new Operation(), new Parameter(CURRENT_VERSION), new Response());
    }
  }
}
