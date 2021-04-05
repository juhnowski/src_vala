using Gee;
using testapp.cache.collections.AbstractMap;
using testapp.cache.collections.AbstractSet;
namespace testapp.cache.collections {

import io.IOException;
import io.ObjectInputStream;
import io.ObjectOutputStream;
import util.AbstractCollection;
import util.AbstractMap;
import util.AbstractSet;

using cache.utils.errors.ConcurrentModificationError;
using cache.utils.errors.NoSuchElementException;
using cache.collections.iterators.EmptyIterator;
using cache.collections.iterators.EmptyMapIterator;
using cache.collections.iterators.MapIterator;

/**
 * Абстрактная реализация класса HashedMap.
 * @author Илья Юхновский
 */
public class AbstractHashedMap : AbstractMap, IterableMap {
    
    protected static const String NO_NEXT_ENTRY = "Нет next()";
    protected static const String NO_PREVIOUS_ENTRY = "Нет previous()";
    protected static const String REMOVE_INVALID = "remove() должен вызываться "
            + "после next()";
    protected static const String GETKEY_INVALID = "getKey() должен вызываться "
            + "после next() и перед remove()";
    protected static const String GETVALUE_INVALID = "getValue() должен "
            + "вызываться после next() и перед remove()";
    protected static const String SETVALUE_INVALID = "setValue() должен "
            + "вызываться после next() и перед remove()";
    
    protected static const int DEFAULT_CAPACITY = 16;
    protected static const int DEFAULT_THRESHOLD = 12;
    protected static const float DEFAULT_LOAD_FACTOR = 0.75f;
    protected static constl int MAXIMUM_CAPACITY = 1 << 30;
    protected static const Object NULL = new Object();
    
    protected float loadFactor;
    protected int size;
    protected HashEntry[] data;
    protected int threshold;
    protected int modCount;
    protected EntrySet entrySet;
    protected KeySet keySet;
    protected Values values;

    /**
     * Конструктор. Использовать только для десериализации.
     */
    protected AbstractHashedMap() {
        base();
    }

    /**
     * Конструктор с определением количества ячеек, коэффициент заполнения и порогом, без валидации.
     * @param initialCapacity  количество ячеек, должна быть степень 2
     * @param loadFactor  коэффициент заполнения, должен быть &gt; 0.0f и как правило &lt; 1.0f
     * @param threshold  порог, должно быть разумным
     */
    protected AbstractHashedMap.with_initialCapacity_loadFactor_threshold(int _initialCapacity, float _loadFactor, int _threshold) {
        base();
        loadFactor = _loadFactor;
        data = new HashEntry[_initialCapacity];
        threshold = _threshold;
        init();
    }

    /**
     * Конструктор с определением начального количества ячеек.
     *
     * @param initialCapacity  количество ячеек, должна быть степени 2
     * @throws IllegalArgumentError если начальное количество значений 1
     */
    protected AbstractHashedMap.with_initialCapacity(int initialCapacity) throws IllegalArgumentError {
        AbstractHashedMap.with_initialCapacity_loadFactor(initialCapacity, DEFAULT_LOAD_FACTOR);
    }

    /**
     * Конструктор с определением количества ячеек, коэффициентом заполнения
     * и порогом, с проверкой устанавливаемых конструктором значений.
     * 
     * @param initialCapacity  количество значений,должна быть степени 2
     * @param loadFactor  коэффициент заполнения, должен быть &gt; 0.0f и как правило &lt; 1.0f
     * @throws IllegalArgumentException если начальное количества ячеек меньше 1
     * @throws IllegalArgumentException если коэффициент заполнения меньше или равен 0
     */
    protected AbstractHashedMap.with_initialCapacity_loadFactor(int _initialCapacity, float _loadFactor) throws IllegalArgumentError{
        base();
        if (_initialCapacity < 1) {
            throw new IllegalArgumentError.ERROR("Начальное количества ячеек должна быть больше чем  0");
        }
        if (_loadFactor <= 0.0f || Float.isNaN(_loadFactor)) {
            throw new IllegalArgumentError.ERROR("Коэффициент заполнения должен быть больше чем 0");
        }
        loadFactor = _loadFactor;
        initialCapacity = calculate_new_capacity(_initialCapacity);
        threshold = calculate_threshold(_initialCapacity, _loadFactor);
        data = new HashEntry[_initialCapacity];
        init();
    }

