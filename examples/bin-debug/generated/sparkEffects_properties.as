package 
{

import mx.resources.ResourceBundle;

[ExcludeClass]

public class en_US$sparkEffects_properties extends ResourceBundle
{

    public function en_US$sparkEffects_properties()
    {
		 super("en_US", "sparkEffects");
    }

    override protected function getContent():Object
    {
        var content:Object =
        {
            "cannotOperateOn": "AnimateShaderTransition can operate only on IUIComponent and GraphicElement instances.",
            "accDecWithinRange": "(acceleration + deceleration) must be within range [0,1].",
            "propNotPropOrStyle": "Property {0} is not a property or a style on object {1}: {2}.",
            "cannotCalculateValue": "Interpolator cannot calculate interpolated values when startValue ({0}) or endValue ({1}) is not a number.",
            "illegalPropValue": "Illegal property value: {0}.",
            "arraysNotOfEqualLength": "The start and end arrays must be of equal length.",
            "endValContainsNonNums": "The endValue array contains non-Numbers: you must supply a custom Interpolator to Animation.",
            "startValContainsNonNums": "The startValue array contains non-Numbers: you must supply Interpolator to Animation."
        };
        return content;
    }
}



}
