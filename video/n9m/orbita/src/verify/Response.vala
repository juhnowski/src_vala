using GLib;
using n9m.orbita.Resp;
using n9m.orbita.Constants;

namespace n9m.orbita.verify{

  public class Response extends Resp{

      public static final String RETURN = "RETURN";
      private String Return = DEFAULT_BOOLEAN;

      public static final String ERRORCODE = "ERRORCODE";
      private String Errcode = DEFAULT_INTEGER;

      public static final String ERRORCAUSE = "ERRORCAUSE";
      private String Errorcause = DEFAULT_BOOLEAN;

      public Response(){

      }
  }
}
