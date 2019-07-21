===================
在 macOS 上安装
===================

当前有两种在 macOS 上安装 PROS 3 的方式。推荐的方法是使用 `Homebrew <https://brew.sh/>`_，另一种方法是手动安装组件。

推荐方式（Homebrew）
-----------------------------

推荐的方法是使用 `Homebrew <https://brew.sh/>`_。

1. 如果你还未安装 Homebrew 按照它的 `说明 <https://brew.sh>`_ 安装。这会花上点时间，并可能提示你遵循一些附加的说明。
2. 当你安装好了 Homebrew，运行 :code:`brew tap osx-cross/arm && brew install arm-gcc-bin` 来向包含用于构建 PROS 工程的工具链的仓库注册，然后安装工具链。
3. 运行 :code:`brew tap purduesigbots/pros` 向 Homebrew 注册 PROS 的仓库。
4. 运行 :code:`brew cask install pros-editor` 安装 PROS 编辑器（CLI 也会被安装）。这会花上一点时间。
5. 就这样！你现在可以开始使用 PROS 3 了。

.. note:: 如果你不想用 PROS 编辑器而只想使用 PROS CLI，用 :code:`brew install pros-cli` 来替换步骤 3 中的命令。

其他方式
-------------

如果你不想使用 Homebrew 安装 PROS 3， 你可以手动安装组件。

安装工具链
^^^^^^^^^^^^^^^^^^^^^
1. 在 `这里 <https://developer.arm.com/open-source/gnu-toolchain/gnu-rm/downloads>`_ 下载 macOS 上最新版本的 GNU Arm Embedded 工具链。
2. 当你下载好了工具链，双击解压它。
3. 把从 :code:`gcc-arm-none-eabi-X-20XX-qX-update` 文件夹（X 是你下载的版本）解压出来的东西复制到另一个文件夹，例如 :code:`/usr/local/lib/pros-toolchain`。
4. 现在，你需要将工具链二进制文件链接到系统能够找到它们的地方。这有两种办法：

   i) （推荐，方便更新) 运行 ``mkdir -p /usr/local/bin/pros-toolchain && ln -s /usr/local/lib/pros-toolchain/bin/* /usr/local/bin/pros-toolchain`` (将 ``/usr/local/lib/pros-toolchain`` 替换为第 4 步中你创建文件夹的路径）。最后，添加 ``/usr/local/bin/pros-toolchain`` 到 ``/etc/paths`` 文件的结尾。
   ii) (更简单，更新没那么方便) 仅需运行 ``ln -s /usr/local/lib/pros-toolchain/bin/* /usr/local/bin``。

   .. note:: 译者注：第 2 种方式同样需要将 ``/usr/local/lib/pros-toolchain`` 替换为第 4 步中你创建文件夹的位置。

安装 CLI
^^^^^^^^^^^^^^^
1. 在 `Python 官网 <http://python.org>`_ 安装 >= 3.6 版本的 Python。
2. 从 `这里 <https://github.com/purduesigbots/pros-cli3/releases/latest>`_ 下载 Python Wheel 文件（.whl）来下载最新版本的 CLI。当下载好之后，运行 :code:`python3 -m pip install ~/Downloads/pros-cli-v5_3.X.X-py3-none-any.whl` （将路径替换为你的下载的文件的）。

安装编辑器
^^^^^^^^^^^^^^^^^^

.. note:: 如果你打算使用 PROS 以外的编辑器，这部分是可选的。

1. 根据他们 `WIKI <https://github.com/cquery-project/cquery/wiki/Building-cquery>`_ 上的说明构建并安装 Cquery。
2. 在我们的 `发布页面 <https://github.com/purduesigbots/atom/releases/latest>`_ 上下载 :code:`pros-editor-mac.zip`。当下载好之后，双击解压，然后把 :code:`PROS Editor.app` 拖到 :code:`/Applications` 里。

要求
------------

最低 macOS 版本： 10.8
最低 Python 版本： 3.6

已知问题
------------

:code:`RuntimeError: Click will abort further execution because Python 3 was configured
to use ASCII as encoding for the environment.`

如果你在使用 PROS 编辑器，打开初始化脚本（File > Init Script）并添加以下两行：

.. code-block:: coffee

   process.env.LANG = 'en_US.utf-8'
   process.env.LC_ALL = 'en_US.utf-8'

如果你仅在终端中使用 CLI：

1. 打开终端。
2. 运行命令 :code:`cd` 确保你在主目录下。
3. 运行命令 :code:`touch .bash_profile` 确保存在 shell 配置文件。
4. 在你偏好的编辑器中（也可以运行 :code:`open -e .bash_profile` 使用 TextEdit）修改 :code:`~/.bash_profile` 文件，在末尾添加以下两行：

.. code-block:: bash

   export LANG="en_US.utf-8"
   export LC_ALL="en_US.utf-8"

5. 运行命令 :code:`. .bash_profile` 为当前会话重载配置文件。

:code:`/bin/sh: intercept-c++: command not found`

.. note:: 该问题将在 PROS CLI 3.1.2 版本后修复。

1. 使用 :code:`prosv5 --version` 检查 PROS CLI 版本。如果 <= 3.1.2，先试试更新以下，看看问题有没有解决。如果没有，继续往下看步骤 2。
2. 遵循上方仅在终端中使用 CLI 的步骤 1-4，不过在步骤 4 中改为添加以下一行（将 Xs 替换为第一部中获取的版本号）：

.. code-block:: bash

   export PATH="/usr/local/Cellar/pros-cli/3.X.X/libexec/bin:$PATH"
