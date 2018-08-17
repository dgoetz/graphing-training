!SLIDE subsectionnonum
#~~~SECTION:MAJOR~~~.~~~SECTION:MINOR~~~ Basic Components


!SLIDE
# Components of Graphite

Graphite is a scalable system which provides realtime graphing. Graphite was originally developed by Chris Davis from orbitz.com, where it was used to visualize business-critical data. Graphite is not a single application, it consists of multiple components which together provide a fully functional performance monitoring solution.

Parts of Graphite:

* Carbon
* Whisper
* Graphite-Web

~~~SECTION:handouts~~~
****

Graphite was published in 2008 under the "Apache 2.0" license.

~~~ENDSECTION~~~


!SLIDE
# Carbon Cache

* Accepts metrics over TCP or UDP
* Various protocols
 * Plaintext
 * Python pickle
 * AMQP
* Caches metrics and writes data to disk
* Provides query port "Carbonlink" (in-memory metrics)

Carbon Cache accepts metrics and provides a mechanism to cache those for a defined amount of time. It uses the underlying Whisper libraries to store permanently to disk. In a growing environment with more I/O a single ``carbon-cache`` process may not be enough. To scale you can simply spawn multiple Carbon Caches.


!SLIDE
# Graphite-Web

* Webinterface (Django)
* Render graphs
* Save graphs in dashboards
* Share graphs

Graphite-Web is the visualizing component. To create graphics, it obtains the data simultaneously from the related Whisper files and the Carbon Cache. Graphite-Web combines data points from both sources and returns a single image. By doing this it ensures that data always can be shown in real time, even if some data points are not written yet into Whisper files and therefore written on the hard drive.