    /**
     * Конструктор копирующий элементы из другого map.
     *
     * @param map  map для копирования
     * @throws NullPointerException если map нулевой
     */
    protected AbstractHashedMap(Map map) {
        this(Math.max(2 * map.size(), DEFAULT_CAPACITY), DEFAULT_LOAD_FACTOR);
        putAll(map);
    }

    /**
     * Инициализация подклассов во время создания, клонирования или десериализации.
     */
    protected void init() {
    }


    /**
     * Получить значение по ключу.
     * 
     * @param key  ключ
     * @return the значение, null если не найдено
     */
    override public Object get(Object key) {
        key = convert_key(key);
        int hashCode = hash(key);
        HashEntry entry = data[hashIndex(hashCode, data.length)];
        while (entry != null) {
            if (entry.hash_code == hashCode && is_equal_key(key, entry.key)) {
                return entry.get_value();
            }
            entry = entry.next;
        }
        return null;
    }

    /**
     * Получить размер map.
     * 
     * @return размер
     */
    override public int size() {
        return size;
    }

    /**
     * Проверить пустой ли map на текущий момент.
     * 
     * @return true если размер map на данный момент 0
     */
    override public bool is_empty() {
        return (size == 0);
    }

    //-----------------------------------------------------------------------
    /**
     * Проверить содержит ли map искомый ключ. Поиск ключа в map.
     * 
     * @param key искомый ключ
     * @return true если map содержит искомый ключ
     */
    override public boolean contains_key(Object key) {
        key = convert_key(key);
        int hashCode = hash(key);
        HashEntry entry = data[hashIndex(hashCode, data.length)];
        while (entry != null) {
            if (entry.hashCode == hashCode && is_equal_key(key, entry.key)) {
                return true;
            }
            entry = entry.next;
        }
        return false;
    }

    /**
     * Проверить содержит ли map искомое значение. Поиск значения в map.
     * 
     * @param value искомое значение
     * @return true если map содержит искомое значение
     */
    override public boolean contains_value(Object value) {
        if (value == null) {
            for (int i = 0, isize = data.length; i < isize; i++) {
                HashEntry entry = data[i];
                while (entry != null) {
                    if (entry.get_value() == null) {
                        return true;
                    }
                    entry = entry.next;
                }
            }
        } else {
            for (int i = 0, isize = data.length; i < isize; i++) {
                HashEntry entry = data[i];
                while (entry != null) {
                    if (is_equal_value(value, entry.get_value())) {
                        return true;
                    }
                    entry = entry.next;
                }
            }
        }
        return false;
    }

    //-----------------------------------------------------------------------
    /**
     * Поместить пару ключ-значение в map.
     * 
     * @param key  ключ добавляемой пары
     * @param value значение добавляемой пары
     * @return ранее присвоенное значение для данного ключа, null если пара с 
     * таким ключом впервые размещается в map.
     */
    override public Object put(Object key, Object value) {
        key = convert_key(key);
        int hashCode = hash(key);
        int index = hash_index(hashCode, data.length);
        HashEntry entry = data[index];
        while (entry != null) {
            if (entry.hashCode == hashCode && is_equal_key(key, entry.key)) {
                Object oldValue = entry.get_value();
                update_entry(entry, value);
                return oldValue;
            }
            entry = entry.next;
        }
        
        add_mapping(index, hashCode, key, value);
        return null;
    }

