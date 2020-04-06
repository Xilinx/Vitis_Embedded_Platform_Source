/*
 * Copyright (C) 2017 – 2018 Xilinx, Inc.  All rights reserved.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * Use of the Software is limited solely to applications: (a) running on a
 * Xilinx device, or (b) that interact with a Xilinx device through a bus or
 * interconnect.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
 * XILINX BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
 * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
 * WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 *
 * Except as contained in this notice, the name of the Xilinx shall not be used
 * in advertising or otherwise to promote the sale, use or other dealings in
 * this Software without prior written authorization from Xilinx.
 */

#include <gst/gst.h>
#include <stdio.h>
#include <glib-unix.h>
#include <gst/video/videooverlay.h>
#include <gst/app/gstappsrc.h>
/* Output driver for HDMI */
#define SINKBUSID "a2070000.v_mix"

static GMainLoop *loop = NULL;
static guint signal_intr_id;
static guint timeout_handle;
GThread *count_thread;
GMutex lock;
GCond cond;

#define TEXT_OVERLAY_WIDTH 1920
#define TEXT_OVERLAY_HEIGHT 360
#define ML_INPUT_WIDTH 480
#define ML_INPUT_HEIGHT 360

#define RTSP_LATENCY 200 // 200ms
GstElement *freeze_textoverlay = NULL;

#define ENABLE_VIDEO_DROP
#define MAX_ML_FRAMERATE 11
#define CONFIG_FILE "inputs.conf"
#define USE_DISPLAY_THREAD
enum {
  ML_FACE_DETECTION,
  ML_TRAFFIC_DETECTION,
  ML_NO_DETECION,
}ML_DETECTION_TYPE;

enum {
  CAR,
  BICYCLE,
  PEDESTRIAN
}DETECTED_OBJECT;

static gboolean
intr_handler (gpointer user_data)
{
  printf ("Interrupt: quitting loop ...\n");
  g_main_loop_quit (loop);
  /* remove signal handler */
  signal_intr_id = 0;
  return G_SOURCE_REMOVE;
}

#define NUM_SINK_ELEMENTS 7 // sink elements those post tags on bus
#define TYPES_OF_TRAFFIC_DETECTION 3 // cars, bicycles, persons 
//#define USE_XLNXSINK
//guint count[NUM_SINK_ELEMENTS][TYPES_OF_TRAFFIC_DETECTION];

guint facecount[4];
guint trafficcount[4][TYPES_OF_TRAFFIC_DETECTION];

