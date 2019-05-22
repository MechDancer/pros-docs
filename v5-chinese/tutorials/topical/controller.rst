==========
手柄
==========

.. note:: 有关与 V5 手柄交互函数的完整列表，请见
          `C API <../../api/c/misc.html>`_ and `C++ API <../../api/cpp/misc.html>`_。

V5 手柄的反馈有两种形式——模拟和数字。\
模拟数据来源于 `摇杆 <https://en.wikipedia.org/wiki/Analog_stick>`_，
数字数据来源于按钮。

模拟数据是在 [-127，127] 范围内的值，数字数据是
1 或者 0（分别是按下或未按下)。

模拟数据
===========

按照下列方式从 V5 手柄中获取模拟值：

.. tabs::
   .. group-tab :: C
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

   .. group-tab :: C++
      .. highlight:: cpp
      .. code-block:: cpp
         :caption: opcontrol.cpp
         :linenos:

         #define MOTOR_PORT 1

         void opcontrol() {
           pros::Controller master (E_CONTROLLER_MASTER);
           pros::Motor example_motor (MOTOR_PORT);
           while (true) {
             example_motor = master.get_analog(E_CONTROLLER_ANALOG_LEFT_Y);
             pros::delay(2);
           }
         }

手柄返回 [-127,127] 范围内的模拟数据正好与
`motor_move <../../api/c/motors.html#motor-move>`_ 函数相适，\
这也是电机和手柄一起用很方便的原因。

数字数据
============

按照下列方式从 V5 手柄中获取数字值：

.. tabs::
   .. group-tab :: C
      .. highlight:: c
      .. code-block:: c
         :caption: opcontrol.c
         :linenos:

         #define MOTOR_PORT 1

         void opcontrol() {
          while (true) {
            if (controller_get_digital(E_CONTROLLER_MASTER, E_CONTROLLER_DIGITAL_A)) {
              motor_move(MOTOR_PORT, 127);
            }
            else {
              motor_move(MOTOR_PORT, 0);
            }

            delay(2);
          }
         }

   .. group-tab :: C++
      .. highlight:: cpp
      .. code-block:: cpp
         :caption: opcontrol.cpp
         :linenos:

         #define MOTOR_PORT 1

         void opcontrol() {
           pros::Controller master (E_CONTROLLER_MASTER);
           pros::Motor example_motor (MOTOR_PORT);
           while (true) {
             if (master.get_digital(E_CONTROLLER_DIGITAL_A)) {
               example_motor = 127;
             }
             else {
               example_motor = 0;
             }

             pros::delay(2);
           }
         }
