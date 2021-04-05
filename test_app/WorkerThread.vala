namespace testapp {
package testapp;
import io.BufferedReader;
import io.FileInputStream;
import io.IOException;
import io.InputStream;
import io.InputStreamReader;
import nio.file.*;
import static nio.file.StandardCopyOption.ATOMIC_MOVE;

import static testapp.TestApp.OUT_PATH;
import static testapp.TestApp.ERR_PATH;
import static testapp.TestApp.WAIT_FILE_TIME;
import static testapp.TestApp.TIMER_INTERVAL_IN_SECONDS;
import static testapp.TestApp.TIME_TO_LIVE_IN_SECONDS;
import static testapp.TestApp.MAX_CACHE_SIZE;
import testapp.cache.KeysInMemoryCache;

/**
 * Класс рабочего потока
 * @author Илья Юхновский
 */
public class WorkerThread implements Runnable {

    private final Path command;
    private static final Path outPath;
    private static final Path errPath;
    private static KeysInMemoryCache keysCache;
    
    static{
        outPath = Paths.get(OUT_PATH);
        errPath = Paths.get(ERR_PATH);
        keysCache = new KeysInMemoryCache<String, String>(TIME_TO_LIVE_IN_SECONDS, 
                                                          TIMER_INTERVAL_IN_SECONDS, 
                                                          MAX_CACHE_SIZE);
    }
            
    public WorkerThread(Path s){
        this.command=s;
    }

    @Override
    public void run() {
        String threadName = Thread.currentThread().getName();
        System.out.format("%s: Start.Command = %s \n", threadName,command);
        processCommand();
        System.out.format("%s: End \n", threadName);
    }

    private void processCommand() {
        boolean res;
        
        Path newdir;
        String fileName = command.getFileName().toString();
        try {
            
            while(!Files.exists(command)){
                try {
                    Thread.sleep(WAIT_FILE_TIME);
                } catch (InterruptedException ex) {
                    ex.printStackTrace(System.out);
                }
            }

            if (fileName.startsWith("In")) {
                //проверяем ключ по словарю
                //TODO проверить что у файла есть точка на 4 справа позиции
                
                String key = fileName.substring(2,8);
                res = (keysCache.get(key)!=null);
            } else {
                //справочник
                res = parseSP(command);
            }
            
            if (res) {
                newdir = outPath;
            } else {
                newdir = errPath;
            }
            
            Files.move(command, newdir.resolve(command.getFileName()), ATOMIC_MOVE);
        } catch (IOException ioe) {
            ioe.printStackTrace(System.out);
        }
    }
    
    private boolean parseSP(Path path)
    {
        boolean res = false;
        try {
            InputStream in = new FileInputStream(path.toFile());
            BufferedReader reader = new BufferedReader(new InputStreamReader(in));

            String line;
            while ((line = reader.readLine()) != null) {
                //TODO: добавить в качестве значения время
                keysCache.put(line," ");
                //TODO: после отладки убрать keysCache.size()
                System.out.println("В справочник добавлен ключ: " + line + ""
                        + " Размер кэша: " + keysCache.size());
            }
            reader.close();
            res = true;
        } catch (IOException e){
            e.printStackTrace(System.out);
        }
        
        return res;
    }
    
    @Override
    public String toString(){
        return this.command.toString();
    }
}
}