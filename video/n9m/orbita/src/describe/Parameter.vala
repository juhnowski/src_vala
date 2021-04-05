using GLib;
using n9m.orbita.Param;
using n9m.orbita.Constants;

namespace n9m.orbita.describe{

  public class Parameter extends Param{

      private static String XML;
      private String xml;
      /**
       * Get the value of xml
       *
       * @return the value of xml
       */
       public Parameter(){

       }
      public String getXml() {
          return xml;
      }

      /**
       * Set the value of XML
       *
       * @param xml new value of XML
       */
      public void setXml(String XML) {
          this.xml = xml;
      }

  }
}
