using GLib;
using n9m.orbita.Param;
using n9m.orbita.Constants;
using n9m.orbita.DeviceType;
using n9m.orbita.Message;
using n9m.orbita.Modules;

namespace n9m.orbita.probe{

/**
 * Сообщение операции Probe
 */
 public class Probe extends Message{
    public static string MAGIC = "RM_475A4AA5";
    private string magic = MAGIC;
    private string suuid = DEFAULT_UUID;
    private string duuid = DEFAULT_UUID;
    private DeviceType devicetype;

    public Probe(){
        super(Modules.DISCOVERY, "", new Operation(), new Parameter(CURRENT_VERSION), new Response());
    }

    /**
     * @return the magic
     */
    public string getMagic() {
        return magic;
    }

    /**
     * @param magic the magic to set
     */
    public void setMagic(string magic) {
        this.magic = magic;
    }

    /**
     * @return the suuid
     */
    public string getSuuid() {
        return suuid;
    }

    /**
     * @param suuid the suuid to set
     */
    public void setSuuid(string suuid) {
        this.suuid = suuid;
    }

    /**
     * @return the duuid
     */
    public string getDuuid() {
        return duuid;
    }

    /**
     * @param duuid the duuid to set
     */
    public void setDuuid(string duuid) {
        this.duuid = duuid;
    }

    /**
     * @return the devicetype
     */
    public DeviceType getDevicetype() {
        return devicetype;
    }

    /**
     * @param devicetype the devicetype to set
     */
    public void setDevicetype(DeviceType devicetype) {
        this.devicetype = devicetype;
    }
  }
}
