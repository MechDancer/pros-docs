===================
在 Linux 上安装
===================

安装工具链
------------------------

1. 按照 `此处 <https://launchpad.net/~team-gcc-arm-embedded/+archive/ubuntu/ppa>`_ 的说明添加并安装最新版本的 GNU Arm Embedded 工具链。

.. note:: 如果你使用的是基于 Debian，版本 >18.04 的 Linux 发行版，你可在 `这里 <https://www.ubuntuupdates.org/package/core/disco/universe/base/gcc-arm-none-eabi>`_ 找到工具链。

.. note:: 如果你使用的不是基于 Debian 的 Linux 发行版，请检查偏好的包仓库以获取更新版本的工具链。主要的要求是你得获得一个使用 GCC 7.2 或更高版本的。

安装 CLI
------------------

1. 如果你还没有安装 Python，安装一个 >= 3.6 版本的。
2. 在我们的 `发布页 <https://github.com/purduesigbots/pros-cli3/releases/latest>`_ 上检查 PROS CLI 的最新版本，之后运行命令 :code:`python3.6 -m pip install --user https://github.com/purduesigbots/pros-cli/releases/download/3.X.X/pros_cli_v5-3.X.X-py3-none-any.whl`，把 'python' 后面的版本替换成你装的，把 Xs 替换成你下载的。如果你想给所有用户安装，在命令前加上 :code:`sudo`，并且移除 :code:`--user` 标识。
3. 运行 :code:`prosv5 --version` 来检查 CLI 是否安装正确。如果命令不起作用，尝试重新启动你的计算机。

安装编辑器
---------------------

.. note:: 以下说明用于安装 Atom 和 Cquery。如果你打算使用 Atom 以外的编辑器，这部分是可选的。

1. 按照 `此处 <https://github.com/cquery-project/cquery/wiki/Building-cquery>`_ 的说明构建并安装 Cquery。
2. `安装 Atom <https://atom.io>`_.
3. 运行 :code:`apm install pros-bootstrapper@0.0.12`.
4. 打开 Atom，等待插件安装完成。
5. 享受编码带来的快乐！

.. note:: 如果在步骤 4 中 Atom 看起来卡住了，每隔几分钟重启一下它。
