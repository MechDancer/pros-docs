==============
PROS 初学者指南
==============

入门时，关于 PROS 的特征，最应该注意的是\
开发 PROS 就是开发标准的 C 或 C++。任何在\
标准 C/C++ 中有效的东西在 \
PROS 项目中同样有效，同时，无效的代码给出\
与一般 C/C++ 给出的的错误也相同。学习 C/C++ \
对于使用 PROS 至关重要。

我从未使用过 PROS，之前也没有编写过 C/C++ 代码，我该从哪里开始？
--------------------------------------------------------

如果你从未使用过 PROS，之前也没有开发过非 VEX C/C++ 项目，\
我们推荐你先浏览下列 C 语言教程：

-  `函数 <http://www.studytonight.com/c/user-defined-functions-in-c.php>`__. \
   C 是一种极其强调函数的语言，了解函数\
   的作用是使用 PROS 的基础。 `PROS API <../api/index.html>`_ 是一系列函数，\
   因此只要你想和传感器或电机交互，就一定会用到函数。

-  `头文件 <https://www.tutorialspoint.com/cprogramming/c_header_files.htm>`__. \
   PROS模板（创建 PROS 项目时自动创建的文件集）\
   包含几个头文件，\
   您在开发自己的代码时也可以添加其他头文件。 \
   头文件包含函数和全局\
   变量的声明（以及其他内容），这就是为什么 `PROS API <../api/index.html>`_ \
   可以从 ``include/pros/api.h`` 找到的原因。起初可能很难确定哪些\
   代码应该放在头文件（``.h``，``.hpp``），哪些应该放在源文件（``.c``，``.cpp``）中，\
   但这是一项非常有用的技巧，\
   值得去学习。
   
-  `printf() <https://www.codingunit.com/printf-format-specifiers-format-conversions-and-formatted-output>`__.
   在开发 PROS 代码的某些时候，您可能希望获得\
   关于变量值的一些反馈。这并不能\
   完全替换完整的调试工具，但这是\
   大多数语言中定位问题的标准方法，\
   而且可以用于查看传感器值或你自己的变量值。\
   这些 ``printf()`` 语句的输出可以\
   通过执行 ``pros terminal`` 显示在终端。

- `Tasks <../tutorials/topical/multitasking.html>`_. One common mistake that new
  如果 PROS 用户忘记在他们的任务中（这包括 ``opcontrol()`` ）包含一个 ``delay()`` 语句，\
  资源和处理器会阻塞，\
  影响 PROS 内核正常运行。每个无限循环，\
  如 ``opcontrol()`` 中的那个，需要有一个延迟语句。 我们建议至少
  2 毫秒。

此外，要浏览更多 C 语言教程，访问 \
`CProgramming.com <https://www.cprogramming.com/tutorial/c-tutorial.html>`__ \
或 `StudyTonight <http://www.studytonight.com/c/overview-of-c.php>`__。\
`YouTube <https://youtu.be/nXvy5900m3M>`__ 可以找到一个\
不错的视频教程系列（不同于上述文本教程）。

我了解 C/C++，该怎么使用 PROS 呢？
-------------------------------

PROS 教程旨在展示如何将 C/C++ 编程应用\
到 PROS 项目。`为 Clawbot 编程 <../tutorials/walkthrough/clawbot.html>`_ \
教程是一个很好的起点，因为它\
完成一个示例 PROS 项目的每一步。一旦\
你准备分支出来，创建自己的自定义项目了，\
建议浏览以下教程： 

-  `PROS 项目结构<../tutorials/general/project-structure.html>`_

-  `上传代码 <../tutorials/walkthrough/uploading.html>`_

-  `调试 <../tutorials/general/debugging.html>`_

-  `常见开发问题 <./faq.html>`_

之后，你还能浏览从 `模数接口 <../tutorials/topical/adi.html>`_ \
到 `任务与多线程 <../tutorials/topical/multitasking.html>`_ 的各类专题教程。
