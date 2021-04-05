using Gee;
using cache.utils.errors.FileNotFoundError;
using cache.utils.errors.IOError;
using cache.io.InputStream;
using cache.io.file.Path;
using cache.io.file.Paths;
using property.Properties;
namespace cache.property{
	


import static testapp.TestApp.THREAD_POOL_SIZE;
import static testapp.TestApp.OUT_PATH;
import static testapp.TestApp.ERR_PATH;
import static testapp.TestApp.IN_PATH;
import static testapp.TestApp.SWAP_PATH;
import static testapp.TestApp.SP_PATH;
import static testapp.TestApp.TMP_PATH;
import static testapp.TestApp.TIME_TO_LIVE_IN_SECONDS;
import static testapp.TestApp.TIMER_INTERVAL_IN_SECONDS;
import static testapp.TestApp.MAX_CACHE_SIZE;
import static testapp.TestApp.WAIT_FILE_TIME;
import static testapp.TestApp.RUNTIME_MODE; 

import java.util.logging.Level;
import static testapp.TestApp.LOG_LEVEL;

/**
 * Вспомогательный класс для работы с конфигурационными настройками
 * @author Илья Юхновский
 */
public class PropertyValues {
    private static final HashMap<String,Level> MAP_LOG_LEVELS = new HashMap();
    private String configPath = "config.properties";;
 
    static{
        MAP_LOG_LEVELS.put("SEVERE", Level.SEVERE);
        MAP_LOG_LEVELS.put("WARNING", Level.WARNING);
        MAP_LOG_LEVELS.put("INFO", Level.INFO);
        MAP_LOG_LEVELS.put("CONFIG", Level.CONFIG);
        MAP_LOG_LEVELS.put("FINE", Level.FINE);
        MAP_LOG_LEVELS.put("FINER", Level.FINER);
        MAP_LOG_LEVELS.put("FINEST", Level.FINEST);
    };
    
    /**
     * Конструктор
     */
    public PropertyValues(){
    }
    
    /**
     * Конструктор, с путем к конфигурационному файлу
     */
    public PropertyValues(String configPath){
        if(configPath.length()>0){
            this.configPath = configPath;
        }
    }
    
    /**
     * Получить настройки из конфигурационного файла
     * @throws IOException исключения потока ввода/вывода
     * @throws java.io.FileNotFoundException если не найден конфигурационный файл
     * @throws IllegalArgumentException ошибки конфигурационного файла
     */
    public void getPropValues() throws IOException, FileNotFoundException, IllegalArgumentException {

		Properties prop = new Properties();
                
		InputStream inputStream = getClass().getClassLoader().getResourceAsStream(configPath);
                System.out.println(configPath);
		if (inputStream != null) {
			prop.load(inputStream);
		} else {
			throw new FileNotFoundException("конфигурационный файл '" + configPath + "' не найден в classpath");
		}
 
                setThreadPoolSize(prop.getProperty("THREAD_POOL_SIZE"));
                setInPath(prop.getProperty("IN_PATH"));
                setOutPath(prop.getProperty("OUT_PATH"));
                setErrPath(prop.getProperty("ERR_PATH"));
                setSwapPath(prop.getProperty("SWAP_PATH"));
                setSpPath(prop.getProperty("SP_PATH"));
                setTmpPath(prop.getProperty("TMP_PATH"));

                setTimeToLiveInSeconds(prop.getProperty("TIME_TO_LIVE_IN_SECONDS"));
                setTimerIntervalInSeconds(prop.getProperty("TIMER_INTERVAL_IN_SECONDS"));
                setMaxCacheSize(prop.getProperty("MAX_CACHE_SIZE"));
                setWaitFileTime(prop.getProperty("WAIT_FILE_TIME"));
                setRuntimeMode(prop.getProperty("RUNTIME_MODE"));
                setLogLevel(prop.getProperty("LOG_LEVEL"));
                inputStream.close();
	}
    
    /**
     * Установка количества потоков обработки.
     * По умолчанию 4.
     * @param threadPoolSize размер пула потоков
     * @throws IllegalArgumentException значение должно быть больше 0
     */
    public void setThreadPoolSize(String threadPoolSize) throws IllegalArgumentException{
        THREAD_POOL_SIZE = setIntParam(threadPoolSize,"THREAD_POOL_SIZE",THREAD_POOL_SIZE);
    }
    
    /**
     * Установка параметра пути к входному каталогу IN_PATH.
     * Путь к входному каталогу (IN). В этот каталог поступают запросы в виде файлов,
     * имя которых начинается с IN. При обработке АС использует справочную информацию,
     * которая также периодически поступает в этот каталог в виде отдельного файла, 
     * имя которого начинается с SP.
     * @param inPath путь к входному каталогу
     * @throws IllegalArgumentException - если нет доступа к каталогу
     */
    public void setInPath(String inPath)throws IllegalArgumentException{
        IN_PATH = setPath(inPath, "IN_PATH", IN_PATH);
    }
    
