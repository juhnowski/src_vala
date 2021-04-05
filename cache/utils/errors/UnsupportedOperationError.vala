namespace cache.utils.errors {

errordomain UnsupportedOperationError {
    ERROR
}

void method () throws UnsupportedOperationError {
    throw new UnsupportedOperationError.ERROR ("Unsupported Operation Error");
}

static int main (string[] args) {
	try {
		method ();
	} catch (UnsupportedOperationError e) {
		stderr.printf ("Error: %s\n", e.message);
	}
}
}