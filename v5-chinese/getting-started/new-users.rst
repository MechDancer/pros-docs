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

-  `函数 <http://www.studytonight.com/c/user-defined-functions-in-c.php>`__.
   C 是一种极其强调函数的语言，了解函数\
   的作用是使用 PROS 的基础。 `PROS API <../api/index.html>`_ 是一系列函数，\
   因此只要你想和传感器或电机交互，就一定会用到函数。

-  `Header
   Files <https://www.tutorialspoint.com/cprogramming/c_header_files.htm>`__.
   The PROS template (the set of files automatically created when you
   start a PROS project) contains a couple of header files, and it's
   recommended that you make additional header files as you develop your
   code. Header files contain the declarations for functions and global
   variables (among other things), which is why the `PROS API <../api/index.html>`_
   can be found in ``include/pros/api.h``. Knowing what
   code should go in a header file (``.h``, ``.hpp``) or a source file (``.c``, ``.cpp``)
   can be difficult to determine at first, but it is a very useful skill
   to learn.

-  `printf() <https://www.codingunit.com/printf-format-specifiers-format-conversions-and-formatted-output>`__.
   At some point when developing PROS code, you will likely want to get
   some feedback on what the value of a variable is. This is not an
   exact replacement for a full debugging utility by any means, but is
   the standard method for troubleshooting issues in most languages and
   can be used for viewing sensor values or your own variables' values.
   The output from these ``printf()`` statements can be viewed in the
   terminal by running ``pros terminal``.

- `Tasks <../tutorials/topical/multitasking.html>`_. One common mistake that new
  PROS users make is forgetting to include a ``delay()`` statement in their tasks
  (this includes ``opcontrol()`` too), starving the processor of resources and
  preventing the PROS kernel from running properly. Every infinite loop, like
  the one in ``opcontrol()``, needs to have a delay statement. We recommend at least
  2ms.

And then for additional C tutorial topics, visit
`CProgramming.com <https://www.cprogramming.com/tutorial/c-tutorial.html>`__
or `StudyTonight <http://www.studytonight.com/c/overview-of-c.php>`__. A
good video tutorial series (as opposed to the previous text-based
tutorials) can be found on `YouTube <https://youtu.be/nXvy5900m3M>`__.

I know C/C++, now how do I use PROS?
------------------------------------

The PROS tutorials are designed to show the application of C/C++ programming
to a PROS project. The `Programming the Clawbot <../tutorials/walkthrough/clawbot.html>`_
tutorial is a great place to start, as it
goes through every step of putting together a sample PROS project. Once
you are ready to branch out and create your own custom project, looking
through the following tutorials is recommended:

-  `PROS Project Structure <../tutorials/general/project-structure.html>`_

-  `Uploading Code <../tutorials/walkthrough/uploading.html>`_

-  `Debugging <../tutorials/general/debugging.html>`_

-  `Coding FAQs <./faq.html>`_

And then you can find tutorials for specific subjects from `the ADI <../tutorials/topical/adi.html>`_
to `tasks and multithreading <../tutorials/topical/multitasking.html>`_ as well.
