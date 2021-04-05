package testapp.cache.collections;

import io.Externalizable;
import io.ObjectInput;
import io.ObjectOutput;
import io.IOException;

import util.Collection;
import util.Collections;
import util.HashMap;
import util.Iterator;
import util.AbstractCollection;
import util.AbstractSet;
import util.ArrayList;
import util.List;
import util.Map;
import util.Set;
import util.NoSuchElementException;
import util.ConcurrentModificationException;

/**
 * Класс map который поддерживает порядок добавления записей в коллекцию
 * 
 * @author Илья Юхновский
 */
public class SequencedHashMap implements Map, Cloneable, Externalizable {

  /**
   *  Класс запись  
   **/
  private static class Entry implements Map.Entry {

    private final Object key;
    private Object value;
    
    Entry next = null;
    Entry prev = null;

    public Entry(Object key, Object value) {
      this.key = key;
      this.value = value;
    }

    @Override
    public Object getKey() { 
      return this.key; 
    }

    @Override
    public Object getValue() { 
      return this.value; 
    }

    @Override
    public Object setValue(Object value) { 
      Object oldValue = this.value;
      this.value = value; 
      return oldValue;
    }

    @Override
    public int hashCode() { 
      return ((getKey() == null ? 0 : getKey().hashCode()) ^
              (getValue()==null ? 0 : getValue().hashCode())); 
    }

    @Override
    public boolean equals(Object obj) {
      if(obj == null) return false;
      if(obj == this) return true;
      if(!(obj instanceof Map.Entry)) return false;

      Map.Entry other = (Map.Entry)obj;

      return((getKey() == null ?
              other.getKey() == null : 
              getKey().equals(other.getKey()))  &&
             (getValue() == null ?
              other.getValue() == null : 
              getValue().equals(other.getValue())));
    }
    @Override
    public String toString() {
      return "[" + getKey() + "=" + getValue() + "]";
    }
  }

  /**
   *  Постройте пустого стража, используемого, чтобы держать голову 
   * (sentinel.next) и хвост (sentinel.prev) списка. 
   **/
  private static Entry createSentinel() {
    Entry s = new Entry(null, null);
    s.prev = s;
    s.next = s;
    return s;
  }

  private Entry sentinel;
  private HashMap entries;

  /**
   *  Количество произведенных изменений в map
   **/
  private transient long modCount = 0;

  /**
   *  Конструктор с начальным размером и коэффициентом загрузки по умолчанию.
   **/
  public SequencedHashMap() {
    sentinel = createSentinel();
    entries = new HashMap();
  }

  /**
   *  Конструктор с начальным размером.
   *
   *  @param initialSize первоначальный размер для hash таблицы 
   **/
  public SequencedHashMap(int initialSize) {
    sentinel = createSentinel();
    entries = new HashMap(initialSize);
  }

  /**
   *  Конструктор с начальным размером и коэффициентом загрузки.
   *
   *  @param initialSize первоначальный размер 
   *  @param loadFactor коэффициентом загрузки.
   **/
  public SequencedHashMap(int initialSize, float loadFactor) {
    sentinel = createSentinel();
    entries = new HashMap(initialSize, loadFactor);
  }

  /**
   *  Конструктор создающий объект из другого map
     * @param m образец
   **/
  public SequencedHashMap(Map m) {
    this();
    putAll(m);
  }

  /**
   *  Удалить запиь из связанного списка.
   **/
  private void removeEntry(Entry entry) {
    entry.next.prev = entry.prev;
    entry.prev.next = entry.next;    
  }

  /**
   *  Вставить запись в связанный список.
   **/
  private void insertEntry(Entry entry) {
    entry.next = sentinel;
    entry.prev = sentinel.prev;
    sentinel.prev.next = entry;
    sentinel.prev = entry;
  }


  /**
   *  Реалзация {@link Map#size()}.
     * @return размер
   */
  @Override
  public int size() {
    // use the underlying Map's size since size is not maintained here.
    return entries.size();
  }

  /**
   *  Реализация {@link Map#isEmpty()}.
     * @return true если map пустой
   */
  @Override
  public boolean isEmpty() {
    return sentinel.next == sentinel;
  }

  /**
   *  Реализация {@link Map#containsKey(Object)}.
     * @param key ключ
     * @return true если существует запись с искомым ключом
   */
  @Override
  public boolean containsKey(Object key) {
    return entries.containsKey(key);
  }

  /**
   *  Реализция {@link Map#containsValue(Object)}.
     * @param value значение
     * @return true если искомое значение найдено
   */
  @Override
  public boolean containsValue(Object value) {

    if(value == null) {
      for(Entry pos = sentinel.next; pos != sentinel; pos = pos.next) {
        if(pos.getValue() == null) return true;
      } 
    } else {
      for(Entry pos = sentinel.next; pos != sentinel; pos = pos.next) {
        if(value.equals(pos.getValue())) return true;
      }
    }
    return false;      
  }

