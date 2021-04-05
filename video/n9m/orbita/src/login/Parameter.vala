using GLib;
using n9m.orbita.Param;
using n9m.orbita.Constants;

  namespace n9m.orbita.login{

  public class Parameter extends Param{
      public static String USER = "USER";
      public static String PASSWD = "PASSWD";
      public static String MAC = "MAC";
      public static String CID = "CID";
      public static String LOGINTYPE = "LOGINTYPE";
      private String user;
      private String passwd;
      private String mac;
      private String cid;
      private String logintype;

      public Parameter(String user, String passwd, String mac, String cid, String logintype) {
          this.user = user;
          this.passwd = passwd;
          this.mac = mac;
          this.cid = cid;
          this.logintype = logintype;
      }

      public String getUser() {
          return user;
      }

      public String getPasswd() {
          return passwd;
      }

      public String getMac() {
          return mac;
      }

      public String getCid() {
          return cid;
      }

      public String getLogintype() {
          return logintype;
      }

      public void setUser(String user) {
          this.user = user;
      }

      public void setPasswd(String passwd) {
          this.passwd = passwd;
      }

      public void setMac(String mac) {
          this.mac = mac;
      }

      public void setCid(String cid) {
          this.cid = cid;
      }

      public void setLogintype(String logintype) {
          this.logintype = logintype;
      }

  }
}
