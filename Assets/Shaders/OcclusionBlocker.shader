
Shader "OcclusionBlocker"
{
	Properties
	{
	}
	SubShader
	{
		//Tags { "RenderPipeline"="LightweightPipeline" "RenderType"="Opaque" "Queue"="Geometry" }
		Tags { "RenderType"="Opaque"}

		//Cull Back
		
		HLSLINCLUDE
		#pragma target 3.0
		ENDHLSL
		
		Pass
		{
			//Tags { "LightMode"="CustomObjectDepth" }
			Tags {"LightMode" = "CustomObjectDepthBack"}
			Name "CustomObjectDepth"
			Blend Off
			ZTest Always
			ZWrite Off
			ZClip Off
			Cull Front //we want to show the back depths so we cull the frontfaces here

			HLSLPROGRAM
			#pragma prefer_hlslcc gles
    
			#pragma multi_compile_instancing

			#pragma vertex vert
			#pragma fragment frag

			#include "LWRP/ShaderLibrary/Core.hlsl"
			#include "LWRP/ShaderLibrary/Lighting.hlsl"
			
			
			struct GraphVertexInput
			{
				float4 vertex : POSITION;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				
			};

			struct GraphVertexOutput
			{
				float4 clipPos					: SV_POSITION;
				half dist: TEXCOORD0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				
			};

			GraphVertexOutput vert (GraphVertexInput v)
			{
				GraphVertexOutput o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				v.vertex.xyz +=  float3(0,0,0) ;
				o.clipPos = TransformObjectToHClip(v.vertex.xyz);
				return o;
			}

			half4 frag (GraphVertexOutput IN, half ase_vface :VFACE ) : SV_Target
		    {
				
				//how can we do this in one pass?
				//need to write backface depth to one channel, and frontface to another
				//but
				//float3 temp_cast_0 = (ase_vface).xxx; //gets the face direction, should be able to use this to
				//write to r or g channel at once, instead of doing two passes
				//maybe? idk
				
				//if(ase_vface > 0){
				//	//return (0, 1,1,1);
				//	//return (IN.clipPos.z, 0, 0, 1);
				//} else {
				//	//return (1,0,1,1);
				//	//return (0, IN.clipPos.z, 1 ,1);
				//}

				
				//return half4(1,1,0,0); //*ase_vface;

				//return (ase_vface + 1)/2;
				return half4(IN.clipPos.z, 1.0, 0.0, 1.0);

				//return (IN.clipPos.z, 1 ,0);

		    	UNITY_SETUP_INSTANCE_ID(IN);

				float Alpha = 1;
				float AlphaClipThreshold = AlphaClipThreshold;
				
				#if _AlphaClip
					clip(Alpha - AlphaClipThreshold);
				#endif
				return Alpha;

		    }
			ENDHLSL
		}

		Pass
		{
			//Tags { "LightMode"="CustomObjectDepth" }
			Tags {"LightMode" = "CustomObjectDepthFront"}
			Name "CustomObjectDepth"
			Blend Off
			ZTest Always
			ZWrite Off
			Cull Back

			HLSLPROGRAM
			#pragma prefer_hlslcc gles
    
			#pragma multi_compile_instancing

			#pragma vertex vert
			#pragma fragment frag

			#include "LWRP/ShaderLibrary/Core.hlsl"
			#include "LWRP/ShaderLibrary/Lighting.hlsl"
			
			
			struct GraphVertexInput
			{
				float4 vertex : POSITION;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				
			};

			struct GraphVertexOutput
			{
				float4 clipPos					: SV_POSITION;
				half dist: TEXCOORD0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				
			};

			GraphVertexOutput vert (GraphVertexInput v)
			{
				GraphVertexOutput o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				v.vertex.xyz +=  float3(0,0,0) ;
				o.clipPos = TransformObjectToHClip(v.vertex.xyz);
				return o;
			}

			half4 frag (GraphVertexOutput IN ) : SV_Target
		    {
			//	return (IN.clipPos.z, 1, 0);
				return half4(IN.clipPos.z, 0.0, 0.0, 1.0);
		    	UNITY_SETUP_INSTANCE_ID(IN);

				float Alpha = 1;
				float AlphaClipThreshold = AlphaClipThreshold;
				
				#if _AlphaClip
					clip(Alpha - AlphaClipThreshold);
				#endif
				return Alpha;

		    }
			ENDHLSL
		}
	}
	CustomEditor "ASEMaterialInspector"
}
