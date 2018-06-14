using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Experimental.Rendering.LightweightPipeline;

[ExecuteInEditMode]
[RequireComponent(typeof(Renderer))]
public class Occluder : MonoBehaviour {

    private Renderer rend;

    public void OnEnable() {
        if(LightweightPipeline.customOccluders == null) return;

        if(LightweightPipeline.customOccluders == null) {
            LightweightPipeline.customOccluders = new List<Renderer>();
        }

        if(rend == null) {
            rend = this.GetComponent<Renderer>();
        }

        if(rend == null) return;

        if(!LightweightPipeline.customOccluders.Contains(rend)) {
            LightweightPipeline.customOccluders.Add(rend);
        }
    }

    public void OnDisable() {
        if(LightweightPipeline.customOccluders == null) return;

        if(LightweightPipeline.customOccluders == null) {
            LightweightPipeline.customOccluders = new List<Renderer>();
        }

        if(rend == null) {
            rend = this.GetComponent<Renderer>();
        }

        if(rend == null) return;

        if(!LightweightPipeline.customOccluders.Contains(rend)) {
            LightweightPipeline.customOccluders.Remove(rend);
        }
    }
}
