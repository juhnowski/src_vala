using GLib;
using n9m.orbita.Oper;

namespace n9m.orbita.connect{

public class Operation extends Oper{

    public static final String CONNECT="CONNECT";

    public Operation(){
        super(CONNECT,Oper.REQUEST_RESPONSE);
    }
}
}
