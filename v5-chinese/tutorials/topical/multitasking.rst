============
多任务
============

.. note:: 有关与任务交互函数的完整列表，请见
          `C API <../../api/c/rtos.html>`_ 和 `C++ API <../../api/cpp/rtos.html>`_.

任务是同时做多个事情的好工具，但很去难正确使用。\
使用任务时要记住的最重要一点是，\
任务不是真正在后台运行的——它们一次运行一个，\
然后被 PROS 调度器调换。如果你的任务运行了一些重复的动作（例如 while 循环），你调一下
``delay()`` 或者 ``task_delay_until()``。如果没有 ``delay()`` 语句，\
你的任务可能导致处理器资源匮乏，阻止内核正常运行。

PROS 任务调度器是一个抢占式、基于优先级的循环调度器。\
这意味着任务每毫秒被抢占（中断），用来决定是否应该运行另外一个任务。\
PROS 根据所有就绪任务的优先级决定下一个运行的是谁。

    - 符合执行条件的任务被称为“就绪”。未就绪的任务通常是因为他们在
      在休眠（在 ``task_delay`` 中) 或被阻塞等待同步机制\
      （例如互斥或信号量）。
    - 优先级越高，任务会被认为越重要，更多的 CPU 时间会分配给\
      这个任务。高优先级的就绪任务总会优先于\
      低优先级的任务运行。
    - 同等优先级任务在任务被抢占时具有优先度是相当的。换句话说，\
      如果任务甲和任务乙具有相同优先级，当甲被中断时接下来乙会运行，即便甲仍然拥有执行资格。\
      这叫作循环调度。

任务的滥用
---------------------

任务经常被误用和滥用，这导致 PROS 内核以预料外的方式运行。\
下面列出了在 PROS 中使用任务时常见的错误和准则：

    - 实时操作系统中的任务应该是长期运行的。也就是说，\
      任务通常不应该执行一个短期操作然后销毁。考虑重新处理程序逻辑来\
      实现这种行为。
    - “任务函数”并不特别，只是它们的签名必须正确。\
      在其他 VEX 编程环境中，任务必须使用特殊关键字标记。\
      在大多数现代编程环境中，任务仅仅是异步执行的函数。
    - 虽然上面已经提到过了，但这件事重要到复读：每个任务的循环中\
      必须有 ``delay()`` 语句。

任务管理
===============

PROS 的任务很容易创建：


.. tabs ::
    .. tab :: C
        .. highlight:: c
        .. code-block:: c
           :caption: initialize.c
           :linenos:

            void my_task_fn(void* param) {
                printf("Hello %s\n", (char*)param);
                // ...
            }
            void initialize() {
                task_t my_task = task_create(my_task_fn, "PROS", TASK_PRIORITY_DEFAULT,
                                            TASK_STACK_DEPTH_DEFAULT, "My Task");
            }

    .. tab :: C++
        .. highlight:: cpp
        .. code-block:: cpp
           :caption: initialize.cpp
           :linenos:

            void my_task_fn(void* param) {
                std::cout << Hello << (char*)param << std::endl;
                // ...
            }
            void initialize() {
                std::string text("PROS");
                Task my_task(my_task_fn, &text);
            }
    .. tab :: API2
        .. highlight:: c
        .. code-block:: c
           :caption: initialize.c
           :linenos:

            void my_task_fn(void* param) {
                printf("Hello %s\n", (char*)param);
            }
            void initialize() {
                TaskHandle my_task = taskCreate(my_task_fn, TASK_DEFAULT_STACK_SIZE, "PROS", TASK_PRIORITY_DEFAULT);
            }

`task_create <../../api/c/rtos.html#task_create>`_ 函数接收任务开始的函数、\
那个函数的参数、任务的优先级，尚未讨论的新字段：栈大小和名字。