    /**
     * Копировать все записи из map в текущую.
     * 
     * @param map  the map to add
     * @throws NullPointerException if the map is null
     */
    override public void put_all(Map map) {
        int mapSize = map.size();
        if (mapSize == 0) {
            return;
        }
        int newSize = (int) ((size + mapSize) / loadFactor + 1);
        ensure_capacity(calculate_new_capacity(newSize));
        for (Iterator it = map.entry_set().iterator(); it.has_next();) {
            Map.Entry entry = (Map.Entry) it.next();
            put(entry.get_key(), entry.get_value());
        }
    }

    /**
     * Удалить запись из map.
     * 
     * @param key ключ удаляемой записи
     * @return возвращает значение удаляемой записи по заданному ключу, 
     * null если запись по заданному ключу не найдена
     */
    override public Object remove(Object key) {
        key = convert_key(key);
        int hashCode = hash(key);
        int index = hash_index(hashCode, data.length);
        HashEntry entry = data[index];
        HashEntry previous = null;
        while (entry != null) {
            if (entry.hashCode == hashCode && is_equal_key(key, entry.key)) {
                Object oldValue = entry.get_value();
                remove_mapping(entry, index, previous);
                return oldValue;
            }
            previous = entry;
            entry = entry.next;
        }
        return null;
    }

    /**
     * Очистить map, сбросить размер в 0 и обнулить ссылки для удаления хранимых
     * объектов сборщиком мусора.
     */
    override public void clear() {
        modCount++;
        HashEntry[] data = this.data;
        for (int i = data.length - 1; i >= 0; i--) {
            data[i] = null;
        }
        size = 0;
    }

    //-----------------------------------------------------------------------
    /**
     * Конвертирует введенный ключ в другой объект для хранения в map.
     * 
     * @param key  ключ на конвертацию
     * @return сконвертированный ключ
     */
    protected Object convert_key(Object key) {
        return (key == null ? NULL : key);
    }
    
    /**
     * Получить hash код для заданного ключа.
     * 
     * @param key значение ключа
     * @return hash код
     */
    protected int hash(Object key) {
        int h = key.hash_code();
        h += ~(h << 9);
        h ^=  (h >>> 14);
        h +=  (h << 4);
        h ^=  (h >>> 10);
        return h;
    }
    
    /**
     * Сравнить два ключа.
     * 
     * @param key1  первый ключ
     * @param key2  второй ключ
     * @return true если равны
     */
    protected bool is_equal_key(Object key1, Object key2) {
        return (key1 == key2 || key1.equals(key2));
    }
    
    /**
     * Сравнить два значения.
     * 
     * @param value1  первое значение
     * @param value2  второе значение
     * @return true если равны
     */
    protected bool is_equal_value(Object value1, Object value2) {
        return (value1 == value2 || value1.equals(value2));
    }
    
    /**
     * Получить индекс в хранилище данных для определенного hashCode.
     * 
     * @param hashCode  hash код
     * @param dataSize  размер данных
     * @return индекс
     */
    protected int hash_index(int hashCode, int dataSize) {
        return hashCode & (dataSize - 1);
    }
    
    /**
     * Получить запись пары по клбчу
     * 
     * @param key  ключ
     * @return запись, null если запись с таким ключом ненайдена
     */
    protected HashEntry get_entry(Object key) {
        key = convert_key(key);
        int hashCode = hash(key);
        HashEntry entry = data[hash_index(hashCode, data.length)]; 
        while (entry != null) {
            if (entry.hashCode == hashCode && is_equal_key(key, entry.key)) {
                return entry;
            }
            entry = entry.next;
        }
        return null;
    }

    /**
     * Обновляет существущее значение записи пары
     * 
     * @param entry  запись для обновления
     * @param newValue  the new value to store
     */
    protected void update_entry(HashEntry entry, Object newValue) {
        entry.set_value(newValue);
    }
    
