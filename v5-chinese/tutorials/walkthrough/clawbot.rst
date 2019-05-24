=======================
为爪爪机器人编程
=======================

.. contents:: :local:

目的
=========

本教程将指导您完成 VEX 爪爪机器人\
的基本编程。

目标受众
=================

本教程面向有一些编程经验，但对 PROS 库陌生的开发者。\
如果你以前从来没写过程序，我们推荐你查看\
`这个教程系列 <http://www.studytonight.com/c/overview-of-c.php>`__\的\
《简介和基本 C 特性》。\
你也可以受益于“指针、数组和字符串部分”\
尽管它们并不相关。

目标
=====

在本教程结束时，你将获得：

-  理解 PROS 基本项目结构
-  会使用“坦克”或“街机”控制对基本底盘进行编程
-  编好的用于控制爪爪机器人机械臂升降的按钮
-  编好的用于控制爪爪的摇杆
-  理解标准子系统模块方法
-  编好的航位推算（dead-reckoned）自动例程

爪爪机器人
===========

这是我们要编程的机器人：

.. image:: /images/tuts/clawbot1.jpg

你可以根据 VEX 的\ `教程 <https://v5beta.vex.com/parent-wrapper.php?id=v5-with-clawbot>`_\搭建这个机器人。

在本教程中，\
我们将电机插入了以下端口：

+--------+----------------+--------+---------------+
| Port   | Description    | Port   | Description   |
+========+================+========+===============+
| 1      | Left Wheels    | 11     |               |
+--------+----------------+--------+---------------+
| 2      |                | 12     |               |
+--------+----------------+--------+---------------+
| 3      | Claw Motor     | 13     |               |
+--------+----------------+--------+---------------+
| 4      |                | 14     |               |
+--------+----------------+--------+---------------+
| 5      | Vision Sensor  | 15     |               |
+--------+----------------+--------+---------------+
| 6      |                | 16     |               |
+--------+----------------+--------+---------------+
| 7      |                | 17     |               |
+--------+----------------+--------+---------------+
| 8      | Arm Motor      | 18     |               |
+--------+----------------+--------+---------------+
| 9      |                | 19     |               |
+--------+----------------+--------+---------------+
| 10     | Right Wheels   | 20     |               |
+--------+----------------+--------+---------------+

Port 21: Radio

ADI:

+--------+----------------+--------+---------------+
| Port   | Description    | Port   | Description   |
+========+================+========+===============+
| A      | Left Bumper    | E      |               |
+--------+----------------+--------+---------------+
| B      | Right Bumper   | F      |               |
+--------+----------------+--------+---------------+
| C      |                | G      |               |
+--------+----------------+--------+---------------+
| D      |                | H      | Arm Limit     |
+--------+----------------+--------+---------------+

创建项目
====================

在 Atom 启动后，你可以点击 ``PROS`` 菜单，点击 ``Create new Project``
创建新的 PROS 项目。

创建一个目录，用于保存爪爪机器人项目的\
源文件。

选择要在其中创建新项目的目录，然后点击创建。\
PROS CLI 会把最新的内核模板复制到制定的目录中，\
然后 Atom 会打开它。

PROS 项目结构
======================

创建项目时，PROS 将复制构建项目所需的所有文件。\
项目的结构如下：

.. highlight:: none

::

  project
  │   project.pros        （PROS CLI 从这得知内核版本和其他元数据）
  │   Makefile            （告诉 make 如何编译这个工程）
  |   common.mk           （Makefile 的帮助文件）
  │
  └───src                 （源文件应该放在这里）
  │   │   autonomous.cpp  （自动部分源码）
  │   │   initialize.cpp  （初始化部分源码）
  │   │   opcontrol.cpp   （遥控部分源码）
  |
  └───include             （头文件应该放在这里）
  │   │   api.h           （让源码知道 PROS API 函数）
  │   │   main.h          （`包含` api.h 和你希望在项目范围内 `包含` 的任何其他内容）
  |   └───pros            （包含所有特定 PROS API 的头文件）
  |   └───okapi           （包含所有 OkapiLib 的头文件）
  |   └───display         （包含 V5 屏幕图形库 LVGL 的头文件）
  │
  └───firmware 
      │   libpros.a       （编译好的 PROS 库）
      │   okapilib.a      （编译好的 OkapiLib）
      |   v5.ld           （告诉链接器如何为 V5 构造二进制文件）


