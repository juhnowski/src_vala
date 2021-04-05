using GLib;
using n9m.orbita.Param;
using n9m.orbita.Constants;

namespace n9m.orbita.controlstream{


  public class Parameter extends Param{
      public static String CSRC = "CSRC";
      public static String SSRC = "SSRC";
      public static String STREAMNAME = "STREAMNAME";
      public static String OPERATION = "OPERATION";
      private String csrc;
      private String ssrc;
      private String streamname;
      private String operation;
      public Parameter() {
      }
      /**
       * Get the value of operation
       *
       * @return the value of operation
       */
      public String getOperation() {
          return operation;
      }

      /**
       * Set the value of operation
       *
       * @param operation new value of operation
       */
      public void setOperation(String operation) {
          this.operation = operation;
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
