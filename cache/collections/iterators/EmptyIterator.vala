using cache.collection.iterators.ResettableIterator;

namespace cache.collections.iterators {


/** 
 * Реализация пустого итератора
 * 
 * @author Илья Юхновский
 */
public class EmptyIterator : AbstractEmptyIterator, ResettableIterator {

    public static const ResettableIterator RESETTABLE_INSTANCE = new EmptyIterator();
    public static const Iterator INSTANCE = RESETTABLE_INSTANCE;

    /**
     * Конструктор.
     */
    protected EmptyIterator() {
        base();
    }

}
}