static gboolean
my_bus_callback (GstBus     *bus,
         GstMessage *message,
         gpointer    data)
{
  //g_print ("Got %s message\n", GST_MESSAGE_TYPE_NAME (message));

  switch (GST_MESSAGE_TYPE (message)) {
    case GST_MESSAGE_ERROR: {
      GError *err;
      gchar *debug;

      gst_message_parse_error (message, &err, &debug);
      g_error_free (err);
      g_free (debug);

      g_main_loop_quit (loop);
      break;
    }
    case GST_MESSAGE_EOS:
      /* end-of-stream */
      g_main_loop_quit (loop);
      break;
	case GST_MESSAGE_TAG: {
      GstTagList *tags;
	  GstElement *element = NULL;

      gst_message_parse_tag (message, &tags);

	  element = GST_ELEMENT (GST_MESSAGE_SRC (message));

	  if (g_strrstr (GST_ELEMENT_NAME(element), "facesink_") && g_strrstr(gst_tag_list_nth_tag_name (tags, 0), "n_faces")) {
        guint n_faces = 0;
        gchar *bin_name = NULL;
		guint i;
		guint bin_idx;

		bin_name = gst_element_get_name(element);
		if (bin_name) {
			bin_idx = strtoll (bin_name+9, NULL, 10);
            //printf ("received msg from %s and idx = %u\n", bin_name, bin_idx);
			g_free (bin_name);
		}
		g_mutex_lock (&lock);
		for (i = 0; i < gst_tag_list_n_tags(tags); i++) {
          gchar *tag_name = gst_tag_list_nth_tag_name(tags, i);
          guint val=0;
		  
		  gst_tag_list_get_uint (tags, tag_name, &val);

		  //printf ("tag_name = %s and val = %u\n", tag_name, val);
          if (!g_strcmp0(tag_name, "n_faces")) {
            facecount[bin_idx] = val;
		  }
		}
#ifdef USE_DISPLAY_THREAD
        g_cond_signal (&cond);
#endif
		g_mutex_unlock (&lock);
	  } else if (g_strrstr (GST_ELEMENT_NAME(element), "trafficsink_") && g_strrstr(gst_tag_list_nth_tag_name (tags, 0), "n_car")) {
		guint n_cars = 0;
		guint n_bicyles = 0;
		guint n_pedestrians = 0;
		guint i;
		gchar *bin_name;
		guint bin_idx = 0;

		bin_name = gst_element_get_name(element);
		
		if (bin_name)
		{
			//printf ("received msg from %s and index = %u\n", bin_name, bin_idx);
			bin_idx = strtoll (bin_name+12, NULL, 10);
			g_free (bin_name);
		}
		g_mutex_lock (&lock);
		for (i = 0; i < gst_tag_list_n_tags(tags); i++) {
          gchar *tag_name = gst_tag_list_nth_tag_name(tags, i);
          guint val=0;
		  
		  gst_tag_list_get_uint (tags, tag_name, &val);

		  //printf ("tag_name = %s and val = %u\n", tag_name, val);

		  if (!g_strcmp0(tag_name, "n_cars")) {
            trafficcount[bin_idx][CAR] = val;
		  } else if (!g_strcmp0(tag_name, "n_bicycles")) {
            trafficcount[bin_idx][BICYCLE] = val;
		  } else if (!g_strcmp0(tag_name, "n_pedestrians")) {
            trafficcount[bin_idx][PEDESTRIAN] = val;
		  }
		}
		
		//printf ("n_cars = %u, n_bicycles = %u, n_pedestrians = %u\n",
		  //  trafficcount[bin_idx][CAR], trafficcount[bin_idx][BICYCLE], trafficcount[bin_idx][PEDESTRIAN]);
#ifdef USE_DISPLAY_THREAD
		g_cond_signal (&cond);
#endif
		g_mutex_unlock (&lock);
	  }
      gst_tag_list_unref (tags);
	  break;
	}
    default:
      /* unhandled message */
      break;
  }

  /* we want to be notified again the next time there is a message
   * on the bus, so returning TRUE (FALSE means we want to stop watching
   * for messages on the bus and our callback should not be called again)
   */
  return TRUE;
}