  /**
   *  Реализация {@link Map#get(Object)}.
     * @param o ключ
     * @return запись
   */
  @Override
  public Object get(Object o) {
    Entry entry = (Entry)entries.get(o);
    if(entry == null) return null;
      
    return entry.getValue();
  }

  /**
   *  Получить "старейшую" запись
   *
   *  @return Первая запись в последовательности, или <code>null</code> если
   *  map пустая.
   **/
  public Map.Entry getFirst() {
    return (isEmpty()) ? null : sentinel.next;
  }

  /**
   *  Получить ключ "старейшей" записи.
   *
   *  @return Первый ключ в последовательности, или <code>null</code> если
   *  map пустая.
   **/
  public Object getFirstKey() {
    return sentinel.next.getKey();
  }

  /**
   *  Получить значение "старейшей" записи.
   *
   *  @return Первое значение в последовательности, или <code>null</code> если
   *  map пустая.
   **/
  public Object getFirstValue() {
    return sentinel.next.getValue();
  }

  /**
   *  Получить "новейшую" запись.
   *
   *  @return Последняя запись в последовательности, или <code>null</code> если 
   *  map пустая.
   **/
  public Map.Entry getLast() {
    return (isEmpty()) ? null : sentinel.prev;
  }

  /**
   * Получить ключ "новейшей" записи.
   *
   * @return Ключ последней записи в последовательности, или <code>null</code> 
   * если map пустая.
   **/
  public Object getLastKey() {
    return sentinel.prev.getKey();
  }

  /**
   *  Получить значение "новейшей" записи.
   *
   *  @return Последнее значение в последовательности, или <code>null</code> 
   *  если map пустая.
   **/
  public Object getLastValue() {
    return sentinel.prev.getValue();
  }

  /**
   *  Реализация {@link Map#put(Object, Object)}.
     * @param key ключ
     * @param value значение
     * @return старая запись, если таковая имелась
   */
  @Override
  public Object put(Object key, Object value) {
    modCount++;

    Object oldValue = null;

    Entry e = (Entry)entries.get(key);

    if(e != null) {
      removeEntry(e);

      oldValue = e.setValue(value);

    } else {
      e = new Entry(key, value);
      entries.put(key, e);
    }

    insertEntry(e);

    return oldValue;
  }

  /**
   *  Реализация {@link Map#remove(Object)}.
     * @param key ключ
     * @return удаляемая запись
   */
  @Override
  public Object remove(Object key) {
    Entry e = removeImpl(key);
    return (e == null) ? null : e.getValue();
  }
  
  /**
   *  Полное удаление записи из map, возвращается удаляемая запись или  null
   *  если запись с искомым ключом не была найдена
   **/
  private Entry removeImpl(Object key) {
    Entry e = (Entry)entries.remove(key);
    if(e == null) return null;
    modCount++;
    removeEntry(e);
    return e;
  }

  /**
   *  Добавить все записи из одной map к этой map
   * 
   *  @param t добавляемая  map.
   *  @exception NullPointerException если <code>t</code> будет <code>null</code>
   **/
  @Override
  public void putAll(Map t) {
    Iterator iter = t.entrySet().iterator();
    while(iter.hasNext()) {
      Map.Entry entry = (Map.Entry)iter.next();
      put(entry.getKey(), entry.getValue());
    }
  }

  /**
   *  Реализация {@link Map#clear()}.
   */
  @Override
  public void clear() {
    modCount++;

    entries.clear();

    sentinel.next = sentinel;
    sentinel.prev = sentinel;
  }

  /**
   *  Реализация {@link Map#equals(Object)}.
     * @param obj объект для сравнения
     * @return true усли равны
   */
  @Override
  public boolean equals(Object obj) {
    if(obj == null) return false;
    if(obj == this) return true;

    if(!(obj instanceof Map)) return false;

    return entrySet().equals(((Map)obj).entrySet());
  }

  /**
   *  Реализация {@link Map#hashCode()}.
     * @return 
   */
  @Override
  public int hashCode() {
    return entrySet().hashCode();
  }

  /**
   *  Получить строковое представление
     * @return строка 
   **/
  @Override
  public String toString() {
    StringBuilder buf = new StringBuilder();
    buf.append('[');
    for(Entry pos = sentinel.next; pos != sentinel; pos = pos.next) {
      buf.append(pos.getKey());
      buf.append('=');
      buf.append(pos.getValue());
      if(pos.next != sentinel) {
        buf.append(',');
      }
    }
    buf.append(']');

    return buf.toString();
  }

