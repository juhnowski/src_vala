using Gee;

namespace cache.collections.iterators {

/**
 * Интерфейс уполрядоченного итератора
 *
 * @author Илья Юхновский
 */
public interface OrderedIterator : Iterator {

    /**
     * Проверить наличие предыдущей записи относительно текущей позиции
     * 
     * @return <code>true</code> если в итераторе есть предыдущий элемент 
     * относительно текущей позиции
     */
    boolean has_previous();

    /**
     * Получить предыдущий, относительно текущей позиции, элемент из коллекции.
     *
     * @return предыдущий, относительно текущей позиции, элемент
     * @throws java.util.NoSuchElementException если достигнут конец итератора
     */
    Object previous();
}
}