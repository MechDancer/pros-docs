====================
Conductor 使用说明
====================

介绍
============

Conductor 是 PROS 的模板和工程管理工具。\
它负责解析 PROS 内核和用户库的版本，\
还向其他 PROS 工具提供项目的信息。例如，\
向上传工具提供目标平台（像是 V5 或者 Cortex）。

这有 Conductor 功能的几个核心概念：

- 模板：模板是对一组文件的描述。他们有名字、\
  版本号、支持目标平台，以及可能有的其他元数据。模板通常有三种形式：\
  远程、本地、已安装。\
  远程模板是可以下载的模板；本地模板是下载好，\
  可以安装到项目中的模板，即便在脱机的时候；\
  已安装的模板是已经拷贝至项目的。

- 仓库：仓库是到远程模板储存的连接器。Conductor
  不需要任何特定的方法来访问远程模板，但他们\
  通常可以从 HTTP 下载链接获得。也可是实现
  SCP、FTP，或其他类型的文件传输仓库。默认的仓库被称作
  pros-mainline，是官方的模板仓库。

- 项目： 项目是一组用户文件和模板文件。它们本身\
  并不包含太多信息——只是包含目标平台和\
  一个已安装模板的列表。PROS Conductor 维护这两个来源模板的文件列表：\
  用户文件和系统文件。升级项目时用户文件不会被替换，\
  并且每次替换的是系统\
  文件。

常见任务
============
创建新项目

.. tabs::
	.. tab :: Terminal

		.. code-block:: console

			> pros conduct new-project ./Top-5-At-Worlds v5
			Updating pros-mainline... Done
			Downloading kernel@3.0.7 (https://www.cs.purdue.edu/~brookea/kernel@3.0.7.zip) [####################################] 100%
			Extracting kernel@3.0.7 [####################################] 100%
			Fetched kernel@3.0.7 from pros-mainline depot
			Adding kernel@3.0.7 to registry...Done
			Applying kernel@3.0.7 [####################################] 100%
			Finished applying kernel@3.0.7 to ./Top-5-At-Worlds
			Downloading okapilib@3.0.1 (https://www.cs.purdue.edu/~berman5/okapilib@3.0.1.zip) [####################################] 100%
			Extracting okapilib@3.0.1 [####################################] 100%
			Fetched okapilib@3.0.1 from pros-mainline depot
			Adding okapilib@3.0.1 to registry...Done
			Applying okapilib@3.0.1 [####################################] 100%
			Finished applying okapilib@3.0.1 to ./Top-5-At-Worlds
			New PROS Project was created:
			PROS Project for v5 at: /home/me/Top-5-At-Worlds (Top-5-At-Worlds)
			Name      Version    Origin
			--------  ---------  -------------
			kernel    3.0.7      pros-mainline
			okapilib  3.0.1      pros-mainline
	.. tab :: PROS Editor

		Coming soon!

安装/升级新模板

.. tabs::
	.. tab :: Terminal

		.. code-block:: console

			> pros conduct apply okapilib


获取远程模板

.. tabs::
	.. tab :: Terminal

		.. code-block:: console

			> pros conduct fetch kernel 3.1.0

获取本地模板存档

.. tabs::
	.. tab :: Terminal

		.. code-block:: console

			> pros conduct fetch mylibrary@1.0.0.zip

创建模板
==================

模板：模板是对一组文件的描述。所有 PROS
项目都很容易创建模板。在项目的\
Makefile 中更改以下部分，之后运行 ``pros make template``
创建模板。

你应该：

- 将 ``IS_LIBRARY:=0`` 改为 ``IS_LIBRARY:=1``
- 将 ``LIBNAME`` 改为你的库的名字
- 将 ``VERSION`` 改为你的库的版本

``pros make template`` 的默认行为是编译/打包\
项目中所有的源码，除了列在 ``EXCLUDE_SRC_FROM_LIB`` 中的。\
此外，你创建的每个头文件都将捆绑在一起。更确切地说，
任何没有被模板添加的头文件都包括在内。

.. highlight:: Makefile

::

	# Set this to 1 to add additional rules to compile your project as a PROS library template
	IS_LIBRARY:=0
	# TODO: CHANGE THIS!
	LIBNAME:=libbest
	VERSION:=1.0.0
	# EXCLUDE_SRC_FROM_LIB= $(SRCDIR)/unpublishedfile.c
	# this line excludes opcontrol.c and similar files
	EXCLUDE_SRC_FROM_LIB+=$(foreach file, $(SRCDIR)/opcontrol $(SRCDIR)/initialize $(SRCDIR)/autonomous,$(foreach cext,$(CEXTS),$(file).$(cext)) $(foreach cxxext,$(CXXEXTS),$(file).$(cxxext)))
	# files that get distributed to every user (beyond your source archive) - add
	# whatever files you want here. This line is configured to add all header files
	# that are in the the include directory get exported
	TEMPLATE_FILES=$(INCDIR)/**/*.h $(INCDIR)/**/*.hpp

对于创建模板的高级用法，你可以用自定义参数修改 ``Makefile``，\
然后运行 ``pros conduct create-template``。

参考
=========
.. click:: pros.cli.conductor:conductor
	:prog: pros conduct
	:show-nested:

.. click:: pros.cli.conductor_utils:create_template
	:prog: pros conduct create-template
