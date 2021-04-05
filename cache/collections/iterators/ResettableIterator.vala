using Gee;

namespace cache.collections.iterators {

/** 
 * Итератор реализующий восстановление к первоначальному состоянию.
 */
public interface ResettableIterator: Iterator {

    /**
     * Сбрасывает итератор в исходное состояние.
     */
    public void reset();

}
}