.. note::
   按照惯例，``opcontrol()``、``autonomous()``，和初始化函数被分为单独的文件\
   （opcontrol.cpp、autonomous.cpp、initialize.cpp）。他们可以在同一个文件中,\ 
   但把函数组织到多个文件中对防止事情变得混乱很有帮助。

遥控 
=============

让我们从最简单的爪爪机器人遥控——坦克驾驶控制开始。我们将会\
把左摇杆映射到左侧驱动电机，\
右摇杆映射到右侧驱动电机。

手柄的摇杆可以通过以下函数读值：

.. tabs ::

   .. group-tab :: C++
      .. highlight:: cpp
      ::

         std::int32_t pros::Controller::get_analog ( pros::controller_analog_e_t channel )

   .. group-tab :: C
      .. highlight:: c
      ::

       int32_t controller_get_analog ( controller_id_e_t id,
                                        controller_analog_e_t channel )

然后我们通过以下函数设置电机：

.. tabs ::

   .. group-tab :: C++
      .. highlight:: cpp
      ::

         std::int32_t motor_move ( const std::int8_t voltage )

   .. group-tab :: C
      .. highlight:: c
      ::

       int32_t motor_move ( uint8_t port,
                              const int8_t voltage )
                            
在我们开始使用坦克驾驶控制之前，有一点需要注意。在 C++ 中，智能设备具有创建智能设备对象的 `构造函数`。\
构造函数是一个标准的 C++ 概念，\
它们非常重要，因为构造函数是为定义像电机或手柄这样对象的 `类` 
所必须的。

我们先在 ``opcontrol()`` 开始时调用电机和手柄的构造器，\
然后运行坦克驾驶控制代码。

.. tabs ::

   .. group-tab :: C++
      .. highlight:: cpp
      .. code-block:: cpp
         :caption: opcontrol.cpp 
         :linenos:

         #define LEFT_WHEELS_PORT 1
         #define RIGHT_WHEELS_PORT 10

         void opcontrol() {
           pros::Motor left_wheels (LEFT_WHEELS_PORT);
           pros::Motor right_wheels (RIGHT_WHEELS_PORT, true); // This reverses the motor
           pros::Controller master (CONTROLLER_MASTER);

           while (true) {
             left_wheels.move(master.get_analog(ANALOG_LEFT_Y));
             right_wheels.move(master.get_analog(ANALOG_RIGHT_Y));

             pros::delay(2);
           }
         }

   .. group-tab :: C
      .. highlight:: c
      .. code-block:: c
         :caption: opcontrol.c
         :linenos:

         #define LEFT_WHEELS_PORT 1
         #define RIGHT_WHEELS_PORT 10

         void opcontrol() {
           while (true) {
             int left = controller_get_analog(CONTROLLER_MASTER, ANALOG_LEFT_Y);
             int right = controller_get_analog(CONTROLLER_MASTER, ANALOG_RIGHT_Y);
             right *= -1; // This will reverse the right motor
             motor_move(LEFT_WHEELS_PORT, left);
             motor_move(RIGHT_WHEELS_PORT, right);

             delay(2);
           }
         }

要测试此代码，请在终端窗口中运行以下命令来创建、构建和上传。

.. code :: bash

    prosv5 make
    prosv5 upload

这两个命令可以简化为 ``prosv5 mu``。

街机控制
==============

虽然坦克驾驶控制非常适合一些人的驾驶风格，\
但也值得介绍街机控制方法。这类似于许多视频游戏的运动风格，\
其中一个摇杆轴覆盖向前/向后运动，另一个轴覆盖转动。

我们将采用以前的坦克驾驶控制代码，并稍微修改它，\
成为街机控制。摇杆的两轴值会经过求和或者作差作为左右两轮的功率。
   .. note:: 译者注：原文最后句说的不明白，换了一种更直观的表达方式。

