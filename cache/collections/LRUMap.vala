using Gee;
using cache.utils.Serializable; 
using cache.utils.Cloneable;
using cache.utils.errors.IOError;
using cache.io.ObjectInputStream;
using cache.io.ObjectOutputStream;
using cache.collections.AbstractLinkedMap;
using cache.collections.BoundedMap;

namespace cache.collections {

/**
 * Реализация Map с ограничением по размеру и устаревающими записями
 *
 * @author Илья Юхновский
 */
public class LRUMap : AbstractLinkedMap, BoundedMap, Serializable, Cloneable {
    
    /** Максимальный размер по умолчанию */
    protected static final int DEFAULT_MAX_SIZE = 100;
    
    /** Максимальный размер */
    private int maxSize;
    /** Поведение сканирования */
    private bool scanUntilRemovable;

    /**
     * Создать новую пустую map с максимальным числом записей 100.
     */
    public LRUMap() {
        LRUMap.with_maxSize_loadFactor_scanUntilRemovable(DEFAULT_MAX_SIZE, DEFAULT_LOAD_FACTOR, false);
    }

    /**
     * Создать новую пустую map с заданным максимальным размером.
     *
     * @param maxSize  максимальны размер map
     * @throws IllegalArgumentException если максимальный размер меньше 1
     */
    public LRUMap.with_maxSize(int maxSize) {
        LRUMap.with_maxSize_loadFactor(maxSize, DEFAULT_LOAD_FACTOR);
    }

    /**
     * Создать новую пустую map с заданным максимальным размером.
     *
     * @param maxSize  максимальны размер map
     * @param scanUntilRemovable  сканировать пока находятся удаляемые записи, по умолчанию false
     * @throws IllegalArgumentException если максимальный размер меньше 1
     */
    public LRUMap.with_maxSize_scanUntilRemovable(int maxSize, boolean scanUntilRemovable) {
        LRUMap.with_maxSize_loadFactor_scanUntilRemovable(maxSize, DEFAULT_LOAD_FACTOR, scanUntilRemovable);
    }

    /**
     * Создать новую пустую map c заданным первоначальным количеством ячеек и коэффициент заполнения. 
     *
     * @param maxSize  максимальный размер map
     * @param loadFactor  коэффициент заполнения
     * @throws IllegalArgumentException если максимальный размер меньше 1
     * @throws IllegalArgumentException если коэффициент заполнения меньше 0
     */
    public LRUMap.with_maxSize_loadFactor(int maxSize, float loadFactor) {
        LRUMap.with_maxSize_loadFactor_scanUntilRemovable(maxSize, loadFactor, false);
    }

    /**
     * Создать новую пустую map c заданным первоначальным количеством ячеек 
     * и коэффициент заполнения. 
     *
     * @param maxSize  максимальный размер map
     * @param loadFactor  коэффициент заполнения
     * @param scanUntilRemovable  сканировать пока находятся удаляемые записи, по умолчанию false
     * @throws IllegalArgumentException  если максимальный размер меньше 1
     * @throws IllegalArgumentException если коэффициент заполнения меньше 0
     */
    public LRUMap.with_maxSize_loadFactor_scanUntilRemovable(int maxSize, float loadFactor, boolean scanUntilRemovable) {
        base((maxSize < 1 ? DEFAULT_CAPACITY : maxSize), loadFactor);
        if (maxSize < 1) {
            throw new IllegalArgumentError.ERROR("Максимальный размер LRUMap должен быть больше 0");
        }
        this.maxSize = maxSize;
        this.scanUntilRemovable = scanUntilRemovable;
    }

    /**
     * Конструктор, копирующий элементы из другого map.
     * 
     * @param map  копируемая map
     * @throws NullPointerException если map null
     * @throws IllegalArgumentException если map пустая
     */
    public LRUMap(Map map) {
        LRUMap.with_maxSize_loadFactor(map, false);
    }

    /**
     * Конструктор, копирующий элементы из другой map.
     *
     * @param map  копируемая map
     * @param scanUntilRemovable  сканировать пока находятся удаляемые записи, по умолчанию false
     * @throws NullPointerException если map null
     * @throws IllegalArgumentException если map пустая
     */
    public LRUMap(Map map, boolean scanUntilRemovable) {
        LRUMap.with_maxSize_loadFactor_scanUntilRemovable(map.size(), DEFAULT_LOAD_FACTOR, scanUntilRemovable);
        putAll(map);
    }

    /**
     * Получить значение по ключу
     * 
     * @param key  ключ
     * @return значение, null если пара с таким ключом отсутствует
     */
    override public Object get(Object key) {
        LinkEntry entry = (LinkEntry) getEntry(key);
        if (entry == null) {
            return null;
        }
        moveToMRU(entry);
        return entry.getValue();
    }

    /**
     * Сдвинуть запись в конец списка.
     * 
     * @param entry  обновляемая запись
     */
    protected void moveToMRU(LinkEntry entry) {
        if (entry.after != header) {
            modCount++;
            // remove
            entry.before.after = entry.after;
            entry.after.before = entry.before;
            // add first
            entry.after = header;
            entry.before = header.before;
            header.before.after = entry;
            header.before = entry;
        } else if (entry == header) {
            throw new IllegalStateError.ERROR("Невозможно свдинуть заголовок");
        }
    }
    
