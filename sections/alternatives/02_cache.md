!SLIDE subsectionnonum
# ~~~SECTION:MAJOR~~~.~~~SECTION:MINOR~~~ Cache


!SLIDE noprint
# go-carbon Overview

*go-carbon* is a re-implementation of Carbon Cache written in Go.

<center><img src="./_images/go-carbon.png" style="width:836px;height:290px;"/></center>


!SLIDE printonly
# go-carbon Overview

*go-carbon* is a re-implementation of Carbon Cache written in Go.

<center><img src="./_images/go-carbon.png" style="width:460px;height:159px;"/></center>

~~~SECTION:handouts~~~
****

Project: https://github.com/lomik/go-carbon

~~~ENDSECTION~~~


!SLIDE
# go-carbon Features

* Receive metrics from TCP and UDP (plaintext protocol)
* Receive metrics with Pickle protocol (TCP only)
* Receive metrics from HTTP and Apache Kafka
* Uses same configuration files as Carbon Cache
* Automatic config reload for many configuration sections
* Acts as carbonlink for Graphite-Web (port 7002)
* Writes statistics about itself
* Supports *carbonapi*, which is useful in supported setups


!SLIDE
# go-carbon Pros/Cons

* Pros:
 * Requests to carbonlink are faster than with Carbon Cache
 * Configuration and deployment is easy
 * Daemon spawns workers automatically, no need for separate configuration
 * Constant development since 2015

* Cons:
 * Current Graphite-Web implementation is experimental
 * Still needs Graphite-Web to access metrics
