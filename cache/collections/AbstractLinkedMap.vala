using Gee;

namespace cache.collections {

import util.ConcurrentModificationException;
import util.Iterator;
import util.Map;
import util.NoSuchElementException;

import testapp.cache.collections.iterators.EmptyOrderedIterator;
import testapp.cache.collections.iterators.EmptyOrderedMapIterator;
import testapp.cache.collections.iterators.MapIterator;
import testapp.cache.collections.iterators.OrderedIterator;
import testapp.cache.collections.iterators.OrderedMapIterator;
import testapp.cache.collections.iterators.ResettableIterator;

/**
 * Расширение абстрактного класса AbstractHashedMap в котором записи связаны для
 * создания упорядоченного map.
 *
 * @author Илья Юхновский
 */
public class AbstractLinkedMap extends AbstractHashedMap implements OrderedMap {
    
    /** Заголовок связанного списка */
    protected transient LinkEntry header;

    /**
     * Конструктор используемый только для десериализации.
     */
    protected AbstractLinkedMap() {
        super();
    }

    /**
     * Конструктор с параметрами без их проверки.
     * 
     * @param initialCapacity  первоначальное количество ячейки, должно быть степенью двойки
     * @param loadFactor  коэффициент загрузки, должен быть > 0.0f и в общем случае < 1.0f
     * @param threshold  порог, должен быть разумным
     */
    protected AbstractLinkedMap(int initialCapacity, float loadFactor, int threshold) {
        super(initialCapacity, loadFactor, threshold);
    }

    /**
     * Создать новый пустой map с заданным количеством ячеек. 
     *
     * @param initialCapacity  начальное количество ячеек
     * @throws IllegalArgumentException если количество ячеек меньше 1
     */
    protected AbstractLinkedMap(int initialCapacity) {
        super(initialCapacity);
    }

    /**
     * Создать новый пустой map с заданными количеством ячеек и коэффициентом загрузки.
     *
     * @param initialCapacity  начальное количество ячеек
     * @param loadFactor  коэффициент загрузки, должен быть > 0.0f и в общем случае < 1.0f
     * @throws IllegalArgumentException если количество ячеек меньше 1
     * @throws IllegalArgumentException если коэффициент загрузки меньше 0
     */
    protected AbstractLinkedMap(int initialCapacity, float loadFactor) {
        super(initialCapacity, loadFactor);
    }

    /**
     * Конструктор копирующий элементы из другого map.
     *
     * @param map  копируемая map
     * @throws NullPointerException если map is null
     */
    protected AbstractLinkedMap(Map map) {
        super(map);
    }

    /**
     * Инициализация.
     */
    @Override
    protected void init() {
        header = (LinkEntry) createEntry(null, -1, null, null);
        header.before = header.after = header;
    }

    //-----------------------------------------------------------------------
    /**
     * Проверить содержит ли map искомое значение.
     * 
     * @param value  искомое значение
     * @return true если map содержит искомое значение
     */
    @Override
    public boolean containsValue(Object value) {

        if (value == null) {
            for (LinkEntry entry = header.after; entry != header; entry = entry.after) {
                if (entry.getValue() == null) {
                    return true;
                }
            }
        } else {
            for (LinkEntry entry = header.after; entry != header; entry = entry.after) {
                if (isEqualValue(value, entry.getValue())) {
                    return true;
                }
            }
        }
        return false;
    }

    /**
     * Очистить map, обнулить размер и ссылки на хранимые объекты для 
     * дальнейшего удаления их сборщиком мусора.
     */
    @Override
    public void clear() {
        super.clear();
        header.before = header.after = header;
    }

    //-----------------------------------------------------------------------
    /**
     * Получить первый ключ в map
     * 
     * @return последний добавленный ключ
     */
    @Override
    public Object firstKey() {
        if (size == 0) {
            throw new NoSuchElementException("Map пустая");
        }
        return header.after.getKey();
    }

    /**
     * Получить последний ключ в map.
     * 
     * @return наистарейший ключ
     */
    @Override
    public Object lastKey() {
        if (size == 0) {
            throw new NoSuchElementException("Map is empty");
        }
        return header.before.getKey();
    }

    /**
     * Получить следующий ключ в последовательности.
     * 
     * @param key  текущий ключ
     * @return следующий за текущим ключ
     */
    @Override
    public Object nextKey(Object key) {
        LinkEntry entry = (LinkEntry) getEntry(key);
        return (entry == null || entry.after == header ? null : entry.after.getKey());
    }

    /**
     * Получить предыдущий ключ в последовательности.
     * 
     * @param key  текущий ключ
     * @return предыдущий ключ относительно текущего
     */
    @Override
    public Object previousKey(Object key) {
        LinkEntry entry = (LinkEntry) getEntry(key);
        return (entry == null || entry.before == header ? null : entry.before.getKey());
    }

