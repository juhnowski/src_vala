using GLib;
using n9m.orbita.Param;
using n9m.orbita.Constants;

namespace n9m.orbita.setvideoimage{

/**
 * Параметры операции SETVIDEOIMAGE
 */
 public class Parameter extends Param{
    public static final string CHANNEL = "CHANNEL";
    public static final string BRIGHTNESS = "BRIGHTNESS";
    public static final string CONTRAST = "CONTRAST";
    public static final string SATURATION = "SATURATION";
    public static final string HUE = "HUE";

    private string channel = DEFAULT_INTEGER;
    private string brightness = DEFAULT_INTEGER;
    private string contrast = DEFAULT_INTEGER;
    private string saturation = DEFAULT_INTEGER;
    private string hue = DEFAULT_INTEGER;

    public Parameter(){
      
    }
    /**
     * @return the channel
     */
    public string getChannel() {
        return channel;
    }

    /**
     * @param channel the channel to set
     */
    public void setChannel(string channel) {
        this.channel = channel;
    }

    /**
     * @return the brightness
     */
    public string getBrightness() {
        return brightness;
    }

    /**
     * @param brightness the brightness to set
     */
    public void setBrightness(string brightness) {
        this.brightness = brightness;
    }

    /**
     * @return the contrast
     */
    public string getContrast() {
        return contrast;
    }

    /**
     * @param contrast the contrast to set
     */
    public void setContrast(string contrast) {
        this.contrast = contrast;
    }

    /**
     * @return the saturation
     */
    public string getSaturation() {
        return saturation;
    }

    /**
     * @param saturation the saturation to set
     */
    public void setSaturation(string saturation) {
        this.saturation = saturation;
    }

    /**
     * @return the hue
     */
    public string getHue() {
        return hue;
    }

    /**
     * @param hue the hue to set
     */
    public void setHue(string hue) {
        this.hue = hue;
    }
  }
}
