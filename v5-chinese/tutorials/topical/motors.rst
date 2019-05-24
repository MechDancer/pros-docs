======
电机
======

.. note:: 有关与 V5 电机交互函数的完整列表，请见
          `C API <../../api/c/motors.html>`_ 和 `C++ API <../../api/cpp/motors.html>`_。

初始化
==============

V5 电机在代码中使用前应该先配置。像齿轮组或编码器单位这样的配置选项\
是非常重要的，应该优先考虑，\
以确保像 `motor_move_velocity <../../api/c/motors.html#motor-move-velocity>`_ 这样的函数能够\
预期工作。

在 C++ 中声明电机时，没有必要为了设置参数而多次使用构造器\
（除了端口号）。\
一个例子如下所示。

.. tabs::
   .. group-tab:: C
      .. highlight:: c
      .. code-block:: c
         :caption: initialize.c
         :linenos:

         #define MOTOR_PORT 1

         void initialize() {
           motor_set_gearing(MOTOR_PORT, E_MOTOR_GEARSET_18);
           motor_set_reversed(MOTOR_PORT, true);
           motor_set_encoder_units(MOTOR_PORT, E_MOTOR_ENCODER_DEGREES);
         }

   .. group-tab:: C++
      .. highlight:: cpp
      .. code-block:: cpp
         :caption: initialize.cpp
         :linenos:

         #define MOTOR_PORT 1

         void initialize() {
           pros::Motor drive_left_initializer (MOTOR_PORT, E_MOTOR_GEARSET_18, true, E_MOTOR_ENCODER_DEGREES);
         }

      .. code-block:: cpp
         :caption: opcontrol.cpp
         :linenos:

         #define MOTOR_PORT 1

         void opcontrol() {
           pros::Motor drive_left (MOTOR_PORT);
           // drive_left will have the same configuration as drive_left_initializer
         }

简单使用
============

与电机交互的最简单的方式是通过 `motor_move <../../api/c/motors.html#motor-move>`_
函数。这类似于 PROS 2 中的
`motorSet <../../../cortex/api/index.html#motorSet>`_。

.. tabs::
   .. group-tab:: C
      .. highlight:: c
      .. code-block:: c
         :caption: opcontrol.c
         :linenos:

         #define MOTOR_PORT 1

         void opcontrol() {
           while (true) {
             motor_move(MOTOR_PORT, controller_get_analog(E_CONTROLLER_MASTER, E_CONTROLLER_ANALOG_LEFT_Y));
             delay(2);
           }
         }

   .. group-tab:: C++
      .. highlight:: cpp
      .. code-block:: cpp
         :caption: opcontrol.cpp
         :linenos:

         #define MOTOR_PORT 1

         void opcontrol() {
           pros::Motor drive_left (MOTOR_PORT);
           pros::Controller master (E_CONTROLLER_MASTER);
           while (true) {
             drive_left.move(master.get_analog(E_CONTROLLER_ANALOG_LEFT_Y));
             pros::delay(2);
           }
         }

自动转动
===================

V5 电机可以用多种不同的方式转动，这些都比上面所示简单 ``motor_move()``
更加适合自动运动（autonomous movement）。

位置环转动
-----------------

位置环转动（Profile movements）是给定角度、由电机固件执行的转动。\
有两个函数可以实现这一点，``motor_move_absolute()`` 和
``motor_move_relative()``。这两个函数实际上是相似的，但
``motor_move_relative()`` 考虑了电机编码器的零位。

这些函数更加适合自动运动。

.. tabs::
   .. group-tab:: C
      .. highlight:: c
      .. code-block:: c
         :caption: autonomous.c
         :linenos:

         #define MOTOR_PORT 1
         #define MOTOR_MAX_SPEED 100 // 电机使用 36 号齿轮组

         void autonomous() {
           motor_move_relative(MOTOR_PORT, 1000, MOTOR_MAX_SPEED);
           // 这将向前转动 1000 刻度
           motor_move_relative(MOTOR_PORT, 1000, MOTOR_MAX_SPEED);
           // T这又向前转动 1000 刻度
           motor_move_absolute(MOTOR_PORT, 1000, MOTOR_MAX_SPEED);
           // 这会向后转动 1000 刻度到达绝对的 1000 刻度
         }

   .. group-tab:: C++
      .. highlight:: cpp
      .. code-block:: cpp
         :caption: autonomous.cpp
         :linenos:

         #define MOTOR_PORT 1
         #define MOTOR_MAX_SPEED 100 // 电机使用 36 号齿轮组

         void autonomous() {
           pros::Motor drive_left (MOTOR_PORT);
           drive_left.move_relative(1000, MOTOR_MAX_SPEED);
           // 这将向前转动 1000 刻度
           drive_left.move_relative(1000, MOTOR_MAX_SPEED);
           // 这又向前转动 1000 刻度
           drive_left.move_absolute(1000, MOTOR_MAX_SPEED);
           // 这会向后转动 1000 刻度到以达绝对的 1000 刻度
         }