    /**
     * Установка параметра пути к выходному каталогу OUT_PATH.
     * Каталог в который перемещаются запросы, при условии, что их значение ключа на 
     * момент обработки актуально. В эту же папку я перемещаю и SP файлы, при условии,
     * что они были удачно обработаны. Выходной каталог (OUT).
     * @param outPath путь к выходному каталогу
     * @throws IllegalArgumentException если нет доступа к каталогу
     */
    public void setOutPath(String outPath)throws IllegalArgumentException{
        OUT_PATH = setPath(outPath, "OUT_PATH", OUT_PATH);
    }
    
    /**
     * Установка параметра пути к каталогу ошибочных файлов ERR_PATH.
     * Путь к каталогу ошибочных файлов (ERR). Если значение ключа на момент обработки
     * не актуально (отсутствует в справочнике), то файл запроса переместится в этот
     * каталог. Если при обработке SP файла была ошибка, то файл справочника будет
     * перемещен в этот каталог.
     * @param errPath пути к каталогу ошибочных файлов
     * @throws IllegalArgumentException если нет доступа к каталогу
     */
    public void setErrPath(String errPath)throws IllegalArgumentException{
        ERR_PATH = setPath(errPath, "ERR_PATH", ERR_PATH);
    }
    
    /**
     * Установка параметра пути к каталогу с тестовыми файлами запросов In
     * @param swapPath путь к каталогу с тестовыми файлами запросов In
     * @throws IllegalArgumentException если нет доступа к каталогу
     */
    public void setSwapPath(String swapPath)throws IllegalArgumentException{
        try{
        SWAP_PATH = setPath(swapPath, "SWAP_PATH", SWAP_PATH);
        } catch(IllegalArgumentException e){
            if (RUNTIME_MODE == 0) {
                e.printStackTrace(System.out);
            }
        }
    }

    /**
     * Установка параметра пути к каталогу со справочниками Sp
     * @param spPath путь к каталогу со справочниками Sp
     * @throws IllegalArgumentException 
     */
    public void setSpPath(String spPath)throws IllegalArgumentException{
        try{
            SP_PATH = setPath(spPath, "SP_PATH", SP_PATH);
        } catch(IllegalArgumentException e){
            if (RUNTIME_MODE == 0) {
                e.printStackTrace(System.out);
            }
        }
    }

    /**
     * Установка параметра пути к каталогу с тестовыми файлами, 
     * предоставленный ЗАО "Сбербанк-Технологии"
     * @param tmpPath каталог с тестовыми In и Sp файлами
     * @throws IllegalArgumentException 
     */
    public void setTmpPath(String tmpPath)throws IllegalArgumentException{
        try {
            TMP_PATH = setPath(tmpPath, "TMP_PATH", TMP_PATH);
        } catch(IllegalArgumentException e){
            if (RUNTIME_MODE == 0) {
                e.printStackTrace(System.out);
            }
        }
    }

    /**
     * Служебная фуекция по проверке и изменению параметров пути
     * @param parsePath строка с устанавливаемым значением
     * @param paramPathName наименование параметра
     * @param paramPath ссылка на параметр
     * @throws IllegalArgumentException неверное значение устанавливаемого параметра
     */
    private String setPath(String parsePath, String paramPathName, String paramPath) 
            throws IllegalArgumentException {
        String parsedPath;
        String errMsg;
        
        if ((parsePath==null)||(parsePath.length()==0)) {
            errMsg = "Нулевой аргумент функции установки параметра "+paramPathName
                    +". Будет использовано значение по умолчанию: " + paramPath;
            System.out.println(errMsg);
            parsedPath = parsePath;
        }
        
        try{
            Path get = Paths.get(parsePath);
            parsedPath = parsePath;
        } catch(Exception e) {
            e.printStackTrace(System.out);
            errMsg = "Ошибка при изменении значения параметра "
                    + paramPathName + ". Текущее значение: " + paramPath
                    + ". Попытка изменить на: " + parsePath;
            throw new IllegalArgumentException(errMsg);
        }
        
        return parsedPath;
    }    
    
    /**
     * Служебная фуекция по проверке и изменению целочисленных параметров
     * @param parseParam строка с устанавливаемым значением
     * @param paramName наименование параметра
     * @param param ссылка на параметр
     * @throws IllegalArgumentException неверное значение устанавливаемого параметра
     */
    private int setIntParam(String parseParam, String paramName, int param)
            throws IllegalArgumentException{
        int value;
        String errMsg;
        
        if ((parseParam==null)||(parseParam.length()==0)) {
            errMsg = "Нулевой аргумент функции установки параметра " +paramName
                    + ". Будет использовано значение по умолчанию: " + param;
            throw new IllegalArgumentException(errMsg);
        }
        
        if (parseParam.length()>10) {
            errMsg = "В качестве аргумента функции установки параметра " 
                    + paramName + " передана очень большая строка.";
            throw new IllegalArgumentException(errMsg);            
        }
        
        
        try{
            value = Integer.parseInt(parseParam);
        } catch (NumberFormatException e){
            errMsg = "Ошибка при изменении значения параметра " + paramName
                    + ". Текущее значение: " + param
                    + ". Попытка изменить на нечисловое значение: " + parseParam;
            throw new IllegalArgumentException(errMsg);            
        }
        
        if (value <1) {
            errMsg = "Ошибка при изменении значения параметра " + paramName
                    + ". Текущее значение: " + param
                    + ". Попытка изменить на: " + parseParam;
            throw new IllegalArgumentException(errMsg);
        }
        
        return value;
    }

