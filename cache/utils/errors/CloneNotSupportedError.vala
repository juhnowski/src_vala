namespace cache.utils.errors{

errordomain CloneNotSupportedError {
    ERROR
}

void method () throws CloneNotSupportedError {
    throw new CloneNotSupportedError.ERROR ("Clone Not Supported Error");
}

static int main (string[] args) {
	try {
		method ();
	} catch (CloneNotSupportedError e) {
		stderr.printf ("Error: %s\n", e.message);
	}
}
}