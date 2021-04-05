using Gtk;
using Gst;

public class VideoSample : Window {
        Element playbin;

        construct {
                Widget video_area;

                playbin = ElementFactory.make ("playbin", "bin");
                playbin["uri"] = "http://www.w3schools.com/html/mov_bbb.mp4";
                var gtksink = ElementFactory.make ("gtksink", "sink");
                gtksink.get ("widget", out video_area);
                playbin["video-sink"] = gtksink;

                var vbox = new Box (Gtk.Orientation.VERTICAL, 0);
                vbox.pack_start (video_area);

                var play_button = new Button.from_icon_name ("media-playback-start", Gtk.IconSize.BUTTON);
                play_button.clicked.connect (on_play);
                var stop_button = new Button.from_icon_name ("media-playback-stop", Gtk.IconSize.BUTTON);
                stop_button.clicked.connect (on_stop);
                var quit_button = new Button.from_icon_name ("application-exit", Gtk.IconSize.BUTTON);
                quit_button.clicked.connect (Gtk.main_quit);

                var bb = new ButtonBox (Orientation.HORIZONTAL);
                bb.add (play_button);
                bb.add (stop_button);
                bb.add (quit_button);
                vbox.pack_start (bb, false);

                add (vbox);
        }

        void on_play() {
                playbin.set_state (Gst.State.PLAYING);
        }

        void on_stop() {
                playbin.set_state (Gst.State.READY);
        }

        public static int main (string[] args) {
                Gst.init (ref args);
                Gtk.init (ref args);

                var sample = new VideoSample ();
                sample.show_all ();

                Gtk.main ();

                return 0;
        }
}