#ifdef USE_DISPLAY_THREAD
gpointer
update_status (gpointer data)
{
	guint n_cars = 0;
	guint n_bicyles = 0;
	guint n_pedestrians = 0;
	guint n_faces = 0;
	char buf[20];
	int i = 0;
	gint64 end_time;
	gboolean bret = FALSE;

	while (1) {
		g_mutex_lock (&lock);
		n_cars = 0; n_bicyles = 0; n_pedestrians = 0; n_faces = 0;
		end_time = g_get_monotonic_time () + (500000 * G_TIME_SPAN_MILLISECOND); // 0.5 sec
		bret = g_cond_wait_until (&cond, &lock, end_time); // wait for long time i.e. -1
		if (bret) {
		  for (i = 0; i < 4; i++) {
			n_cars += trafficcount[i][CAR];
			n_bicyles += trafficcount[i][BICYCLE];
			n_pedestrians += trafficcount[i][PEDESTRIAN];
		  }
		  for (i = 0; i < 4; i++) {
            n_faces += facecount[i];
		  }
		  //printf ("Naveen : n_faces = %u, n_cars = %u, n_bicycles = %u, n_pedestrians = %u\n", n_faces, n_cars, n_bicyles, n_pedestrians);
		  sprintf (buf, "\n\n Faces : %4d\n Cars : %4d\n Bicylces : %4d\n Persons : %4d\n Resolution : 1080p\n CNN : 360x480", 
			n_faces, n_cars, n_bicyles, n_pedestrians);
          g_object_set (freeze_textoverlay, "text", buf, NULL);
		}
		g_mutex_unlock (&lock);
	}
}
#else
gboolean
update_status_timeout (gpointer handle)
{
  int n_cars = 0, n_bicyles = 0, n_pedestrians = 0, n_faces = 0;
  int i;
  char buf[20];

  if (freeze_textoverlay) {
    g_mutex_lock (&lock);
    for (i = 0; i < 4; i++) {
	  n_cars += trafficcount[i][CAR];
	  n_bicyles += trafficcount[i][BICYCLE];
	  n_pedestrians += trafficcount[i][PEDESTRIAN];
    }
    for (i = 0; i < 4; i++) {
      n_faces += facecount[i];
    }
    printf ("timed out : n_faces = %u, n_cars = %u, n_bicycles = %u, n_pedestrians = %u\n", n_faces, n_cars, n_bicyles, n_pedestrians);
    sprintf (buf, "\n\n Faces : %4d\n Cars : %4d\n Bicylces : %4d\n Persons : %4d\n Resolution : 1080p\n CNN : 360x480", 
	  n_faces, n_cars, n_bicyles, n_pedestrians);
    g_object_set (freeze_textoverlay, "text", buf, NULL);
    g_mutex_unlock (&lock);
  }

  return TRUE;
}
#endif

GstBin *
create_display_count_bin()
{
  GstBin *bin;
  GstElement *src, *dec, *imgfreeze, *convert, *capsfilter, *sink;
  GstStateChangeReturn sret;
  gboolean bret =0;
  GstVideoOverlay *overlay = NULL;
  GstCaps *caps;

  bin = gst_bin_new ("imgfrz_bin");
  src = gst_element_factory_make("filesrc", NULL);
  dec = gst_element_factory_make("jpegdec", NULL);
  capsfilter = gst_element_factory_make ("capsfilter", NULL);
  imgfreeze = gst_element_factory_make("imagefreeze", NULL);
  convert = gst_element_factory_make("videoconvert", NULL);
  freeze_textoverlay = gst_element_factory_make("textoverlay", NULL);
#ifdef USE_XLNXSINK
  sink = gst_element_factory_make("xlnxvideosink", "count_sink");
  g_object_set (sink, "sink-type", 1, NULL);
#else
  sink = gst_element_factory_make("kmssink", "count_sink");
#endif

  if (!src || !dec || !imgfreeze || !freeze_textoverlay || !convert || !capsfilter || !sink) {
    printf ("failed to create one of the element...\n");
    return NULL;
  }

  caps = gst_caps_new_simple ("video/x-raw",
      "width", G_TYPE_INT, TEXT_OVERLAY_WIDTH,
      "height", G_TYPE_INT, TEXT_OVERLAY_HEIGHT,
      "framerate", GST_TYPE_FRACTION, 7, 1,
      NULL);
  g_object_set (capsfilter, "caps", caps, NULL);
  gst_caps_unref (caps);
  g_object_set (freeze_textoverlay, 
      "valignment", 4, 
      "halignment", 2, 
      "font-desc", "Sans 10",
      "line-alignment", 0,
      "draw-shadow", FALSE,
      "draw-outline", FALSE,
      NULL);
  g_object_set (src, "location", "xilinx_8_1080p.jpg", NULL);
  g_object_set (sink, "plane-id", 38, "bus-id", SINKBUSID, NULL);

  overlay = GST_VIDEO_OVERLAY (sink);
  gst_video_overlay_set_render_rectangle (overlay, 0,2*ML_INPUT_HEIGHT, TEXT_OVERLAY_WIDTH, TEXT_OVERLAY_HEIGHT);
  gst_video_overlay_expose (overlay);
	
  gst_bin_add_many (bin, src, dec, convert, imgfreeze, freeze_textoverlay, capsfilter, sink, NULL);

  bret = gst_element_link_many (src, dec, convert, imgfreeze, capsfilter, freeze_textoverlay, sink, NULL);
  if (bret == FALSE) {
    g_error ("Failure linking elements.");
    return NULL;
  }
#ifdef USE_DISPLAY_THREAD
  count_thread = g_thread_new ("display_thread", (GThreadFunc)update_status, NULL);
#else
  timeout_handle = g_timeout_add (500, update_status_timeout, NULL); // 500 ms
#endif
  //printf ("created displaybin...\n");
  return bin;
}