栈大小描述了分配给这个任务的栈空间。栈是程序\
储存变量、返回函数地址等等的区域。像 PROS 这样在内存有限的情况下工作的实时操作系统是不允许\
动态调整栈大小的。现代桌面操作系统\
不需要像在 RTOS 那样担心栈空间。好消息是大多数任务应该选择
``TASK_STACK_DEPTH_DEFAULT``，这会给几乎任何的任务操作提供足够的栈空间。\
非常基本简单的任务（例如没有很多函数嵌套、没有浮点上下问、变量很少，只有 C)
可能能够使用 ``TASK_STACK_DEPTH_MIN``。

最后的参数是任务的名字。任务名允许你为任务命名一个人性化的名字。\
它主要用于调试目的，允许你（两脚兽）在执行高级任务管理中轻松识别任务。\
任务名称最长可达32个字符，你可以将 NULL 或空字符串传递给函数。
在 API2 中，`taskCreate <../../../cortex/api/index.html#taskCreate>`_ 会自动让任务名变成空字符串。

同步
===============

在使用任务时经常遇到的一个问题就是同步。
如果两个任务试图同时读取同一个传感器或\
控制同一个电机，由于两个任务同时写入同一数据或变量，\
（例如 `竞争条件 <https://en.wikipedia.org/wiki/Race_condition#Software>`_）\
可能会出现预料外的行为。\
编写针对竞争条件代码的概念称为\
线程安全。实现线程安全有许多不同的方法，\
PROS 也拥有几个工具来帮助维护线程安全。

确保线程安全的最简单方法是设计永远不会访问相同变量或数据的任务。\
你可以设计机器人的每部分子系统拥有它们自己的任务。\
确保任务从不写入相同的变量称为\
责任划分（division of responsibility）或领域分离（separation of domain）。

.. code-block:: c
   :linenos:

    int task1_variable = 0;
    void Task1(void * ignore) {
        // 进行一些操作
        task1_variable = 4;
    }

    void Task2(void * ignore) {
      // 进行一些操作
      // 我可以读 task1_variable，但不能写
      printf("%d\n", task1_variable);
    }

有时候这是不可能的：假设你想在一个任务上写一个 PID
控制器，并想改变这个控制器的目标。\
PROS 有两种类型的同步结构可用于协调任务，它们是：\
*互斥* 和 *通知*。

互斥
-------

互斥，即相互排斥；在给定任何时间中，只有一个任务可以持有互斥体。、
其他任务必须等待地一个任务完成（并释放互斥体）\
才能继续运行。

.. tabs::
   .. tab:: C
      .. highlight:: c
      .. code-block:: c
         :linenos:

         mutex_t mutex = mutex_create();

         // 获取互斥体； 其他任务在使用这个命令时候会进入等待，直到互斥体释放
         // 超时可以指定等待的最大时间，或使用 MAX_DELAY 永久等待
         // 如果超时了，函数将会返回“false”，否则返回“true”
         mutex_take(mutex, timeout);
         // 进行一些操作
         // 为其他任务释放互斥体
         mutex_give(mutex);

   .. tab:: C++
      .. highlight:: cpp
      .. code-block:: cpp
         :linenos:

         Mutex mutex;
         // 获取互斥体； 其他任务在使用这个命令时候会进入等待，直到互斥体释放
         // 超时可以指定等待的最大时间，或使用 MAX_DELAY 永久等待
         // 如果超时了，函数将会返回“false”，否则返回“true”
         mutex.take(timeout);
         // 进行一些操作
         // 为其他任务释放互斥体
         mutex.give();

互斥不会神奇地阻止并发写入，\
而是为任务提供相互创建“契约”的能力。你可以想这样编写代码，确保\
任务拥有变量指定的互斥体时才可写入变量。

通知
-------------

任务通知是 PROS 3 中强大的一个新功能，\
它允许面向任务的同步。关于任务通知的完整教程可以在 `这里 <./notifications.html>`_ 找到。
