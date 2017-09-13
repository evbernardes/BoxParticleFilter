# Box Particle Filter

Matlab code for the Box Particle filtering project. Implementation of Interval class and simulation applications.

- BPF2D - 2D Box Particle Filter implementation.
BPF2D.m: 2D Box Particle Filter simulation.
measurementUpdate.m: Measurement update for 2D box particle filtering.
stateUpdate.m: State Update for 2D box particle filtering.
initBoxesArray.m: Initialise Box cell array. Used by stateUpdate function to perform resampling.
findIndexes.m: Find which boxes in a box array intersect a given input box.

Obs.: the BPF2D function performs a full simulation. If something else must be done after each iteration, a loop calling the functions measurementUpdate and stateUpdate must be programmed manually (see BPF2D for the implemetation).

- BPF2D_fixed - 2D Box Particle Filter implementation for a fixed rectangular room [Not used anymore].
BPF2D_fixed.m: 2D Box Particle Filter simulation.
measurementUpdate_fixed.m: Measurement update for 2D box particle filtering.
stateUpdate_fixed.m: State Update for 2D box particle filtering.
initBoxesArray.m: Initialise Box cell array. Used by stateUpdate function to perform resampling.
findIndexes_fixed.m: Find which boxes in a box array intersect a given input box.

- ConventionalParticleFilter - Conventional particle filter implementation.

- SLAM - Simple implementation of the SLAM algorithm using the BPF2D as estimator engine.

- Interval - Implementation of intervals.

- Mist - Plot helper functions.
plotBoxes.m - plot of each box in a box array
plotBoxesColor.m - plot of each box in a box array with colouring representing each box's weight
plotDistance.m - plot of distance between each point in two vectors

- Simulations - Multiple example environments defined to test the SLAM algorithm and the Box Particle Filter implementations
