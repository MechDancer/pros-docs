======================
PROS CLI 3.1.2 版本
======================

.. post:: 20 September, 2018
   :tags: 博客, CLI发布

- 提升用于调试的日志记录
- 为 Windows 安装程序添加 V5 驱动
- 为 Windows 安装程序添加视觉实用工具

更新到新版本
===========================

Python PIP
----------

运行 pip install https://github.com/purduesigbots/pros-cli3/releases/download/3.1.2/pros_cli_v5-3.1.2-py3-none-any.whl（或者 pip3，这取决于你的系统）

Windows
-------

下载并运行合适的安装程序

macOS
-----

参见下方安装 CLI 推荐的新方法

macOS 安装方法
~~~~~~~~~~~~~~

如果你还未安装 Homebrew，那么去安装一个，这会花上点时间
运行 brew tap purduesigbots/pros
运行 brew cask install gcc-arm-embedded pros-editor（如果你仅想安装 CLI，你可以取而代之运行 brew cask install gcc-arm-embedded && brew install pros-cli）

注意事项：
~~~~~~~~~~

- 如果在安装工具链（gcc-arm-embedded）时 Homebrew 报错说一些文件已经存在，运行 rm -f /usr/local/bin/arm-none-eabi-* 来清除旧文件
- 如果你已经安装 PROS CLI 或在安装 CLI 时 Homebrew 报错说一些文件已经存在，你需要先卸载它们
- 如果之前使用 pip 进行的安装，你可以运行 pip3 uninstall pros-cli-v5
- 如果之前使用 .app 程序包进行的安装，你可以将程序包移入废纸篓，然后运行 rm -f /usr/local/bin/prosv5 来清除旧文件