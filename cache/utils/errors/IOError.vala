namespace cache.utils.errors{

errordomain IOError {
    ERROR
}

void method () throws IOError {
    throw new IOError.ERROR ("IO Error");
}

static int main (string[] args) {
	try {
		method ();
	} catch (IOError e) {
		stderr.printf ("Error: %s\n", e.message);
	}
}
}