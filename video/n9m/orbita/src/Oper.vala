using GLib;

namespace n9m.streamax{
/**
 * Операции в сообщениях
 */
public class Oper {
    public static string REQUEST_RESPONSE = "REQUEST-RESPONSE";
    private string name;
    private string type;

    public Oper(string name, string type){
        this.name = name;
        this.type = type;
    }

    /**
     * @return the name
     */
    public string getName() {
        return name;
    }

    /**
     * @param name the name to set
     */
    public void setName(string name) {
        this.name = name;
    }

    /**
     * @return the type
     */
    public string getType() {
        return type;
    }

    /**
     * @param type the type to set
     */
    public void setType(string type) {
        this.type = type;
    }
  }
}
