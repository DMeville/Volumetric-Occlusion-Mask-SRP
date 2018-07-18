using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SetOcclusionProperties : MonoBehaviour {


    [Range(0,10)] public float occlusionAdd = 0f;
    [Range(0, 10)] public float occlusionSharpness = 1f;

	// Use this for initialization
	void Start () {
		
	}
	
	// Update is called once per frame
	void Update () {
        Shader.SetGlobalFloat("OcclusionSharpnessOffset", occlusionAdd);
        Shader.SetGlobalFloat("OcclusionSharpnessMultiplier", occlusionSharpness);
	}
}