.. tabs ::

   .. group-tab :: C++
      .. highlight:: cpp
      .. code-block:: cpp
         :caption: opcontrol.cpp 
         :linenos:

         #define LEFT_WHEELS_PORT 1
         #define RIGHT_WHEELS_PORT 10

         void opcontrol() {
           pros::Motor left_wheels (LEFT_WHEELS_PORT);
           pros::Motor right_wheels (RIGHT_WHEELS_PORT, true);
           pros::Controller master (CONTROLLER_MASTER);

           while (true) {
             int power = master.get_analog(ANALOG_LEFT_Y);
             int turn = master.get_analog(ANALOG_RIGHT_X);
             int left = power + turn;
             int right = power - turn;
             left_wheels.move(left);
             right_wheels.move(right);

             pros::delay(2);
           }
         }

   .. group-tab :: C
      .. highlight:: c
      .. code-block:: c
         :caption: opcontrol.c
         :linenos:

         #define LEFT_WHEELS_PORT 1
         #define RIGHT_WHEELS_PORT 10

         void opcontrol() {
           while (true) {
             int power = controller_get_analog(CONTROLLER_MASTER, ANALOG_LEFT_Y);
             int turn = controller_get_analog(CONTROLLER_MASTER, ANALOG_RIGHT_X);
             int left = power + turn;
             int right = power - turn;
             right *= -1; // This reverses the right motor
             motor_move(LEFT_WHEELS_PORT, left);
             motor_move(RIGHT_WHEELS_PORT, right);

             delay(2);
           }
         }


与坦克驾驶代码一样，这可以通过 ``prosv5 mu`` 命令上传。

机械臂控制
===========

接下来让我们控制爪爪机器人的机械臂。这不需要用摇杆，\
而是使用手柄的按钮。

我们通过以下函数读按钮的值：

.. tabs ::

   .. group-tab :: C++
      .. highlight:: cpp
      ::

         std::int32_t pros::Controller::get_digital ( pros::controller_digital_e_t button )

   .. group-tab :: C
      .. highlight:: c
      ::

       int32_t controller_get_digital ( controller_id_e_t id,
                                        controller_digital_e_t button )

我们将使用不同于传动系统（drive train）的电机运动函数。通过使用速度控制，
运动函数，我们可以确保升降以恒定速度移动\
而不需要考虑它承载的重量。

.. tabs ::

   .. group-tab :: C++
      .. highlight:: cpp
      ::

         std::int32_t pros::Motor::move_velocity ( const std::int32_t velocity )

   .. group-tab :: C
      .. highlight:: c
      ::
        
        int32_t motor_move_velocity ( uint8_t port, 
                                      const int32_t velocity )

要运动升降机械臂，我们检查最手柄右侧或左侧的扳机是否按下，\
如果是，就按照对应方向移动机械臂。

.. tabs ::

   .. group-tab :: C++
      .. highlight:: cpp
      .. code-block:: cpp
         :caption: opcontrol.cpp 
         :linenos:

         #define LEFT_WHEELS_PORT 1
         #define RIGHT_WHEELS_PORT 10
         #define ARM_PORT 8

         void opcontrol() {
           pros::Motor left_wheels (LEFT_WHEELS_PORT);
           pros::Motor right_wheels (RIGHT_WHEELS_PORT, true);
           pros::Motor arm (ARM_PORT, MOTOR_GEARSET_36); // 机械臂电机使用 100rpm（红色）齿轮组
           pros::Controller master (CONTROLLER_MASTER);

           while (true) {
             int power = master.get_analog(ANALOG_LEFT_Y);
             int turn = master.get_analog(ANALOG_RIGHT_X);
             int left = power + turn;
             int right = power - turn;
             left_wheels.move(left);
             right_wheels.move(right);

             if (master.get_digital(DIGITAL_R1)) {
               arm.move_velocity(100); // 因为是 100rpm 的电机，所以这是 100。
             }
             else if (master.get_digital(DIGITAL_R2)) {
               arm.move_velocity(-100);
             }
             else {
               arm.move_velocity(0);
             }

             pros::delay(2);
           }
         }

   .. group-tab :: C
      .. highlight:: c
      .. code-block:: c
         :caption: opcontrol.c
         :linenos:

         #define LEFT_WHEELS_PORT 1
         #define RIGHT_WHEELS_PORT 10
         #define ARM_PORT 8

         void opcontrol() {
           motor_set_gearing(ARM_PORT, MOTOR_GEARSET_36); // 机械臂电机使用 100rpm（红色）齿轮组
           while (true) {
             int power = controller_get_analog(CONTROLLER_MASTER, ANALOG_LEFT_Y);
             int turn = controller_get_analog(CONTROLLER_MASTER, ANALOG_RIGHT_X);
             int left = power + turn;
             int right = power - turn;
             right *= -1; // This reverses the right motor
             motor_move(LEFT_WHEELS_PORT, left);
             motor_move(RIGHT_WHEELS_PORT, right);

             if (master.get_digital(DIGITAL_R1)) {
               motor_move_velocity(ARM_PORT, 100); // 因为是 100rpm 的电机，所以这是 100。
             }
             else if (master.get_digital(DIGITAL_R2)) {
               motor_move_velocity(ARM_PORT, -100);
             }
             else {
               motor_move_velocity(ARM_PORT, 0);
             }

             delay(2);
           }
         }
       
