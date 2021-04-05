namespace cache.utils.errors {

errordomain IllegalStateError {
    ERROR
}

void method () throws IllegalStateError {
    throw new IllegalStateError.ERROR ("Illegal State Error");
}

static int main (string[] args) {
	try {
		method ();
	} catch (IllegalStateError e) {
		stderr.printf ("Error: %s\n", e.message);
	}
}
}