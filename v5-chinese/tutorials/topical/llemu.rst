===========================
LLEMU（传统 LCD 仿真器）
===========================

.. note:: 有关与 LLEMU 交互函数的完整列表，请见
          `C API <../../api/c/llemu.html>`_ 和 `C++ API <../../api/cpp/llemu.html>`_。

初始化
==============

初始化 LLEMU 非常简单，只要在 LLEMU 开始显示之前\
调用他的初始化函数即可\
（这很可能在 ``initialize()`` 中）。

初始化是这样完成的：

.. tabs::
   .. group-tab:: C
      .. highlight:: c
      .. code-block:: c
         :caption: initialize.c
         :linenos:

         void initialize() {
           lcd_initialize();
         }

   .. group-tab:: C++
      .. highlight:: cpp
      .. code-block:: cpp
         :caption: initialize.cpp
         :linenos:

         void initializa() {
           pros::lcd::initialize();
         }

写入 LLEMU
====================

写入 LLEMU 几乎等同于使用
`PROS 2 <../../cortex/tutorials/lcd.html>`_ 写入 LCD。
大多数写入应使用打印函数，类似于
`printf <http://www.cplusplus.com/reference/cstdio/printf/>`_。

.. tabs::
   .. group-tab:: C
      .. highlight:: c
      .. code-block:: c
         :caption: initialize.c
         :linenos:

         void initialize() {
           lcd_initialize();
           while (true) {
             lcd_print(0, "Buttons Bitmap: %d\n", lcd_read_buttons());
             delay(20);
           }
         }

   .. group-tab:: C++
      ..highlight:: cpp
      .. code-block:: cpp
         :caption: initialize.cpp
         :linenos:

         void initialize() {
           pros::lcd::initialize();
           while (true) {
             pros::lcd::print(0, "Buttons Bitmap: %d\n", pros::lcd::read_buttons());
             delay(20);
           }
         }

使用按钮
=================

Using the buttons can be done in a similar method to
`PROS 2 <../../../cortex/tutorials/lcd.html>`_ with the
`pros::lcd::read_buttons <../../api/cpp/llemu.html#read-buttons>`_ function. See
the above example for printing the button readings.

While this is sufficient for most applications, some tasks are easier to perform
using the `pros::lcd::register_btn#_cb <../../api/cpp/llemu.html#register-btn0-cb>`_ functions
(where # is replaced with 0, 1, or 2 for the left, center, and right buttons respectively).
With these function you can assign a function to be called each time that the button
is pressed.

.. tabs::
   .. group-tab:: C
      .. highlight:: c
      .. code-block:: c
         :caption: initialize.c
         :linenos:

         void on_center_button() {
           static bool pressed = false;
           pressed = !pressed;
           if (pressed) {
             lcd_set_text(2, "I was pressed!");
           } else {
             lcd_clear_line(2);
           }
         }

         void initialize() {
           lcd_initialize();
           lcd_register_btn0_cb(on_center_button);
         }

   .. group-tab:: C++
      .. highlight:: cpp
      .. code-block:: cpp
         :caption: initialize.cpp
         :linenos:

         void on_center_button() {
           static bool pressed = false;
           pressed = !pressed;
           if (pressed) {
             pros::lcd::set_text(2, "I was pressed!");
           } else {
             pros::lcd::clear_line(2);
           }
         }

         void initialize() {
           pros::lcd::initialize();
           pros::lcd::register_btn0_cb(on_center_button);
         }


.. note:: Custom LVGL code cannot be displayed at the same time as LLEMU.
