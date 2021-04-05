using GLib;
using n9m.orbita.Oper;

namespace n9m.orbita.setvideoimage{
/**
 * Операция протокола SETVIDEOIMAGE
 */
 public class Operation extends Oper{
    public static final String SETVIDEOIMAGE = "SETVIDEOIMAGE";
    public Operation(){
        super(SETVIDEOIMAGE, Oper.REQUEST_RESPONSE);
    }
  }
}
