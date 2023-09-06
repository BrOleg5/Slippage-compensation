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

## Citation

```
@article{Belyaev2021,
    title = {Slip Detection and Compensation System for Mobile Robot in Heterogeneous Environment},
    journal = {IFAC-PapersOnLine},
    volume = {54},
    number = {13},
    pages = {339-344},
    year = {2021},
    note = {20th IFAC Conference on Technology, Culture, and International Stability TECIS 2021},
    issn = {2405-8963},
    doi = {https://doi.org/10.1016/j.ifacol.2021.10.470},
    url = {https://www.sciencedirect.com/science/article/pii/S2405896321019078},
    author = {A.S. Belyaev and O.A. Brylev and E.A. Ivanov},
    keywords = {Mobile robot, control system, terrain, slip detection, different environments},
}
```
