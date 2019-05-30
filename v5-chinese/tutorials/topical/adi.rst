==========================
模拟数字接口（3 线端口）
==========================

.. note:: 要了解与模拟数字接口交互的完成函数列表，查看
          `C API <../../api/c/adi.html>`_ 和 `C++ API <../../api/cpp/adi.html>`_。

.. contents:: :local:

模拟传感器
==============

虽然与 VEX 机器人对接的计算机，微控制器和其他设备是数字系统，\
但现实世界的大多数成分都表现为\
模拟的，其中存在一系列可能的值，而不仅仅是
1 和 0 的排列。电位器和\
循线传感器等模拟传感器用于与这些模拟的真实系统进行通信。\
这些传感器根据它们的输入返回预设值范围内的数字，\
而不是像数字传感器那样\
简单地返回开或关的状态。

要获取这些模拟输入并将其转换为 Cortex 实际可以使用的信息，\
每个模拟输入端口都使用 ADC（模数转换器）\
将模拟输入信号（变化的\
电压信号）转换为 12 位整数。因此，\
用于 Cortex 时，所有模拟传感器的范围是 0 到 4095（12位\
无符号整数的范围）。

初始化
--------------

使用任何模拟数字传感器的第一步是设置其\
端口配置。

.. tabs::
   .. group-tab :: C
      .. highlight:: c
      .. code-block:: c
         :caption: initialize.c
         :linenos:

         #define ANALOG_SENSOR_PORT 1

         void initialize() {
           adi_port_set_config(ANALOG_SENSOR_PORT, E_ADI_ANALOG_IN);
         }

   .. group-tab :: C++
      .. highlight:: cpp
      .. code-block:: cpp
         :caption: initialize.cpp
         :linenos:

         #define ANALOG_SENSOR_PORT 1

         void initialize() {
           pros::ADIAnalogIn sensor (ANALOG_SENSOR_PORT);
           // 使用传感器
         }

另外，最好先校准模拟传感器，再在
``initialize()`` 函数中使用它们。\
`analog_calibrate <../../ api / c / adi.html＃adi-analog-calibrate>`_ 函数\
在半秒的时间内采样大约 500 个数据，\
并返回这些数据的平均值。\
该平均值可用于说明环境变化，如循线传感器感受到的环境光等。

.. tabs::
   .. group-tab :: C
      .. highlight:: c
      .. code-block:: c
         :caption: initialize.c
         :linenos:

         #define ANALOG_SENSOR_PORT 1

         void initialize() {
           adi_port_set_config(ANALOG_SENSOR_PORT, E_ADI_ANALOG_IN);
           adi_analog_calibrate(ANALOG_SENSOR_PORT);
         }

   .. group-tab :: C++
      .. highlight:: cpp
      .. code-block:: cpp
         :caption: initialize.cpp
         :linenos:

         #define ANALOG_SENSOR_PORT 1

         void initialize() {
           pros::ADIAnalogIn sensor (ANALOG_SENSOR_PORT);
           sensor.calibrate();
         }

电位器
-------------

电位计测量角位置，可用于确定\
其输入的旋转方向。电位计最适用于\
升降机等结构中，这些结构中传感器不会有\
旋转超过其 250 度的物理约束的风险。电位器\
通常不需要校准，但有可能还是需要\
进行校准，因为校准有助于解决电位器安装中的可能变化，或者\
找到电位器被机械约束的实际范围，\
因为该范围可能更接近 5-4090 而不是 0-4095。如果\
不校准电位器，可以使用 `analog_read <../../api/c/adi.html＃adi-analog-read>`_ \
函数来获得电位计的原始\
输入值。如果传感器已校准，\
则应使用`analog_read_calibrated <../../ api / c / adi.html＃adi-analog-read-calibrated>`_ 函数，\
因为它将考虑传感器的校准\
并返回准确的结果。这两个函数的输入（参数）\
是传感器的通道号，并返回一个整数。


因此在升降机中使用的例子可能看起来像这样：

