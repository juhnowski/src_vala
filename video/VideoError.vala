namespace video {

errordomain VideoError {
    ERROR
}

void method () throws VideoError {
    throw new VideoError.ERROR ("Video Error");
}

static int main (string[] args) {
	try {
		method ();
	} catch (VideoError e) {
		stderr.printf ("Error: %s\n", e.message);
	}
}
}