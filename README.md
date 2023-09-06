# Slippage detection and compensation system of mobile robot's wheel 

Research of wheel slippage and development of slippage detection and compensation system of mobile robot's wheel.

The repository contains [experimental data](data), [Simulink models](models), and [Matlab scripts](scripts), which were used in research and development.

Continuation of the project at the [link](https://github.com/BrOleg5/research-wheel-slippage).

## Test site and mobile robot

The test site represents a set of surfaces of various shapes and sizes. Each surface consists of two layers: internal and external. The internal one is responsible for the immersion effect and is of 2 types: hard ‐ without immersion and soft ‐ with immersion. The external layer differs in relief and color.

| Type 1 | Type 2 | Type 3 |
|--------|--------|--------|
|![](/../readme-images/red_surface.jpg)|![](/../readme-images/blue_surface.jpg)|![](/../readme-images/green_surface.jpg)|
| Surface with low traversabitity, with immersion | Surface with medium traversabitity, without immersion | Surface with high traversabitity, without immersion

Festo Robotino v2 is used as a mobile platform. It has omni-wheels, encoders, and motor current sensors. Aruco marker is placed on the top side of Robotino to define the robot’s location via a computer vision system that is located above the test site.

Festo Robotino v2 with Aruco marker:
![](/../readme-images/robotino.jpg)

Top view of the test site:
![](/../readme-images/test_site.jpg)

## References

L. Ojeda, D. Cruz, G. Reina and J. Borenstein, "[Current-Based Slippage Detection and Odometry Correction for Mobile Robots and Planetary Rovers](https://ieeexplore.ieee.org/abstract/document/1618745)," in IEEE Transactions on Robotics, vol. 22, no. 2, pp. 366-378, April 2006, doi: 10.1109/TRO.2005.862480.
