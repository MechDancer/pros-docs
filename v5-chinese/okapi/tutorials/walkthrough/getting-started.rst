=============================
入门 OkapiLib
=============================

介绍
============

OkapiLib 默认伴随着所有新 PROS 项目安装。如果你不确定 OkapiLib 是否已经安装，\
你可以检查 ``prosv5 conduct info-project`` 命令的输出。此外，OkapiLib 的头文件位于
 ``include/okapi``。确认好 OkapiLib 已安装后，就可以开始使用了。\
不要忘记取消注释文件 ``include/main.h`` 中包括 OkapiLib API 头文件的语句\ 
（下面这四行：）

.. highlight: cpp
.. code-block:: cpp
   :linenos:

   /**
    * You should add more #includes here
    */
    #include "okapi/api.hpp"
    //#include "pros/api_legacy.h"

接下来，在文件 ``src/opcontrol.cpp`` 中移除语句 ``using namespace pros::literals``（如果它存在的话）。

就这样！查看 `其他教程 <../index.html>`_ 来更好地理解
Okapilib 拥有的工具。

疑难解答
===============

如果在安装过程中 OkapiLib 并没有从 GitHub 正确下载，你可以你可以在
`这里 <https://github.com/OkapiLib/OkapiLib/releases>`_ 手动下载，并通过运行
``prosv5 conduct fetch path/to/okapilib.zip`` 安装。\
当 OkapiLib 安装好之后，重新创建 PROS 项目。
