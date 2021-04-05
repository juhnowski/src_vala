using GLib;
using n9m.orbita.Resp;
using n9m.orbita.Constants;

  namespace n9m.orbita.login{

  public class Response extends Resp{

      public static final String RETURN = "RETURN";
      private String Return = DEFAULT_BOOLEAN;

      public static final String ERRORCODE = "ERRORCODE";
      private String Errcode = DEFAULT_INTEGER;

      public static final String ERRORCAUSE = "ERRORCAUSE";
      private String Errorcause = DEFAULT_BOOLEAN;

      public static final String DSN0 = "DSN0";
      private String Dsn0 = DEFAULT_BOOLEAN;

      public static final String DEVNAME = "DEVNAME";
      private String Devname = DEFAULT_BOOLEAN;

      public static final String CHANNEL = "CHANNEL";
      private String Channel = DEFAULT_BOOLEAN;

      public static final String UID = "UID";
      private String Uid = DEFAULT_BOOLEAN;

      public static final String ALARMIN = "ALARMIN";
      private String Alarmin = DEFAULT_BOOLEAN;

      public Response(){

      }
  }
}
