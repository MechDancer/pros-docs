=========================
PROS 内核 3.1.6 版本
=========================

.. post:: 18 February, 2019
   :tags: blog, kernel-release

.. warning:: 请务必查看以下重要升级说明。

新特性：

- 支持冷/热链接
- 修复 LLEMU 和任务通知的一些 bug

可用性提升：

- 重构 Makefile

错误修复：

- 各式各样的 RTOS bug
- 修复了使用手柄打印时可能出现的缓冲区溢出

重要升级说明
------------------------------

为了支持修改后的冷/热链接，Makefile 还需要修改，\
这件事就交给你了。当更新项目时（无论是否启用\
冷/热链接）都必须按照下列方式修改 Makefile：

1. 移除 `-include ./common.mk` 后的所有行
2. 在 `-include ./common.mk` 这行上面添加下列两行（例如在 `EXTRA_CXXFLAGS=` 下面）：

    .. highlight: Makefile
    .. code-block:: Makefile
    
        # Set to 1 to enable hot/cold linking
        USE_PACKAGE:=0

你的 Makefile 现在应该和模板 `Makefile <https://github.com/purduesigbots/pros/blob/3.1.6/template-Makefile>`_ 相似。
