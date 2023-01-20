# Vive Tracker 3-D Data Visualization on MATLAB

This code is a script that facilitates data visualization for 3-D coordinates extracted from HTC's Vive tracker.

# Purpose
The main purpose of this script is to perform data translation and rotation on the Vive tracker coordinates to improve the representation of All-Terrain Vehicles (ATVs). This enables the evaluation of machine-rider fit, quantification of rider's field of vision, and many other applications. Check out two of our projects to know more:

### - Project 1 - Ability of youth operators to reach agricultural all-terrain vehicles controls

#### Guilherme De Moura Araujo, Farzaneh Khorsandi & Fadi Fathallah (2022). Ability of youth operators to reach agricultural all-terrain vehicles controls. Journal of Safety Research. [DOI: 10.1016/j.jsr.2022.11.010](https://doi.org/10.1016/j.jsr.2022.11.010)

### - Project 2 - How do children perceive the environment around them when riding adult-sized ATVs on farms?

#### Guilherme De Moura Araujo, Farzaneh Khorsandi & Fadi Fathallah (2022). How do children perceive the environment around them when riding adult-sized ATVs on farms?. Journal of Safety Research [GitHub repo](https://github.com/ucdavis-bae/openFV)

# Justification
One of the major problems with HTC's Vive tracker is that its axis system (X, Y, Z) is local, and can change every time you power the device on/off. For this reason, it's practically impossible to assume that Vive's x,y,z coordinates are similar to any system we know (for example, UTM's easting, northing, and altitude). Therefore, we developed this code to establish and reconfigure the coordinate system based on the ATV's orientation. Our goal was to have the X axis along the horizontal axis of the ATV from its top view (i.e., left to right wheels), the Y axis along the vertical axis of the ATV (i.e., left rear to left front wheel), and the Z axis along the ATV's height.

# How it works
For context: We collected 38 points (x,y,z) for each ATV. Each set of points is saved in a csv file. Data collection is performed in a standard order, so we know exactly which point represents which feature of the ATV. For example, points 1-5 represent the ATV's seat. Points 34-37 represent the wheels of the ATVs and so on. Detailed information is available in the figure below.

The script begins by adding the necessary files to the path and defining which ATVs should be processed. The script then proceeds to identify the correct axes by performing an error and trial attempt. It first assumes that X = x and Y = y, and then rotates all points to perfectly align the wheels of the ATV (points #34-#37). The script then makes the same assumption for X = x and Y = z, and X = y and Y = z. At each step, the script calculates a few metrics that assist in determining which column (x, y, z) corresponds to each axis (X, Y, Z). For instance, the average distance from the seat reference point (SRP) to the center of the handlebar of an ATV is 65 cm. We can calculate the euclidian distance between points 1 (SRP) and 7 (handlebar's center) for each transformation and which one gets closer to reality.

By rotating the data, the script automatically lines up the points in the correct XY plane, i.e., the wheels, seat center, and the handlebar are automatically aligned. After reading all the Excel files, the script begins the process of data translation and rotation. It starts with the backup of data, which is the data of the y and z columns. Then, the script performs the same process again, translating the points, finding angles, making transformations, getting error metrics, and visualizing how the transformation worked.

# How to run the code
The script is written in Matlab and requires the Matlab software to be able to run it. It can be run by opening the script in Matlab and clicking the "run" button or by typing the name of the script in the command window and hitting enter. It is important to ensure that all necessary files are in the correct path before running the script.

# Example
In addition to the script, this repository also includes examples of ATVs' coordinates in CSV files. These files are used as input for the script and provide a demonstration of how the script can be applied to real-world data.
Additionally, an extra excel file is provided which contains the calculation of metrics that assist in determining which column (x, y, z) corresponds to each axis (X, Y, Z). This file serves as an example of how the script can be used to analyze and understand the data. It is important to note that users should have the necessary software to open and work with csv and excel files.
