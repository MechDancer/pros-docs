=========================
PROS 内核 3.1.2 版本
=========================

.. post:: 16 October, 2018
   :tags: blog, kernel-release

新特性：

- 手柄运行（rumble）电机功能

错误修复：

- 全局构造函数 ``ADIGyro`` 现在可以工作了

- 修复 ``ADIUltrasonic`` 构造函数的端口名

- 修复 ``get_digital_new_press()`` 总会返回 ``true`` 的 bug

- 实现 ``pros::Task::remove()``，这类似于 ``task_delete()``

- 更改 VDML 初始化过程，来修复用户定义使用 VDML 功能对象在任务中立即启动全局初始化

已弃用：

- 弃用与通用 I/O 类型相同的 ADI 端口配置枚举值（例如使用 ``E_ADI_SMART_POT`` 而不推荐 ``E_ADI_ANALOG_IN``）。项目仍然会编译并在功能上等同于新的偏好值，但会发出推荐使用新值的警告。

头文件文档：

- 阐明 ``task_delay_until()`` 的参数初始化

- 描述手柄文本设置 ``errno`` 的含义

- 修复 ``Motor::get_current_limit()`` 文档中的拼写错误

- 修复 ``motor_get_actual_velocity()`` 的返回单位
