using GLib;
using n9m.orbita.Oper;

  namespace n9m.orbita.mediataskstart{

  public class Operation extends Oper{

      public static final String MEDIATASKSTART="MEDIATASKSTART";

      public Operation(){
          super(MEDIATASKSTART,Oper.NOTIFICATION);
      }
  }
}