.. tabs::
   .. group-tab:: C
      .. highlight:: c
      .. code-block:: c
         :caption: autonomous.c
         :linenos:

         #define POTENTIOMETER_PORT 1
         #define MOTOR_PORT 1

         void autonomous() {
           // 若电位器没有达到其最大值
           while (adi_analog_read(POTENTIOMETER_PORT) < 4095) {
             motor_move(MOTOR_PORT, 127); // 启动升降机
             delay(50);
           }
         }

   .. group-tab:: C++
      .. highlight:: cpp
      .. code-block:: cpp
         :caption: autonomous.cpp
         :linenos:

         #define POTENTIOMETER_PORT 1
         #define MOTOR_PORT 1

         void autonomous() {
           pros::ADIPotentiometer sensor (POTENTIOMETER_PORT);
           pros::Motor motor (MOTOR_PORT);
           // 若电位器没有达到其最大值
           while (sensor.get_value() < 4095) {
             motor = 127;
             pros::delay(50);
           }
         }

循线传感器
------------

VEX Line Trackers operate by measuring the amount of light reflected to
the sensor and determining the existence of lines from the difference in
light reflected by the white tape and the dark tiles. The Line Trackers
return a value between 0 and 4095, with 0 being the lightest reading and
4095 the darkest. It is recommended that Line Trackers be calibrated to
account for changes in ambient light.

An example of Line Tracker use:

.. tabs::
   .. group-tab:: C
      .. highlight:: c
      .. code-block:: c
         :caption: autonomous.c
         :linenos:

         #define LINE_TRACKER_PORT 1
         #define MOTOR_PORT 1

         void autonomous() {
           // Arbitrarily set the threshold for a line at 2000 quid
           while(analogRead(LINE_TRACKER_PORT) < 2000) {
             // drive forward until a line is hit
             motorSet(MOTOR_PORT,127);
             delay(50);
           }
         }


   .. group-tab:: C++
      .. highlight:: cpp
      .. code-block:: cpp
         :caption: autonomous.cpp
         :linenos:

         #define LINE_TRACKER_PORT 1
         #define MOTOR_PORT 1

         void autonomous() {
           pros::ADILineSensor sensor (LINE_TRACKER_PORT);
           pros::Motor motor (MOTOR_PORT);
           // Arbitrarily set the threshold for a line at 2000 quid
           while(sensor.get_value() < 2000) {
             // drive forward until a line is hit
             motor = 127;
             delay(50);
           }
         }

加速度计
-------------

The VEX Accelerometer measures acceleration on the x, y, and z axes
simultaneously. Accelerometers can be used to infer velocity and
displacement, but due to the error induced by such integration it is
recommended that simply the acceleration data be used. By design of the
VEX Accelerometer each axis is treated as its own analog sensors. Due to
this the VEX Accelerometer requires three analog input ports on the
Cortex.

Example accelerometer use:

.. tabs::
   .. group-tab:: C
      .. highlight:: c
      .. code-block:: c
         :caption: initialize.c
         :linenos:

         #define ACCELEROMETER_X 1
         #define ACCELEROMETER_Y 2
         #define ACCELEROMETER_Z 3

         void initialize() {
           analog_calibrate(ACCELEROMETER_X); //calibrates the x axis input
           analog_calibrate(ACCELEROMETER_Y); //calibrates the y axis input
           analog_calibrate(ACCELEROMETER_Z); //calibrates the z axis input

           int x_acc = analog_read_calibrated_HR(ACCELEROMETER_X);
           int y_acc = analog_read_calibrated_HR(ACCELEROMETER_Y);
           int z_acc = analog_read_calibrated_HR(ACCELEROMETER_Z);
           printf("X: %d, Y: %d, Z: %d\n", x_acc, y_acc, z_acc);
         }


   .. group-tab:: C++
      .. highlight:: cpp
      .. code-block:: cpp
         :caption: initialize.cpp
         :linenos:

         #define ACCELEROMETER_X 1
         #define ACCELEROMETER_Y 2
         #define ACCELEROMETER_Z 3

         void initialize() {
           pros::ADIAnalogIn acc_x (ACCELEROMETER_X);
           pros::ADIAnalogIn acc_y (ACCELEROMETER_Y);
           pros::ADIAnalogIn acc_z (ACCELEROMETER_Z);
           acc_x.calibrate(); //calibrates the x axis input
           acc_y.calibrate(); //calibrates the y axis input
           acc_z.calibrate(); //calibrates the z axis input

           int x_acc = acc_x.value_get_calibrated_HR();
           int y_acc = acc_y.value_get_calibrated_HR();
           int z_acc = acc_z.value_get_calibrated_HR();
           std::cout << "X: " << x_acc << "Y: " << y_acc << "Z: " z_acc;
         }

数字传感器
===============

初始化
--------------

As with all ADI sensors, the first step to using the sensor is to set the configuration
for its ADI port.

