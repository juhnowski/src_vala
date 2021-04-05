GstElement *    (*default_create_element)     (GstRTSPMediaFactory *factory, const GstRTSPUrl *url);

GstElement *    custom_create_element     (GstRTSPMediaFactory *factory, const GstRTSPUrl *url) {
  GstElement *result = default_create_element(factory,url);
  gst_object_set_name((GstObject*)result,url->abspath);
  g_timeout_add (1000, (GSourceFunc)check_timer, result);
  return result;
}

static gchar *
custom_make_path (GstRTSPMountPoints * mounts, const GstRTSPUrl * url)
{
  GstRTSPMediaFactory *factory;
  GstElement *pipeline;
  int alive;

  if (!(factory = gst_rtsp_mount_points_match (mounts,
              url->abspath, NULL))) {

    g_print ("query factory for path %s\n", url->abspath);

    gchar *str;
    gchar *request = g_strdup_printf("{\"cmd\":\"getport\",\"stream\":\"%s\"}", url->abspath);

//    JsonParser *response =  tarantool_gstserver_query(request);

    int t_port = json_int(response,"port");
    int alive = json_int(response,"source_online");
    gchar *type = g_strdup(json_string(response,"type"));
    gchar *uri = g_strdup(json_string(response,"uri"));
	/*int width = 352;
	int height = 288;*/
    int width = json_int(response,"width"),
        height = json_int(response,"height");

    g_print ("size %d %d port %d type %s\n",width,height,t_port,type);

    g_object_unref (response);
    g_free(request);

    if(t_port == 0 && !type) {
      g_print ("404\n");
      return g_strdup("/404");
    }

    g_print ("create factory for path %s\n", url->abspath);
    factory = gst_rtsp_media_factory_new ();

    if(!default_create_element)
      default_create_element = GST_RTSP_MEDIA_FACTORY_GET_CLASS( factory )->create_element;
    GST_RTSP_MEDIA_FACTORY_GET_CLASS( factory )->create_element = custom_create_element;

    if(strcmp(type, "N9M") == 0) {

       if(width && height)
        str =
          g_strdup_printf ("("

            " input-selector name=slt "
            //" videotestsrc is-live=1 pattern=red ! video/x-raw,width=%d,height=%d ! textoverlay text=\"NO SIGNAL!\" ! slt. "
	" videotestsrc is-live=1 pattern=red ! video/x-raw,width=%d,height=%d ! slt. "
            " udpsrc address=\"127.0.0.1\" port=%d ! h264parse ! avdec_h264 ! queue ! slt. "
            " slt. ! x264enc ! rtph264pay pt=96 name=pay0 "

          ")",
          width,height,t_port);
      else
        str =
          g_strdup_printf ("("

            " udpsrc address=\"127.0.0.1\" port=%d ! h264parse ! avdec_h264 "
            " ! x264enc ! rtph264pay pt=96 name=pay0 "

          ")",
          t_port);
    }
    else if(strcmp(type, "RTSP") == 0) {
      g_print ("%s\n", uri);
      str =
        g_strdup_printf ("("
          " rtspsrc location=\"%s\""
          " ! rtph264depay "
          " ! rtph264pay pt=96 name=pay0 "
        ")",
        uri);
    }

    gst_rtsp_media_factory_set_launch (factory, str);
    g_free(str);
    g_free(type);
    g_free(uri);

/*
    factory = GST_RTSP_MEDIA_FACTORY(gst_rtsp_media_factory_custom_new ());

  //  gst_rtsp_media_factory_set_launch (factory,
  //      "( udpsrc address=\"127.0.0.1\" port=11111 ! h264parse ! avdec_h264 ! x264enc ! queue ! rtph264pay pt=96 name=pay0 )");

    GError *error = NULL;
  //  GstElement *pipeline = gst_parse_launch("( udpsrc address=\"127.0.0.1\" port=11111 ! h264parse ! avdec_h264 ! x264enc ! queue ! rtph264pay pt=96 name=pay0 )", &error);
    if(!g_strcmp0(url->abspath,"/snow"))
      pipeline = gst_parse_launch("(videotestsrc pattern=snow ! video/x-raw,width=400,height=400 ! x264enc  ! rtph264pay name=pay0 )", &error);
    else
      pipeline = gst_parse_launch("(videotestsrc ! video/x-raw,width=400,height=400 ! x264enc  ! rtph264pay name=pay0 )", &error);

    if(pipeline==NULL) {
      g_critical ("could not parse launch syntax: %s",
          (error ? error->message : "unknown reason"));
      if (error)
        g_error_free (error);
    }

    g_object_set(factory, "bin", pipeline, NULL);
*/

    gst_rtsp_media_factory_set_shared (factory, TRUE);

    gst_rtsp_mount_points_add_factory (mounts, url->abspath, factory);
  }
  else
    gst_object_unref (factory);

  return g_strdup (url->abspath);
}

int
main (int argc, char *argv[])
{
  GMainLoop *loop;
  GstRTSPServer *server;
  GstRTSPMountPoints *mounts;
  GstRTSPMediaFactory *factory;

  gst_init (&argc, &argv);

  loop = g_main_loop_new (NULL, FALSE);

  server = gst_rtsp_server_new ();

  mounts = gst_rtsp_server_get_mount_points (server);

  GST_RTSP_MOUNT_POINTS_GET_CLASS( mounts )->make_path = custom_make_path;

  factory = gst_rtsp_media_factory_new ();
  gst_rtsp_media_factory_set_launch (factory,
      //"( videotestsrc is-live=1 pattern=red ! video/x-raw,width=352,height=288 ! textoverlay text=\"INVALID URL\" ! x264enc ! rtph264pay pt=96 name=pay0 )");
	"( videotestsrc is-live=1 pattern=red ! video/x-raw,width=240,height=180 ! x264enc ! rtph264pay pt=96 name=pay0 )");

  gst_rtsp_media_factory_set_shared (factory, TRUE);
  gst_rtsp_mount_points_add_factory (mounts, "/404", factory);
  gst_object_unref (mounts);

  gst_rtsp_server_attach (server, NULL);

  g_print ("stream ready at rtsp://127.0.0.1:8554/device/channel/stream\n");
  g_main_loop_run (loop);

  return 0;
}
