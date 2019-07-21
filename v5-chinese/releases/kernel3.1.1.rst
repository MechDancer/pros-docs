=========================
PROS 内核 3.1.1 版本
=========================

.. post:: 20 September, 2018
   :tags: 博客, 内核发布

在 3.1.0 之上修复了许多错误，提升了各方面的可用性。

错误修复：

- 比赛控制现在可以通过 Brain/手柄（而不是之前的比赛开关/场控) 正确运行

- 智能设备（电机、视觉传感器等）的全局构造函数现在可以工作了

- ``pros::Controller::print()`` 现在可以编译并正常工作

- Okapilib 现在默认使用模板操作符控制文件，不再需要事先移除 ``using pros::literals`` 这行

新特性：

- 在 C 和 C++ 中正确的陀螺仪驱动。不再需要手动配置 ADI 端口使其成为陀螺仪

可用性提升：

- 所有比赛控制函数（``autonomous()``、``opcontrol()`` 等）现在被原型化为 ``main.h``，并且能够从用户代码中调用

- C 和 C++ 中所有 API 头文件实现了 ``PROS_USE_SIMPLE_NAMES``

- ``motor_move()`` and its C++ equivalent properly clamp inputs to ``[-127,127]``, so arcade control code will work properly with no clamping of the controller values in user code
