using GLib;
using n9m.orbita.Param;
using n9m.orbita.Constants;

namespace n9m.orbita.connect{

/**
 *
 * @author gtkuser
 */
  public class Parameter extends Param{
      public static String USER = "USER";
      public static String PASSWORD = "PASSWORD";
      private String user;
      private String password;

      public Parameter(String user, String password) {
          this.user = user;
          this.password = password;
      }


      /**
       * @return the user
       */
      public String getUser() {
          return user;
      }

      public String getPassword() {
          return password;
      }

      /**
       * @param user the version to set
       */
      public void setUser(String user) {
          this.user = user;
      }

      public void setPassword(String password) {
          this.password = password;
      }

  }
}