    /**
     * Реиспользовать существующий мапинг, сохранение полностью новых данных.
     * 
     * @param entry  запись для обновления, не null
     * @param hashIndex  индекс в массиве данных
     * @param hashCode  hash код добавляемого ключа
     * @param key  ключ добавляемой пары
     * @param value  значение добавляемой пары
     */
    protected void reuse_entry(HashEntry entry, int hashIndex, int hashCode, Object key, Object value) {
        entry.next = data[hashIndex];
        entry.hashCode = hashCode;
        entry.key = key;
        entry.value = value;
    }
    
    /**
     * Добавить новый мапинг в map.
     * 
     * @param hashIndex  индекс под которым сохранить
     * @param hashCode  hash код ключа
     * @param key  ключ добавляемой пары
     * @param value  значение добавляемой пары
     */
    protected void add_mapping(int hashIndex, int hashCode, Object key, Object value) {
        modCount++;
        HashEntry entry = create_entry(data[hashIndex], hashCode, key, value);
        add_entry(entry, hashIndex);
        size++;
        check_capacity();
    }
    
    /**
     * Созать запись для сохранения пары ключ-значени.
     * 
     * @param next  следующая запись в последовательности
     * @param hashCode  использовать hash код
     * @param key  ключ добавляемой пары
     * @param value  значение добавляемой пары
     * @return вновь созданная запись
     */
    protected HashEntry create_entry(HashEntry next, int hashCode, Object key, Object value) {
        return new HashEntry(next, hashCode, key, value);
    }
    
    /**
     * Добавить запись в map.
     *
     * @param entry  добавляемая запись
     * @param hashIndex  индекс под которым сохранена запись в массиве
     */
    protected void add_entry(HashEntry entry, int hashIndex) {
        data[hashIndex] = entry;
        
    }
    
    /**
     * Удалить мапинг из map.
     * 
     * @param entry  удаляемая запись
     * @param hashIndex  индекс в структуре данных
     * @param previous  предыдущая запись в цепочке
     */
    protected void remove_mapping(HashEntry entry, int hashIndex, HashEntry previous) {
        modCount++;
        remove_entry(entry, hashIndex, previous);
        size--;
        destroy_entry(entry);
    }
    
    /**
     * Удалить запись из цепочки по заданному индексу.
     * 
     * @param entry  удаляемая запись
     * @param hashIndex  индекс в структуре данных
     * @param previous  предыдущая запись в цепочке
     */
    protected void remove_entry(HashEntry entry, int hashIndex, HashEntry previous) {
        if (previous == null) {
            data[hashIndex] = entry.next;
        } else {
            previous.next = entry.next;
        }
    }
    
    /**
     * Подготовить запись к удалению сборщиком мусора
     * 
     * @param entry  разрушаемая запись
     */
    protected void destroy_entry(HashEntry entry) {
        entry.next = null;
        entry.key = null;
        entry.value = null;
    }
    
    /**
     * Проверить количество ячеек map и увеличть при необходимости.
     */
    protected void check_capacity() {
        if (size >= threshold) {
            int newCapacity = data.length * 2;
            if (newCapacity <= MAXIMUM_CAPACITY) {
                ensure_capacity(newCapacity);
            }
        }
    }
    
    /**
     * Изменить размер структуры данных в соответствии с новым значением 
     * количества ячеек map .
     * 
     * @param newCapacity  новое количество ячеек в map (степеь двойки и меньше 
     * или равно максимаолно возможному значению для целого)
     */
    protected void ensure_capacity(int newCapacity) {
        int oldCapacity = data.length;
        if (newCapacity <= oldCapacity) {
            return;
        }
        if (size == 0) {
            threshold = calculate_threshold(newCapacity, loadFactor);
            data = new HashEntry[newCapacity];
        } else {
            HashEntry oldEntries[] = data;
            HashEntry newEntries[] = new HashEntry[newCapacity];

            modCount++;
            for (int i = oldCapacity - 1; i >= 0; i--) {
                HashEntry entry = oldEntries[i];
                if (entry != null) {
                    oldEntries[i] = null;  // gc
                    do {
                        HashEntry next = entry.next;
                        int index = hash_index(entry.hashCode, newCapacity);  
                        entry.next = newEntries[index];
                        newEntries[index] = entry;
                        entry = next;
                    } while (entry != null);
                }
            }
            threshold = calculate_threshold(newCapacity, loadFactor);
            data = newEntries;
        }
    }

