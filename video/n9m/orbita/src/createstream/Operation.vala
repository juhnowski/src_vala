using GLib;
using n9m.orbita.Oper;

namespace n9m.orbita.createstream{

  public class Operation extends Oper{

      public static final String CREATESTREAM="CREATESTREAM";

      public Operation(){
          super(CREATESTREAM,Oper.REQUEST_RESPONSE);
      }
  }
}
