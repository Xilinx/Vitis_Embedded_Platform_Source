# Source files
add_executable(rtspapp rtsp.c)

# Dependencies
find_library (GSTVIDEO_LIBRARIES gstvideo-1.0)
find_library (GSTBASE_LIBRARIES gstbase-1.0)
find_library (GSTALLOCATORS_LIBRARIES gstallocators-1.0)
find_package (GLIB REQUIRED)
find_package (Threads REQUIRED)
set(GStreamer_FIND_VERSION "1.8.3")
find_package (GStreamer REQUIRED Video)

target_include_directories (rtspapp
  PUBLIC ${GSTREAMER_VIDEO_INCLUDE_DIRS}
)

target_link_libraries (rtspapp
  ${GSTVIDEO_LIBRARIES}
  ${GSTBASE_LIBRARIES}
  ${GSTALLOCATORS_LIBRARIES}
  ${GLIB_GIO_LIBRARIES}
  ${GLIB_LIBRARIES}
  ${GSTREAMER_LIBRARIES}
  ${GSTREAMER_VIDEO_LIBRARIES}
  ${CMAKE_THREAD_LIBS_INIT}
)

install (TARGETS rtspapp DESTINATION "/usr/bin/")
