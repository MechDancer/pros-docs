==========
文件系统
==========

你可以通过标准 C/C++ 文件 I/O 方法与 microSD 卡上的文件（V5 Brains 的闪存是 **不能** 的）
进行交互。在大多数情况下，你可以遵循任何标准 C 的文件 IO 教程，\
它们在 PROS 上也是行得通的。\
以下是推荐的教程：

- https://www.cprogramming.com/tutorial/cfileio.html
- https://www.tutorialspoint.com/cprogramming/c_file_io.htm

在 PROS 中与文件系统交互时唯一需要附加的细节是\
microSD 卡上的文件 **必须** 以 ``/usd/`` 开头。
microSD 卡上的文件可以通过以下方式写入：

.. highlight: cpp
.. code-block:: cpp

   FILE* usd_file_write = fopen("/usd/example.txt", "w");
   fputs("Example text", usd_fil_write);
   fclose(usd_file_write);

   FILE* usd_file_read = fopen("/usd/example.txt", "r");
   char buf[50]; // 大于文件内容即可
   fread(buf, 1, 50, usd_file_read); // 传 1 是因为一个 `char` 1 字节，50 b/c 是 buf 的长度
   printf("%s\n", buf); // 打印从文件中读取的字符串
   // 应该将 "Example text" 打印到终端
   fclose(usd_file_read); // 用完文件后，不要忘了关闭它们

串口
======

通过文件系统的驱动，你也可以和串口通信交互（``stdin``、``stdout`` 等等）。\
你可以用与操作文件相同的方式读写这些流，\
但是要使用四个字符流标识符。

例如，你可以通过以下方式写入“stderr”：

.. highlight: cpp
.. code-block:: cpp

   FILE* stderr = fopen("serr", "w");
   fputs("Example text", stderr);
   fclose(usd_file_write);

`apix.h <../../extended/apix.html>`_ 还暴露了许多控制串口通信行为的方法。
这些方法可以通过\
``serctl()`` 函数访问。目前只支持两个动作——\
激活/停用流，以及启用/禁用 `COBS <https://en.wikipedia.org/wiki/Consistent_Overhead_Byte_Stuffing>`_。\
如个你想自己读串口通信（不使用 ``pros terminal``），
那么你得禁用 COBS。
