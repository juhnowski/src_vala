using GLib;
using n9m.orbita.Oper;

namespace n9m.orbita.reboot{

  public class Operation extends Oper{
          public static final String REBOOT = "REBOOT";

          public Operation(){
          super(REBOOT,Oper.REQUEST_RESPONSE);
      }
  }
}
