package testapp.cache.collections;

import testapp.cache.collections.iterators.OrderedMapIterator;

/**
 * Определяет map поддерживающий порядок записей и позволяющий перемещаться в 
 * обе стороны, как вперед, так и назад.
 * 
 * @author Илья Юхновский
 */
public interface OrderedMap extends IterableMap {
    
    /**
     * Итератор <code>OrderedMapIterator</code> для map.
     * 
     * @return итератор по map
     */
    OrderedMapIterator orderedMapIterator();
    
    /**
     * Получить первый ключ map на текущий момент.
     *
     * @return первый ключ map на текущий момент
     * @throws java.util.NoSuchElementException если map пустая
     */
    public Object firstKey();

    /**
     * Получить последний ключ map на текущий момент.
     *
     * @return последний ключ map на текущий момент
     * @throws java.util.NoSuchElementException если map пустая
     */
    public Object lastKey();
    
    /**
     * Получить следующий по порядку, за переданным в функцию, ключ
     *
     * @param key  переданный ключ
     * @return следующий за переданным ключ
     */
    public Object nextKey(Object key);

    /**
     * Получить предыдущий по порядку, за переданным в функцию, ключ
     *
     * @param key  переданный ключ
     * @return предыдущий по порядку, за переданным в функцию, ключ
     */
    public Object previousKey(Object key);
    
}
