using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Rendering.PostProcessing;

[Serializable]
[PostProcess(typeof(ShowOcclusionMaskPostProcessRenderer), PostProcessEvent.BeforeStack, "ShowOcclusionMaskPostProcess")]
public sealed class ShowOcclusionMaskPostProcess: PostProcessEffectSettings {

    public FloatParameter multiplier = new FloatParameter { value = 1f };
    public ColorParameter tint = new ColorParameter();
    
    //public Shader effect;
}

public sealed class ShowOcclusionMaskPostProcessRenderer: PostProcessEffectRenderer<ShowOcclusionMaskPostProcess> {

    public override void Render(PostProcessRenderContext context) {
        //var sheet = context.propertySheets.Get(Shader.Find("ASETemplateShaders/PostProcess"));
        //sheet.properties.SetFloat("_Multiplier", settings.multiplier);
        //context.command.BlitFullscreenTriangle(context.source, context.destination, sheet, 0);

        var sheet = context.propertySheets.Get(Shader.Find("Hidden/Custom/ShowOcclusionMaskPostProcess"));
        sheet.properties.SetFloat("_Blend", settings.multiplier);
        sheet.properties.SetColor("_Tint", settings.tint);
        context.command.BlitFullscreenTriangle(context.source, context.destination, sheet, 0);
    }
}
