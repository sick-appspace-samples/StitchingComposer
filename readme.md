## StitchingComposer
Demonstrating image stitching in a scene with known geometry and motion.
### Description
This sample shows how the views from three cameras and 13 exposures can be used to create one combined image. This method is recommended for cases where the geometry and placement of all cameras are known with good precision. Also the object surface should be possible to estimate by means of an external method as it is needed to stitch the image correctly.
### How to Run
Starting this sample is possible either by running the App (F5) or debugging (F7+F10). Setting breakpoint on the first row inside the 'main' function allows debugging step-by-step after 'Engine.OnStarted' event. Results can be seen in the image viewer on the DevicePage. Restarting the Sample may be necessary to show images after loading the web-page.
To run this Sample a device with SICK Algorithm API and AppEngine >= V2.8.0 is required. For example SIM4000 with latest firmware. Alternatively the Emulator in AppStudio 2.4 or higher can be used.

### Topics
Algorithm, Image-2D, Stitching, Sample, SICK-AppSpace