using GLib;
using n9m.orbita.Param;
using n9m.orbita.Constants;

  namespace n9m.orbita.listdevice{

  public class Parameter extends Param{
      public static String USER = "USER";
      public static String PASSWORD = "PASSWORD";
      public static String MODE = "USER";
      public static String CID = "USER";
      public static String DSNO = "USER";
      public static String DEVNAME = "USER";
      public static String DEVCLASS = "USER";
      public static String PRO = "USER";
      public static String MAC = "USER";
      public static String CARNUM = "USER";
      public static String AUTOCAR = "USER";
      public static String UNAME = "USER";
      public static String NET = "USER";


      private String mode;
      private String cid;
      private String dsno;
      private String devname;
      private String devclass;
      private String pro;
      private String mac;
      private String carnum;
      private String autocar;
      private String uname;
      private String net;

      public Parameter(String mode, String cid, String dsno, String devname, String devclass, String pro, String mac, String carnum, String autocar, String uname, String net) {
          this.mode = mode;
          this.cid = cid;
          this.dsno = dsno;
          this.devname = devname;
          this.devclass = devclass;
          this.pro = pro;
          this.mac = mac;
          this.carnum = carnum;
          this.autocar = autocar;
          this.uname = uname;
          this.net = net;
      }

      public String getMode() {
          return mode;
      }

      public String getCid() {
          return cid;
      }

      public String getDsno() {
          return dsno;
      }

      public String getDevname() {
          return devname;
      }

      public String getDevclass() {
          return devclass;
      }

      public String getPro() {
          return pro;
      }

      public String getMac() {
          return mac;
      }

      public String getCarnum() {
          return carnum;
      }

      public String getAutocar() {
          return autocar;
      }

      public String getUname() {
          return uname;
      }

      public String getNet() {
          return net;
      }

      public void setMode(String mode) {
          this.mode = mode;
      }

      public void setCid(String cid) {
          this.cid = cid;
      }

      public void setDsno(String dsno) {
          this.dsno = dsno;
      }

      public void setDevname(String devname) {
          this.devname = devname;
      }

      public void setDevclass(String devclass) {
          this.devclass = devclass;
      }

      public void setPro(String pro) {
          this.pro = pro;
      }

      public void setMac(String mac) {
          this.mac = mac;
      }

      public void setCarnum(String carnum) {
          this.carnum = carnum;
      }

      public void setAutocar(String autocar) {
          this.autocar = autocar;
      }

      public void setUname(String uname) {
          this.uname = uname;
      }

      public void setNet(String net) {
          this.net = net;
      }


  }
}
