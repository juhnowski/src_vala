using GLib;
using n9m.orbita.AliveNet;
using n9m.orbita.Constants;
using n9m.orbita.Resp;

namespace n9m.orbita.probe{

/**
 * Отклик операции Probe
 */
public class Response extends Resp{

    public static final String RETURN = "RETURN";
    private String Return = DEFAULT_BOOLEAN;

    public static final String VERSION = "VERSION";
    private String Version = CURRENT_VERSION;

    private AliveNet aliveNet;

    public static final String WEBPORT="WEBPORT";


    public Response(){

    }
  }
}