有关创建这些位置环转动算法的更多阅读材料，请见
`前馈 <https://en.wikipedia.org/wiki/Feed_forward_(control)>`_ 控制的
`Mathematics of Motion Control Profiles <https://pdfs.semanticscholar.org/a229/fdba63d8d68abd09f70604d56cc07ee50f7d.pdf>`_
和 `反馈 <https://en.wikipedia.org/wiki/Control_theory#PID_feedback_control>`_ 控制的
`George Gillard's PID Explanation <http://georgegillard.com/documents/2-introduction-to-pid-controllers>`_。

速度环转动
----------------------------

最后一个 PROS 电机 API 可用的 `转动` 函数是 ``motor_move_velocity()``。\
它保证了电机输出的速度是不变的，通过\
`PID <http://georgegillard.com/documents/2-introduction-to-pid-controllers>`_ 实现。

.. tabs::
   .. group-tab:: C
      .. highlight:: c
      .. code-block:: c
         :caption: autonomous.c
         :linenos:

         #define MOTOR_PORT 1
         #define MOTOR_MAX_SPEED 100 // 电机使用 36 号齿轮组

         void autonomous() {
           motor_move_velocity(MOTOR_PORT, MOTOR_MAX_SPEED);
           delay(1000); // 满速运行 1 秒
         }

   .. group-tab:: C++
      .. highlight:: cpp
      .. code-block:: cpp
         :caption: autonomous.cpp
         :linenos:

         #define MOTOR_PORT 1
         #define MOTOR_MAX_SPEED 100 // 电机使用 36 号齿轮组

         void autonomous() {
           pros::Motor drive_left (MOTOR_PORT);
           drive_left.move_velocity(MOTOR_MAX_SPEED);
           pros::delay(1000); // 满速运行 1 秒
         }

遥测
=========

V5 电机返回大量关于性能的诊断信息。\
电机返回以下参数：

============= ============================== ============================================================
 参数          C 函数                          C++ 函数
============= ============================== ============================================================
 位置          motor_get_position_            `pros::Motor::get_position <get_position_>`_
 速度          motor_get_actual_velocity_     `pros::Motor::get_actual_velocity <get_actual_velocity_>`_
 电流          motor_get_current_draw_        `pros::Motor::get_current_draw <get_current_draw_>`_
 效率          motor_get_efficiency_          `pros::Motor::get_efficiency <get_efficiency_>`_
 功率          motor_get_power_               `pros::Motor::get_power <get_power_>`_
 温度          motor_get_temperature_         `pros::Motor::get_temperature <get_temperature_>`_
 转距          motor_get_torque_              `pros::Motor::get_torque <get_torque_>`_
 电压          motor_get_voltage_             `pros::Motor::get_voltage <get_voltage_>`_
 方向          motor_get_direction_           `pros::Motor::get_direction <get_direction_>`_
============= ============================== ============================================================

.. _motor_get_position: ../../api/c/motors.html#motor-get-position
.. _motor_get_actual_velocity: ../../api/c/motors.html#motor-get-actual-velocity
.. _motor_get_current_draw: ../../api/c/motors.html#motor-get-current-draw
.. _motor_get_efficiency: ../../api/c/motors.html#motor-get-efficiency
.. _motor_get_power: ../../api/c/motors.html#motor-get-power
.. _motor_get_temperature: ../../api/c/motors.html#motor-get-temperature
.. _motor_get_torque: ../../api/c/motors.html#motor-get-torque
.. _motor_get_voltage: ../../api/c/motors.html#motor-get-voltage
.. _motor_get_direction: ../../api/c/motors.html#motor-get-direction

.. _get_position: ../../api/cpp/motors.html#get-position
.. _get_actual_velocity: ../../api/cpp/motors.html#get-actual-velocity
.. _get_current_draw: ../../api/cpp/motors.html#get-current-draw
.. _get_efficiency: ../../api/cpp/motors.html#get-efficiency
.. _get_power: ../../api/cpp/motors.html#get-power
.. _get_temperature: ../../api/cpp/motors.html#get-temperature
.. _get_torque: ../../api/cpp/motors.html#get-torque
.. _get_voltage: ../../api/cpp/motors.html#get-voltage
.. _get_direction: ../../api/cpp/motors.html#get-direction