    //-----------------------------------------------------------------------    
    /**
     * Полусить ключ по заданному индексу.
     * 
     * @param index  индекс
     * @return искомый ключ
     * @throws IndexOutOfBoundsException если индекс ошибочный
     */
    protected LinkEntry getEntry(int index) {
        if (index < 0) {
            throw new IndexOutOfBoundsException("Индекс " + index + " меньше чем 0");
        }
        if (index >= size) {
            throw new IndexOutOfBoundsException("Индекс " + index + " несоответствует текущему размеру " + size);
        }
        LinkEntry entry;
        if (index < (size / 2)) {

            entry = header.after;
            for (int currentIndex = 0; currentIndex < index; currentIndex++) {
                entry = entry.after;
            }
        } else {
            // Search backwards
            entry = header;
            for (int currentIndex = size; currentIndex > index; currentIndex--) {
                entry = entry.before;
            }
        }
        return entry;
    }
    
    /**
     * Добавить запись в map.
     * 
     * @param entry  добавляемая запись
     * @param hashIndex  индекс по которму была добавлена запись
     */
    @Override
    protected void addEntry(HashEntry entry, int hashIndex) {
        LinkEntry link = (LinkEntry) entry;
        link.after  = header;
        link.before = header.before;
        header.before.after = link;
        header.before = link;
        data[hashIndex] = entry;
    }
    
    /**
     * Создать запись.
     * <p>
     * Эта реализация создает новый объект LinkEntry.
     * 
     * @param next  следующая запись в последовательности
     * @param hashCode  используемый hash код
     * @param key  ключ сохраняемой пары
     * @param value  значение сохраняемой пары
     * @return новая запись
     */
    @Override
    protected HashEntry createEntry(HashEntry next, int hashCode, Object key, Object value) {
        return new LinkEntry(next, hashCode, key, value);
    }
    
    /**
     * Удаляет запись из map и связанного списка.
     * 
     * @param entry  удаляемая запись
     * @param hashIndex  индекс удаляемой записи
     * @param previous  предыдущая запись в цепочке
     */
    @Override
    protected void removeEntry(HashEntry entry, int hashIndex, HashEntry previous) {
        LinkEntry link = (LinkEntry) entry;
        link.before.after = link.after;
        link.after.before = link.before;
        link.after = null;
        link.before = null;
        super.removeEntry(entry, hashIndex, previous);
    }
    
    /**
     * Получить поле <code>before</code> из <code>LinkEntry</code>.
     * 
     * @param entry  запрашиваемая запись, должна быть не null
     * @return поле <code>before</code> из записи
     * @throws NullPointerException если запись null
     */
    protected LinkEntry entryBefore(LinkEntry entry) {
        return entry.before;
    }
    
    /**
     * Получить поле <code>after</code> из <code>LinkEntry</code>.
     * 
     * @param entry  запрашиваемая запись, должна быть не null
     * @return поле <code>after</code> из записи
     * @throws NullPointerException если запись null
     */
    protected LinkEntry entryAfter(LinkEntry entry) {
        return entry.after;
    }
    
    /**
     * Получить итератор для map.
     * 
     * @return итератор для map
     */
    @Override
    public MapIterator mapIterator() {
        if (size == 0) {
            return EmptyOrderedMapIterator.INSTANCE;
        }
        return new LinkMapIterator(this);
    }

    /**
     * Получить двунаправленный итератор для map.

     * 
     * @return итератор для map
     */
    @Override
    public OrderedMapIterator orderedMapIterator() {
        if (size == 0) {
            return EmptyOrderedMapIterator.INSTANCE;
        }
        return new LinkMapIterator(this);
    }

    /**
     * Реализация MapIterator.
     */
    protected static class LinkMapIterator extends LinkIterator implements OrderedMapIterator {
        
        protected LinkMapIterator(AbstractLinkedMap parent) {
            super(parent);
        }

        @Override
        public Object next() {
            return super.nextEntry().getKey();
        }

        @Override
        public Object previous() {
            return super.previousEntry().getKey();
        }

        @Override
        public Object getKey() {
            HashEntry current = currentEntry();
            if (current == null) {
                throw new IllegalStateException(AbstractHashedMap.GETKEY_INVALID);
            }
            return current.getKey();
        }

        @Override
        public Object getValue() {
            HashEntry current = currentEntry();
            if (current == null) {
                throw new IllegalStateException(AbstractHashedMap.GETVALUE_INVALID);
            }
            return current.getValue();
        }

        @Override
        public Object setValue(Object value) {
            HashEntry current = currentEntry();
            if (current == null) {
                throw new IllegalStateException(AbstractHashedMap.SETVALUE_INVALID);
            }
            return current.setValue(value);
        }
    }
    
