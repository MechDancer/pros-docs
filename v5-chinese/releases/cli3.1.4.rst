======================
PROS CLI 3.1.4 版本
======================

.. post:: 18 February, 2019
   :tags: 博客, CLI发布

- 创建、升级和上传项目的新 UI 体验
- 添加二进制压缩以节省 V5 上的空间
- 添加对冷/热链接的支持
- 添加使用 ``prosv5 v5 capture`` 对 V5 屏幕进行捕获
- 添加无线下载支持
- 添加了对 ``mu``/``mut``/``ut`` 提供上传参数的支持
- 修复 V5 上传协议的 bug

更新到新版本
===========================

Python PIP
----------

运行 ``pip install https://github.com/purduesigbots/pros-cli/releases/download/3.1.4/pros_cli_v5-3.1.4-py3-none-any.whl``（或 pip3，这取决于你的系统）

Windows
-------

从我们的 `发布页面 <https://github.com/purduesigbots/pros-cli/releases/3.1.4>`_ 下载并运行合适的安装程序（.exe）

macOS
-----

要从之前的版本升级，运行 ``brew upgrade pros-cli``。
如果你还安装了编辑器，还可以运行 ``brew cask upgrade pros-editor``。

从头开始安装：

如果你还未安装 Homebrew，那么去安装一个。这会花上点时间。
运行 ``brew tap osx-cross/arm && brew tap purduesigbots/pros``
运行 ``brew install gcc-arm-bin && brew cask install pros-editor``（如果你仅想安装 CLI，你可以取而代之运行 ``brew install gcc-arm-bin pros-cli``）

注意事项：
~~~~~~~~~~

- 如果在升级编辑器时 Homebrew 报错（"It seems there is already an App at '/usr/local/Caskroom/pros-editor/1.32.2/PROS Editor.app'"），取而代之运行 ``brew cask upgrade --force pros-editor``。
- 如果你已经安装 PROS CLI 或在安装 CLI 时 Homebrew 报错说一些文件已经存在，你需要先卸载它们
- 如果之前使用 pip 进行的安装，你可以运行 pip3 uninstall pros-cli-v5
- 如果之前使用 .app 程序包进行的安装，你可以将程序包移入废纸篓，然后运行 ``rm -f /usr/local/bin/prosv5`` 来清除旧文件
