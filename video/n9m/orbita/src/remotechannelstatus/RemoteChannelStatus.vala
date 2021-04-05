using GLib;
using n9m.orbita.Param;
using n9m.orbita.Constants;
using n9m.orbita.DeviceType;
using n9m.orbita.Message;
using n9m.orbita.Modules;

namespace n9m.orbita.remotechannelstatus{

/**
 * Сообщение операции RemoteChannelStatus
 */
 public class RemoteChannelStatus extends Message{

    public RemoteChannelStatus(){
        super(Modules.MEDIASTREAMMODEL, "", new Operation(), new Parameter(CURRENT_VERSION), new Response());
    }
  }
}
