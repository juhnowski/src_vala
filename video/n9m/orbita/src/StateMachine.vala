using GLib;

namespace n9m.streamax{
  /**
  * Конечный автомат
  */
  public class StateMachine {
    private Statable state;

    public void setState(Statable state){
        this.state = state;
    }

    public Statable getState(){
        return state;
    }
  }
}
