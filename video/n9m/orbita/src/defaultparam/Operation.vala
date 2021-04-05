using GLib;
using n9m.orbita.Oper;

namespace n9m.orbita.defaultparam{

  public class Operation extends Oper{
          public static final String DEFAULTPARAM = "DEFAULTPARAM";

          public Operation(){
          super(DEFAULTPARAM,Oper.REQUEST_RESPONSE);
      }
  }
}