  /**
   *  Реализация {@link Map#keySet()}.
     * @return набор ключей
   */
  @Override
  public Set keySet() {
    return new AbstractSet() {

      @Override
      public Iterator iterator() { 
          return new OrderedIterator(KEY); 
      }
      
      @Override
      public boolean remove(Object o) {
        Entry e = SequencedHashMap.this.removeImpl(o);
        return (e != null);
      }

      @Override
      public void clear() { 
        SequencedHashMap.this.clear(); 
      }
      
      @Override
      public int size() { 
        return SequencedHashMap.this.size(); 
      }
      
      @Override
      public boolean isEmpty() { 
        return SequencedHashMap.this.isEmpty(); 
      }
      
      @Override
      public boolean contains(Object o) { 
        return SequencedHashMap.this.containsKey(o);
      }
    };
  }

  /**
   *  Реализация {@link Map#values()}.
     * @return 
   */
  @Override
  public Collection values() {
    return new AbstractCollection() {

      @Override
      public Iterator iterator() { 
          return new OrderedIterator(VALUE); 
      }
      
      @Override
      public boolean remove(Object value) {
        if(value == null) {
          for(Entry pos = sentinel.next; pos != sentinel; pos = pos.next) {
            if(pos.getValue() == null) {
              SequencedHashMap.this.removeImpl(pos.getKey());
              return true;
            }
          } 
        } else {
          for(Entry pos = sentinel.next; pos != sentinel; pos = pos.next) {
            if(value.equals(pos.getValue())) {
              SequencedHashMap.this.removeImpl(pos.getKey());
              return true;
            }
          }
        }

        return false;
      }

      @Override
      public void clear() { 
        SequencedHashMap.this.clear(); 
      }
      
      @Override
      public int size() { 
        return SequencedHashMap.this.size(); 
      }
      
      @Override
      public boolean isEmpty() { 
        return SequencedHashMap.this.isEmpty(); 
      }
      
      @Override
      public boolean contains(Object o) {
        return SequencedHashMap.this.containsValue(o);
      }
    };
  }

  /**
   *  Реализация {@link Map#entrySet()}.
     * @return набор записей
   */
  @Override
  public Set entrySet() {
    return new AbstractSet() {

      private Entry findEntry(Object o) {
        if(o == null) return null;
        if(!(o instanceof Map.Entry)) return null;
        
        Map.Entry e = (Map.Entry)o;
        Entry entry = (Entry)entries.get(e.getKey());
        if(entry != null && entry.equals(e)) return entry;
        else return null;
      }


      @Override
      public Iterator iterator() { 
        return new OrderedIterator(ENTRY); 
      }
      
      @Override
      public boolean remove(Object o) {
        Entry e = findEntry(o);
        if(e == null) return false;

        return SequencedHashMap.this.removeImpl(e.getKey()) != null;
      }        

      @Override
      public void clear() { 
        SequencedHashMap.this.clear(); 
      }
      
      @Override
      public int size() { 
        return SequencedHashMap.this.size(); 
      }
      
      @Override
      public boolean isEmpty() { 
        return SequencedHashMap.this.isEmpty(); 
      }
      
      @Override
      public boolean contains(Object o) {
        return findEntry(o) != null;
      }
    };
  }

  private static final int KEY = 0;
  private static final int VALUE = 1;
  private static final int ENTRY = 2;
  private static final int REMOVED_MASK = 0x80000000;

  private class OrderedIterator implements Iterator {

    private int returnType;

    /**
     *  Содержит "текущую" позицию в итераторе.
     **/
    private Entry pos = sentinel;

    /**
     *  Количество модификаций.
     **/
    private transient long expectedModCount = modCount;
    
    /**
     *  Конструктор.
     **/
    public OrderedIterator(int returnType) {
      this.returnType = returnType | REMOVED_MASK;
    }

    /**
     *  Проверить наличие следующего элемента
     *
     *  @return <code>true</code> если в последовательности есть следующий 
     * элемент, иначе <code>false</code>.
     **/
    @Override
    public boolean hasNext() {
      return pos.next != sentinel;
    }

    /**
     *  Получить следующий элемент.
     *
     *  @return следующий элемент из итератора.
     *
     *  @exception NoSuchElementException следующий элемент не найден в итераторе.
     *  @exception ConcurrentModificationException конкурентное изменение.
     **/
    @Override
    public Object next() {
      if(modCount != expectedModCount) {
        throw new ConcurrentModificationException();
      }
      if(pos.next == sentinel) {
        throw new NoSuchElementException();
      }

      returnType = returnType & ~REMOVED_MASK;

      pos = pos.next;
      switch(returnType) {
      case KEY:
        return pos.getKey();
      case VALUE:
        return pos.getValue();
      case ENTRY:
        return pos;
      default:
        // should never happen
        throw new Error("bad iterator type: " + returnType);
      }

    }
    
