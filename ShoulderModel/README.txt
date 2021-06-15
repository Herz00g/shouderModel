This readme details how to use the EPFL musculoskeletal model through its GUI.
This version of the model allows replicating patients/subjects with anatomical glenohumeral joint (no implant) as well as patients with anatomical total shoulder arthroplasty (aTSA).

Author: ehsan.sarshari@epfl.ch
Revision 1, 26 Nov 2018
——————————————————————————————
Some notes before getting started:

- For running the model you need to have Matlab installed.
- The model is developed such that it is consistent with different platforms (Unix and Windows).
- It is strongly recommended to run the model on Matlab 2014 or 2015 to have the best performance.
- Depending on your screen size/resolution you may have to resize the GUI windows to full screen view so that the menus/buttons are readable.

——————————————————————————————
By following the steps bellow, you would be able to:
	- adapt/scale the model to a specific patient
	- simulate a measured motion
	- estimate the muscle and joint reaction forces
	- understand the overall structure of the model

Now, let’s get started.
	
1- Open your Matlab.

2- Set the directory to /ShoulderModel.

3- Open MODEL_MAIN_FILE.m and run it.

The MasterHead window appears first including information about the contributors in developing the model. You can close it right-away.

Meantime the model is constructed and two messages are printed one after another in the Command Window as the following.

Building the model data, please wait ...
The model has been constructed, ...

Following the two messages, the main GUI window (EPFL-LBO Upper Extremity Model MAIN GUI) now appears.

In this window, access to six model toolbox is granted. The toolboxes are:

	- SUBJECT SPECIFIC TOOL
	  To adapt/scale the generic model to a specific patient/subject

	- MUSCLE WRAPPING TOOL
	  To visually check the path of the muscles in different joint configurations and set the number of strings by which a muscle should  	  be replicated.

	- JOINT INITIALIZATION TOOL
	  To change the initial configuration of the model in terms of its joint angles.

	- KINEMATICS TOOL
	  To reconstruct a motion either when measured data are available from videogrammetry systems or when no measured data is available.

	- CHECK INDIVIDUAL MOMENT ARMS
	  To calculate the moment arms of all the muscles around each joint for the reconstructed motion.

	- ESTIMATE FORCES
	  To transform the measured EMG signals to muscle forces and estimate the muscle and joint reaction forces using inverse dynamics and 	  static optimization.

The main GUI window also provides interactive options for changing/saving the model visualizations.

You can close the model and clean up the Workspace by hitting the CLOSE GUI button.
  
4- Click on the “SUBJECT SPECIFIC TOOL” button.

SUBJECT SPECIFIC TOOLBOX window appears that allows specifying numbers of subject-specific parameters so that the generic model can be adapted to a specific patient/subject. These parameters are as the following:

	- Gender
	- Weight
	- Height
	- PCSA of muscles
	- Glenoid fossa orientation defined using glenoid version angle, glenoid inclination angle, glenoid center point, and implant/humeral head diameter (a definition of these parameters is available in “Terrier, A., et al. Measurements of three-dimensional glenoid erosion when planning the prosthetic replacement of osteoarthritic shoulders, The bone & joint journal 96.4 (2014): 513-518).

A protocol named MSM_input_output_preprocessing.pdf/docx is available in smb://lbovenus/shoulder/methods/matlab/MSM/ShoulderModel_pre_post_processing in order to allow you feed the subject-specific tool with patients’/subjects’ data obtainable from CT or blueprint data. For patients with anatomical glenohumeral joint refer to section 1-1 and for patients with anatomical total shoulder arthroplasty refer to section 1-2.

5- Once you input the subject-specific parameters, you can load videogrametry-based measured kinematics by hitting the gray button below “Load Measured Kinematics”.

A set of measured motions in their raw format (without filtration) are provided together with the model that can be obtained in /ShoulderModel/Generic_Measurements/kinematics. It includes the following activities in a desired format/structure that the model can read.

	act1: abduction frontal plane with 2 kg
	act2: elevation sagittal plane with 2 kg
	act3: abduction scapula plane with 2 kg
	act4: fast abduction scapula plane
	act5: slow abduction scapula plane
	act6: put 2 kg in a shelf at head height
	act7: hand behind the head
	act8: touch the other shoulder
	act9: french canes
	act10: counter external rotation (static pose, no motion)
	act11: counter internal rotation (static pose, no motion)
	act12: french cranes a second try

Once the kinematic data is loaded, a message box will pop up to show if the provided data was consistent or something was missing or went wrong. You can simply close it in case it is SUCCESSFUL.

