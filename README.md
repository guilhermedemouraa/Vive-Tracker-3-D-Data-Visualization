# Vive Tracker 3-D Data Visualization on MATLAB

This code is a script that facilitates data visualization for 3-D coordinates extracted from HTC's Vive tracker.

# Purpose
The main purpose of this script is to perform data translation and rotation on the Vive tracker coordinates to improve the representation of All-Terrain Vehicles (ATVs). This enables the evaluation of machine-rider fit, quantification of rider's field of vision, and many other applications. Check out two of our projects to know more:

#### Guilherme De Moura Araujo, Farzaneh Khorsandi & Fadi Fathallah (2022). Ability of youth operators to reach agricultural all-terrain vehicles controls. Journal of Safety Research. [DOI: 10.1016/j.jsr.2022.11.010](https://doi.org/10.1016/j.jsr.2022.11.010)

#### Guilherme De Moura Araujo, Farzaneh Khorsandi & Fadi Fathallah (2022). How do children perceive the environment around them when riding adult-sized ATVs on farms?. Journal of Safety Research [GitHub repo](https://github.com/ucdavis-bae/openFV)

# Justification
One of the major problems with HTC's Vive tracker is that its axis system (X, Y, Z) is local, and can change every time you power the device on/off. For this reason, it's practically impossible to assume that Vive's x,y,z coordinates are similar to any system we know (for example, UTM's easting, northing, and altitude). Therefore, we developed this code to establish and reconfigure the coordinate system based on the ATV's orientation. Our goal was to have the X axis along the horizontal axis of the ATV from its top view (i.e., left to right wheels), the Y axis along the vertical axis of the ATV (i.e., left rear to left front wheel), and the Z axis along the ATV's height.

# How it works
For context: We collected 38 points (x,y,z) for each ATV. Each set of points is saved in a csv file. Data collection is performed in a standard order, so we know exactly which point represents which feature of the ATV. For example, points 1-5 represent the ATV's seat. Points 34-37 represent the wheels of the ATVs and so on. Detailed information is available in the figure below.

The script begins by adding the necessary files to the path and defining which ATVs should be processed. The script then proceeds to identify the correct axes by performing an error and trial attempt. It first assumes that X = x and Y = y, and then rotates all points to perfectly align the wheels of the ATV (points #34-#37). The script then makes the same assumption for X = x and Y = z, and X = y and Y = z. At each step, the script calculates a few metrics that assist in determining which column (x, y, z) corresponds to each axis (X, Y, Z). For instance, the average distance from the seat reference point (SRP) to the center of the handlebar of an ATV is 65 cm. We can calculate the euclidian distance between points 1 (SRP) and 7 (handlebar's center) for each transformation and which one gets closer to reality.

By rotating the data, the script automatically lines up the points in the correct XY plane, i.e., the wheels, seat center, and the handlebar are automatically aligned. After reading all the Excel files, the script begins the process of data translation and rotation. It starts with the backup of data, which is the data of the y and z columns. Then, the script performs the same process again, translating the points, finding angles, making transformations, getting error metrics, and visualizing how the transformation worked.

The second part of the code is mostly for visualizing the data in different ways. The first figure block creates a figure for each ATV in the list, plots the different parts of the ATV (wheels, seat, handlebar, etc.) on the figure and then applies a rotation to align the points based on the assumption that X = x and Y = z. The second figure block creates a 3D plot for each ATV, plots the different parts of the ATV in 3D, and then applies a rotation to align the points based on the assumption that X = x and Y = z.

The final part of the code is cleaning up the variable space, organizing the newly rotated data, and saving the data in a CSV file. First, the code creates an array of strings that indicate the ATV number. Then, it prompts the user to save the newly rotated data in a CSV file using a dialog box. If the user confirms, the code creates a new directory called "Rotated Data" in the directory where the original data is located, and then saves each ATV's coordinates in a separate file with the naming format "ATV number _rot.csv". Finally, the code removes all the variables that are no longer needed from the workspace.

# How to run the code
The script is written in Matlab and requires the Matlab software to be able to run it. It can be run by opening the script in Matlab and clicking the "run" button or by typing the name of the script in the command window and hitting enter. It is important to ensure that all necessary files are in the correct path before running the script.

# Example
In addition to the script, this repository also includes [examples](https://github.com/guilhermedemouraa/Vive-Tracker-3-D-Data-Visualization/tree/main/examples) of ATVs' coordinates in CSV files. These files are used as input for the script and provide a demonstration of how the script can be applied to real-world data.
