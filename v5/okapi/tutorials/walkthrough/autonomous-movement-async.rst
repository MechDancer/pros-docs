================================
Asynchronous Autonomous Movement
================================

.. note:: This tutorial covers asynchronous movement (multiple subsystems operating at a time).
          For a more basic tutorial on sequential movements, see `Moving Autonomously <./autonomous-movement-basic.html>`_.

Oftentimes the fastest way to move in autonomous involves actuating multiple subsystems at once
(i.e. driving and raising/lowering a lift). This is made possible with Async Controllers.

To create a Chassis Controller for a given system, modify the below example to fit your subsystem.

.. highlight: cpp
.. code-block:: cpp
   :linenos:

   using namespace okapi;

   const int DRIVE_MOTOR_LEFT = 1;
   const int DRIVE_MOTOR_RIGHT = 2;

   auto driveController = ChassisControllerBuilder()
                            .withMotors(DRIVE_MOTOR_LEFT, -DRIVE_MOTOR_RIGHT)
                            .build();

   void autonomous() {
   }

And then we'll add a lift subsystem as an Async Controller:

.. highlight: cpp
.. code-block:: cpp
   :linenos:

   using namespace okapi;

   const int DRIVE_MOTOR_LEFT = 1;
   const int DRIVE_MOTOR_RIGHT = 2;

   const double liftkP = 0.001;
   const double liftkI = 0.0001;
   const double liftkD = 0.0001;
   const int LIFT_MOTOR = 2;

   auto driveController = ChassisControllerBuilder()
                            .withMotors(DRIVE_MOTOR_LEFT, -DRIVE_MOTOR_RIGHT)
                            .build();

   auto liftController = AsyncPosControllerBuilder()
                           .withMotor(LIFT_MOTOR)
                           .withGains({liftkP, liftkI, liftkD})
                           .build();

   void autonomous() {
   }

Now that we have two subsystems to run, let's execute a few different movements.

If we want both systems to move, and the next movement in the autonomous routine only depends on the
drive completing its movement (and it doesn't care about the lift's status), we'll run
``waitUntilSettled()`` with just the drive controller.

.. highlight: cpp
.. code-block:: cpp
   :linenos:

   using namespace okapi;

   const int DRIVE_MOTOR_LEFT = 1;
   const int DRIVE_MOTOR_RIGHT = 2;

   const double liftkP = 0.001;
   const double liftkI = 0.0001;
   const double liftkD = 0.0001;
   const int LIFT_MOTOR = 2;

   auto driveController = ChassisControllerBuilder()
                            .withMotors(DRIVE_MOTOR_LEFT, -DRIVE_MOTOR_RIGHT)
                            .build();

   auto liftController = AsyncPosControllerBuilder()
                           .withMotor(LIFT_MOTOR)
                           .withGains({liftkP, liftkI, liftkD})
                           .build();

   void autonomous() {
     // Begin movements
     driveController->moveDistanceAsync(1000); // Move 1000 motor degrees forward
     liftController->setTarget(200); // Move 200 motor degrees upward
     driveController->waitUntilSettled();

     // Then the next movement will execute after the drive movement finishes
   }

If blocking the next movement with regard only to the lift is desired, swap ``driveController`` for
``liftController`` in the last line.

If both movements need to finish before executing the next movement, then call
``waitUntilSettled()`` on both controllers.

.. highlight: cpp
.. code-block:: cpp
   :linenos:

   using namespace okapi;

   const int DRIVE_MOTOR_LEFT = 1;
   const int DRIVE_MOTOR_RIGHT = 2;

   const double liftkP = 0.001;
   const double liftkI = 0.0001;
   const double liftkD = 0.0001;
   const int LIFT_MOTOR = 2;

   auto driveController = ChassisControllerBuilder()
                            .withMotors(DRIVE_MOTOR_LEFT, -DRIVE_MOTOR_RIGHT)
                            .build();

   auto liftController = AsyncPosControllerBuilder()
                           .withMotor(LIFT_MOTOR)
                           .withGains({liftkP, liftkI, liftkD})
                           .build();

   void autonomous() {
     // Begin movements
     driveController->moveDistanceAsync(1000); // Move 1000 motor degrees forward
     liftController->setTarget(200); // Move 200 motor degrees upward
     driveController->waitUntilSettled();
     liftController->waitUntilSettled();

     // Then the next movement will execute after both movements finish
   }
