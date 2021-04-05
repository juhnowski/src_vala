using GLib;
using n9m.orbita.Param;
using n9m.orbita.Constants;

namespace n9m.orbita.createstream{

  public class Parameter extends Param{

      public static String VISION = "VISION";
      public static String DEVTYPE = "DEVTYPE";
      public static String STREAMNAME = "STREAMNAME";
      public static String IPANDPORT = "IPANDPORT";
      private String vision;
      private String devtype;
      private String streamname;
      private String ipandport;
      public Parameter(){

      }
      /**
       * Get the value of ipandport
       *
       * @return the value of ipandport
       */
      public String getIpandport() {
          return ipandport;
      }

      /**
       * Set the value of ipandport
       *
       * @param ipandport new value of ipandport
       */
      public void setIpandport(String ipandport) {
          this.ipandport = ipandport;
      }

      /**
       * Get the value of streamname
       *
       * @return the value of streamname
       */
      public String getStreamname() {
          return streamname;
      }

      /**
       * Set the value of streamname
       *
       * @param streamname new value of streamname
       */
      public void setStreamname(String streamname) {
          this.streamname = streamname;
      }

      /**
       * Get the value of devtype
       *
       * @return the value of devtype
       */
      public String getDevtype() {
          return devtype;
      }

      /**
       * Set the value of devtype
       *
       * @param devtype new value of devtype
       */
      public void setDevtype(String devtype) {
          this.devtype = devtype;
      }

      /**
       * Get the value of vision
       *
       * @return the value of vision
       */
      public String getVision() {
          return vision;
      }

      /**
       * Set the value of vision
       *
       * @param vision new value of vision
       */
      public void setVision(String vision) {
          this.vision = vision;
      }

  }
}
