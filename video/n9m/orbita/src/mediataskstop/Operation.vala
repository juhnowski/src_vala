using GLib;
using n9m.orbita.Oper;

namespace n9m.orbita.mediataskstop{

  public class Operation extends Oper{

      public static final String MEDIATASKSTOP="MEDIATASKSTOP";

      public Operation(){
          super(MEDIATASKSTOP,Oper.NOTIFICATION);
      }
  }
}
