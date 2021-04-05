using GLib;
using n9m.orbita.Param;
using n9m.orbita.Constants;
using n9m.orbita.DeviceType;
using n9m.orbita.Message;
using n9m.orbita.Modules;

namespace n9m.orbita.sendrecordstatus{

/**
 * Сообщение операции SendRecordStatus
 */
 public class SendRecordStatus extends Message{

    public SendRecordStatus(){
        super(Modules.EVEM, "", new Operation(), new Parameter(CURRENT_VERSION), new Response());
    }
  }
}
