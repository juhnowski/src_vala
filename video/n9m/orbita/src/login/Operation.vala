using GLib;
using n9m.orbita.Oper;

  namespace n9m.orbita.login{

  public class Operation extends Oper{

      public static final String LOGIN="LOGIN";

      public Operation(){
          super(LOGIN,Oper.REQUEST_RESPONSE);
      }
  }
}
