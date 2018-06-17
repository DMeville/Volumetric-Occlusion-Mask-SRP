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
		ZWrite Off
		

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
				float2 uv_MainTex = i.uv.xy * _MainTex_ST.xy + _MainTex_ST.zw;
				float4 tex2DNode1 = tex2D( _MainTex, uv_MainTex );
				float4 screenPos = i.ase_texcoord4;
				float clampDepth19 = UNITY_SAMPLE_DEPTH(tex2Dproj(_CameraDepthTexture,UNITY_PROJ_COORD(screenPos)));
				float2 uv_CustomObjectDepthTemp2 = i.uv.xy * _CustomObjectDepthTemp2_ST.xy + _CustomObjectDepthTemp2_ST.zw;
				float4 tex2DNode4 = tex2D( _CustomObjectDepthTemp2, uv_CustomObjectDepthTemp2 );
				float ifLocalVar16 = 0;
				if( clampDepth19 >= tex2DNode4.r )
				ifLocalVar16 = 0.0;
				else
				ifLocalVar16 = 1.0;
				float2 uv_CustomObjectDepthTemp1 = i.uv.xy * _CustomObjectDepthTemp1_ST.xy + _CustomObjectDepthTemp1_ST.zw;
				float4 tex2DNode3 = tex2D( _CustomObjectDepthTemp1, uv_CustomObjectDepthTemp1 );
				float ifLocalVar13 = 0;
				if( clampDepth19 >= tex2DNode3.r )
				ifLocalVar13 = 1.0;
				else
				ifLocalVar13 = 0.0;
				float clampResult64 = clamp( ( tex2DNode3.g + ( 1.0 - tex2DNode4.g ) ) , 0.0 , 1.0 );
				float GeoMask65 = clampResult64;
				float4 temp_cast_0 = (( max( tex2DNode1.r , ( ifLocalVar16 * ifLocalVar13 ) ) * GeoMask65 )).xxxx;
				

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
-1199;23;1198;1536;1924.884;2013.446;2.663609;True;False
Node;AmplifyShaderEditor.SamplerNode;4;-1106.871,-1197.411;Float;True;Global;_CustomObjectDepthTemp2;_CustomObjectDepthTemp2;0;0;Create;True;0;0;False;0;None;;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;3;-1172.785,-397.5674;Float;True;Global;_CustomObjectDepthTemp1;_CustomObjectDepthTemp1;1;0;Create;True;0;0;False;0;None;;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ScreenDepthNode;19;-797.303,-539.4059;Float;False;1;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;15;-369.4838,-238.4257;Float;False;Constant;_Float1;Float 1;2;0;Create;True;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;62;-965.6855,272.2695;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;14;-336.2481,-86.24045;Float;False;Constant;_Float0;Float 0;2;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TemplateShaderPropertyNode;2;-565.6407,-993.6328;Float;False;0;0;_MainTex;Shader;0;5;SAMPLER2D;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ConditionalIfNode;13;-187.5615,-350.3777;Float;False;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;63;-670.025,440.0769;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ConditionalIfNode;16;-173.5675,-687.9839;Float;False;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;64;-446.2815,490.6858;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1;-406.4578,-997.1318;Float;True;Global;TextureSample0;Texture Sample 0;0;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;29;78.32359,-695.5294;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;66;483.4978,-521.8883;Float;False;65;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;65;-283.8015,511.994;Float;False;GeoMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;31;292.7082,-924.5497;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RelayNode;34;446.7231,-132.3029;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DistanceOpNode;44;-80.03485,-10.92997;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;68;509.6529,-1083.846;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DistanceOpNode;33;-470.8556,258.5178;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DistanceOpNode;32;-466.0004,120.1528;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;58;259.1769,-1445.183;Float;False;Global;OcclusionSharpnessMultiplier;OcclusionSharpnessMultiplier;4;0;Create;True;0;0;False;0;10.42;7.26;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;57;268.7307,-1548.484;Float;False;Global;OcclusionSharpnessOffset;OcclusionSharpnessOffset;3;0;Create;True;0;0;False;0;0;-0.01;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;59;746.2854,-1376.653;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.AbsOpNode;37;-211.1176,243.9528;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;67;690.7779,-913.3745;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;56;598.8544,-1530.061;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;45;711.3157,-159.005;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;60;676.5544,-1215.275;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RelayNode;49;-289.7162,-1366.691;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RelayNode;50;-285.7315,-1288.991;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RelayNode;51;-281.7468,-1205.314;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;53;-72.55422,-1334.814;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;52;-74.54649,-1444.391;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;54;72.88469,-1438.414;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMinOpNode;40;143.291,297.3569;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;61;234.2616,-1338.798;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;46;553.5314,78.88559;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.AbsOpNode;35;-211.1176,125.0075;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;55;939.5393,-1149.529;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;47;407.8836,270.6546;Float;False;Property;_Float2;Float 2;2;0;Create;True;0;0;False;0;28.33;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;39;92.31444,71.60347;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;42;322.9229,-365.3385;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;0;929.2462,-689.2681;Float;False;True;2;Float;ASEMaterialInspector;0;2;OcclusionBlitCombineObjMasks;c71b220b631b6344493ea3cf87110c93;0;0;SubShader 0 Pass 0;1;False;False;True;Off;False;False;True;2;True;7;False;True;0;False;0;0;0;False;False;False;False;False;False;False;False;False;True;2;0;0;0;1;0;FLOAT4;0,0,0,0;False;0
Node;AmplifyShaderEditor.CommentaryNode;48;-403.2778,-1492.207;Float;False;100;100;Comment;0;Output = (T - A)/(B-A);1,1,1,1;0;0
WireConnection;62;0;4;2
WireConnection;13;0;19;0
WireConnection;13;1;3;1
WireConnection;13;2;15;0
WireConnection;13;3;15;0
WireConnection;13;4;14;0
WireConnection;63;0;3;2
WireConnection;63;1;62;0
WireConnection;16;0;19;0
WireConnection;16;1;4;1
WireConnection;16;2;14;0
WireConnection;16;3;14;0
WireConnection;16;4;15;0
WireConnection;64;0;63;0
WireConnection;1;0;2;0
WireConnection;29;0;16;0
WireConnection;29;1;13;0
WireConnection;65;0;64;0
WireConnection;31;0;1;1
WireConnection;31;1;29;0
WireConnection;34;0;42;0
WireConnection;44;0;32;0
WireConnection;44;1;33;0
WireConnection;68;0;55;0
WireConnection;68;1;1;1
WireConnection;33;0;3;1
WireConnection;33;1;19;0
WireConnection;32;0;4;1
WireConnection;32;1;19;0
WireConnection;59;0;56;0
WireConnection;59;1;58;0
WireConnection;37;0;33;0
WireConnection;67;0;31;0
WireConnection;67;1;66;0
WireConnection;56;0;57;0
WireConnection;56;1;61;0
WireConnection;45;0;34;0
WireConnection;60;0;59;0
WireConnection;49;0;3;1
WireConnection;50;0;4;1
WireConnection;51;0;19;0
WireConnection;53;0;50;0
WireConnection;53;1;49;0
WireConnection;52;0;51;0
WireConnection;52;1;49;0
WireConnection;54;0;53;0
WireConnection;54;1;52;0
WireConnection;40;0;35;0
WireConnection;40;1;37;0
WireConnection;61;0;54;0
WireConnection;46;0;34;0
WireConnection;46;1;47;0
WireConnection;35;0;32;0
WireConnection;55;0;59;0
WireConnection;39;0;33;0
WireConnection;39;1;32;0
WireConnection;42;0;1;1
WireConnection;42;1;44;0
WireConnection;0;0;67;0
ASEEND*/
//CHKSM=8D2205537D1BB95BC5700663CC055A04C03EC270