爪爪控制
============

我们将以升降机械臂相同的方式控制爪爪，通过一个手柄上的按钮切换它的运动。

.. tabs ::

   .. group-tab :: C++
      .. highlight:: cpp
      .. code-block:: cpp
         :caption: opcontrol.cpp 
         :linenos:

         #define LEFT_WHEELS_PORT 1
         #define RIGHT_WHEELS_PORT 10
         #define ARM_PORT 8
         #define CLAW_PORT 3

         void opcontrol() {
           pros::Motor left_wheels (LEFT_WHEELS_PORT);
           pros::Motor right_wheels (RIGHT_WHEELS_PORT, true);
           pros::Motor arm (ARM_PORT, MOTOR_GEARSET_36); // 机械臂电机使用 100rpm（红色）齿轮组
           pros::Motor claw (CLAW_PORT, MOTOR_GEARSET_36);
           pros::Controller master (CONTROLLER_MASTER);

           while (true) {
             int power = master.get_analog(ANALOG_LEFT_Y);
             int turn = master.get_analog(ANALOG_RIGHT_X);
             int left = power + turn;
             int right = power - turn;
             left_wheels.move(left);
             right_wheels.move(right);

             if (master.get_digital(DIGITAL_R1)) {
               arm.move_velocity(100); // 因为是 100rpm 的电机，所以这是 100。
             }
             else if (master.get_digital(DIGITAL_R2)) {
               arm.move_velocity(-100);
             }
             else {
               arm.move_velocity(0);
             }

             if (master.get_digital(DIGITAL_L1)) {
               claw.move_velocity(100);
             }
             else if (master.get_digital(DIGITAL_L2)) {
               claw.move_velocity(-100);
             }
             else {
               claw.move_velocity(0);
             }

             pros::delay(2);
           }
         }

   .. group-tab :: C
      .. highlight:: c
      .. code-block:: c
         :caption: opcontrol.c
         :linenos:

         #define LEFT_WHEELS_PORT 1
         #define RIGHT_WHEELS_PORT 10
         #define ARM_PORT 8
         #define CLAW_PORT 3

         void opcontrol() {
           motor_set_gearing(ARM_PORT, MOTOR_GEARSET_36); // 机械臂电机使用 100rpm（红色）齿轮组
           motor_set_gearing(CLAW_PORT, MOTOR_GEARSET_36);
           while (true) {
             int power = controller_get_analog(CONTROLLER_MASTER, ANALOG_LEFT_Y);
             int turn = controller_get_analog(CONTROLLER_MASTER, ANALOG_RIGHT_X);
             int left = power + turn;
             int right = power - turn;
             right *= -1; // This reverses the right motor
             motor_move(LEFT_WHEELS_PORT, left);
             motor_move(RIGHT_WHEELS_PORT, right);

             if (master.get_digital(DIGITAL_R1)) {
               motor_move_velocity(ARM_PORT, 100); // 因为是 100rpm 的电机，所以这是 100。
             }
             else if (master.get_digital(DIGITAL_R2)) {
               motor_move_velocity(ARM_PORT, -100);
             }
             else {
               motor_move_velocity(ARM_PORT, 0);
             }

             if (master.get_digital(DIGITAL_R1)) {
               motor_move_velocity(CLAW_PORT, 100); // 因为是 100rpm 的电机，所以这是 100。
             }
             else if (master.get_digital(DIGITAL_R2)) {
               motor_move_velocity(CLAW_PORT, -100);
             }
             else {
               motor_move_velocity(CLAW_PORT, 0);
             }

             delay(2);
           }
         }

