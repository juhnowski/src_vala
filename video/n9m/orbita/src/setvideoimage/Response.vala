using GLib;
using n9m.orbita.Resp;
using n9m.orbita.Constants;

namespace n9m.orbita.setvideoimage{

/**
 * Отклик операции SETVIDEOIMAGE
 */
 public class Response extends Resp{
    public static final string RETURN = "RETURN";
    private string Return = DEFAULT_BOOLEAN;

    /**
     * @return the Return
     */
    public string getReturn() {
        return Return;
    }

    /**
     * @param Return the Return to set
     */
    public void setReturn(string Return) {
        this.Return = Return;
    }
  }
}
