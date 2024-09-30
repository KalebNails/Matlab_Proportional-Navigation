# Proportional-Navigation
This is a very simple basic example of how proportional navigation works. 

# The Difference between the zip and the .m file
The zip file contains everything in order to run the code such as peripheral functions
while the .m file is just the codes itself in case if the codes needs to be seen without downloading it.

# Purpose
The purpose of this project was as an introduction Matlab class in which I made this as my final project. This project idea existed before hand, but this project gave me an opportunity to learn the skills involved. The final goal is to be able to track a projectile and predict its motion using a webcam. This was just a proof of concept.

# rocket_withwind #
This marks my initial foray into Simulink. My objective was to construct a model for a dummy rocket capable of orienting itself towards a specified heading or unit vector. In essence, I've implemented a continuous thrust emanating from the rocket's base. The drag is modeled by utilizing the rocket's body frame and then incorporating the relative XYZ components of the wind. Assumptions about the coefficient of drag are made based on the different faces of the rocket.
Furthermore, I've integrated a straightforward Proportional-Integral-Derivative (PID) controller to dictate the rocket's orientation. This is achieved by introducing a damped moment to the rocket. Concurrently, I calculate the moment induced by drag, ensuring that the rocket naturally orients itself to minimize aerodynamic drag.
This synergy of moments and drag forces enables the rocket to sustain a general direction even in the absence of thrust to propel it. In practical terms, I can incline the rocket at an approximate 45-degree angle, instruct it to maintain that orientation (as depicted in the image below), and with zero thrust, observe controlled movement to the right and downward—distinct from the scenario where it simply free-falls vertically.
![image](https://github.com/KalebNails/Matlab_Proportional-Navigation/assets/102830532/254a6619-8bff-4761-b9f5-21bd977a213f)

Below is the tree:
![image](https://github.com/KalebNails/Matlab_Proportional-Navigation/assets/102830532/00b6fa04-8cf7-4ca6-ad30-b241d7011b7a)

Below, you can observe the error in the rocket's heading gradually approaching zero over time. While this might not be the most refined or visually appealing error graph I possess, it is the one readily available. Additionally, please note that the rocket turns about ~45 degrees to the left, almost achieving a completely horizontal orientation to the right.
There exists a specific threshold wherein providing too large of a heading deviation results in instability. I have not discovered a direct solution to this issue, and it may be linked to the type of Euler angles employed for coordinate transformations. To address a potential singularity, I implemented a hardcoded if statement, assuming that if the heading ever reaches zero, the rocket must be facing directly upward. This assumption seemed reasonable, as facing straight down would indicate more significant issues.
Moreover, employing quaternions could potentially circumvent this problem, but further research is warranted. The ultimate objective is to guide the rocket to a specific coordinate. However, my research indicates that proportional navigation becomes not only more intricate in three dimensions but also exacerbates with a variable speed, influenced by burn time and drag.
![image](https://github.com/KalebNails/Matlab_Proportional-Navigation/assets/102830532/90103ac3-bcf2-4b0f-b6b3-322fac6f53b4)

# cylinderfallbackground.wrl #
This is a background object/world/stage used for the VR Sink2 simulink block. The world looks like the image below.
![image](https://github.com/KalebNails/Matlab_Proportional-Navigation/assets/102830532/d184c7e6-8368-44ad-b693-a310f4474521)

# Predictivepathtest4 #
This code makes the images seen below, one is a user controlled projectile and the other is a dummy seeker. This using general proportional navigation to solve.
![image](https://github.com/KalebNails/Matlab_Proportional-Navigation/assets/102830532/f6ab11e0-2b32-4a86-ba28-edbb76bb54f8)

![image](https://github.com/KalebNails/Matlab_Proportional-Navigation/assets/102830532/59ea9a64-cff8-41c4-9405-c2ccd9bcfc2d)

There is a small bug in the code, I have yet to fix, or have yet had a reason to fix. As time increases mass/momentum of the dot you are controlling also increases. Making tighter turns harder to make. It is workable for shorter demonstartions under about 10 seconds, but beyond that it would need to be fixed.

# Balistic_trajectory.m #

This MATLAB script models the motion of a rocket under constant thrust and simulates its trajectory in 3D space, focusing on both vertical and horizontal movement. It uses symbolic integration to calculate the velocity and height after a specified burn time, followed by generating a 3D parametric plot of the rocket’s flight path. The ascent is limited to 60% of the rocket's maximum height to reflect more energy being directed toward horizontal movement. Mathematically, the acceleration is derived from Newton's Second Law, where the net force (thrust minus weight) is divided by the mass to give constant acceleration. The kinematic equations are then integrated to solve for velocity and position.

The primary purpose of this code is to provide both the rocket's current location and its final impact location. It calculates the approximate vertex of the ballistic trajectory based on thrust, weight, and other factors. Once the vertex is determined, it remains constant throughout the process. The second portion of the code solves a parametric parabola that intersects both the current location and the vertex. This approach offers a simplified method for determining the rocket's heading without complex calculations. By solving the parabolic curve, the rocket's current position can be continuously updated, allowing for corrections to perturbations. This concept is intended for use in the rocket_withwind Simulink model, where the rocket is guided by heading. The discrete derivative of the parabolic curve provides a unit vector along the trajectory, which can be used for real-time heading adjustments. Additionally, if the rocket overshoots the vertex vertically, the solved parametric equation inverts smoothly, maintaining a parabolic guide. The code limits the rocket's maximum height to 60% of what a burn would achieve without drag, while horizontally aiming to reach the 60% marker over the target.

![image](https://github.com/user-attachments/assets/70956082-894b-497a-be5d-ccc64bd810f6)
![image](https://github.com/user-attachments/assets/2379204f-828c-495a-aba7-f0c494c9d97f)
![image](https://github.com/user-attachments/assets/272a0e0f-8cff-4365-9e08-4151cbc49c25)

You see the parabola over shooting the target, this is a purposeful over estimation, and once the rocket reaches the vertex, it will switch to a terminal phase algorithm.