    /**
     *  Удалить последний возвращенны методом {@link #next()} элемент из map.
     *
     *  @exception IllegalStateException если "последнего элемента" не существует.
     *  Это может случиться если метод {@link #next()} не вызывался, или если
     *  {@link #remove()} вызывается повторно.
     *
     *  @exception ConcurrentModificationException конкурентные изменения.
     **/
    @Override
    public void remove() {
      if((returnType & REMOVED_MASK) != 0) {
        throw new IllegalStateException("remove() вызывается только после next()");
      }
      if(modCount != expectedModCount) {
        throw new ConcurrentModificationException();
      }

      SequencedHashMap.this.removeImpl(pos.getKey());

      expectedModCount++;

      returnType = returnType | REMOVED_MASK;
    }
  }

  /**
   * Сделать неглубокое клонирование.
   *
   * @return Клон объекта.  
   *
   * @exception CloneNotSupportedException клонирование не поддерживается.
   */
  @Override
  public Object clone () throws CloneNotSupportedException {
    SequencedHashMap map = (SequencedHashMap)super.clone();

    map.sentinel = createSentinel();

    map.entries = new HashMap();
      
    map.putAll(this);

    return map;
  }

  /**
   *  Получить Map.Entry по заданному индексу
   *
   *  @exception ArrayIndexOutOfBoundsException если искомый индекс
   *  <code>&lt; 0</code> или <code>&gt;</code> размера map.
   **/
  private Map.Entry getEntry(int index) {
    Entry pos = sentinel;

    if(index < 0) {
      throw new ArrayIndexOutOfBoundsException(index + " < 0");
    }

    int i = -1;
    while(i < (index-1) && pos.next != sentinel) {
      i++;
      pos = pos.next;
    }

    if(pos.next == sentinel) {
      throw new ArrayIndexOutOfBoundsException(index + " >= " + (i + 1));
    }

    return pos.next;
  }

  /**
   * Получить ключ по индексу.
   *
     * @param index индекс <code>index</code>
     * @return ключ
   *  @exception ArrayIndexOutOfBoundsException если <code>index</code> будет
   *  <code>&lt; 0</code> или <code>&gt;</code> размера map.
   */
  public Object get (int index)
  {
    return getEntry(index).getKey();
  }

  /**
   * Получить значение по индексу.
   *
     * @param index индекс
     * @return значение
   *  @exception ArrayIndexOutOfBoundsException если <code>index</code> будет
   *  <code>&lt; 0</code> или <code>&gt;</code> размера map.
   */
  public Object getValue (int index)
  {
    return getEntry(index).getValue();
  }

  /**
   * Получить индекс по ключу.
     * @param key
     * @return индекс
   */
  public int indexOf (Object key)
  {
    Entry e = (Entry)entries.get(key);
    int pos = 0;
    while(e.prev != sentinel) {
      pos++;
      e = e.prev;
    }
    return pos;
  }

  /**
   * Получить итератор по ключам.
     * @return итератор
   */
  public Iterator iterator ()
  {
    return keySet().iterator();
  }

  /**
   * Получить последний индекс по ключу.
     * @param key ключ
     * @return индекс
   */
  public int lastIndexOf (Object key)
  {
    return indexOf(key);
  }

  /**
   * Получиь последовательность ключей.
   *
   * @see #keySet()
   * @return Упорядоченный список ключей.  
   */
  public List sequence()
  {
    List l = new ArrayList(size());
    Iterator iter = keySet().iterator();
    while(iter.hasNext()) {
      l.add(iter.next());
    }
      
    return Collections.unmodifiableList(l);
  }

  /**
   * Удалить элемент по индексу.
   *
   * @param index Индекс удаляемого элемента.
   * @return      Удаляемая запись, или <code>null</code> запись не существовала.
   *
   * @exception ArrayIndexOutOfBoundsException если <code>index</code> будет
   * <code>&lt; 0</code> или <code>&gt;</code> размера map.
   */
  public Object remove (int index)
  {
    return remove(get(index));
  }


  /**
   *  Десериализация map из заданного потока stream.
   *
   *  @param in входной поток
   *  @throws IOException исключения потока
   *  @throws ClassNotFoundException исключение потока
   */
  @Override
  public void readExternal( ObjectInput in ) 
    throws IOException, ClassNotFoundException 
  {
    int size = in.readInt();    
    for(int i = 0; i < size; i++)  {
      Object key = in.readObject();
      Object value = in.readObject();
      put(key, value);
    }
  }
  
  /**
   *  Сериализация map с выводом в поток stream.
   *
   *  @param out  выходной поток
   *  @throws IOException  исключения потока
   */
  @Override
  public void writeExternal( ObjectOutput out ) throws IOException {
    out.writeInt(size());
    for(Entry pos = sentinel.next; pos != sentinel; pos = pos.next) {
      out.writeObject(pos.getKey());
      out.writeObject(pos.getValue());
    }
  }
}