    /**
     * Обновить существующую пару ключ-значение.
     * 
     * @param entry  обнавляемая записьthe entry to update
     * @param newValue  новая обновленная запись
     */
    override protected void updateEntry(HashEntry entry, Object newValue) {
        moveToMRU((LinkEntry) entry);  
        entry.setValue(newValue);
    }
    
    /**
     * Добавить новую пару ключ-значение в map.
     * 
     * @param hashIndex  индекс позиции для вставки
     * @param hashCode  hash код ключа добавляемой пары
     * @param key  добавляемый ключ
     * @param value  добавляемое значение
     */
    override protected void addMapping(int hashIndex, int hashCode, Object key, Object value) {
        if (isFull()) {
            LinkEntry reuse = header.after;
            boolean removeLRUEntry = false;
            if (scanUntilRemovable) {
                while (reuse != header && reuse != null) {
                    if (removeLRU(reuse)) {
                        removeLRUEntry = true;
                        break;
                    }
                    reuse = reuse.after;
                }
                if (reuse == null) {
                    throw new IllegalStateException(
                        "Entry.after=null, header.after" + header.after + " header.before" + header.before +
                        " key=" + key + " value=" + value + " size=" + size + " maxSize=" + maxSize);
                }
            } else {
                removeLRUEntry = removeLRU(reuse);
            }
            
            if (removeLRUEntry) {
                if (reuse == null) {
                    throw new IllegalStateException(
                        "reuse=null, header.after=" + header.after + " header.before" + header.before +
                        " key=" + key + " value=" + value + " size=" + size + " maxSize=" + maxSize);
                }
                reuseMapping(reuse, hashIndex, hashCode, key, value);
            } else {
                base.addMapping(hashIndex, hashCode, key, value);
            }
        } else {
            base.addMapping(hashIndex, hashCode, key, value);
        }
    }
    
    /**
     * Реиспользование записи.
     * 
     * @param entry  запись для реиспользования
     * @param hashIndex  индекс позиции
     * @param hashCode  hash код добавляемой записи
     * @param key  ключ добавляемой записи
     * @param value  значение добавляемой записи
     */
    protected void reuseMapping(LinkEntry entry, int hashIndex, int hashCode, Object key, Object value) {
        try {
            int removeIndex = hashIndex(entry.hashCode, data.length);
            HashEntry[] tmp = data;  
            HashEntry loop = tmp[removeIndex];
            HashEntry previous = null;
            while (loop != entry && loop != null) {
                previous = loop;
                loop = loop.next;
            }
            if (loop == null) {
                throw new IllegalStateException(
                    "Entry.next=null, data[removeIndex]=" + data[removeIndex] + " previous=" + previous +
                    " key=" + key + " value=" + value + " size=" + size + " maxSize=" + maxSize);
            }
            
            modCount++;
            removeEntry(entry, removeIndex, previous);
            reuseEntry(entry, hashIndex, hashCode, key, value);
            addEntry(entry, hashIndex);
        } catch (NullPointerException ex) {
            throw new IllegalStateException(
                    "NPE, entry=" + entry + " entryIsHeader=" + (entry==header) +
                    " key=" + key + " value=" + value + " size=" + size + " maxSize=" + maxSize );
        }
    }
    
    /**
     * Метод подклассов, контролирующий удаление устаревших записей.
     * 
     * @param entry  удаляемая запись
     * @return true
     */
    protected boolean removeLRU(LinkEntry entry) {
        return true;
    }


    /**
     * Возвращается true если эта map полная и новая запись не может быть добавлена.
     *
     * @return <code>true</code> если map полная
     */
    @Override
    public boolean isFull() {
        return (size >= maxSize);
    }

    /**
     * Получить максимальный размер map (границу).
     *
     * @return максимальное число элементов возможное для размещения в map
     */
    @Override
    public int maxSize() {
        return maxSize;
    }

    /**
     * Флаг LRUMap будет сканироваться до тех пор пока находятся удаляемые записи
     *
     * @return true если эта map сканируется
     */
    public boolean isScanUntilRemovable() {
        return scanUntilRemovable;
    }

    /**
     * Клонирование map без клонирования ключей и значений.
     *
     * @return неглубокий клон
     * @throws java.lang.CloneNotSupportedException клонирование не поддерживается
     */
    @Override
    public Object clone() throws CloneNotSupportedException {
        return super.clone();
    }
    
    /**
     * Запись map в поток.
     */
    private void writeObject(ObjectOutputStream out) throws IOException {
        out.defaultWriteObject();
        doWriteObject(out);
    }

    /**
     * Чтение map из потока.
     */
    private void readObject(ObjectInputStream in) throws IOException, ClassNotFoundException {
        in.defaultReadObject();
        doReadObject(in);
    }
    
    /**
     * Функция записи данных, необходимая для работы метода <code>put()</code> при десериализации.
     * @throws java.io.IOException
     */
    @Override
    protected void doWriteObject(ObjectOutputStream out) throws IOException {
        out.writeInt(maxSize);
        super.doWriteObject(out);
    }

    /**
     * Функция чтения данных, необходимая для работы метода <code>put()</code> в суперклассах.
     */
    protected void doReadObject(ObjectInputStream in) throws IOException, ClassNotFoundException {
        maxSize = in.readInt();
        super.doReadObject(in);
    }
    
}
}