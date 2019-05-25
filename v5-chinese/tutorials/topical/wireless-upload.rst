===================
无线上传及冷热链接
===================

.. note:: 无线上传至少需要的版本为 CLI 3.1.4、内核 3.1.6、VEXos 1.0.5、OkapiLib 3.3.12（如果用了的话）。

PROS 支持通过 V5 手柄无线上传到 V5 Brain。尽管让 PROS 启用这个\
没什么特殊需求，不过文件传输速度通常难以接受。为了让它们变得更合理，PROS
有一种不同的方法来编译你的项目，以便 PROS 内核和其他不常改的代码\
只上传一次；你经常改的代码（例如 opcontrol.cpp、autonomous.cpp、initialize.cpp）\
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
即使有热/冷链接，具有大型代码库的项目可能仍然需要一些时间来上传。\
你可以通过把项目的一部分作为库使，让它们被包括进冷映像，以此来减少热映像的大小。\
为此，修改你项目 Makefile 的以下几行：

.. highlight: Makefile
.. code-block:: Makefile

    # 设置为 1 可添加其他规则，为了将项目编译为 PROS 库模板
    IS_LIBRARY:=0
    # TODO: CHANGE THIS!
    LIBNAME:=libbest
    VERSION:=1.0.0
    # EXCLUDE_SRC_FROM_LIB= $(SRCDIR)/unpublishedfile.c

将 ``IS_LIBRARY`` 改为 ``1``，并挑个名字给库命名。我们推荐 ``lib<你机器人的名字>`` 或者
``lib<你的队号>``（例如``lib7701``）以确保具它是唯一的，不会与其他冷映像发生命名冲突。\
When compiling, PROS will include this library as part of the cold image. Your library should only contain
files you infrequently change so that you do not have to frequently upload the cold image. By default, the Makefile 
is set up to exclude your project's opcontrol.cpp, autonomous.cpp, and initialize.cpp files. If you change other 
files frequently, you can add lines like ``EXCLUDE_SRC_FROM_LIB+=$(SRCDIR)/myfile.c`` as needed.

**An important caveat** is that code that goes into the cold image is **not** able to link against anything (call 
functions or use variables) in the hot image. Doing so will result in a linker error - you will be told what's
trying to refer to what in the hot image:

::

    bin/libtheseus.a(lcdselector.cpp.o):(.data.inits+0x0): undefined reference to `auton::allianceInit(auton::color)'

You should refactor your code so that only "hot" code calls "cold" code or include the culprit file in the hot image.

An example of a modified Makefile's relevant lines is shown below:

.. highlight: Makefile
.. code-block:: Makefile

    # Set to 1 to enable hot/cold linking
    USE_PACKAGE=1

    # Set this to 1 to add additional rules to compile your project as a PROS library template
    IS_LIBRARY:=1
    LIBNAME:=libtheseus
    VERSION:=1.0.0
    # this line excludes opcontrol.c and similar files
    EXCLUDE_SRC_FROM_LIB+=$(foreach file, $(SRCDIR)/opcontrol $(SRCDIR)/initialize $(SRCDIR)/autonomous,$(foreach cext,$(CEXTS),$(file).$(cext)) $(foreach cxxext,$(CXXEXTS),$(file).$(cxxext)))
    EXCLUDE_SRC_FROM_LIB+=$(SRCDIR)/scripts             # exclude any files in the src/scripts directory
    EXCLUDE_SRC_FROM_LIB+=$(SRCDIR)/lcdselector.cpp     # exclude src/lcdselector.cpp

冷热链接疑难解答
--------------------------------
Since hot/cold linking involves ensuring two compiled programs interact consistently, there may be additional runtime
issues running in this mode. This section serves as a guide for debugging these sorts of issues.

Generally, if the program appears to be running correctly (i.e. the screen shows), then the compilation mode worked 
correctly and the error you're experiencing is likely related to your code's logic. If your code's logic runs correctly
when not using hot/cold linking, contact us so we may assist in troubleshooting.

If you see a black scren, then PROS did not boot correctly.

- A global constructor is in an infinite loop or raised an exception.
- See also troubleshooting steps below

If you see a grey screen, then PROS booted correctly, but is not running your hot image.

- Delete all user programs, perform a clean build, and upload

If you're having issues, contact us so we may assist in troubleshooting.
