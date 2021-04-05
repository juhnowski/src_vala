package testapp;
import io.IOException;
import util.logging.FileHandler;
import util.logging.Level;
import static util.logging.Level.SEVERE;
import util.logging.Logger;
import util.logging.SimpleFormatter;
import property.PropertyValues;

/**
 * Главный класс приложения
 * @author Илья Юхновский
 */
public class TestApp {
    public static final Logger LOG = Logger.getLogger(TestApp.class.getName());
    private static FileHandler fh = null;
 
    public static int THREAD_POOL_SIZE = 4;
    public static String IN_PATH = "IN";
    public static String OUT_PATH = "OUT";
    public static String ERR_PATH = "ERR";
    public static String SWAP_PATH = "SWAP";
    public static String SP_PATH = "SP";
    public static String TMP_PATH="TMP";
    public static int TIME_TO_LIVE_IN_SECONDS = 60;
    public static int TIMER_INTERVAL_IN_SECONDS = 60;
    public static int MAX_CACHE_SIZE = 100;
    public static int WAIT_FILE_TIME = 100;
    public static int RUNTIME_MODE = 1;
    public static Level LOG_LEVEL=SEVERE;
    
    /**
     * @param args аргументы командной строки, пока не используются
     */
    public static void main(String[] args) {
        init();
        try {
            LOG.log( Level.SEVERE, "Старт тестового приложения" );
            WatchDir.start();
        } catch (IOException e) {
            LOG.log( Level.SEVERE, e.getMessage() );
        }
    }
    
    /**
     * Инициализация механизма логирования, конфигурационные параметры
     */
    public static void init() {
        try {
            fh=new FileHandler("TestApp.log", false);
        } catch (IOException ioe) {
            ioe.printStackTrace(System.out);
        } catch (SecurityException se) {
            se.printStackTrace(System.out);
        }
        
        fh.setFormatter(new SimpleFormatter());
        LOG.addHandler(fh);
        LOG.setLevel(LOG_LEVEL);
        
        PropertyValues prop = new PropertyValues();
        try{
            prop.getPropValues();
        } catch(IOException ioe){
            LOG.log( Level.SEVERE, ioe.getMessage() );
        } catch(IllegalArgumentException iae){
            LOG.log( Level.SEVERE, iae.getMessage() );
        }
        
    }
    
}
