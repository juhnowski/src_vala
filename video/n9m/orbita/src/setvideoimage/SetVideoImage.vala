using GLib;
using n9m.orbita.Message;
using n9m.orbita.Modules;

namespace n9m.orbita.setvideoimage{

/**
 * Сообщение операции SETVIDEOIMAGE
 */
 public class SetVideoImage extends Message{
    public SetVideoImage(){
        super(Modules.AVSTREAM, "", new Operation(), new Parameter(), new Response());
    }
  }
}