    /**
     * Вычисляет новое количество ячеек для map.
     * 
     * @param proposedCapacity  предполагаемое новое количество ячеек
     * @return нормализованное новое количество ячеек для map
     */
    protected int calculate_new_capacity(int proposedCapacity) {
        int newCapacity = 1;
        if (proposedCapacity > MAXIMUM_CAPACITY) {
            newCapacity = MAXIMUM_CAPACITY;
        } else {
            while (newCapacity < proposedCapacity) {
                newCapacity <<= 1;  
            }
            if (newCapacity > MAXIMUM_CAPACITY) {
                newCapacity = MAXIMUM_CAPACITY;
            }
        }
        return newCapacity;
    }
    
    /**
     * Вычисляет новый порог для map, при достижении которого количество ячеек 
     * должно быть увеличено
     * 
     * @param newCapacity  новое количество ячеек
     * @param factor  коэффициент заполнения
     * @return новое пороговое значение
     */
    protected int calculate_threshold(int newCapacity, float factor) {
        return (int) (newCapacity * factor);
    }
    
    /**
     * Получить следующую запись.
     * 
     * @param entry  запрос, не должен быть null
     * @return следующая запись
     * @throws NullPointerException если запись null
     */
    protected HashEntry entry_next(HashEntry entry) {
        return entry.next;
    }
    
    /**
     * Получить поле <code>hashCode</code> из <code>HashEntry</code>.
     * 
     * @param entry  запись запроса, не должна быть null
     * @return поле <code>hashCode</code> из записи
     * @throws NullPointerException если запись null
     */
    protected int entry_hash_code(HashEntry entry) {
        return entry.hashCode;
    }
    
    /**
     * Получить поле <code>key</code> из <code>HashEntry</code>.
     * 
     * @param entry  запись запроса, не должна быть null
     * @return поле <code>key</code> из записи
     * @throws NullPointerException если запись null
     */
    protected Object entry_key(HashEntry entry) {
        return entry.key;
    }
    
    /**
     * Получить поле <code>value</code> из <code>HashEntry</code>.
     * 
     * @param entry  запись запроса, не должна быть null
     * @return поле <code>value</code> из записи
     * @throws NullPointerException если запись null
     */
    protected Object entry_value(HashEntry entry) {
        return entry.value;
    }
    
    /**
     * Получить итератор для map.
     * 
     * @return the map iterator
     */
    @Override
    public MapIterator map_iterator() {
        if (size == 0) {
            return EmptyMapIterator.INSTANCE;
        }
        return new HashMapIterator(this);
    }

    /**
     * Реализация MapIterator.
     */
    protected static class HashMapIterator : HashIterator, MapIterator {
        
        protected HashMapIterator(AbstractHashedMap parent) {
            base(parent);
        }

        override public Object next() {
            return base.nextEntry().getKey();
        }

        override public Object get_key() throws IllegalStateError{
            HashEntry current = current_entry();
            if (current == null) {
                throw new IllegalStateError.ERROR(AbstractHashedMap.GETKEY_INVALID);
            }
            return current.get_key();
        }

        override public Object get_value() throws IllegalStateError{
            HashEntry current = current_entry();
            if (current == null) {
                throw new IllegalStateError.ERROR(AbstractHashedMap.GETVALUE_INVALID);
            }
            return current.get_value();
        }

        override public Object set_value(Object value) throws IllegalStateError{
            HashEntry current = current_entry();
            if (current == null) {
                throw new IllegalStateError(AbstractHashedMap.SETVALUE_INVALID);
            }
            return current.setValue(value);
        }
    }
    
    /**
     * Получить набор хранимых записей entrySet.
     * 
     * @return набор хранимых записей entrySet
     */
    override public Set entry_set() {
        if (entrySet == null) {
            entrySet = new EntrySet(this);
        }
        return entrySet;
    }
    
