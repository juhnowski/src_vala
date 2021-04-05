using GLib;
using n9m.orbita.Param;
using n9m.orbita.Constants;
using n9m.orbita.DeviceType;
using n9m.orbita.Message;
using n9m.orbita.Modules;

namespace n9m.orbita.uploadgpsinfo{

/**
 * Сообщение операции UploadGpsInfo
 */
 public class UploadGpsInfo extends Message{

    public UploadGpsInfo(){
        super(Modules.EVEM, "", new Operation(), new Parameter(CURRENT_VERSION), new Response());
    }
  }
}