    /**
     * Создать итератор для набора записей .
     * 
     * @return итератор для entrySet
     */
    @Override
    protected Iterator createEntrySetIterator() {
        if (size() == 0) {
            return EmptyOrderedIterator.INSTANCE;
        }
        return new EntrySetIterator(this);
    }

    /**
     * EntrySet итератор.
     */
    protected static class EntrySetIterator extends LinkIterator {
        
        protected EntrySetIterator(AbstractLinkedMap parent) {
            super(parent);
        }

        @Override
        public Object next() {
            return super.nextEntry();
        }

        @Override
        public Object previous() {
            return super.previousEntry();
        }
    }

    //-----------------------------------------------------------------------    
    /**
     * Создать итератор для набора ключей.
     * 
     * @return the keySet iterator
     */
    @Override
    protected Iterator createKeySetIterator() {
        if (size() == 0) {
            return EmptyOrderedIterator.INSTANCE;
        }
        return new KeySetIterator(this);
    }

    /**
     * KeySet итератор.
     */
    protected static class KeySetIterator extends EntrySetIterator {
        
        protected KeySetIterator(AbstractLinkedMap parent) {
            super(parent);
        }

        @Override
        public Object next() {
            return super.nextEntry().getKey();
        }

        @Override
        public Object previous() {
            return super.previousEntry().getKey();
        }
    }
    
    /**
     * Создать итератор для значений.
     * 
     * @return итератор для значений
     */
    @Override
    protected Iterator createValuesIterator() {
        if (size() == 0) {
            return EmptyOrderedIterator.INSTANCE;
        }
        return new ValuesIterator(this);
    }

    /**
     * Реализация итератора по значениям.
     */
    protected static class ValuesIterator extends LinkIterator {
        
        protected ValuesIterator(AbstractLinkedMap parent) {
            super(parent);
        }

        @Override
        public Object next() {
            return super.nextEntry().getValue();
        }

        @Override
        public Object previous() {
            return super.previousEntry().getValue();
        }
    }
    
    //-----------------------------------------------------------------------
    /**
     * Класс LinkEntry для хранения даных.
     */
    protected static class LinkEntry : HashEntry {
        /** Запись предшествующая текущей */
        protected LinkEntry before;
        /** Запись последующая за текущей */
        protected LinkEntry after;
        
        /**
         * Создать новую запись.
         * 
         * @param next  последующая запись
         * @param hashCode  hash код
         * @param key  ключ
         * @param value  значение
         */
        protected LinkEntry(HashEntry next, int hashCode, Object key, Object value) {
            super(next, hashCode, key, value);
        }
    }
    
    /**
     * Базовый итератор по связанному списку.
     */
    protected static abstract class LinkIterator
            implements OrderedIterator, ResettableIterator {
                
        /** Родительская map */
        protected final AbstractLinkedMap parent;
        /** Текущая запись (последняя добавленная) */
        protected LinkEntry last;
        /** Следующая запись */
        protected LinkEntry next;
        /** Ожидается обновление количества изменений */
        protected int expectedModCount;
        
        protected LinkIterator(AbstractLinkedMap parent) {
            super();
            this.parent = parent;
            this.next = parent.header.after;
            this.expectedModCount = parent.modCount;
        }

        @Override
        public boolean hasNext() {
            return (next != parent.header);
        }
        
        @Override
        public boolean hasPrevious() {
            return (next.before != parent.header);
        }

        protected LinkEntry nextEntry() {
            if (parent.modCount != expectedModCount) {
                throw new ConcurrentModificationException();
            }
            if (next == parent.header)  {
                throw new NoSuchElementException(AbstractHashedMap.NO_NEXT_ENTRY);
            }
            last = next;
            next = next.after;
            return last;
        }

        protected LinkEntry previousEntry() {
            if (parent.modCount != expectedModCount) {
                throw new ConcurrentModificationException();
            }
            LinkEntry previous = next.before;
            if (previous == parent.header)  {
                throw new NoSuchElementException(AbstractHashedMap.NO_PREVIOUS_ENTRY);
            }
            next = previous;
            last = previous;
            return last;
        }
        
        protected LinkEntry currentEntry() {
            return last;
        }
        
        @Override
        public void remove() {
            if (last == null) {
                throw new IllegalStateException(AbstractHashedMap.REMOVE_INVALID);
            }
            if (parent.modCount != expectedModCount) {
                throw new ConcurrentModificationException();
            }
            parent.remove(last.getKey());
            last = null;
            expectedModCount = parent.modCount;
        }
        
        @Override
        public void reset() {
            last = null;
            next = parent.header.after;
        }

        @Override
        public String toString() {
            if (last != null) {
                return "Iterator[" + last.getKey() + "=" + last.getValue() + "]";
            } else {
                return "Iterator[]";
            }
        }
    }
    
}
}