    /**
     * Создать итератор для набора записей.
     * Subclasses can override this to return iterators with different properties.
     * 
     * @return итератор для entrySet
     */
    protected Iterator create_entry_set_iterator() {
        if (size() == 0) {
            return EmptyIterator.INSTANCE;
        }
        return new EntrySetIterator(this);
    }

    /**
     * Реализация EntrySet.
     */
    protected static class EntrySet : AbstractSet {
        /** Родительский map */
        protected const AbstractHashedMap parent;
        
        protected EntrySet(AbstractHashedMap parent) {
            base();
            this.parent = parent;
        }

        override public int size() {
            return parent.size();
        }
        
        override public void clear() {
            parent.clear();
        }
        
        override public bool contains(Object entry) {
            if (entry instanceof Map.Entry) {
                Map.Entry e = (Map.Entry) entry;
                Entry match = parent.get_entry(e.get_key());
                return (match != null && match.equals(e));
            }
            return false;
        }
        
        override public bool remove(Object obj) {
            if (obj instanceof Map.Entry == false) {
                return false;
            }
            if (contains(obj) == false) {
                return false;
            }
            Map.Entry entry = (Map.Entry) obj;
            Object key = entry.get_key();
            parent.remove(key);
            return true;
        }

        override public Iterator iterator() {
            return create_entry_set_iterator(); //parent.
        }
    }

    /**
     * EntrySet итератор.
     */
    protected static class EntrySetIterator extends HashIterator {
        
        protected EntrySetIterator(AbstractHashedMap parent) {
            base(parent);
        }

        override public Object next() {
            return base.next_entry();
        }
    }

    /**
     * Получить представление набора ключей keySet для map.
     * 
     * @return представление набора ключей
     */
    override public Set key_set() {
        if (keySet == null) {
            keySet = new KeySet(this);
        }
        return keySet;
    }

    /**
     * Создать итератор для набора ключей.
     * 
     * @return итерато для keySet
     */
    protected Iterator create_key_set_iterator() {
        if (size() == 0) {
            return EmptyIterator.INSTANCE;
        }
        return new KeySetIterator(this);
    }

    /**
     * Реализация KeySet.
     */
    protected static class KeySet : AbstractSet {
        /** The parent map */
        protected const AbstractHashedMap parent;
        
        protected KeySet(AbstractHashedMap _parent) {
            base();
            parent = parent;
        }

        override public int size() {
            return parent.size();
        }
        
        override public void clear() {
            parent.clear();
        }
        
        override public bool contains(Object key) {
            return parent.contains_key(key);
        }
        
        override public bool remove(Object key) {
            boolean result = parent.contains_key(key);
            parent.remove(key);
            return result;
        }

        override public Iterator iterator() {
            return parent.create_key_set_iterator();
        }
    }

    /**
     * Итератор для KeySet.
     */
    protected static class KeySetIterator : EntrySetIterator {
        
        protected KeySetIterator(AbstractHashedMap parent) {
            base(parent);
        }

        override public Object next() {
            return base.next_entry().get_key();
        }
    }
    
    /**
     * Получить значения из map.
     * 
     * @return значения
     */
    override public Collection values() {
        if (values == null) {
            values = new Values(this);
        }
        return values;
    }

    /**
     * Создать итератор по значениям.
     * 
     * @return the values iterator
     */
    protected Iterator create_values_iterator() {
        if (size() == 0) {
            return EmptyIterator.INSTANCE;
        }
        return new ValuesIterator(this);
    }

    /**
     * Values implementation.
     */
    protected static class Values : AbstractCollection {
        /** The parent map */
        protected const AbstractHashedMap parent;
        
        protected Values(AbstractHashedMap _parent) {
            base();
            parent = _parent;
        }

        override public int size() {
            return parent.size();
        }
        
        override public void clear() {
            parent.clear();
        }
        
