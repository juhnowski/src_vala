using GLib;
using n9m.orbita.Oper;

namespace n9m.orbita.keepalive{


  public class Operation extends Oper{

      public static final String KEEPALIVE="KEEPALIVE";

      public Operation(){
          super(KEEPALIVE,Oper.REQUEST_RESPONSE);
      }
}
}
