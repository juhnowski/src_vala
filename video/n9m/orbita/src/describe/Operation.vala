using GLib;
using n9m.orbita.Oper;

namespace n9m.orbita.describe{

  public class Operation extends Oper{

      public static final String DESCRIBE="DESCRIBE";

      public Operation(){
          super(DESCRIBE,Oper.REQUEST_RESPONSE);
      }
  }
}
