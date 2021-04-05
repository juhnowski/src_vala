using GLib;
using n9m.orbita.Oper;

  namespace n9m.orbita.listserver{

  public class Operation extends Oper{

      public static final String LISTSERVER="LISTSERVER";

      public Operation(){
          super(LISTSERVER,Oper.REQUEST_RESPONSE);
      }
  }
}
