using GLib;
using n9m.orbita.Param;
using n9m.orbita.Constants;
using n9m.orbita.DeviceType;
using n9m.orbita.Message;
using n9m.orbita.Modules;

namespace n9m.orbita.getcalendar{

/**
 * Сообщение операции GetCalendar
 */
 public class GetCalendar extends Message{

    public GetCalendar(){
        super(Modules.STORM, "", new Operation(), new Parameter(CURRENT_VERSION), new Response());
    }
  }
}
