Shader "Hidden/Custom/ShowOcclusionMaskPostProcess"
{
    HLSLINCLUDE

        #include "PostProcessing/Shaders/StdLib.hlsl"

        TEXTURE2D_SAMPLER2D(_CustomOcclusionMask, sampler_CustomOcclusionMask);
        float _Blend;
		float4 _Tint;

        float4 Frag(VaryingsDefault i) : SV_Target
        {
            float4 color = SAMPLE_TEXTURE2D(_CustomOcclusionMask, sampler_CustomOcclusionMask, i.texcoord);
            color.rgb = color.rgb*_Tint*_Blend;
            return color;
        }

    ENDHLSL

    SubShader
    {
        Cull Off ZWrite Off ZTest Always

        Pass
        {
            HLSLPROGRAM

                #pragma vertex VertDefault
                #pragma fragment Frag

            ENDHLSL
        }
    }
}