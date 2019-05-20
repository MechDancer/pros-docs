=================
项目结构
=================

PROS 项目在内由三部分组成：**PROS 库** （位于
``/firmware``)、**头** 文件（位于 ``/include``）、**用户代码**\
（位于 ``/src``）。

firmware
========

**PROS 库** 是一个包含 PROS 核心例程的单个文件。\
该文件不需要更改。如果核心 PROS 函数出现问题，\
请在 `GitHub <https://github.com/purduesigbots/pros/issues>`_
提出 issue。

include
=======

所有 **头** 文件都可在 ``include`` 目录找到。 One
header file, `api.h <../../api/index.html>`_, is required to declare
the PROS library functions. This file exists merely to include the individual
PROS API headers, all of which can be found in ``include/pros``. Each header file
in this directory covers a specific aspect of interacting with the V5 hardware,
and correlates to the files found in the `API documentation <../../api/index.html>`_.

另一个文件 ``main.h`` 旨在声明用户代码文件之间共享的函数\
和变量。``main.h`` 还\
还提供各种可配置选项，根据你的需求定制PROS。

* ``PROS_USE_SIMPLE_NAMES``：如果定义了这个，一些常用的枚举将会被预处理器宏赋予更短、更方便的命名模式。\
  举个例子，
  E_CONTROLLER_MASTER 将会拥有一个更短的名字 ``CONTROLLER_MASTER``。尽管 ``E_CONTROLLER_MASTER``
  在 PROS 风格指南中是学究式（pedantically）的正确，但对大多数学生程序员\
  来说并不方便。

* ``using namespace pros``：通过定义 ``PROS_USE_SIMPLE_NAMES``
  可以取消它的注释。这减少了使用 C++ 时声明的长度，允许你仅仅\
  声明 ``Motor`` 而不是 ``pros::Motor``。这将使代码看起来更简洁，\
  对新程序员来说也更简单, 但通常是
  `不好的习惯 <https://msdn.microsoft.com/en-us/library/5cb46ksf.aspx>`_。\
  因此，默认情况下这行是被注释的。

可以在 include 目录创建名称以 .h（传统 C）或
.hpp（C++）结尾的头文件。\
有关如何创建头文件的更多信息，\
可以参见 `C++ 教程 <http://www.learncpp.com/cpp-tutorial/19-header-files/>`_。

src
===

**用户代码** 具有控制机器人行为的实际顺序指令。\
PROS 默认将用户代码分为\
自动（``autonomous.c`` 或 ``autonomous.cpp``）、遥控\
（``opcontrol.c`` 或 ``opcontrol.cpp``）、初始化\
（``initialize.c`` 或 ``initialize.cpp``）文件。一个文件中的代码可以通过头文件的声明\
与另一个文件中的代码进行交互。

可以在 ``src`` 目录创建名称以\
``.c`` 或 ``.cpp`` 结尾的用户代码文件，它们会和其他文件一起编译。

所有用户代码文件都应以以下内容开头：

.. highlight:: none

::

    #include "main.h"

这将保证 PROS API 和其他关键的定义在\
每个文件中都可用。

虽然比某些环境更复杂，但是将代码分割提供了强大的\
模块性和复用性，尤其是在与源码控制\
相结合的时候。
