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

One problem which one often runs into when dealing with tasks is the
problem of synchronization. If two tasks try to read the same sensor or
control the same motor at the same time, unexpected behavior may occur
since two tasks are trying to write to the same piece of data or variable
(i.e. `race conditions <https://en.wikipedia.org/wiki/Race_condition#Software>`_).
The concept of writing code which has protections against race conditions
is called thread safety. There are many different ways to implement thread safety,
and PROS has several facilities to help maintain thread safety.

The simplest way to ensure thread safety is to design tasks which will never access
the same variables or data. You may design your code to have each subsystem of your
robot in its own task. Ensuring that tasks never write to the same variables is called
division of responsibility or separation of domain.

.. code-block:: c
   :linenos:

    int task1_variable = 0;
    void Task1(void * ignore) {
        // do things
        task1_variable = 4;
    }

    void Task2(void * ignore) {
      // do things
      // I can read task1_variable, but NOT write to it
      printf("%d\n", task1_variable);
    }

Sometimes this is impossible: suppose you wanted to write a PID
controller on its own task and you wanted to change the target of the
PID controller. PROS features two types of synchronization structures,
*mutexes* and *notifications* that can be used to coordinate tasks.

互斥
-------

Mutexes stand for mutual exclusion; only one task can hold a mutex at any given
time. Other tasks must wait for the first task to finish (and release
the mutex) before they may continue.

.. tabs::
   .. tab:: C
      .. highlight:: c
      .. code-block:: c
         :linenos:

         mutex_t mutex = mutex_create();

         // Acquire the mutex; other tasks using this command will wait until the mutex is released
         // timeout can specify the maximum time to wait, or MAX_DELAY to wait forever
         // If the timeout expires, "false" will be returned, otherwise "true"
         mutex_take(mutex, timeout);
         // do some work
         // Release the mutex for other tasks
         mutex_give(mutex);

   .. tab:: C++
      .. highlight:: cpp
      .. code-block:: cpp
         :linenos:

         Mutex mutex;
         // Acquire the mutex; other tasks using this command will wait until the mutex is released
         // timeout can specify the maximum time to wait, or MAX_DELAY to wait forever
         // If the timeout expires, "false" will be returned, otherwise "true"
         mutex.take(timeout);
         // do some work
         // Release the mutex for other tasks
         mutex.give();

Mutexes do not magically prevent concurrent writing, but provide the ability for tasks to
create "contracts" with each other. You can write your code such that a variable is never
written to unless the task owns a mutex designated for that variable.

通知
-------------

Task notifications are a powerful new feature in PROS 3 which allows direct-to-task
synchronization. A full tutorial on task notifications can be found `here <./notifications.html>`_.
