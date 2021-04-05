using GLib;
using n9m.orbita.Oper;

namespace n9m.orbita.verify{

  public class Operation extends Oper{

      public static final String VERIFY="VERIFY";

      public Operation(){
          super(VERIFY,Oper.REQUEST_RESPONSE);
      }
  }
}
