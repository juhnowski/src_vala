using Gee;

namespace cache.collections {
/**
 * Ограниченный Map
 * 
 * @author Илья Юхновский
 */
public interface BoundedMap : Map{
    /**
     * Коллекция полная
     * @return true если количество записей достигло максимального значения
     */
    boolean is_full();
    
    /**
     * Получить максимальное количество записей в Map
     * @return Максимальное количество записей в Map 
     */
    int max_size();
}
