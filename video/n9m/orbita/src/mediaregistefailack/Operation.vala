using GLib;
using n9m.orbita.Oper;

  namespace n9m.orbita.mediaregistefailack{

  public class Operation extends Oper{

      public static final String MEDIAREGISTEFAILACK="MEDIAREGISTEFAILACK";

      public Operation(){
          super(MEDIAREGISTEFAILACK,Oper.NOTIFICATION);
      }
  }
}