读取开关
====================

保险杠开关/按钮插入了 ADI 并装在了机器人的后部。\
我们会监控它的状态，如果它被按下了，\ 
则禁止机器人向后运动。

为此，我们将使用 ADI 数字信号读取功能。

.. tabs ::

   .. group-tab :: C++
      .. highlight:: cpp
      ::

         std::int32_t pros::ADIDigitalIn::get_value ( ) const

   .. group-tab :: C
      .. highlight:: c
      ::
        
        int32_t adi_get_value (uint8_t port )

下面是更新后的代码：

.. tabs ::

   .. group-tab :: C++
      .. highlight:: cpp
      .. code-block:: cpp
         :caption: opcontrol.cpp 
         :linenos:

         #define LEFT_WHEELS_PORT 1
         #define RIGHT_WHEELS_PORT 10
         #define ARM_PORT 8
         #define CLAW_PORT 3

         #define LEFT_BUMPER_PORT 'a'
         #define RIGHT_BUMPER_PORT 'b'

         void opcontrol() {
           pros::Motor left_wheels (LEFT_WHEELS_PORT);
           pros::Motor right_wheels (RIGHT_WHEELS_PORT, true);
           pros::Motor arm (ARM_PORT, MOTOR_GEARSET_36); // 机械臂电机使用 100rpm（红色）齿轮组
           pros::Motor claw (CLAW_PORT, MOTOR_GEARSET_36);

           pros::ADIDigitalIn left_bumper (LEFT_BUMPER_PORT);
           pros::ADIDigitalIn right_bumper (RIGHT_BUMPER_PORT);

           pros::Controller master (CONTROLLER_MASTER);

           while (true) {
             int power = master.get_analog(ANALOG_LEFT_Y);
             int turn = master.get_analog(ANALOG_RIGHT_X);
             int left = power + turn;
             int right = power - turn;
             
             if (left_bumper.get_value() || right_bumper.get_value()) {
               // One of the bump switches is currently pressed
               if (left < 0) {
                 left = 0;
               }
               if (right < 0) {
                 right = 0;
               }
             }
             left_wheels.move(left);
             right_wheels.move(right);

             if (master.get_digital(DIGITAL_R1)) {
               arm.move_velocity(100); // 因为是 100rpm 的电机，所以这是 100。
             }
             else if (master.get_digital(DIGITAL_R2)) {
               arm.move_velocity(-100);
             }
             else {
               arm.move_velocity(0);
             }

             if (master.get_digital(DIGITAL_L1)) {
               claw.move_velocity(100);
             }
             else if (master.get_digital(DIGITAL_L2)) {
               claw.move_velocity(-100);
             }
             else {
               claw.move_velocity(0);
             }

             pros::delay(2);
           }
         }

   .. group-tab :: C
      .. highlight:: c
      .. code-block:: c
         :caption: opcontrol.c
         :linenos:

         #define LEFT_WHEELS_PORT 1
         #define RIGHT_WHEELS_PORT 10
         #define ARM_PORT 8
         #define CLAW_PORT 3

         #define LEFT_BUMPER_PORT 'a'
         #define RIGHT_BUMPER_PORT 'b'

         void opcontrol() {
           motor_set_gearing(ARM_PORT, MOTOR_GEARSET_36); // 机械臂电机使用 100rpm（红色）齿轮组
           motor_set_gearing(CLAW_PORT, MOTOR_GEARSET_36);

           adi_port_set_config(LEFT_BUMPER_PORT, ADI_DIGITAL_IN);
           adi_port_set_config(RIGHT_BUMPER_PORT, ADI_DIGITAL_IN);
           while (true) {
             int power = controller_get_analog(CONTROLLER_MASTER, ANALOG_LEFT_Y);
             int turn = controller_get_analog(CONTROLLER_MASTER, ANALOG_RIGHT_X);
             int left = power + turn;
             int right = power - turn;
             
             if (adi_port_get_value(LEFT_BUMPER_PORT) || adi_port_get_value(RIGHT_BUMPER_PORT)) {
               // One of the bump switches is currently pressed
               if (left < 0) {
                 left = 0;
               }
               if (right < 0) {
                 right = 0;
               }
             }
             right *= -1; // This reverses the right motor
             motor_move(LEFT_WHEELS_PORT, left);
             motor_move(RIGHT_WHEELS_PORT, right);

             if (master.get_digital(DIGITAL_R1)) {
               motor_move_velocity(ARM_PORT, 100); // 因为是 100rpm 的电机，所以这是 100。
             }
             else if (master.get_digital(DIGITAL_R2)) {
               motor_move_velocity(ARM_PORT, -100);
             }
             else {
               motor_move_velocity(ARM_PORT, 0);
             }

             if (master.get_digital(DIGITAL_R1)) {
               motor_move_velocity(CLAW_PORT, 100); // 因为是 100rpm 的电机，所以这是 100。
             }
             else if (master.get_digital(DIGITAL_R2)) {
               motor_move_velocity(CLAW_PORT, -100);
             }
             else {
               motor_move_velocity(CLAW_PORT, 0);
             }

             delay(2);
           }
         }