6- Click on the “SCALE MEASURED KINEMATICS” to scale the generic measurements to the specific subject that you input his/her data.

“The measured kinematics were scaled.” will be printed once this is done.

7- Click “SCALE USING GENDER, BW, BH” to scale the model dynamics and kinematics based on gender, weight, and hight and according to the anthropometric studies that the model uses in the background.

“The model skeletal morphology and muscle architecture and propertis were scaled” will be printed in the Command Window once this is done.

8- Click “SCALE RIBCAGE ELLIPSOID” to scale the ellipsoids approximating the ribcage.

These ellipsoids are used to constrain the scapula to gliding over the ribcage (for more detail see “Sarshari, Ehsan, A Closed-Loop EMG-Assisted Shoulder Model, No. THESIS. EPFL, 2018” and “Ingram, David, Musculoskeletal Model of the Human Shoulder for Joint Force Estimation, No. THESIS_LIB. EPFL, 2015”.

This step takes longer than the other last two steps and when it is done the following message is printed in the Command Window.
“Ribcage ellipsoides and dynamic model were scaled…”.

9- Click “VISUALIZE THE SCALED DATA” to have a visual comparison between the scaled-generic model (will be shown in blue) and the generic model (shown in red).

10- Click the “CLOSE TOOL” button to permanently save the subject-specific changes in the model. Otherwise, you can leave this window open so that in case you want to reset the model to its generic form, you can hit “RESET TO GENERIC MODEL” button. Evidently, you can always start from step 3 to have the generic model.

11- Hit the “MUSCLE WRAPPING TOOL” in the MAIN GUI window.

The “MUSCLE WRAPPING TOOLBOX” appears.

By default all the muscles are replicated with one single segment shown in red. The origin of the muscles are shown on the bones in green and the insertions are in blue.

On the right hand-side of this window you can vary 11 joint angles to visually check the path taken by all the muscles.

You can reset the joint angles to the model’s initial configuration by hitting the “RESET ANGLES” button.

By default all the muscles, their origins, and their insertions are shown. You can change the visualization of each muscle or all of the muscles through “Muscle Properties” menu and “Set All Properties” menu in the menu bar, respectively. You need to hit the “UPDATE VISUALIZATION” button to put the changes in effect.

You can also visualize the wrapping object(s) of each muscle through Muscle Properties menu. First select the muscle, and tick the “Object Visible?” option. Then, click on the “UPDATE VISUALIZATION” button.

The obstacle set method of Garner and Pandy with some modifications in implementation was used to construct the muscle paths, while the insertions, origins, and the wrapping objects were defined based on our generic subject’s MRI and CTs with the help of a professional radiologist. For more details see “Garner, B. A., & Pandy, M. G. (2000). The obstacle-set method for representing muscle paths in musculoskeletal models. Computer methods in biomechanics and biomedical engineering, 3(1), 1-30.” and “Ingram, D. (2015). Musculoskeletal Model of the Human Shoulder for Joint Force Estimation (No. THESIS_LIB). EPFL.”.

12- On the “MUSCLE WRAPPING TOOLBOX” window, click on the “Set All Properties” menu and set the “Number of Segments” option to 3. Then click on the “UPDATE VISUALIZATION” button. This would increase the number of segments used for replicating each one of the muscles from 1 to 3.

13- Click on the “CLOSE TOOL” button to close the “MUSCLE WRAPPING TOOLBOX”.

14- Click the “KINEMATICS TOOL” in the Main GUI window.

The “KINEMATICS TOOLBOX” window appears.

On the top right-hand corner, you have two options to reconstruct a motion.

	- Option 1: Use this option in case you do not have videogrammetry-based measured motions. This option constructs the joint space using 9 minimal coordinates that inherently satisfy the kinematic constraints regarding scapula gliding over the ribcage ellipsoids.

The minimal coordinates (M1 to M9) are detailed in the bottom of the top right-hand corner of the “KINEMATICS TOOLBOX”.

To construct a motion using this option you should first set the initial and final values of the minimal coordinates through the boxes available on the left hand-side corner of the toolbox. Then set the number of frames that you want to have between the initial and final values through “Number Of Points”, i.e. in how many steps (frames) you want the model to go from the configuration defined by the initial values to the configuration defined using the final values of the minimal coordinates. Once you set these, hit the “BUILD MOTION (Option 1)” button to construct a motion.

The constructed motion would appear in terms of 11 joint angles on the lower half of the window. You can click on each graph to have it open in a separate window.

In order to replicate a specific motion using the minimal coordinates you need to set proper initial and final values for them. To this end, you require a more thorough understanding of these coordinates and also some tweaking afterwards. To find out more about the minimal coordinates check the followings “Ingram, D. (2015). Musculoskeletal Model of the Human Shoulder for Joint Force Estimation (No. THESIS_LIB). EPFL.” and “Ingram, D., Engelhardt, C., Farron, A., Terrier, A., & Müllhaupt, P. (2016). Modelling of the human shoulder as a parallel mechanism without constraints. Mechanism and Machine Theory, 100, 120-137.”.

	- Option 2: Once you loaded a videogrammetry-based measured kinematics in the “SUBJECT-SPECIFIC TOOLBOX” you can use this option to reconstruct a motion. Motion reconstruction here refers to deriving the joint angles from the videogrammetry-based measured trajectories of skin-fixed markers. The joint angles are defined such that the sum of distance between the model landmarks and the measured markers is minimized for each frame of measured data while the kinematic constraint of scapula gliding over the ribcage is satisfied.

15- Click on the “BUILD MOTION (Option 2)” button.

“BUILD MOTION (Option 2), reconstruction of a measured motion” window appears.

This window allows you to
	- analyze the measured data to design a proper filter
	- design a filter
	- filter the data
	- estimate missing markers (see step 18)
	- perform inverse-kinematics
	- see the reconstructed motion in terms of an animated motion as well as the joint angles graphs.

16- Click on either “residual Analysis” or “Harmonic Analysis” buttons to analyze the measured kinematic data in terms of the amount of noise they have. For each case a graph showing the results of the analysis will appear. Based on these graphs you can define the cutoff frequency of the low-pass filter. If you are not familiar with these two standard analyses, you can find more details in “Winter, D. A. (2009). Biomechanics and motor control of human movement. John Wiley & Sons.”.

17- Set the “Cutoff Frequency” and “Filter Order” in the associated boxes and then hit the “Filter Measured Data” button.

A success message would pop up, that you can close, and a graph showing the filtered data together with the raw data. You can use this graph to have an idea of how long the measurements are and set a proper time for your simulation in the “Motion time span” box. Otherwise, you can keep the default value. It is recommended to consider a proper value to avoid simulation of the measured motion while the subject was in the transition pause.

18- Click on the “Estimate Missing Landmarks”.

In the measurements provided with the model, only the trajectories of 11 markers were measured. However, the model consists of 14 landmarks. The 3 missing markers were associated with the center of the glenohumeral joint (GH) and two points on the border of the scapula (TS and AI). These three markers cannot effectively be palpated. On the other hand, in order to be able to evaluate the distance between the model landmarks and the measured markers a one-to-one association between the model landmarks and the measured markers is required. To this end, the missing markers are estimated. Our approach in estimating these markers can be found here “Sarshari, E. (2018). A Closed-Loop EMG-Assisted Shoulder Model (No. THESIS). EPFL.”. Alternatively, if a set of kinematic data including these missing landmarks is provided for instance by using a scapula kinematic measurement-device, the estimation step can be simply skipped.


While the estimation is on course, the progress is printed in the Command Window. Once the estimation is finished, the following message is printed in the Command Window “Show the estimated/measured landmarks in GREEN for the first time Stamp” and the configuration of the subject for the first frame of the measured data is displayed in green together with the model configuration (based on the posture of the generic subject in the MRI machine in blue).

19- Set a proper/meaningful time span for the simulation in the “Motion time Span” that excludes portions of the motion that are not necessary/interesting. Practically speaking, there is always a few seconds at the end of our measurements where the subject is not performing any motion and instead waiting for the indication to perform the next task.

20- Hit the “Perform Inverse Kinematics” button to reconstruct the motion.

It takes some time to complete and meanwhile the progress can be observed through the Command Window.

Once it is completed, the following messages are printed in the Command Window “Motion reconstruction was finished and the results smoothened.
Plot the resulted generalized coordinates (joint angels)” and the 11 joint angles are plotted in the lower half of the window.

Each one of the plots will be plotted separately upon clicking on them. Furthermore, a smooth fitted polynomial and its first and second order derivatives will be also shown in the same figure.

Click on the “View Motion” button if you would like to see the reconstructed motion. A video with AVI format will be save in the main directory of the model at the same time.

21- Click on the “CLOSE TOOL” and proceed to the MAIN GUI window.


22- Click on the “ESTIMATE FORCES” button on the MAIN GUI window.

The “MUSCEL FORCE ESTIMATION TOOLBOX” window appears.

This window allows you to estimate the muscle and joint reaction forces. There are three options possible for performing this estimation as the following that can be activated through the “Estimation Options/Options” menu in the menu bar.

	- Glenohumeral Stability Constraint: forces the glenohumeral joint reaction force to always point toward the glenoid fossa, more details here “Ingram, D. (2015). Musculoskeletal Model of the Human Shoulder for Joint Force Estimation (No. THESIS_LIB). EPFL.” and “Sarshari, E. (2018). A Closed-Loop EMG-Assisted Shoulder Model (No. THESIS). EPFL.”.

	- EMG-Assisted: introduces the muscle forces of 15 muscles calculated based on the measured EMG excitations and a Hill-type muscle model as upper and lower bounds in the load-sharing problem, more details in Step 24 and here “Sarshari, E. (2018). A Closed-Loop EMG-Assisted Shoulder Model (No. THESIS). EPFL.”. 

	- Measured Kinematics: considers the reconstructed motion from the measured kinematics in the inverse dynamics.


23- Check the tick for the three options in “Estimation Options/Options” menu in the menu bar.

24- Hit the gray button below the “Load EMG data”.

This allows you to load the EMG excitations of 15 superficial muscles that were measured on the same subject during the same motion. The measured EMG data can be found in ShoulderModel/Generic_Measurements/EMG.

The idea is to use the measured EMG excitations to estimate the muscle forces of 15 muscles using a Hill type muscle model for the reconstructed motion. These EMG-based muscle forces will be used as upper and lower bounds in the load-sharing to shrink its feasible set. We have shown that this can improve the model’s muscle force estimations.

25- Select the measured EMG data for the associating motion (activity).

A success message would appear that you can dismiss.

Note that the EMG data have been already processed, more details here “Sarshari, E. (2018). A Closed-Loop EMG-Assisted Shoulder Model (No. THESIS). EPFL.”.

26- Set the time of the simulation through the box under “Motion Time Span” according to the time that you set in Step 19.

27- If the subject carried a weight during the measurements you should indicate it through the box under the “Weight in Hand”.

28- Click on the “EMG to Force” button.

This will calculate the muscle forces for each one of the 15 muscles for which you provided EMG signals by integrating a Hill type muscle-tendon model. More details here “Sarshari, E. (2018). A Closed-Loop EMG-Assisted Shoulder Model (No. THESIS). EPFL.”.

You can follow the progress in the Command Window given that it might take quite some time depending on the motion time span.

Once it is completed, a graph showing the EMG based muscle forces will be plotted.

You can dismiss this graph and proceed to the next step.

29- Click the “ESTIMATE FORCES” button to solve the load-sharing problem given the 3 options that you selected.

The progress can be observed through the Command Window.

Once it is completed, a message box would pop up that can assist you to check if the load-sharing was performed successfully.

The muscle and joint reaction forces will be plotted on the “MUSCEL FORCE ESTIMATION TOOLBOX” window. By clicking on each one of these plots you can visualize them separately.

The save button saves the muscle and joint reaction force estimations results (JRDATA and EFDATA respectively) in the folder “Data_Structures_and_Documentation”. 

30- The following details the simulations outcome that you find in the Workspace.

	- SSDATA: includes all subject-specific data, all data associating with the measurements (EMG/kinematics), and the model kinematics (joint angles) if inverse kinematics (Option 2) is used to reconstruct a motion.
	- KEDATA: includes all the data associating with the model kinematics if minimal coordinates (Option 1) is used to construct a motion.
	- JRDATA: is a 16 column vertical matrix that includes the 3 components of the GH joint reaction force in the thorax coordinate system, the magnitude of the GH joint reaction force, the three coordinates of the intersection of the GH joint reaction force with the glenoid fossa in the fossa coordinate system, the stability ratio, the 3 components of the HU joint reaction force, the magnitude of the HU joint reaction force, the 3 components of the RU joint reaction force and the magnitude of the RU joint reaction force, respectively.
	- EFDATA: includes estimations of muscle forces and their moment arms.
	- DYDATA: includes all the data associating with the model inertial properties. 
	- BLDATA: includes all the data associating with the model morphologies. The coordinate systems of different bone segment can be found here.
	- MWDATA: includes all the data associating with the muscle paths and their physiological constants.
	- REDATA: includes all the data associating with the ribcage ellipsoids.






