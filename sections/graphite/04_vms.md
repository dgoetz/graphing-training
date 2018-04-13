!SLIDE subsectionnonum
#~~~SECTION:MAJOR~~~.~~~SECTION:MINOR~~~ Virtual Machines

!SLIDE
# Training VMs

* VirtualBox
* Host-only network (192.168.56.0/24)
* "graphing1.localdomain" is the primary training VM
* "graphing2.localdomain" is used for Cluster setup

  Instance              | IP                    | Login
  ----------------------|-----------------------|---------------------------
  graphing1.localdomain | 192.168.56.101        | training/netways (sudo su)
  graphing2.localdomain | 192.168.56.102        | training/netways (sudo su)

~~~SECTION:handouts~~~
****

VirtualBox user manual: https://www.virtualbox.org/manual/UserManual.html

~~~ENDSECTION~~~


!SLIDE
# Base Linux Installation

* CentOS 7
* **Systemd** as init system
* **Firewalld** (Stopped)
* **SELinux** (Permissive)
* EPEL repository for additional packages
