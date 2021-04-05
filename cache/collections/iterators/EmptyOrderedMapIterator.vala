using cache.collections.iterators.AbstractEmptyIterator; 
using cache.collections.iterators.OrderedMapIterator;
using cache.collections.iterators.ResettableIterator;

namespace cache.collections.iterators {

/** 
 * Реализация пустого упорядоченного итератора для Map
 * 
 * @author Илья Юхновский
 */
public class EmptyOrderedMapIterator : AbstractEmptyIterator, OrderedMapIterator, ResettableIterator {

    public static const OrderedMapIterator INSTANCE = new EmptyOrderedMapIterator();

    /**
     * Конструктор.
     */
    protected EmptyOrderedMapIterator() {
        base();
    }

}
}