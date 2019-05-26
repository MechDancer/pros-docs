===================
无线上传及冷热链接
===================

.. note:: 无线上传至少需要的版本为 CLI 3.1.4、内核 3.1.6、VEXos 1.0.5、OkapiLib 3.3.12（如果用了的话）。

PROS 支持通过 V5 手柄无线上传到 V5 Brain。尽管让 PROS 启用这个\
没什么特殊需求，不过文件传输速度通常难以接受。为了让它们变得更合理，PROS
有一种不同的方法来编译你的项目，以便 PROS 内核和其他不常改的代码\
只上传一次；经常改的代码（例如 opcontrol.cpp、autonomous.cpp、initialize.cpp）\
可通过无线传到 V5。我们称你只传一次、不会修改的为“冷映像”，\
频繁修改上传的代码为“热映像”。

若要启用此编译模式，你得打开你项目的 Makefile，并且改这行：

.. highlight: Makefile
.. code-block:: Makefile

   # 设置为 1 来启用冷/热链接
   USE_PACKAGE:=0

因此 ``USE_PACKAGE:=1``。重新构建并上传你的项目，PROS 将自动使用新文件。PROS
会自动检测你是否在用相同的组合库，并且决定不去重新上传\
“冷”代码。校验库是否存在是靠文件名和校验码来实现的。
如果你使用相同的组合库（冷映像），仅有一份冷映像的副本会被上传到 V5。

大型项目
--------------
即使有冷/热链接，具有大型代码库的项目可能仍然需要一些时间来上传。\
你可以通过把项目的一部分作为库使，让它们被包括进冷映像，以此来减少热映像的大小。\
为此，修改你项目 Makefile 的以下几行：

.. highlight: Makefile
.. code-block:: Makefile

    # 设置为 1 可添加其他规则，将项目编译为 PROS 库模板
    IS_LIBRARY:=0
    # TODO: CHANGE THIS!
    LIBNAME:=libbest
    VERSION:=1.0.0
    # EXCLUDE_SRC_FROM_LIB= $(SRCDIR)/unpublishedfile.c

将 ``IS_LIBRARY`` 改为 ``1``，并挑个名字给库命名。我们推荐 ``lib<你机器人的名字>`` 或者
``lib<你的队号>``（例如``lib7701``）以确保具它是唯一的，不会与其他冷映像发生命名冲突。\
在编译过程中，PROS 会把这个库包括到冷映像的一部分。你的库仅应包含\
不常改变的文件，以便不需要频繁上传冷映像。默认情况下，Makefile
被设置为排除项目的 opcontrol.cpp、autonomous.cpp、、initialize.cpp 文件。如果你经常修改其他文件，\
可以根据需要添加 ``EXCLUDE_SRC_FROM_LIB+=$(SRCDIR)/myfile.c``。

**一个重要的警告**：进入冷映像的代码 **不能** 链接到热映像的任何东西（调用函数或\
使用变量）。这样做将导致链接器错误——你将被告知\
哪处引用了热映像：

::

    bin/libtheseus.a(lcdselector.cpp.o):(.data.inits+0x0): undefined reference to `auton::allianceInit(auton::color)'

你应该重构代码，以便只有“热”代码调用“冷”代码，或把引起问题的文件丢到热映像中。

Makefile 修改后的几行示例如下所示：

.. highlight: Makefile
.. code-block:: Makefile

    # 设置为 1 来启用冷/热链接
    USE_PACKAGE=1

    # 设置为 1 可添加其他规则，将项目编译为 PROS 库模板
    IS_LIBRARY:=1
    LIBNAME:=libtheseus
    VERSION:=1.0.0
    # 这一行排除 opcontrol.c 和类似文件
    EXCLUDE_SRC_FROM_LIB+=$(foreach file, $(SRCDIR)/opcontrol $(SRCDIR)/initialize $(SRCDIR)/autonomous,$(foreach cext,$(CEXTS),$(file).$(cext)) $(foreach cxxext,$(CXXEXTS),$(file).$(cxxext)))
    EXCLUDE_SRC_FROM_LIB+=$(SRCDIR)/scripts             # 排除 src/scripts 目录中的所有文件
    EXCLUDE_SRC_FROM_LIB+=$(SRCDIR)/lcdselector.cpp     # 排除 src/lcdselector.cpp

冷热链接疑难解答
--------------------------------
由于冷/热链接涉及确保两个编译后程序一致交互，\
这种模式下可能有额外运行期问题。本节是调试这类问题的指南。

通常，如果程序看起来运行正常（即屏幕显示）, 那么编译模式工作正常，\
你遇到的错误可能与代码逻辑有关。如果你的代码逻辑在不使用冷/热链接时可以正常工作，\
请联系我们，以便我们可以帮你排除故障。

如果屏幕是黑的，PROS 没有正确启动。

- 全局构造器处于无限循环中或引发了异常
- 另请参见下面的故障排除步骤

如果屏幕是灰的，PROS 正确启动了，但没有运行热映像。

- 删除所有用户程序，执行清理构建，然后上传

如果你有问题，请联系我们，以便我们可以帮助您排除故障。
