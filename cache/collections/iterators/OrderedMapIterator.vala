using cache.collections.iterators.MapIterator;
using cache.collections.iterators.OrderedIterator;

namespace cache.collections.iterators{

/**
 * Интерфейс упорядоченного итератора для Map
 * Итератор поддерживает двунаправленное перемещение по итератору
 * 
 * @author Илья Юхновский
 */
public interface OrderedMapIterator : MapIterator, OrderedIterator {
    
    /**
     * Проверить наличие предыдущей записи относительно текущей позиции
     * 
     * @return <code>true</code> если в итераторе есть предыдущий элемент 
     * относительно текущей позиции
     */
    override boolean has_previous();

    /**
     * Получить предыдущий, относительно текущей позиции, элемент из коллекции.
     *
     * @return предыдущий, относительно текущей позиции, элемент
     * @throws java.util.NoSuchElementException если достигнут конец итератора
     */
    override Object previous();

}
}