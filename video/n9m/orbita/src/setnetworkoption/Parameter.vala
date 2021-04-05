using GLib;
using n9m.orbita.Param;
using n9m.orbita.Constants;

namespace n9m.orbita.setnetworkoption{

  public class Parameter extends Param{
      public static String VERSION = "VERSION";
      public static String WEBPORT = "WEBPORT";
      public static String MEDIAPORT = "MEDIAPORT";
      public static String MOBILEPORT = "MOBILEPORT";
      private String version;
      private String webport;
      private String mediaport;
      private String mobileport;

      public Parameter(String version) {
          this.version = version;
      }


      /**
       * @return the version
       */
      public String getVersion() {
          return version;
      }
      public String getWebport() {
          return webport;
      }
      public String getMediaport() {
          return mediaport;
      }
      public String getMobileport() {
          return mobileport;
      }

      /**
       * @param version the version to set
       */
      public void setVersion(String version) {
          this.version = version;
      }
      public void setWebport(String webport) {
          this.webport = webport;
      }
      public void setMediaport(String mediaport) {
          this.mediaport = mediaport;
      }
      public void setMobileport(String mobileport) {
          this.mobileport = mobileport;
      }
  }
}
