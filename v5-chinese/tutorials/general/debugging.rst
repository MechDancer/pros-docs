=========
调试
=========

.. warning:: 随着 V5 PROS CLI 的创建，此内容可能会发生变化。

`PROS API <../../api/index.html>`_ 提供了像
`printf <http://www.cplusplus.com/reference/cstdio/printf/>`_ 这样\
可以在机器人操作过程中将信息通过串口连接输出到控制台\
的函数。

查看 printf 的输出
=====================

要查看机器人的输出，有两种官方支持的方法：

1. 通过 PROS CLI:

   在命令行运行 ``prosv5 terminal`` 将会打开通过 USB 连接、VEXnet 或
   `JINX <./tutorials/topical/jinx.html>`_ 连接的机器人输出流。
   .

2. 使用 Atom:

   点击带有 "Open cortex serial output" 标签的按钮

.. image:: /images/atom/open-cortex.png

终端面板将在屏幕底部打开，\
其中包含连接机器人的输出。

.. image:: /images/atom/terminal-platformio.png

带有 ``errno`` 的进一步调试信息
=================================

``errno`` 是 PROS 内核任何部分遇到错误时设置的全局值。\
``errno`` 的值是特定于每个函数的，因此在 `API docs <../../api/index.html>`_
检查函数头文件获得可能的值及含义。如果你认为在内核代码中遇到了错误，请检查
``errno`` 的值，看看是什么导致了这个问题。

以这种方式调试是除 PROS 之外的其他环境的标准。有关更多
``errno`` 的信息，参见以下教程：https://www.tutorialspoint.com/cprogramming/c_error_handling.htm

JINX 图形调试器
=======================

JINX 通过打印语句提供了比传统调试更进一步的调试功能。
有关 JINX 能力及使用的完整解释，请见 :doc:`../topical/jinx`。
