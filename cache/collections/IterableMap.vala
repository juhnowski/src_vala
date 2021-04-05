using Gee;
using cache.collections.iterators.MapIterator;

namespace cache.collections {

/**
 * Определяет map по которому можно перемещаться напрямую, без необходимости 
 * создавать набор записей.
 *
 * @author Илья Юхновский
 */
public interface IterableMap : Map {

    /**
     * Получить <code>MapIterator</code> по map.
     * 
     * @return итератор по map
     */
    MapIterator map_iterator();
    
}
}