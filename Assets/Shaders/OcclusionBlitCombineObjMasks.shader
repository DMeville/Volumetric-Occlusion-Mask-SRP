// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "OcclusionBlitCombineObjMasks"
{
	Properties
	{
		_MainTex ( "Screen", 2D ) = "black" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
	}

	SubShader
	{
		
		
		ZTest Always
		Cull Off
		ZWrite On
		Blend One One

		Pass
		{ 
			CGPROGRAM 

			#pragma vertex vert_img_custom 
			#pragma fragment frag
			#pragma target 3.0
			#include "UnityCG.cginc"
			#include "UnityCG.cginc"


			struct appdata_img_custom
			{
				float4 vertex : POSITION;
				half2 texcoord : TEXCOORD0;
				
			};

			struct v2f_img_custom
			{
				float4 pos : SV_POSITION;
				half2 uv   : TEXCOORD0;
				half2 stereoUV : TEXCOORD2;
		#if UNITY_UV_STARTS_AT_TOP
				half4 uv2 : TEXCOORD1;
				half4 stereoUV2 : TEXCOORD3;
		#endif
				float4 ase_texcoord4 : TEXCOORD4;
			};

			uniform sampler2D _MainTex;
			uniform half4 _MainTex_TexelSize;
			uniform half4 _MainTex_ST;
			
			uniform float OcclusionSharpnessMultiplier;
			uniform sampler2D _CameraDepthTexture;
			uniform sampler2D _CustomObjectDepthTemp2;
			uniform float4 _CustomObjectDepthTemp2_ST;
			uniform sampler2D _CustomObjectDepthTemp1;
			uniform float4 _CustomObjectDepthTemp1_ST;

			v2f_img_custom vert_img_custom ( appdata_img_custom v  )
			{
				v2f_img_custom o;
				float4 ase_clipPos = UnityObjectToClipPos(v.vertex);
				float4 screenPos = ComputeScreenPos(ase_clipPos);
				o.ase_texcoord4 = screenPos;
				
				o.pos = UnityObjectToClipPos ( v.vertex );
				o.uv = float4( v.texcoord.xy, 1, 1 );

				#if UNITY_UV_STARTS_AT_TOP
					o.uv2 = float4( v.texcoord.xy, 1, 1 );
					o.stereoUV2 = UnityStereoScreenSpaceUVAdjust ( o.uv2, _MainTex_ST );

					if ( _MainTex_TexelSize.y < 0.0 )
						o.uv.y = 1.0 - o.uv.y;
				#endif
				o.stereoUV = UnityStereoScreenSpaceUVAdjust ( o.uv, _MainTex_ST );
				return o;
			}

			half4 frag ( v2f_img_custom i ) : SV_Target
			{
				#ifdef UNITY_UV_STARTS_AT_TOP
					half2 uv = i.uv2;
					half2 stereoUV = i.stereoUV2;
				#else
					half2 uv = i.uv;
					half2 stereoUV = i.stereoUV;
				#endif	
				
				half4 finalColor;

				// ase common template code
				float4 screenPos = i.ase_texcoord4;
				float clampDepth19 = UNITY_SAMPLE_DEPTH(tex2Dproj(_CameraDepthTexture,UNITY_PROJ_COORD(screenPos)));
				float2 uv_CustomObjectDepthTemp2 = i.uv.xy * _CustomObjectDepthTemp2_ST.xy + _CustomObjectDepthTemp2_ST.zw;
				float4 tex2DNode4 = tex2D( _CustomObjectDepthTemp2, uv_CustomObjectDepthTemp2 );
				float2 uv_CustomObjectDepthTemp1 = i.uv.xy * _CustomObjectDepthTemp1_ST.xy + _CustomObjectDepthTemp1_ST.zw;
				float4 tex2DNode3 = tex2D( _CustomObjectDepthTemp1, uv_CustomObjectDepthTemp1 );
				float clampResult61 = clamp( ( ( clampDepth19 - tex2DNode4.r ) / ( tex2DNode3.r - tex2DNode4.r ) ) , 0.0 , 1.0 );
				float clampResult64 = clamp( ( tex2DNode3.g + ( 1.0 - tex2DNode4.g ) ) , 0.0 , 1.0 );
				float2 uv_MainTex = i.uv.xy * _MainTex_ST.xy + _MainTex_ST.zw;
				float4 temp_cast_0 = (max( ( OcclusionSharpnessMultiplier * ( ( 1.0 - clampResult61 ) * clampResult61 ) * clampResult64 ) , tex2D( _MainTex, uv_MainTex ).r )).xxxx;
				

				finalColor = temp_cast_0;

				return finalColor;
			} 
			ENDCG 
		}
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=15301
-1156;136;1186;1004;1820.115;2002.395;2.527192;True;False
Node;AmplifyShaderEditor.SamplerNode;4;-1106.871,-1197.411;Float;True;Global;_CustomObjectDepthTemp2;_CustomObjectDepthTemp2;0;0;Create;True;0;0;False;0;None;;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;3;-1122.671,-988.913;Float;True;Global;_CustomObjectDepthTemp1;_CustomObjectDepthTemp1;1;0;Create;True;0;0;False;0;None;;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ScreenDepthNode;19;-1121.374,-763.249;Float;False;1;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RelayNode;50;-664.8098,-1165.158;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RelayNode;51;-660.8251,-1081.481;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RelayNode;49;-663.0185,-1251.521;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;53;-462.1042,-1160.436;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;52;-466.2629,-1257.016;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;54;-287.7889,-1217.827;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;61;-159.6246,-1215.326;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;62;-535.3857,-745.8625;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;63;-323.2495,-771.8296;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;89;20.83275,-1252.572;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;90;181.8394,-1224.035;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;64;-126.2336,-784.6983;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;58;62.78096,-1328.543;Float;False;Global;OcclusionSharpnessMultiplier;OcclusionSharpnessMultiplier;4;0;Create;True;0;0;False;0;10.42;4.84;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TemplateShaderPropertyNode;2;-565.6407,-993.6328;Float;False;0;0;_MainTex;Shader;0;5;SAMPLER2D;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;1;-406.4578,-997.1318;Float;True;Global;TextureSample0;Texture Sample 0;0;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;59;389.5826,-1235.107;Float;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;96;576.0202,-1172.498;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;0;719.0303,-1186.595;Float;False;True;2;Float;ASEMaterialInspector;0;2;OcclusionBlitCombineObjMasks;c71b220b631b6344493ea3cf87110c93;0;0;SubShader 0 Pass 0;1;False;False;True;Off;False;False;True;1;True;7;False;True;0;False;0;0;0;False;False;False;False;False;False;False;False;False;True;2;0;0;0;1;0;FLOAT4;0,0,0,0;False;0
Node;AmplifyShaderEditor.CommentaryNode;85;-624.2166,-1476.13;Float;False;585.2209;107.5817;Otherwise you'll only have one blocker visible;0;Blend mode needs to be set to One One manually every time after compile;1,1,1,1;0;0
WireConnection;50;0;3;1
WireConnection;51;0;19;0
WireConnection;49;0;4;1
WireConnection;53;0;51;0
WireConnection;53;1;49;0
WireConnection;52;0;50;0
WireConnection;52;1;49;0
WireConnection;54;0;53;0
WireConnection;54;1;52;0
WireConnection;61;0;54;0
WireConnection;62;0;4;2
WireConnection;63;0;3;2
WireConnection;63;1;62;0
WireConnection;89;0;61;0
WireConnection;90;0;89;0
WireConnection;90;1;61;0
WireConnection;64;0;63;0
WireConnection;1;0;2;0
WireConnection;59;0;58;0
WireConnection;59;1;90;0
WireConnection;59;2;64;0
WireConnection;96;0;59;0
WireConnection;96;1;1;1
WireConnection;0;0;96;0
ASEEND*/
//CHKSM=B81FF3A09CF6CE06A8A270808425F15B6A47B878