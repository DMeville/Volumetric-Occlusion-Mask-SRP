

## WANT TO BLOCK STUFF FROM GETTING WET?! I GOTCHU FAM

![screenshot](https://i.imgur.com/GQkoxMy.gif)
![screenshot](https://i.imgur.com/6XeEZDS.gif)

Using Unity 2018.2.0b7
Package Manager: Lightweight Render Pipeline 1.1.10-preview and Post-processing 2.0.7-preview 

Most of the code is in LightweightPipeline.Render, be sure to replace the version of LightweightPipeline.cs that comes from the package manager with the included one in the project.

Occluder objects need a convex closed mesh rendered on them, and a Occluder behaviour on them.  

Access the global shader texture _CustomOcclusionMask to use the mask in an objects shader (to mask it's colour or whatever) or use the incldued CustomOcclusionMask.Asset Amplify Shader Function with ASE.

There is also an included ShowOcclusionDepth post process that shows the mask

Is probably slow and unoptimized, has some issues I'm still working out, but is a good starting point if someone is looking for a system like this.

----
https://www.youtube.com/watch?v=wDp5uLv2HrU

Been learning about the new scriptable render pipeline in unity 2018, stumbling along because I have no idea what I'm doing.

I wanted to make a system that would allow me to mask out shader effects based on other geometry and work properly with masking by depth. For example, in a snowy forest, I would like to control snow coverage with a global shader variable to affect all meshes, however some meshes (like inside a house) shouldn't get snow on them.  I could manually paint masks for individual geometry but that sounds dumb.

Instead I create a cube (or any other concave closed mesh) and mark it with a special two pass shader.  This shader renders the backface and frontface depth of the cube to calculate the cubes volume, and uses that to compare with the depth texture.  If the pixel we're trying has a depth that falls between the frontface and backface depths, we know that pixel is within the blocking volume and should be masked out.

Volumes are baked into a OcclusionMask texture which I can sample in any shader to access the mask.

I will use this to easily make it so shader wet-ness effects (like animated water dripping on rocks) or snow on the ground doesn't appear in places they shouldnt (like inside houses, caves, etc).  What's cool is that it obeys depth properly, so if we're looking "through" a occlusion mesh, only the pixels within the volume are masked, pixels "behind" the mask but off in the distance are not affected (as they would be if it was a simple screen space effect!)

More info of me trying to work through this problem on reddit: 
https://www.reddit.com/r/Unity3D/comments/8f2stm/how_would_you_go_about_making_a_shader_that_color/?st=jidwwnr0&sh=c9ff5f64

----

Do whatever you want with this code.
Have questions? 
- Twitter: @DMeville
- Email: dylan@dylanmeville.com
