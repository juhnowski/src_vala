namespace cache.utils.errors{

errordomain ConcurrentModificationError {
    ERROR
}

void method () throws ConcurrentModificationError {
    throw new ConcurrentModificationError.ERROR ("Concurrent Modification Error");
}

static int main (string[] args) {
	try {
		method ();
	} catch (ConcurrentModificationError e) {
		stderr.printf ("Error: %s\n", e.message);
	}
}
}