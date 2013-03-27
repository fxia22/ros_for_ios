ros_for_ios
===========

How to build the Robot Operating System for the iOS platform.

First of all, you need to be on a MacOSX system with the Xcode and the iOS tool
chain installed. You also need to have the command line tools installed (svn,
 git ... see Xcode options). 

```
git clone https://github.com/introlab/ros_for_ios.git
sh build.sh
```

After some minutes a ros for ios framework is available for the ios arm7, arm7s and
simulator in the ros/frameworks directory.

External libraries
------------------

ROS base system depends of two main libraries :
* Boost (useful c++ library)
* log4cxx (log system with levels)

**The first step before build the ROS tree is to get an iOS framework of these
two libraries.**

* Boost is already available for iOS :
The script will download the latest version of Boost for your iOS SDK.
(To configure the script set BOOST_LIBS, IPHONE_SDKVERSION and OSX_SDKVERSION)

```
git://gitorious.org/~galbraithjoseph/boostoniphone/galbraithjosephs-boostoniphone.git
or
git://gitorious.org/~d16/boostoniphone/d16s-boost-iphone.git
```
 
* log4cxx is not available for iOS and depends of the APR library (Apache
runtime library), and more precisely apr and apr-utils.


ROS
---

**The catkin build system available with the ROS groovy release is not used.**

Here is the principal parts that has been built (for arm7, arm7s and i386
simulator) from the sources available on the ROS GitHub 
(https://github.com/ros) :

* roscpp_core (https://github.com/ros/roscpp_core.git) :
roscpp_core is an underlying library for support roscpp message data types. It is a 
lightweight/minimal library that can easily be used in non-ROS-based projects.
	- roscpp_core/cpp_common
	- roscpp_core/roscpp_serialization
	- roscpp_core/roscpp_traits
	- roscpp_core/ros_time

* ros_comm (https://github.com/ros/ros_comm.git) :
ROS communications-related packages, including core client libraries (roscpp, rospy,
roslisp) and graph introspection tools (rostopic, rosnode, rosservice, rosparam).
    - ros_comm/utilities/xmlrpcpp (Xml-RCP modified for ROS)
    - ros_comm/client/roscpp
    - ros_comm/tools/rosconsole

* ros (https://github.com/ros/ros.git)
Main package
    - ros/roslib (removal of the rospack dependancy because no Python support
        on iOS)

* core messages
    - rosgraph_msgs (included in ros_comm/messages/rosgraph_msgs/)
    - std_srvs (included in ros_comm/messages/std_srvs/)
    - roscpp (included in ros_comm/clients/roscpp/)

The headers of the ros messages are put into a specific framework. By this way, they
can be added with `#include <message_package/header.h>`.

- std_msgs (https://github.com/ros/std_msgs.git)
- common_msgs (https://github.com/ros/common_msgs.git) :
    - nav_msgs
    - geometry_msgs
    - sensor_msgs
    - ... the one you need ...

You can use the script message_gen.sh to generate the messages framework you need.

For example,
`sh message_gen.sh path_to_nav_msgs path_to_std_msgs path_to_geometry_msgs`
will build nav_msgs which depends of std_msgs and geometry_msgs.

iOS demo applications
---------------------

It's an Xcode project which can be found in the demo_app directory.

Some iOS demonstration apps were realized.

- Touch Control
- Accelerometer Control
- Planner Control
- ROS Logger
- Video Feeds

IntRolab
http://introlab.3it.usherbrooke.ca
Université de Sherbrooke, Québec, Canada