namespace cache.utils.errors{

errordomain ClassNotFoundError {
    ERROR
}

void method () throws ClassNotFoundError {
    throw new ClassNotFoundError.ERROR ("Class Not Found Error");
}

static int main (string[] args) {
	try {
		method ();
	} catch (ClassNotFoundError e) {
		stderr.printf ("Error: %s\n", e.message);
	}
}
}