我们将使用类似的技术读取限位开关。如果按下限位开关，\
则阻止机械臂进一步下降。

.. tabs ::

   .. group-tab :: C++
      .. highlight:: cpp
      .. code-block:: cpp
         :caption: opcontrol.cpp 
         :linenos:

         #define LEFT_WHEELS_PORT 1
         #define RIGHT_WHEELS_PORT 10
         #define ARM_PORT 8
         #define CLAW_PORT 3

         #define LEFT_BUMPER_PORT 'a'
         #define RIGHT_BUMPER_PORT 'b'
         #define ARM_LIMIT_SWITCH_PORT 'h'

         void opcontrol() {
           pros::Motor left_wheels (LEFT_WHEELS_PORT);
           pros::Motor right_wheels (RIGHT_WHEELS_PORT, true);
           pros::Motor arm (ARM_PORT, MOTOR_GEARSET_36); // 机械臂电机使用 100rpm（红色）齿轮组
           pros::Motor claw (CLAW_PORT, MOTOR_GEARSET_36);

           pros::ADIDigitalIn left_bumper (LEFT_BUMPER_PORT);
           pros::ADIDigitalIn right_bumper (RIGHT_BUMPER_PORT);
           pros::ADIDigitalIn arm_limit (ARM_LIMIT_SWITCH_PORT);

           pros::Controller master (CONTROLLER_MASTER);

           while (true) {
             int power = master.get_analog(ANALOG_LEFT_Y);
             int turn = master.get_analog(ANALOG_RIGHT_X);
             int left = power + turn;
             int right = power - turn;

             if (left_bumper.get_value() || right_bumper.get_value()) {
               // One of the bump switches is currently pressed
               if (left < 0) {
                 left = 0;
               }
               if (right < 0) {
                 right = 0;
               }
             }
             left_wheels.move(left);
             right_wheels.move(right);

             if (master.get_digital(DIGITAL_R1)) {
               arm.move_velocity(100); // 因为是 100rpm 的电机，所以这是 100。
             }
             else if (master.get_digital(DIGITAL_R2) && !arm_limit.get_value()) {
               arm.move_velocity(-100);
             }
             else {
               arm.move_velocity(0);
             }

             if (master.get_digital(DIGITAL_L1)) {
               claw.move_velocity(100);
             }
             else if (master.get_digital(DIGITAL_L2)) {
               claw.move_velocity(-100);
             }
             else {
               claw.move_velocity(0);
             }

             pros::delay(2);
           }
         }

   .. group-tab :: C
      .. highlight:: c
      .. code-block:: c
         :caption: opcontrol.c
         :linenos:

         #define LEFT_WHEELS_PORT 1
         #define RIGHT_WHEELS_PORT 10
         #define ARM_PORT 8
         #define CLAW_PORT 3

         #define LEFT_BUMPER_PORT 'a'
         #define RIGHT_BUMPER_PORT 'b'
         #define ARM_LIMIT_SWITCH_PORT 'h'

         void opcontrol() {
           motor_set_gearing(ARM_PORT, GEARSET_36); // 机械臂电机使用 100rpm（红色）齿轮组
           motor_set_gearing(CLAW_PORT, GEARSET_36);

           adi_port_set_config(LEFT_BUMPER_PORT, ADI_DIGITAL_IN);
           adi_port_set_config(RIGHT_BUMPER_PORT, ADI_DIGITAL_IN);
           adi_port_set_config(ARM_LIMIT_SWITCH_PORT, ADI_DIGITAL_IN);
           while (true) {
             int power = controller_get_analog(CONTROLLER_MASTER, CONTROLLER_ANALOG_LEFT_Y);
             int turn = controller_get_analog(CONTROLLER_MASTER, CONTROLLER_ANALOG_RIGHT_X);
             int left = power + turn;
             int right = power - turn;
             
             if (adi_port_get_value(LEFT_BUMPER_PORT) || adi_port_get_value(RIGHT_BUMPER_PORT)) {
               // One of the bump switches is currently pressed
               if (left < 0) {
                 left = 0;
               }
               if (right < 0) {
                 right = 0;
               }
             }
             right *= -1; // This reverses the right motor
             motor_move(LEFT_WHEELS_PORT, left);
             motor_move(RIGHT_WHEELS_PORT, right);

             if (master.get_digital(CONTROLLER_DIGITAL_R1)) {
               motor_move_velocity(ARM_PORT, 100); // 因为是 100rpm 的电机，所以这是 100。
             }
             else if (master.get_digital(CONTROLLER_DIGITAL_R2) && !adi_port_get_value(ARM_LIMIT_SWITCH_PORT)) {
               motor_move_velocity(ARM_PORT, -100);
             }
             else {
               motor_move_velocity(ARM_PORT, 0);
             }

             if (master.get_digital(CONTROLLER_DIGITAL_R1)) {
               motor_move_velocity(CLAW_PORT, 100); // 因为是 100rpm 的电机，所以这是 100。
             }
             else if (master.get_digital(CONTROLLER_DIGITAL_R2)) {
               motor_move_velocity(CLAW_PORT, -100);
             }
             else {
               motor_move_velocity(CLAW_PORT, 0);
             }

             delay(2);
           }
         }

