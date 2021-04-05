using GLib;
using n9m.orbita.Resp;
using n9m.orbita.Constants;

namespace n9m.orbita.listserver{
  public class Response extends Resp{

      public static final String SIGNALSERVER = "SIGNALSERVER";
      private String Signalserver = DEFAULT_BOOLEAN;

      public static final String STREAMSERVER = "STREAMSERVER";
      private String Streamserver = DEFAULT_INTEGER;

      public static final String EVENTSERVER = "EVENTSERVER";
      private String Eventserver = DEFAULT_BOOLEAN;

      public Response(){

      }
  }
}
