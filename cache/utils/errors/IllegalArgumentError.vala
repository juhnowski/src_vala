namespace cache.utils.errors{

errordomain IllegalArgumentError {
    ERROR
}

void method () throws IllegalArgumentError {
    throw new IllegalArgumentError.ERROR ("Illegal Argument Error");
}

static int main (string[] args) {
	try {
		method ();
	} catch (IllegalArgumentError e) {
		stderr.printf ("Error: %s\n", e.message);
	}
}
}