.. tabs::
   .. group-tab :: C
      .. highlight:: c
      .. code-block:: c
         :caption: initialize.c
         :linenos:

         #define DIGITAL_SENSOR_PORT 1

         void initialize() {
           adi_port_set_config(DIGITAL_SENSOR_PORT, E_ADI_DIGITAL_IN);
         }

   .. group-tab :: C++
      .. highlight:: cpp
      .. code-block:: cpp
         :caption: initialize.cpp
         :linenos:

         #define DIGITAL_SENSOR_PORT 1

         void initialize() {
           pros::ADIDigitalIn sensor (DIGITAL_SENSOR_PORT);
           // Use the sensor
         }

From there, using a digital sensor is fairly straightforward. Digital Sensors
always return a true or false (boolean) value.

.. tabs::
   .. group-tab :: C
      .. highlight:: c
      .. code-block:: c
         :caption: autonomous.c
         :linenos:

         #define DIGITAL_SENSOR_PORT 1
         #define MOTOR_PORT 1

         void autonomous() {
           while (!adi_digital_read(DIGITAL_SENSOR_PORT)) {
             // Drive forward until the button digital sensor button is pressed
             motor_move(1, 127);
             delay(50);
           }
           // The button was pressed, stop moving.
           motor_move(1, 0);
         }

   .. group-tab :: C++
      .. highlight:: cpp
      .. code-block:: cpp
         :caption: autonomous.cpp
         :linenos:

         #define DIGITAL_SENSOR_PORT 1
         #define MOTOR_PORT 1

         void autonomous() {
           pros::ADIDigitalIn button (DIGITAL_SENSOR_PORT);
           pros::Motor drive (MOTOR_PORT);

           while (!button.get_value()) {
             // Drive forward until the button digital sensor button is pressed
             drive = 127;
             pros::delay(50);
           }
           // The button was pressed, stop moving.
           drive =  0;
         }

正交编码器
------------

Quadrature encoders can measure the rotation of the attached axle on
your robot. Most common uses of this sensor type are to track distance
traveled by attaching them to your robots drivetrain and monitoring how
much the axle spins.

With these sensors 1 measured tick is 1 degree of revolution.

.. note:: Encoders must be plugged into the ADI such that the top wire
          is in an odd numbered port (1, 3, 5, 7 or 'A', 'C', 'E', or 'G'),
          and then the bottom wire must be in the next highest port number.

Encoders are initialized as such:

.. tabs::
   .. group-tab :: C
      .. highlight:: c
      .. code-block:: c
         :caption: main.h
         :linenos:

         // Digital port number for top and bottom port of quad encoder
         #define QUAD_TOP_PORT 1
         #define QUAD_BOTTOM_PORT 2

         // Multiple encoders can be declared
         extern adi_encoder_t encoder;

      .. code-block:: c
         :caption: initialize.c
         :linenos:

         void initialize() {
           encoder = adi_encoder_init(QUAD_TOP_PORT, QUAD_BOTTOM_PORT, false);
         }

   .. group-tab :: C++
      .. highlight:: cpp
      .. code-block:: cpp
         :caption: initialize.cpp
         :linenos:

         // Digital port number for top and bottom port of quad encoder
         #define QUAD_TOP_PORT 1
         #define QUAD_BOTTOM_PORT 2

         void initialize() {
           pros::ADIEncoder encoder (QUAD_TOP_PORT, QUAD_BOTTOM_PORT, false);
         }

And then used in the following manner:

.. tabs::
   .. group-tab :: C
      .. highlight:: c
      .. code-block:: c
         :caption: autonomous.c
         :linenos:

         #define MOTOR_PORT 1

         void autonomous() {
           while (adi_encoder_get(encoder) < 1000) {
             // Move forward for 1000 ticks
             motor_move(MOTOR_PORT, 127);
             delay(50);
           }
           motor_move(MOTOR_PORT, 0);
         }

   .. group-tab :: C++
      .. highlight:: cpp
      .. code-block:: cpp
         :caption: autonomous.cpp
         :linenos:

         #define MOTOR_PORT 1
         #define QUAD_TOP_PORT 1
         #define QUAD_BOTTOM_PORT 2

         void autonomous() {
           pros::ADIEncoder encoder (QUAD_TOP_PORT, QUAD_BOTTOM_PORT);
           pros::Motor drive (MOTOR_PORT);

           while (encoder.get_value() < 1000) {
             // Move forward for 1000 ticks
             drive = 127;
             pros::delay(50);
           }
           drive = 0;
         }

