using cache.collections.iterators.AbstractEmptyIterator;
using cache.collections.iterators.OrderedIterator;
using cache.collections.iterators.ResettableIterator;

namespace cache.collections.iterators {

/** 
 * Реализация пустого упорядоченного итератора
 * 
 * @author Илья Юхновский
 */
public class EmptyOrderedIterator : AbstractEmptyIterator, OrderedIterator, ResettableIterator {

    public static const OrderedIterator INSTANCE = new EmptyOrderedIterator();

    /**
     * Конструктор.
     */
    protected EmptyOrderedIterator() {
        base();
    }
}
}