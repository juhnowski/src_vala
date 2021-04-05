using GLib;
using n9m.orbita.Param;
using n9m.orbita.Constants;

  namespace n9m.orbita.mediataskstop{

  public class Parameter extends Param{
      public static String CSRC = "CSRC";
      public static String PT = "PT";
      public static String SSRC = "SSRC";
      public static String ERRORCODE = "ERRORCODE";
      public static String ERRORCAUSE = "ERRORCAUSE";
      public static String STREAMNAME = "STREAMNAME";
      public static String IPANDPORT = "IPANDPORT";
      private String csrc;
      private String pt;
      private String ssrc;
      private String errorcode;
      private String errorcause;
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
       * Get the value of errorcause
       *
       * @return the value of errorcause
       */
      public String getErrorcause() {
          return errorcause;
      }

      /**
       * Set the value of errorcause
       *
       * @param errorcause new value of errorcause
       */
      public void setErrorcause(String errorcause) {
          this.errorcause = errorcause;
      }

      /**
       * Get the value of errorcode
       *
       * @return the value of errorcode
       */
      public String getErrorcode() {
          return errorcode;
      }

      /**
       * Set the value of errorcode
       *
       * @param errorcode new value of errorcode
       */
      public void setErrorcode(String errorcode) {
          this.errorcode = errorcode;
      }
      /**
       * Get the value of ssrc
       *
       * @return the value of ssrc
       */
      public String getSsrc() {
          return ssrc;
      }

      /**
       * Set the value of ssrc
       *
       * @param ssrc new value of ssrc
       */
      public void setSsrc(String ssrc) {
          this.ssrc = ssrc;
      }

      /**
       * Get the value of pt
       *
       * @return the value of pt
       */
      public String getPt() {
          return pt;
      }

      /**
       * Set the value of pt
       *
       * @param pt new value of pt
       */
      public void setPt(String pt) {
          this.pt = pt;
      }

      /**
       * Get the value of csrc
       *
       * @return the value of csrc
       */
      public String getCsrc() {
          return csrc;
      }

      /**
       * Set the value of csrc
       *
       * @param csrc new value of csrc
       */
      public void setCsrc(String csrc) {
          this.csrc = csrc;
      }
  }
}
