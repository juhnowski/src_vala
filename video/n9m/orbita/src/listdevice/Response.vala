using GLib;
using n9m.orbita.Resp;
using n9m.orbita.Constants;

  namespace n9m.orbita.listdevice{

  public class Response extends Resp{

      public static final String S0 = "S0";
      private String s0 = DEFAULT_BOOLEAN;

      public static final String ERRCODE = "ERRCODE";
      private String Errcode = DEFAULT_INTEGER;

      public static final String ERRORCAUSE = "ERRORCAUSE";
      private String Errorcause = DEFAULT_BOOLEAN;

      public Response(){

      }
  }
}
