using GLib;
using n9m.orbita.Oper;

namespace n9m.orbita.probe{
/**
 * Операция Probe
 */
 public class Operation extends Oper{

    public static final String PROBE="PROBE";

    public Operation(){
        super(PROBE,Oper.REQUEST_RESPONSE);
    }
  }
}
