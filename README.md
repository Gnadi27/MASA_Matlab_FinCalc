# MASA_Matlab_FinCalc

Disclaimer: As with any project this was never really fully finished and fleshed out. The output hasn't been verified on it's accuracy. It should be seen as a demonstrator of what might be possible and feasible to implement and calculate analytically.

This Applet is meant for hand calculation of the aerodynamic loads on *one* rocket fin during it's flight profile (velocity - altitude)

Coded in Matlab 2023b - no backwards compatibility guaranteed

11/24/2024 ... not any form of simulation or wind tunnel test validation

To Run:

1. Run "paramterInputs" in Matlab
2. Upload flight profile file (exemplary flight profile: in "hypothetical_student_rocket_profile.csv")
3. Put in fin dimensions and AoA, RollRate, etc.
4. Hit "Calculate"
5. Read the Assumptions printed in the Matlab Command Window
6. Some Figures might be hidden in the Background

## What to expect to see on 

GUI with exemplary input
<img width="596" height="327" alt="image" src="https://github.com/user-attachments/assets/55993355-e6db-4b0c-aecf-fe4380dba7e2" />

Uploading a trajectory provides plots about the flight profile and categorization of flight regimes
<img width="1119" height="450" alt="image" src="https://github.com/user-attachments/assets/ed80c6ec-0301-4c5c-ba48-0fccf8778498" />

Different fin shape categorize to select and then geometrically define
<img width="447" height="217" alt="image" src="https://github.com/user-attachments/assets/173e44eb-873a-4f2c-abff-8df248898d45" />

After calculating, warning about broken assumptions are diplayed
<img width="867" height="111" alt="image" src="https://github.com/user-attachments/assets/cdc95a7a-27f7-4a51-9063-0b7d69e03071" />

Analysis output on the planar fin
<img width="1109" height="500" alt="image" src="https://github.com/user-attachments/assets/2c718fa8-47ef-4377-a414-9bd9fc432fee" />
<img width="600" height="231" alt="image" src="https://github.com/user-attachments/assets/523361c9-bc14-4c68-84eb-c5d586b56b33" />

Output of calculated aerodynaMic loads
<img width="557" height="501" alt="image" src="https://github.com/user-attachments/assets/616d5792-2f73-4ec4-aeca-84ebc7abc5df" />