简单自动
=================

自动程序运行时不使用手柄。我们将写一个简单的向前直走自动程序。

.. tabs ::

   .. group-tab :: C++
      .. highlight:: cpp
      .. code-block:: cpp
         :caption: autonomous.cpp 
         :linenos:

         #define LEFT_WHEELS_PORT 1
         #define RIGHT_WHEELS_PORT 10
         #define MOTOR_MAX_SPEED 100 // 电机使用 36 号齿轮组

         void autonomous() {
           pros::Motor left_wheels (LEFT_WHEELS_PORT);
           pros::Motor right_wheels (RIGHT_WHEELS_PORT, true); // This reverses the motor
           
           right_wheels.move_relative(1000, MOTOR_MAX_SPEED);
           left_wheels.move_relative(1000, MOTOR_MAX_SPEED);
         }

   .. group-tab :: C
      .. highlight:: c
      .. code-block:: c
         :caption: autonomous.c
         :linenos:

         #define LEFT_WHEELS_PORT 1
         #define RIGHT_WHEELS_PORT 10
         #define MOTOR_MAX_SPEED 100 // 电机使用 36 号齿轮组

         void autonomous() {
           motor_move_relative(LEFT_WHEELS_PORT, 1000, MOTOR_MAX_SPEED);
           motor_move_relative(RIGHT_WHEELS_PORT, -1000, MOTOR_MAX_SPEED);
         }
