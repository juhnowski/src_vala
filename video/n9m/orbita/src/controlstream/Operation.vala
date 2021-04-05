using GLib;
using n9m.orbita.Oper;

namespace n9m.orbita.controlstream{

  public class Operation extends Oper{

      public static final String CONTROLSTREAM="CONTROLSTREAM";

      public Operation(){
          super(CONTROLSTREAM,Oper.REQUEST_RESPONSE);
      }
  }
}
