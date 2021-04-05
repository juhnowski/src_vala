namespace cache.collections {
/**
 * Определяет простую пару ключ-значение.
 * 
 * @author Илья Юхновский
 */
public interface KeyValue {

    /**
     * Получить ключ из пары.
     *
     * @return ключ 
     */
    Object get_key();

    /**
     * Получить значение из пары.
     *
     * @return значение
     */
    Object get_value();

}
}