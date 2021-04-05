using GLib;
using n9m.orbita.Param;

namespace n9m.orbita.probe{

/**
 * Параметры операции Probe
 */
 public class Parameter extends Param{
    public static string VERSION = "VERSION";
    private string version;
    public Parameter(string version){
        super();
        this.version = version;
    }

    /**
     * @return the version
     */
    public string getVersion() {
        return version;
    }

    /**
     * @param version the version to set
     */
    public void setVersion(string version) {
        this.version = version;
    }
  }
}
