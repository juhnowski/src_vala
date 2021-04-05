using GLib;
using n9m.orbita.Param;
using n9m.orbita.Constants;
using n9m.orbita.DeviceType;
using n9m.orbita.Message;
using n9m.orbita.Modules;

namespace n9m.orbita.login{

/**
 * Сообщение операции Login
 */
 public class Login extends Message{

    public Login(){
        super(Modules.CERTIFICATE, "", new Operation(), new Parameter(CURRENT_VERSION,CURRENT_VERSION,CURRENT_VERSION,CURRENT_VERSION,CURRENT_VERSION), new Response());
    }
  }
}
