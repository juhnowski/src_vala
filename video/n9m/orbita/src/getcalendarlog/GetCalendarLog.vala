using GLib;
using n9m.orbita.Param;
using n9m.orbita.Constants;
using n9m.orbita.DeviceType;
using n9m.orbita.Message;
using n9m.orbita.Modules;

namespace n9m.orbita.getcalendarlog{

/**
 * Сообщение операции GetCalendarLog
 */
 public class GetCalendarLog extends Message{

    public GetCalendarLog(){
        super(Modules.STORM, "", new Operation(), new Parameter(CURRENT_VERSION), new Response());
    }
  }
}