    /**
     * Установить параметр TIME_TO_LIVE_IN_SECONDS.
     * После загрузки ключи сохраняют актуальность ограниченное время 
     * (по умолчанию - 1 минуту). По истечении этого времени ключ должен быть 
     * удален из справочника.Параметр позволяет изменить это время жизни в
     * секундах.
     * 
     * @param parseParam строковое значение параметра
     * @throws IllegalArgumentException если найдена ошибка в передаваемом 
     * строковом значении
     */
    public void setTimeToLiveInSeconds(String parseParam)throws IllegalArgumentException{
        TIME_TO_LIVE_IN_SECONDS = setIntParam(parseParam, "TIME_TO_LIVE_IN_SECONDS", TIME_TO_LIVE_IN_SECONDS);
    }
    
    /**
     * Установить параметр TIMER_INTERVAL_IN_SECONDS.
     * Параметр интервалов проверки устаревания ключей в секундах.
     * @param parseParam строковое значение параметра
     * @throws IllegalArgumentException если найдена ошибка в передаваемом 
     * строковом значении
     */
    public void setTimerIntervalInSeconds(String parseParam)throws IllegalArgumentException{
        TIMER_INTERVAL_IN_SECONDS = setIntParam(parseParam, "TIMER_INTERVAL_IN_SECONDS", TIMER_INTERVAL_IN_SECONDS);
    }    

    /**
     * Установить параметр MAX_CACHE_SIZE.
     * Параметр, ограничивающий объем справочника, который можно разместить в
     * оперативной памяти. По требованиям тестового задания - ограничен 100
     * записями. Оставшаяся часть справочной информации размещается на жестком
     * диске, объем которого не ограничивается.
     * 
     * @param parseParam строковое значение параметра
     * @throws IllegalArgumentException если найдена ошибка в передаваемом 
     * строковом значении
     */
    public void setMaxCacheSize(String parseParam)throws IllegalArgumentException{
        MAX_CACHE_SIZE = setIntParam(parseParam, "MAX_CACHE_SIZE", MAX_CACHE_SIZE);
    }
    
    /**
     * Установить параметр WAIT_FILE_TIME.
     * В случае, если помещенный в папку IN файл запроса или справочник по
     * каким то причинам долго закрывается файловой системой, то повторно он 
     * будет проверен на доступность через данный промежуток времени в мс.
     *
     * @param parseParam строковое значение параметра
     * @throws IllegalArgumentException если найдена ошибка в передаваемом 
     * строковом значении
     */
    public void setWaitFileTime(String parseParam)throws IllegalArgumentException{
        WAIT_FILE_TIME = setIntParam(parseParam, "WAIT_FILE_TIME", WAIT_FILE_TIME);
    }
    
    /**
     * Установить параметр RUNTIME_MODE
     * Параметр режима работы.
     * 0 - релиз. 
     * 1 - отладка
     * В режиме релиза если будут ошибки в параметрах SWAP_PATH, SP_PATH, 
     * TMP_PATH, то они не будут критичны - будут выведены в консоль только 
     * предупреждения.
     * @param parseParam строковое значение параметра
     * @throws IllegalArgumentException если найдена ошибка в передаваемом 
     * строковом значении
     */
    public void setRuntimeMode(String parseParam)throws IllegalArgumentException{
        RUNTIME_MODE = setIntParam(parseParam, "RUNTIME_MODE", RUNTIME_MODE);
    }

    /**
     * Установить параметр LOG_LEVEL
    * Параметр уровня логирования информации 
    * @param parseParam значения параметра:
    * SEVERE (только ошибки)
    * WARNING
    * INFO
    * CONFIG
    * FINE
    * FINER
    * FINEST (полная детальная информация)
    * @throws IllegalArgumentException 
    */
    public void setLogLevel(String parseParam)throws IllegalArgumentException{
        String upperParsedParam;
        String errMsg;
        
        if ((parseParam==null)||(parseParam.length()==0)) {
            errMsg = "Нулевой аргумент функции установки параметра логирования LOG_LEVEL"
                    + ". Будет использовано значение по умолчанию: " + LOG_LEVEL.getName();
            throw new IllegalArgumentException(errMsg);
        }
        
        upperParsedParam = parseParam.trim().toUpperCase();
        if (MAP_LOG_LEVELS.containsKey(upperParsedParam)) {
            LOG_LEVEL = MAP_LOG_LEVELS.get(upperParsedParam);
        } else {
            errMsg = "Ошибка при изменении значения параметра логирования LOG_LEVEL" 
                + ". Текущее значение: " + LOG_LEVEL.getName()
                + ". Попытка изменить на некоректное: " + upperParsedParam;
            throw new IllegalArgumentException(errMsg);
        }
    }
}
}