        override public bool contains(Object value) {
            return parent.contains_value(value);
        }
        
        override
        public Iterator iterator() {
            return parent.create_values_iterator();
        }
    }

    /**
     * Итератор по значениям.
     */
    protected static class ValuesIterator : HashIterator {
        
        protected ValuesIterator(AbstractHashedMap parent) {
            base(parent);
        }

        override public Object next() {
            return base.next_entry().get_value();
        }
    }
    
    /**
     * Класс HashEntry используемый для хранения данных.
     */
    protected static class HashEntry : Map.Entry, KeyValue {
        /** Следуюая запись в hash цепочке */
        protected HashEntry next;
        /** hash код ключа */
        protected int hashCode;
        /** Ключ */
        protected Object key;
        /** Значение */
        protected Object value;
        
        protected HashEntry(HashEntry _next, int _hashCode, Object _key, Object _value) {
            base();
            next = _next;
            hashCode = _hashCode;
            key = _key;
            value = _value;
        }
        
        override public Object get_key() {
            return (key == NULL ? null : key);
        }
        
        override public Object get_value() {
            return value;
        }
        
        override public Object set_value(Object _value) {
            Object old = value;
            value = _value;
            return old;
        }
        
        override public boolean equals(Object obj) {
            if (obj == this) {
                return true;
            }
            if (obj instanceof Map.Entry == false) {
                return false;
            }
            Map.Entry other = (Map.Entry) obj;
            return
                (get_key() == null ? other.get_key() == null : get_key().equals(other.get_key())) &&
                (get_value() == null ? other.get_value() == null : get_value().equals(other.get_value()));
        }
        
        override public int hash_code() {
            return (get_key() == null ? 0 : get_key().hash_code()) ^
                   (get_value() == null ? 0 : get_value().hash_code()); 
        }
        
        override public string to_string() {
			string key = get_key().to_string();
			string value = get_value().to_string();
			string s = @"$key = $value";
            return s;
        }
    }
    
    /**
     * Базовый итератор
     */
    protected static abstract class HashIterator : Iterator {
        
        /** Родительская map */
        protected const AbstractHashedMap parent;
        /** Текущий индекс в массиве */
        protected int hashIndex;
        /** Последняя возвращаемая запись */
        protected HashEntry last;
        /** Следующая запись */
        protected HashEntry next;
        /** Ожидается количество модификации*/
        protected int expectedModCount;
        
        protected HashIterator(AbstractHashedMap _parent) {
            base();
            parent = _parent;
            HashEntry[] data = parent.data;
            int i = data.length;
            HashEntry _next = null;
            while (i > 0 && next == null) {
                next = data[--i];
            }
            this.next = _next;
            this.hashIndex = i;
            this.expectedModCount = parent.modCount;
        }

        override public boolean has_next() {
            return (next != null);
        }

        protected HashEntry next_entry() throws ConcurrentModificationError,NoSuchElementError{ 
            if (parent.modCount != expectedModCount) {
                throw new ConcurrentModificationError.ERROR();
            }
            HashEntry newCurrent = next;
            if (newCurrent == null)  {
                throw new NoSuchElementError.ERROR(AbstractHashedMap.NO_NEXT_ENTRY);
            }
            HashEntry[] data = parent.data;
            int i = hashIndex;
            HashEntry n = newCurrent.next;
            while (n == null && i > 0) {
                n = data[--i];
            }
            next = n;
            hashIndex = i;
            last = newCurrent;
            return newCurrent;
        }

        protected HashEntry current_entry() {
            return last;
        }
        
        override public void remove() throws IllegalStateError, ConcurrentModificationError{
            if (last == null) {
                throw new IllegalStateError.ERROR(AbstractHashedMap.REMOVE_INVALID);
            }
            if (parent.modCount != expectedModCount) {
                throw new ConcurrentModificationError();
            }
            parent.remove(last.getKey());
            last = null;
            expectedModCount = parent.modCount;
        }