static GstCaps *
get_pad_caps (GstPad * pad)
{
  GstCaps *caps;

  /* first check the pad caps, if this is set, we are positively sure it is
   * fixed and exactly what the element will produce. */
  caps = gst_pad_get_current_caps (pad);

  /* then use the getcaps function if we don't have caps. These caps might not
   * be fixed in some cases, in which case analyze_new_pad will set up a
   * notify::caps signal to continue autoplugging. */
  if (caps == NULL)
    caps = gst_pad_query_caps (pad, NULL);

  return caps;
}

void
rtspsrc_on_new_pad (GstElement *gstelement,
               GstPad     *new_pad,
               gpointer    user_data)
{
  GstElement *depay = (GstElement*)user_data;
  GstPad *sinkpad;
  GstCaps *src_caps = NULL;
  GstStructure *src_struct;
  const gchar *media;
  const gchar *codec;
  const gchar *mime;

  //printf ("received pad_padded on %s\n", GST_ELEMENT_NAME(gstelement));

  sinkpad = gst_element_get_static_pad (depay, "sink");
  if (!sinkpad){
    printf ("failed to get sink pad from %s\n", GST_ELEMENT_NAME(depay));
    return;
  }
  
  src_caps = gst_pad_get_current_caps(new_pad);
  //printf("[%s] caps are %" GST_PTR_FORMAT"\n", GST_ELEMENT_NAME(gstelement), src_caps);
  
  src_struct = gst_caps_get_structure (src_caps, 0);

  mime = gst_structure_get_name (src_struct);
  media = gst_structure_get_string (src_struct, "media");
  codec = gst_structure_get_string (src_struct, "encoding-name");

  if (!g_strcmp0 (mime, "application/x-rtp") && !g_strcmp0 (media, "video") && !g_strcmp0 (codec, "H264")) {
    if (gst_pad_link(new_pad, sinkpad) != GST_PAD_LINK_OK) {
      printf ("failed to link %s and %s\n", GST_ELEMENT_NAME(gstelement), GST_ELEMENT_NAME(depay));
	  gst_object_unref (sinkpad);
	  return;
    }
  }
  gst_object_unref (sinkpad);
}

