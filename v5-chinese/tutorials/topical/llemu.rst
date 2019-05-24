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

使用按钮的方法与
`PROS 2 <../../../cortex/tutorials/lcd.html>`_
`pros::lcd::read_buttons <../../api/cpp/llemu.html#read-buttons>`_ 的类似。\
参阅上面的示例打印按钮读数。

虽然这对于大多数应用程序来说已经足够，但是使用
`pros::lcd::register_btn#_cb <../../api/cpp/llemu.html#register-btn0-cb>`_ 函数\
（# 分别替换为 0、1 或 2 对应左、中、右按钮）更容易执行一些任务。
使用这些函数，\
你可以分配每次按下按钮时调用的函数。

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


.. note:: 自定义 LVGL 代码不能与 LLEMU 同时显示。
