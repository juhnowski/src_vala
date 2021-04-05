using GLib;

namespace n9m.streamax{
  /**
  * Сообщение протокола
  */
  public abstract class Message {

    public static string MAGIC = "RM_475A4AA5";

    private string module;
    private string session;
    private Oper operation;
    private Param parameter;
    private Resp response;

    public Message(string module,string session, Oper operation, Param parameter, Resp response){
        this.module = module;
        this.session = session;
        this.parameter = parameter;
        this.response = response;
    }

    /**
     * @return the module
     */
    public string getModule() {
        return module;
    }

    /**
     * @param module the module to set
     */
    public void setModule(string module) {
        this.module = module;
    }

    /**
     * @return the session
     */
    public string getSession() {
        return session;
    }

    /**
     * @param session the session to set
     */
    public void setSession(string session) {
        this.session = session;
    }

    /**
     * @return the operation
     */
    public Oper getOperation() {
        return operation;
    }

    /**
     * @param operation the operation to set
     */
    public void setOperation(Oper operation) {
        this.operation = operation;
    }

    /**
     * @return the parameter
     */
    public Param getParameter() {
        return parameter;
    }

    /**
     * @param parameter the parameter to set
     */
    public void setParameter(Param parameter) {
        this.parameter = parameter;
    }

    /**
     * @return the response
     */
    public Resp getResponse() {
        return response;
    }

    /**
     * @param response the response to set
     */
    public void setResponse(Resp response) {
        this.response = response;
    }
  }
}
