using cache.utils.errors.NoSuchElementException;
using cache.utils.errors.UnsupportedOperationException;
using cache.utils.errors.IllegalStateException;

namespace cache.collections.iterators {

/** 
 * Абстрактный класс пустого итератора
 * 
 * @author Илья Юхновский
 */
class AbstractEmptyIterator {
 
    /**
     * Конструктор
     */
    public AbstractEmptyIterator() {
        base();
    }

    public boolean has_next() {
        return false;
    }

    public Object next() throws NoSuchElementError {
		throw new NoSuchElementError.ERROR ("Итератор не сдержит элементов");
    }

    public boolean has_previous() {
        return false;
    }

    public Object previous() throws NoSuchElementError {
        throw new NoSuchElementException.ERROR("Итератор не сдержит элементов");
    }

    public int next_index() {
        return 0;
    }

    public int previous_index() {
        return -1;
    }

    public void add(Object obj) throws UnsupportedOperationException {
        throw new UnsupportedOperationException("метод add() не поддерживается для пустого итератора");
    }

    public void set(Object obj) throws IllegalStateException {
        throw new IllegalStateException("Итератор не сдержит элементов");
    }

    public void remove() throws IllegalStateException {
        throw new IllegalStateException("Итератор не сдержит элементов");
    }

    public Object get_key() throws IllegalStateException {
        throw new IllegalStateException("Итератор не сдержит элементов");
    }

    public Object get_value() throws IllegalStateException {
        throw new IllegalStateException("Итератор не сдержит элементов");
    }

    public Object set_value(Object value) throws IllegalStateException {
        throw new IllegalStateException("Итератор не сдержит элементов");
    }

    public void reset() {
        // ничего не делаем
    }
}
}