GstBin *
create_decode_bin (guint idx, int detection_type, gchar *location, guint plane_id, guint x_pos, guint y_pos)
{
  GstCaps *caps = NULL;
  GstBin *bin = NULL;
  GstElement *src, *depay, *parser, *decoder, *vconvert, *capsfilter, *detect, *sink, *queue;
  GstElement *videorate = NULL;
  GstVideoOverlay *overlay = NULL;
  gboolean bret;
  char name [50];
  
  if (detection_type == ML_FACE_DETECTION)
    sprintf (name, "%s_%d", "facedecodebin", idx);
  else
    sprintf (name, "%s_%d", "trafficdecodebin", idx);

  bin = gst_bin_new(name);
  if (detection_type == ML_FACE_DETECTION) {
    sprintf (name, "%s_%d", "facertspsrc", idx);
    printf ("facertsp[%d] location = %s\n", idx, name);
  } else {
    sprintf (name, "%s_%d", "trafficrtspsrc", idx);
	printf ("trafficrtsp[%d] location = %s\n", idx, name);
  }

  src = gst_element_factory_make("rtspsrc", name);
  depay = gst_element_factory_make("rtph264depay", NULL);
  parser = gst_element_factory_make("h264parse", NULL);
  decoder = gst_element_factory_make("omxh264dec", NULL);
#ifdef ENABLE_VIDEO_DROP
  if (detection_type == ML_TRAFFIC_DETECTION) {
    videorate = gst_element_factory_make("videorate", NULL);
    if (!videorate) {
      printf ("failed to create videorate element...\n");
	  return NULL;
    }
    g_object_set (videorate, "max-rate", MAX_ML_FRAMERATE, NULL);
	printf ("introducing video rate in bin index = %d\n", idx);
  }
#endif
  vconvert = gst_element_factory_make("xlnxvideoscale", NULL);

  if (detection_type == ML_FACE_DETECTION) {
	sprintf (name, "%s_%d", "facedetect", idx);
    detect = gst_element_factory_make("sdxfacedetect", name);
    if (!detect) {
      printf ("failed to create facedetection element...\n");
	  return NULL;
	}
  } else if (detection_type == ML_TRAFFIC_DETECTION) {
	sprintf (name, "%s_%d", "trafficdetect", idx);
    detect = gst_element_factory_make("sdxtrafficdetect", name);
	if (!detect) {
      printf ("failed to create trafficdetection element...\n");
	  return NULL;
	}
  } else {
    detect = NULL;
  }

  capsfilter = gst_element_factory_make ("capsfilter", NULL);
  queue = gst_element_factory_make ("queue", NULL);
  if (detection_type == ML_FACE_DETECTION)
    sprintf (name, "%s_%d", "facesink", idx);
  else
    sprintf (name, "%s_%d", "trafficsink", idx);

#ifdef USE_XLNXSINK
  sink = gst_element_factory_make("xlnxvideosink", name);
  g_object_set (sink, "sink-type", 1, NULL);
#else
  sink = gst_element_factory_make("kmssink", name);
#endif

  if (!src || !depay || !parser || !decoder || !vconvert || !capsfilter || !queue || !sink) {
    printf ("failed to create bin...\n\n");
	return NULL;
  }

  g_signal_connect (src, "pad-added", G_CALLBACK (rtspsrc_on_new_pad), depay);
  g_object_set (src, "location", location, "latency", RTSP_LATENCY, NULL);
  g_object_set (decoder, "internal-entropy-buffers", 3, NULL);

  caps = gst_caps_new_simple ("video/x-raw",
      "width", G_TYPE_INT, ML_INPUT_WIDTH,
      "height", G_TYPE_INT, ML_INPUT_HEIGHT,
      "format", G_TYPE_STRING, "BGR",
      NULL);
  g_object_set (capsfilter, "caps", caps, NULL);
  gst_caps_unref (caps);

  g_object_set (sink, "plane-id", plane_id, "bus-id", SINKBUSID, "sync", FALSE, NULL);

  overlay = GST_VIDEO_OVERLAY (sink);
  gst_video_overlay_set_render_rectangle (overlay, x_pos, y_pos, ML_INPUT_WIDTH, ML_INPUT_HEIGHT);
  gst_video_overlay_expose (overlay);
  
  if (detect) {
#ifdef ENABLE_VIDEO_DROP
    if (videorate) {
      gst_bin_add_many (bin, src, depay, parser, decoder, videorate, vconvert, capsfilter, detect, queue, sink, NULL);
      bret = gst_element_link_many (depay, parser, decoder, videorate, vconvert, capsfilter, detect, queue, sink, NULL);
	} else {
      gst_bin_add_many (bin, src, depay, parser, decoder, vconvert, capsfilter, detect, queue, sink, NULL);
      bret = gst_element_link_many (depay, parser, decoder, vconvert, capsfilter, detect, queue, sink, NULL);
	}
#else
    gst_bin_add_many (bin, src, depay, parser, decoder, vconvert, capsfilter, detect, queue, sink, NULL);
    bret = gst_element_link_many (depay, parser, decoder, vconvert, capsfilter, detect, queue, sink, NULL);
#endif
    if (bret == FALSE) {
      g_error ("Failure linking elements.");
	  return NULL;
    
	}
  } else { /* no detection */
	gst_bin_add_many (bin, src, depay, parser, decoder, vconvert, capsfilter, queue, sink, NULL);
    bret = gst_element_link_many (depay, parser, decoder, vconvert, capsfilter, queue, sink, NULL);
    if (bret == FALSE) {
      g_error ("Failure linking elements.");
	  return NULL;
    
	}
  }

  return bin;
}

