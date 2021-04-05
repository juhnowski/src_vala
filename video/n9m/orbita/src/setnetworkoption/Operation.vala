using GLib;
using n9m.orbita.Oper;

namespace n9m.orbita.setnetworkoption{

  public class Operation extends Oper{
          public static final String SETNETWORKOPTION = "SETNETWORKOPTION";

          public Operation(){
          super(SETNETWORKOPTION,Oper.REQUEST_RESPONSE);
      }
  }
}
