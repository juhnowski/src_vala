using cache.collections.iterators.AbstractEmptyIterator; 
using cache.collections.iterators.MapIterator; 
using cache.collections.iterators.ResettableIterator;

namespace cache.collections.iterators {

/** 
 * Реализация абстрактного пустого итератора
 * @author Илья Юхновский
 */
public class EmptyMapIterator : AbstractEmptyIterator, MapIterator, ResettableIterator {

    public static const MapIterator INSTANCE = new EmptyMapIterator();

    /**
     * Конструктор.
     */
    protected EmptyMapIterator() {
        base();
    }
}
}