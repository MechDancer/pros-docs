=======================
V5 Brain 显示屏（LVGL）
=======================

我们可以通过 `LVGL <https://littlevgl.com>`_ 与 V5 Brain 上的触摸屏交互。\
LVGL 是一个功能齐全的 C 图形库（在相同的 API 下也可以在 C++ 项目中访问）。

开始使用 LVGL 的第一步是在你的 ``main.h`` 文件或其他头文件中包含 ``apix.h`` 。\
这包括了在他们的文档中描述的完整 LVGL 功能集：https://littlevgl.com/

你可以遵从任何 LVGL `教程 <https://github.com/littlevgl/lv_examples/tree/master/lv_tutorial>`_
或 `维基 <https://docs.littlevgl.com/#Objects>`_。你可以直接开始创建对象，\
并不需要移植或初始化 LVGL。

.. note:: 自定义 LVGL 代码不能与 `LLEMU <./llemu.html>`_ 同时显示。
          因此，\
          你必须移除在新项目中默认有的 LLEMU 代码（``pros::lcd``）。