int
main (int argc, char **argv)
{
  GstElement *pipeline;
  GstBus *bus;
  GstStateChangeReturn sret;
  gboolean bret;
  GstBin *bin;
  guint bus_watch_id;
  GKeyFile* keyfile = NULL;
  gchar *url = NULL;

  printf ("EW 9 layer demo...\n");
  signal_intr_id = g_unix_signal_add (SIGINT, (GSourceFunc) intr_handler, NULL);
  keyfile = g_key_file_new();

  gst_init (&argc, &argv);
  g_mutex_init (&lock);
  g_cond_init (&cond);

  if (!g_key_file_load_from_file(keyfile, CONFIG_FILE, G_KEY_FILE_NONE, NULL)){
    printf ("Could not read config file %s\n", CONFIG_FILE);
    return -1;
  }

  /* prepare the pipeline */
  pipeline = gst_pipeline_new ("rtsp-vcudemo");
  
  url = g_key_file_get_string (keyfile, "urls", "faceurl_1", NULL);
  if (url == NULL) {
    printf ("failed to get face URL - 1..\n");
	return -1;
  }
  printf ("face URL - 1: %s\n", url);

  bin = create_decode_bin (0, ML_FACE_DETECTION, url, 30, 0, 0);
  if (bin == NULL) {
    printf ("bin not created...\n");
	return -1;
  }
  g_free (url);

  gst_bin_add (GST_BIN (pipeline), bin);

  url = g_key_file_get_string (keyfile, "urls", "faceurl_2", NULL);
  if (url == NULL) {
    printf ("failed to get face URL - 2..\n");
	return -1;
  }
  printf ("face URL - 2: %s\n", url);
  bin = create_decode_bin (1, ML_FACE_DETECTION, url, 31, ML_INPUT_WIDTH, 0);
  if (bin == NULL) {
    printf ("bin not created...\n");
	return -1;
  }
  gst_bin_add (GST_BIN (pipeline), bin);
  g_free (url);

  url = g_key_file_get_string (keyfile, "urls", "faceurl_3", NULL);
  if (url == NULL) {
    printf ("failed to get face URL - 3..\n");
	return -1;
  }
  printf ("face URL - 3: %s\n", url);
  bin = create_decode_bin (2, ML_FACE_DETECTION, url, 32, 0, ML_INPUT_HEIGHT);
  if (bin == NULL) {
    printf ("bin not created...\n");
	return -1;
  }
  gst_bin_add (GST_BIN (pipeline), bin);
  g_free (url);

  url = g_key_file_get_string (keyfile, "urls", "faceurl_4", NULL);
  if (url == NULL) {
    printf ("failed to get face URL - 4..\n");
	return -1;
  }
  printf ("face URL - 4: %s\n", url);
  bin = create_decode_bin (3, ML_FACE_DETECTION, url, 33, ML_INPUT_WIDTH, ML_INPUT_HEIGHT);
  if (bin == NULL) {
    printf ("bin not created...\n");
	return -1;
  }
  gst_bin_add (GST_BIN (pipeline), bin);
  g_free (url);
 
  url = g_key_file_get_string (keyfile, "urls", "trafficurl_1", NULL);
  if (url == NULL) {
    printf ("failed to get traffic URL - 1..\n");
	return -1;
  }
  printf ("traffic URL - 1: %s\n", url);
  bin = create_decode_bin (0, ML_TRAFFIC_DETECTION, url, 34, 2*ML_INPUT_WIDTH, 0);
  if (bin == NULL) {
    printf ("bin not created...\n");
	return -1;
  }
  gst_bin_add (GST_BIN (pipeline), bin);
  g_free (url);

  url = g_key_file_get_string (keyfile, "urls", "trafficurl_2", NULL);
  if (url == NULL) {
    printf ("failed to get traffic URL - 2..\n");
	return -1;
  }
  printf ("traffic URL - 2: %s\n", url);
  bin = create_decode_bin (1, ML_TRAFFIC_DETECTION, url, 35, 3*ML_INPUT_WIDTH, 0);
  if (bin == NULL) {
    printf ("bin not created...\n");
	return -1;
  }
  gst_bin_add (GST_BIN (pipeline), bin);
  g_free (url);

  url = g_key_file_get_string (keyfile, "urls", "trafficurl_3", NULL);
  if (url == NULL) {
    printf ("failed to get traffic URL - 3..\n");
	return -1;
  }
  printf ("traffic URL - 3: %s\n", url);
  bin = create_decode_bin (2, ML_TRAFFIC_DETECTION, url, 36, 2*ML_INPUT_WIDTH, ML_INPUT_HEIGHT);
  if (bin == NULL) {
    printf ("bin not created...\n");
	return -1;
  }
  gst_bin_add (GST_BIN (pipeline), bin);
  g_free (url);

  url = g_key_file_get_string (keyfile, "urls", "trafficurl_4", NULL);
  if (url == NULL) {
    printf ("failed to get traffic URL - 4..\n");
	return -1;
  }
  printf ("traffic URL - 4: %s\n", url);
  bin = create_decode_bin (3, ML_TRAFFIC_DETECTION, url, 37, 3*ML_INPUT_WIDTH, ML_INPUT_HEIGHT);
  if (bin == NULL) {
    printf ("bin not created...\n");
	return -1;
  }
  gst_bin_add (GST_BIN (pipeline), bin);
  g_free (url);

  /* Shows logo & object counts found */
  bin = create_display_count_bin ();
  if (bin == NULL) {
    printf ("bin not created...\n");
	return -1;
  }
  gst_bin_add (GST_BIN (pipeline), bin);

  bus = gst_pipeline_get_bus (GST_PIPELINE (pipeline));
  bus_watch_id = gst_bus_add_watch (bus, my_bus_callback, NULL);
  gst_object_unref (bus);

  /* start the pipeline */
  sret = gst_element_set_state (pipeline, GST_STATE_PLAYING);
  if (sret == GST_STATE_CHANGE_FAILURE) {
    g_error ("ERROR: Could not change state in pipeline.\n");
    gst_object_unref (pipeline);
    return 1;
  }

  /* run the pipeline */
  loop = g_main_loop_new (NULL, TRUE);
  g_main_loop_run (loop);

  gst_element_set_state (pipeline, GST_STATE_NULL);

  if (signal_intr_id > 0)
    g_source_remove (signal_intr_id);
  
#ifndef USE_DISPLAY_THREAD
  if (timeout_handle > 0)
    g_source_remove (timeout_handle);
#endif
  g_main_loop_unref (loop);
  gst_object_unref (pipeline);

  g_key_file_free (keyfile);

  gst_deinit ();
  return 0;
}
