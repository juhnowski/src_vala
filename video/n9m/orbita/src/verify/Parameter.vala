using GLib;
using n9m.orbita.Param;
using n9m.orbita.Constants;

namespace n9m.orbita.verify{

  public class Parameter extends Param{
      public static String S0 = "S0";
      private String s0;

      public Parameter(String s0) {
          this.s0 = s0;
      }

      public String getS0() {
          return s0;
      }

      public void setS0(String s0) {
          this.s0 = s0;
      }


  }
}
