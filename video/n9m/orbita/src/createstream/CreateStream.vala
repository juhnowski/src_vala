using GLib;
using n9m.orbita.Param;
using n9m.orbita.Constants;
using n9m.orbita.DeviceType;
using n9m.orbita.Message;
using n9m.orbita.Modules;

namespace n9m.orbita.createstream{

/**
 * Сообщение операции CreateStream
 */
 public class CreateStream extends Message{

    public CreateStream(){
        super(Modules.CERTIFICATE, "", new Operation(), new Parameter(), new Response());
    }
  }
}
