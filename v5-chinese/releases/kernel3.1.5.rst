=========================
PROS 内核 3.1.5 版本
=========================

.. post:: 7 January, 2019
   :tags: 博客, 内核发布

新特性：

- 添加 ``vision_signature_from_utility`` 函数，它与 VCS 和 RMS 视觉签名创建函数具有等效参数。该函数的值也可以从视觉实用程序中获取。
- 添加 ``vision_set_wifi_mode`` 来启用或禁用视觉传感器的 Wi-Fi。

可用性提升：

- 视觉传感器曝光现在与实用程序中使用的亮度值完全匹配。
- 我们不再扩展 API 的头文件中添加 ``using namespace pros``。
- 添加隐式操作符用于将 ``pros::Task`` 转换为 ``task_t``。

错误修复：

- 各式各样的 RTOS bug
