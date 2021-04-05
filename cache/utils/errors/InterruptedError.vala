namespace cache.utils.errors {

errordomain InterruptedError {
    ERROR
}

void method () throws InterruptedError {
    throw new InterruptedError.ERROR ("Interrupted Error");
}

static int main (string[] args) {
	try {
		method ();
	} catch (InterruptedError e) {
		stderr.printf ("Error: %s\n", e.message);
	}
}
}