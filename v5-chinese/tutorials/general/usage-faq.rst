=================
通用常见问题
=================

为什么刷程序时会出现 "Could not open port" 错误？
=========================================================

你可能会看到这样的错误：

.. code-block:: none

  Uploading bin/output.bin to v5 device on COM11 as hello to slot 1
  ERROR - pros.cli.upload:upload - could not open port 'COM11': PermissionError(13, 'Access is denied.', None, 5)
  File "c:\users\jonathan\appdata\local\programs\python\python36-32\lib\site-packages\serial\serialwin32.py", line 62, in open
    raise SerialException("could not open port {!r}: {!r}".format(self.portstr, ctypes.WinError()))
  serial.serialutil.SerialException: could not open port 'COM11': PermissionError(13, 'Access is denied.', None, 5)

这意味着其他一些资源正在使用该端口。如果你还打开了 V5
实用工具就会导致这个错误。如果想要刷程序，请关闭
V5 实用工具。
