echo Hello - Alive simple program. Check vala environment.
echo start
valac hello.vala -o hello
echo done

echo Video - library for video operations
echo start
valac \
	video/VideoAuthServer.vala  \
	video/VideoError.vala \
	video/VideoAddress.vala  \
	video/VideoConnection.vala  \
	video/VideoUtils.vala \
	video/n9m/VideoCodec.vala \
-o video
echo done
 
echo VideoServer - Server get a stream from videregistrator, decode and retranslate
echo start
valac \
	videoserver/VideoAuthObserver.vala  \
	videoserver/VideoServerFlags.vala  \
	videoserver/VideoServer.vala \
-o videoserver
echo done

echo VideoPlayer - Video client
echo start
valac videoplayer/VideoPlayer.vala -o videoplayer
echo done

echo Property - Property client
echo start
valac \
	property/PropertyValues.vala \
	property/Properties.vala \
 -o property
echo done

echo Cache - in-memory
echo start
valac \
	  cache/KeysInMemoryCache.vala \
	  cache/collections/AbstractHashedMap.vala  \
	  cache/collections/BoundedMap.vala \
	  cache/collections/LRUMap.vala \
	  cache/collections/SequencedHashMap.vala \
	  cache/collections/AbstractLinkedMap.vala \
	  cache/collections/IterableMap.vala \
	  cache/collections/KeyValue.vala \
	  cache/collections/OrderedMap.vala
	  cache/collections/iterators/AbstractEmptyIterator.vala \
	  cache/collections/iterators/EmptyOrderedIterator.vala \
	  cache/collections/iterators/OrderedMapIterator.vala \
	  cache/collections/iterators/EmptyOrderedMapIterator.vala \
	  cache/collections/iterators/ResettableIterator.vala \
	  cache/collections/iterators/EmptyIterator.vala \
	  cache/collections/iterators/MapIterator.vala \
	  cache/collections/iterators/EmptyMapIterator.vala \
	  cache/collections/iterators/OrderedIterator.vala \
	  cache/utils/errors/IllegalStateError.vala \  
	  cache/utils/errors/NoSuchElementError.vala \  
	  cache/utils/errors/UnsupportedOperationError.vala \
	  cache/utils/errors/CloneNotSupportedError.vala \
	  cache/utils/errors/IllegalArgumentError.vala \
	  cache/utils/errors/InterruptedError.vala \
	  cache/utils/errors/IOError.vala \
	  cache/utils/errors/ConcurrentModificationError.vala \
	  cache/utils/errors/ClassNotFoundError.vala \
	  cache/utils/Cloneable.vala \
	  cache/utils/Serializable.vala \
	  cache/io/ObjectInputStream.vala \
	  cache/io/ObjectOutputStream.vala \
-o cache
echo done

echo Unit - Unit Tests Compilation
echo start
	valac cache/utils/errors/CloneNotSupportedError.vala -o unit_tests/CloneNotSupportedError
	valac cache/utils/errors/IllegalArgumentError.vala -o unit_tests/IllegalArgumentError
	valac cache/utils/errors/IllegalStateError.vala -o unit_tests/IllegalStateError 
	valac cache/utils/errors/IOError.vala -o unit_tests/IOError
	valac cache/utils/errors/NoSuchElementError.vala -o unit_tests/NoSuchElementError  
	valac cache/utils/errors/UnsupportedOperationError.vala -o unit_tests/UnsupportedOperationError
	valac cache/utils/errors/ConcurrentModificationError.vala -o unit_tests/ConcurrentModificationError
	valac cache/utils/errors/ClassNotFoundError.vala -o unit_tests/ClassNotFoundError	
	valac cache/io/ObjectInputStream.vala -o unit_tests/ObjectInputStream
	valac cache/io/ObjectOutputStream.vala -o unit_tests/ObjectOutputStream
	valac video/n9m/VideoCodec.vala -o unit_tests/VideoCodec
echo done

echo Start Unit Tests
	unit_tests/CloneNotSupportedError
	unit_tests/IllegalArgumentError
	unit_tests/IllegalStateError 
	unit_tests/IOError
	unit_tests/NoSuchElementError  
	unit_tests/UnsupportedOperationError
	unit_tests/ObjectInputStream
	unit_tests/ObjectOutputStream.vala
	unit_tests/VideoCodec
echo Unit Tests done

echo Test App
echo start
	valac \
		test_app/TestApp.vala \
		test_app/WatchDir.vala \
		test_app/WorkerThread.vala \
 -o TestApp
echo done