        override public String to_string() {
            if (last != null) {
				string key = last.get_key();
				string value = last.get_value();
                return @"Iterator[ $key = $value]";
            } else {
                return "Iterator[]";
            }
        }
    }
    
    //-----------------------------------------------------------------------
    /**
     * Запись данных map в поток stream.
     * 
     * @param out  выходной поток
     * @throws java.io.IOException ошибки потока
     */
    protected void do_write_object(ObjectOutputStream out) throws IOError {
        out.write_float(loadFactor);
        out.write_int(data.length);
        out.write_int(size);
        for (MapIterator it = map_iterator(); it.has_next();) {
            out.write_object(it.next());
            out.write_object(it.get_value());
        }
    }

    /**
     * Чтение данных map из потока stream.
     * 
     * @param in  входной поток
     * @throws java.io.IOException ошибки потока
     * @throws java.lang.ClassNotFoundException
     */
    protected void do_read_object(ObjectInputStream in) throws IOError, ClassNotFoundError {
        loadFactor = in.readFloat();
        int capacity = in.readInt();
        int size = in.readInt();
        init();
        threshold = calculateThreshold(capacity, loadFactor);
        data = new HashEntry[capacity];
        for (int i = 0; i < size; i++) {
            Object key = in.readObject();
            Object value = in.readObject();
            put(key, value);
        }
    }
    
    //-----------------------------------------------------------------------
    /**
     * Клонирование map без клонирования ключей и значений.
     *
     * @return неглубокий клон
     * @throws java.lang.CloneNotSupportedException клонирование не поддерживается
     */
    @Override
    protected Object clone() throws CloneNotSupportedException {
        try {
            AbstractHashedMap cloned = (AbstractHashedMap) super.clone();
            cloned.data = new HashEntry[data.length];
            cloned.entrySet = null;
            cloned.keySet = null;
            cloned.values = null;
            cloned.modCount = 0;
            cloned.size = 0;
            cloned.init();
            cloned.putAll(this);
            return cloned;
            
        } catch (CloneNotSupportedException ex) {
            return null;  // should never happen
        }
    }
    
    /**
     * Сравнение этого map с другим.
     * 
     * @param obj  объект для сравнения
     * @return true если равны
     */
    @Override
    public boolean equals(Object obj) {
        if (obj == this) {
            return true;
        }
        if (obj instanceof Map == false) {
            return false;
        }
        Map map = (Map) obj;
        if (map.size() != size()) {
            return false;
        }
        MapIterator it = mapIterator();
        try {
            while (it.hasNext()) {
                Object key = it.next();
                Object value = it.getValue();
                if (value == null) {
                    if (map.get(key) != null || map.containsKey(key) == false) {
                        return false;
                    }
                } else {
                    if (value.equals(map.get(key)) == false) {
                        return false;
                    }
                }
            }
        } catch (ClassCastException ignored)   {
            return false;
        } catch (NullPointerException ignored) {
            return false;
        }
        return true;
    }

    /**
     * Получить hashCode стандартного Map.
     * 
     * @return hash код определенный в стандартном Map интерфейсе
     */
    @Override
    public int hashCode() {
        int total = 0;
        Iterator it = createEntrySetIterator();
        while (it.hasNext()) {
            total += it.next().hashCode();
        }
        return total;
    }

    /**
     * Получить представление map как String.
     * 
     * @return a string version of the map
     */
    @Override
    public String toString() {
        if (size() == 0) {
            return "{}";
        }
        StringBuilder buf = new StringBuilder(32 * size());
        buf.append('{');

        MapIterator it = mapIterator();
        boolean hasNext = it.hasNext();
        while (hasNext) {
            Object key = it.next();
            Object value = it.getValue();
            buf.append(key == this ? "(this Map)" : key)
               .append('=')
               .append(value == this ? "(this Map)" : value);

            hasNext = it.hasNext();
            if (hasNext) {
                buf.append(',').append(' ');
            }
        }

        buf.append('}');
        return buf.toString();
    }
}
}