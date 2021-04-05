using GLib;
using n9m.orbita.Param;
using n9m.orbita.Constants;
using n9m.orbita.DeviceType;
using n9m.orbita.Message;
using n9m.orbita.Modules;

namespace n9m.orbita.uploadstat{


//TODO: возможно опечатка в спецификации, не UPLOADSTAT а UPLOADSTART
/**
 * Сообщение операции UploadStat
 */
 public class UploadStat extends Message{

    public UploadStat(){
        super(Modules.MEDIASTREAMMODEL, "", new Operation(), new Parameter(CURRENT_VERSION), new Response());
    }
  }
}