超声波传感器
-------------

Ultrasonic sensors are used in a manner that is very similar to encoders, given
that they are both two-wire sensors.

.. note:: Ultrasonic sensors must be plugged into the ADI such that the PING wire
          (the orange OUTPUT cable) is in an odd numbered port (1, 3, 5, 7 or 'A', 'C', 'E', or 'G'),
          and then the ECHO wire (the yellow INPUT cable) must be in the next highest port number.

Ultrasonic sensors are initialized as such:

.. tabs::
   .. group-tab :: C
      .. highlight:: c
      .. code-block:: c
         :caption: main.h
         :linenos:

         // Digital port number for top and bottom port of quad encoder
         #define ULTRA_PING_PORT 1
         #define ULTRA_ECHO_PORT 2

         // Multiple encoders can be declared
         extern adi_ultrasonic_t ultrasonic;

      .. code-block:: c
         :caption: initialize.c
         :linenos:

         void initialize() {
           ultrasonic = adi_ultrasonic_init(ULTRA_PING_PORT, ULTRA_ECHO_PORT);
         }

   .. group-tab :: C++
      .. highlight:: cpp
      .. code-block:: cpp
         :caption: initialize.cpp
         :linenos:

         // Digital port number for top and bottom port of quad encoder
         #define ULTRA_PING_PORT 1
         #define ULTRA_ECHO_PORT 2

         void initialize() {
           pros::ADIUltrasonic ultrasonic (ULTRA_PING_PORT, ULTRA_ECHO_PORT);
         }

And then used in the following manner:

.. tabs::
   .. group-tab :: C
      .. highlight:: c
      .. code-block:: c
         :caption: autonomous.c
         :linenos:

         #define MOTOR_PORT 1

         void autonomous() {
           while (adi_ultrasonic_get(ultrasonic) > 100) {
             // Move forward until the robot is 100 cm from a solid object
             motor_move(MOTOR_PORT, 127);
             delay(50);
           }
           motor_move(MOTOR_PORT, 0);
         }

   .. group-tab :: C++
      .. highlight:: cpp
      .. code-block:: cpp
         :caption: autonomous.cpp
         :linenos:

         #define MOTOR_PORT 1
         #define ULTRA_PING_PORT 1
         #define ULTRA_ECHO_PORT 2

         void autonomous() {
           pros::ADIUltrasonic ultrasonic (ULTRA_PING_PORT, ULTRA_ECHO_PORT);
           pros::Motor drive (MOTOR_PORT);

           while (ultrasonic.get_value() > 100) {
             // Move forward until the robot is 100 cm from a solid object
             drive = 127;
             pros::delay(50);
           }
           drive = 0;
         }

Pneumatics
----------

Pneumatics in VEX provide two-state linear actuation. They differ from
other digital sensors in that they are output signals. Therefore, the
default digital sensor configuration is insufficient.

.. tabs::
   .. group-tab :: C
      .. highlight:: c
      .. code-block:: c
         :caption: initialize.c
         :linenos:

         #define DIGITAL_SENSOR_PORT 1

         void initialize() {
           adi_port_set_config(DIGITAL_SENSOR_PORT, E_ADI_DIGITAL_OUT);
         }

   .. group-tab :: C++
      .. highlight:: cpp
      .. code-block:: cpp
         :caption: initialize.cpp
         :linenos:

         #define DIGITAL_SENSOR_PORT 1

         void initialize() {
           pros::ADIDigitalOut piston (DIGITAL_SENSOR_PORT);
         }

And then the pneumatics are used as such:

.. tabs::
   .. group-tab :: C
      .. highlight:: c
      .. code-block:: c
         :caption: autonomous.c
         :linenos:

         #define DIGITAL_SENSOR_PORT 1

         void autonomous() {
           adi_digital_write(DIGITAL_SENSOR_PORT, true);
           delay(1000);
           adi_digital_write(DIGITAL_SENSOR_PORT, false);s
         }

   .. group-tab :: C++
      .. highlight:: cpp
      .. code-block:: cpp
         :caption: autonomous.cpp
         :linenos:

         #define DIGITAL_SENSOR_PORT 1

         void autonomous() {
           pros::ADIDigitalOut piston (DIGITAL_SENSOR_PORT);

           piston.set_value(true);
           pros::delay(1000);
           piston.set_value(false);
         }
