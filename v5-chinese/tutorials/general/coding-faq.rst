==========
编码常见问题
==========

编译期问题
===================

 * ``undefined reference to ...`` 或 ``implicit declaration of function ...``:
    一个函数的名称拼写错误或函数在头文件中\
    错误声明。自定义头文件或\
    使用它们的文件中必须包含 ``main.h``。

 * ``format ... expects argument of type ..., but argument has type ...``:
    为 `printf <http://www.cplusplus.com/reference/cstdio/printf/>`_
    或 `lcd_print <../../api/c/llemu.html#lcd-print>`_ 等函数提供的值与从字符串、
    推断出的预期类型不匹配。在一些情况下可以安全地忽略警告，\
    但如果类型 ``double`` 和 ``long long`` 与其他类型混合则\
    会发生崩溃。

 * ``assignment makes pointer from integer without a cast``:
    通常由于一个 C 指针使用了错误的星号来
    `解引用 <http://stackoverflow.com/a/4955297/3681958>`_，或者\
    把一个常量赋值给 ``pointer`` （而不是 ``*pointer``）。

运行期问题
===============

 * **有些任务正在运行，有些没有运行：**
    一个任务没有使用 `delay <../../api/c/rtos.html#delay>`_ 或
    `task_delay_until <../../api/c/rtos.html#task-delay-until>`_ 等待。由于\
    PROS使用基于优先级的非抢占式调度程序，因此优先级高于\
    或等于阻塞任务的任务仍会运行，而优先级较低的任务不会运行。\
    这种情况也被称为
    `饥饿 <https://en.wikipedia.org/wiki/Starvation_(computer_science)>`_。\
    有关更多信息，请参见 `任务/多线程 </tutorials/topical/multitasking>`_。

 * **VEX LCD 刷新非常慢，或冻屏：**
    一个任务没有使用 `delay <../../api/c/rtos.html#delay>`_ 或
    `task_delay_until <../../api/c/rtos.html#task-delay-until>`_ 等待。从内核角度来看，\
    更新 LCD 没有机器人运行重要。\
    因此，PROS 优先处理用户任务而不是 LCD。

    只有当所有其他任务都在等待时，LCD 才会更新。

 * **自动或遥控代码都不会启动：**
    ``initialize()`` 函数可能仍在运行。一些任务例如
    `analog_calibrate <../../api/c/adi.html#analog-calibrate>`_ 很耗时。

    如果 ``initialize()`` 函数实现了某类循环或\
    selection routine，请确保它能够结束。

 * **代码意外重新启动:**
    一个运行期错误导致程序崩溃。\
    `调试 <./debugging>`_ 可能揭示错误的原因。\
    检查任何新添加的代码是否有可能出现逻辑错误。\
    一些常见的错误消息包括：

   * **Segmentation Fault:**
      这说明使用了无效的 C 指针。检查指针和常规变量之间是否混淆\
      以及无效指针是否没有传递给\
      PROS API 函数。

   * **Stack Overflow:**
      通常说明无限递归，或者自定义任务的堆栈大小太小。\
      调用多层函数和声明大的局部变量\
      可能需要堆栈上的大量空间。如果错误\
      发生在像 ``autonomous()`` 的默认任务中，考虑更改代码以\
      减少对栈的需求。你也可以使用 `task_create <../../api/c/rtos.html#task_create>`_
      来创建栈较大，用于处理大型作业的任务。\
      在函数内部声明的大型数组通常可以全局声明\
      以减轻对栈空间的压力。

   * **System Task Failure:**
      系统运行的任务太多，无法启动新任务。\
      禁用或合并不必要的任务以消除此错误。

 * **上传程序后 Cortex 闪红灯：**
    重启 Cortex 微控制器。这样通常能解决\
    问题。而且在大多数情况下重新初始化来模拟比赛环境是一个很好的习惯\
    如果错误仍存在，请见\
    上面的 "**代码意外重新启动**" 一节。

 * `printf <printf_>`_ **不起作用**:
    `printf <http://www.cplusplus.com/reference/cstdio/printf/>`_ 通过\
    串口连接（`调试 <../tutorials/general/debugging>`_）打印信息，
    而不是 VEX LCD。想要打印至 LCD 上，请改用 
    `lcd_print <../../api/c/llemu.html#lcd-print>`_。

.. _printf: http://www.cplusplus.com/reference/cstdio/printf/
