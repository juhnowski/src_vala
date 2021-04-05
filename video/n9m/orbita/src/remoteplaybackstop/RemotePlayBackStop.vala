using GLib;
using n9m.orbita.Param;
using n9m.orbita.Constants;
using n9m.orbita.DeviceType;
using n9m.orbita.Message;
using n9m.orbita.Modules;

namespace n9m.orbita.remoteplaybackstop{

/**
 * Сообщение операции RemotePlayBackStop
 */
 public class RemotePlayBackStop extends Message{

    public RemotePlayBackStop(){
        super(Modules.MEDIASTREAMMODEL, "", new Operation(), new Parameter(CURRENT_VERSION), new Response());
    }
  }
}
