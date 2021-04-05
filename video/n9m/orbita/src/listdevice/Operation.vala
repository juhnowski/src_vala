using GLib;
using n9m.orbita.Oper;

namespace n9m.orbita.listdevice{

  public class Operation extends Oper{
      public static final String LISTDEVICE="LISTDEVICE";

      public Operation(){
          super(LISTDEVICE,Oper.REQUEST_RESPONSE);
      }
  }
}
