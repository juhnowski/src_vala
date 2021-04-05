package testapp;

import nio.file.*;
import static nio.file.StandardWatchEventKinds.*;
import nio.file.attribute.*;
import io.*;
import util.*;
import util.concurrent.ExecutorService;
import util.concurrent.Executors;
import util.logging.Level;

import static testapp.TestApp.THREAD_POOL_SIZE;
import static testapp.TestApp.IN_PATH;
import static testapp.TestApp.LOG;

/**
 * Класс слежения за папкой входящих сообщений
 * @author Илья Юхновский
 */
public class WatchDir {

    private final WatchService watcher;
    private final Map<WatchKey,Path> keys;
    private ExecutorService executor = Executors.newFixedThreadPool(THREAD_POOL_SIZE);

    @SuppressWarnings("unchecked")
    static <T> WatchEvent<T> cast(WatchEvent<?> event) {
        return (WatchEvent<T>)event;
    }

    /**
     * Регистрация директории для WatchService.
     */
    private void register(Path dir) throws IOException {
        // Решистрируем ключи событий, в начальной версии не отслеживаем  
        // ENTRY_DELETE, ENTRY_MODIFY
        WatchKey key = dir.register(watcher, ENTRY_CREATE );
        keys.put(key, dir);
    }

    /**
     * Регистрация директории для WatchService.
     */
    private void registerAll(final Path start) throws IOException {
        // Регистрируем директорию
        Files.walkFileTree(start, new SimpleFileVisitor<Path>() {
            @Override
            public FileVisitResult preVisitDirectory(Path dir, BasicFileAttributes attrs)
                throws IOException
            {
                register(dir);
                return FileVisitResult.CONTINUE;
            }
        });
    }

    /**
     * Создаем WatchService и регистрируем директорию
     */
    WatchDir(Path dir) throws IOException {
        this.watcher = FileSystems.getDefault().newWatchService();
        this.keys = new HashMap<WatchKey,Path>();
        register(dir);
    }

    /**
     * Обработчик всех событий помещенных в очередь
     */
    void processEvents() {
        for (;;) {

            WatchKey key;
            try {
                key = watcher.take();
            } catch (InterruptedException x) {
                LOG.log( Level.SEVERE, x.getMessage() );
                return;
            }

            Path dir = keys.get(key);
            if (dir == null) {
                LOG.log( Level.SEVERE, "Входной каталог не найден!" );
                continue;
            }

            for (WatchEvent<?> event: key.pollEvents()) {
                WatchEvent.Kind kind = event.kind();

                // TODO - подумать над обработчиком события OVERFLOW
                if (kind == OVERFLOW) {
                    continue;
                }

                WatchEvent<Path> ev = cast(event);
                Path name = ev.context();
                Path child = dir.resolve(name);

                // логируем событие
                if (kind == ENTRY_CREATE){
                   LOG.log( Level.FINEST, "{0}: {1}",new Object[]{event.kind().name(),child} );
                    Runnable worker = new WorkerThread(child);
                    executor.execute(worker);
                }
            }

            boolean valid = key.reset();
            if (!valid) {
                keys.remove(key);
                if (keys.isEmpty()) {
                    break;
                }
            }
        }
    }

    /**
     * 
     * @throws IOException 
     */
    public static void start() throws IOException {
        // флаг для рекурсивного просмотра каталогов
        Path dir = Paths.get(IN_PATH);
        new WatchDir(dir).processEvents();
        
    }
}