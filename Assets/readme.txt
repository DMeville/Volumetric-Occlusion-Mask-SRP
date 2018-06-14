Do whatever you want with this code.
Have questions? 
Twitter: @DMeville
Email: dylan@dylanmeville.com
Github: http://github.com/dmeville

---------------------

Most of the code is in LightweightPipeline.Render, be sure to replace the version of LightweightPipeline.cs that comes from the package manager with the included one in the project.

Occluder objects need a convex closed mesh rendered on them, and a Occluder behaviour on them.  

Access the global shader texture _CustomOcclusionMask to use the mask in an objects shader (to mask it's colour or whatever) or use the incldued CustomOcclusionMask.Asset Amplify Shader Function with ASE.

There is also an included ShowOcclusionDepth post process that shows the mask

Is probably slow and unoptimized, has some issues I'm still working out, but is a good starting point if someone is looking for a system like this.

