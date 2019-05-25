==================
通知
==================

.. note:: 有关与任务交互函数的完整列表，请见
          `C API <../../api/c/rtos.html>`_ 和 `C++ API <../../api/cpp/rtos.html>`_。

任务通知是 PROS 3 中强大的一个新功能，它允许面向任务的同步。\
每个任务都有一个 32 位的通知值, 可以跟据自己的通知\
（等待它变为非 0）来进行阻塞，其他任务可以更新这个通知值。
与传统的基于信号量的同步机制相比，\
任务通知具有广泛的应用范围，\
以及易于使用以及在内存和速度上显著的优势。

任务通知的最简单应用不关心任务通知值：

.. tabs ::
    .. tab :: C
        .. highlight:: c
        .. code-block:: c
           :caption: initialize.c
           :linenos:

            void my_task_fn(void* ign) {
                while(task_notify_take(true, TIMEOUT_MAX)) {
                    puts("I was unblocked!");
                }
            }
            void opcontrol() {
                task_t my_task = task_create(my_task_fn, NULL, TASK_PRIORITY_DEFAULT,
                                             TASK_STACK_DEPTH_DEFAULT, "Notify me! Task");
                while(true) {
                    if(controller_get_digital(CONTROLLER_MASTER, DIGITAL_L1)) {
                        task_notify(my_task);
                    }
                }
            }
