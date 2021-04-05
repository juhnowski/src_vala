namespace n9m.streamax{
	public class Range : GLib.Object {
		public int min_value { get; set; }
		public int max_value { get; set; }

		// Constructor
			public Range (int min_val, int max_val) {
				min_value = min_val;
				max_val = max_val;
		}

	}
}
