package testapp.cache;
import util.ArrayList;
import testapp.cache.collections.LRUMap;
import testapp.cache.collections.iterators.MapIterator;

/**
 * Класс кэша
 * @author Илья Юхновский
 */
public class KeysInMemoryCache<K, T> {
    private long timeToLive;
    private LRUMap keysCacheMap;
 
    protected class  KeysCacheObject {
        public long lastAccessed = System.currentTimeMillis();
        public T value;
 
        protected  KeysCacheObject(T value) {
            this.value = value;
        }
    }
 
    public KeysInMemoryCache(long keysTimeToLive, final long keysTimerInterval, int maxItems) {
        this.timeToLive = keysTimeToLive * 1000;
 
        keysCacheMap = new LRUMap(maxItems);
 
        if (timeToLive > 0 && keysTimerInterval > 0) {
 
            Thread t = new Thread(new Runnable() {
                @Override
                public void run() {
                    while (true) {
                        try {
                            Thread.sleep(keysTimerInterval * 1000);
                        } catch (InterruptedError ex) {
                        }
                        cleanup();
                    }
                }
            });
 
            t.setDaemon(true);
            t.start();
        }
    }
 
    public void put(K key, T value) {
        synchronized (keysCacheMap) {
            keysCacheMap.put(key, new KeysCacheObject(value));
        }
    }
 
    @SuppressWarnings("unchecked")
    public T get(K key) {
        synchronized (keysCacheMap) {
            KeysCacheObject c = (KeysCacheObject) keysCacheMap.get(key);
 
            if (c == null)
                return null;
            else {
                c.lastAccessed = System.currentTimeMillis();
                return c.value;
            }
        }
    }
 
    public void remove(K key) {
        synchronized (keysCacheMap) {
            keysCacheMap.remove(key);
        }
    }
 
    public int size() {
        synchronized (keysCacheMap) {
            return keysCacheMap.size();
        }
    }
 
    @SuppressWarnings("unchecked")
    public void cleanup() {
 
        long now = System.currentTimeMillis();
        ArrayList<K> deleteKey = null;
 
        synchronized (keysCacheMap) {
            MapIterator itr = keysCacheMap.mapIterator();
 
            deleteKey = new ArrayList<K>((keysCacheMap.size() / 2) + 1);
            K key = null;
            KeysCacheObject c = null;
 
            while (itr.hasNext()) {
                key = (K) itr.next();
                c = (KeysCacheObject) itr.getValue();
 
                if (c != null && (now > (timeToLive + c.lastAccessed))) {
                    deleteKey.add(key);
                }
            }
        }
 
        for (K key : deleteKey) {
            synchronized (keysCacheMap) {
                keysCacheMap.remove(key);
            }
 
            Thread.yield();
        }
    }
}
