namespace cache.utils.errors {

errordomain NoSuchElementError {
    ERROR
}

void method () throws NoSuchElementError {
    throw new NoSuchElementError.ERROR ("No Such Element Error");
}

static int main (string[] args) {
	try {
		method ();
	} catch (NoSuchElementError e) {
		stderr.printf ("Error: %s\n", e.message);
	}
}
}