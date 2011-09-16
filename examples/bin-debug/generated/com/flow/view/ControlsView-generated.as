
/**
 *  Generated by mxmlc 4.0
 *
 *  Package:    com.flow.view
 *  Class:      ControlsView
 *  Source:     /Users/artman/Documents/Flow/examples/src/com/flow/view/ControlsView.mxml
 *  Template:   flex2/compiler/mxml/gen/ClassDef.vm
 *  Time:       2011.06.14 11:20:55 EEST
 */

package com.flow.view
{

import com.flow.components.Button;
import com.flow.components.Checkbox;
import com.flow.components.HScrollBar;
import com.flow.components.Label;
import com.flow.components.TextInput;
import com.flow.containers.Container;
import com.flow.containers.HBox;
import com.flow.containers.layout.VBoxLayout;
import com.flow.graphics.GradientData;
import com.flow.graphics.fills.GradientFill;
import com.flow.graphics.strokes.SolidStroke;
import flash.accessibility.*;
import flash.debugger.*;
import flash.display.*;
import flash.errors.*;
import flash.events.*;
import flash.external.*;
import flash.geom.*;
import flash.media.*;
import flash.net.*;
import flash.printing.*;
import flash.profiler.*;
import flash.system.*;
import flash.text.*;
import flash.ui.*;
import flash.utils.*;
import flash.xml.*;
import mx.binding.*;
import mx.binding.IBindingClient;
import mx.core.ClassFactory;
import mx.core.DeferredInstanceFromClass;
import mx.core.DeferredInstanceFromFunction;
import mx.core.IDeferredInstance;
import mx.core.IFactory;
import mx.core.IFlexModuleFactory;
import mx.core.IPropertyChangeNotifier;
import mx.core.mx_internal;
import mx.filters.*;
import mx.styles.*;



//  begin class def
public class ControlsView
    extends com.flow.containers.Container
    implements mx.binding.IBindingClient
{

    //  instance variables
/**
 * @private
 **/
    public var _ControlsView_Button1 : com.flow.components.Button;

/**
 * @private
 **/
    public var _ControlsView_Label2 : com.flow.components.Label;

/**
 * @private
 **/
    public var _ControlsView_Label3 : com.flow.components.Label;

    [Bindable]
	/**
 * @private
 **/
    public var checkbox : com.flow.components.Checkbox;

    [Bindable]
	/**
 * @private
 **/
    public var itemFill : com.flow.graphics.fills.GradientFill;

    [Bindable]
	/**
 * @private
 **/
    public var itemStroke : com.flow.graphics.strokes.SolidStroke;

    [Bindable]
	/**
 * @private
 **/
    public var scroller : com.flow.components.HScrollBar;

    [Bindable]
	/**
 * @private
 **/
    public var textInput : com.flow.components.TextInput;


    //  type-import dummies



    //  constructor (non-Flex display object)
    /**
     * @private
     **/
    public function ControlsView()
    {
        super();










        var bindings:Array = _ControlsView_bindingsSetup();
        var watchers:Array = [];

        var target:Object = this;

        if (_watcherSetupUtil == null)
        {
            var watcherSetupUtilClass:Object = getDefinitionByName("_com_flow_view_ControlsViewWatcherSetupUtil");
            watcherSetupUtilClass["init"](null);
        }

        _watcherSetupUtil.setup(this,
                    function(propertyName:String):* { return target[propertyName]; },
                    function(propertyName:String):* { return ControlsView[propertyName]; },
                    bindings,
                    watchers);

        mx_internal::_bindings = mx_internal::_bindings.concat(bindings);
        mx_internal::_watchers = mx_internal::_watchers.concat(watchers);



        // our style settings



        // layer initializers

       
        // properties
        this.width = 500;
        this.height = 240;
        this.children = _ControlsView_Container2_c();
        _ControlsView_GradientFill1_i();
        _ControlsView_SolidStroke1_i();


        // events


        for (var i:uint = 0; i < bindings.length; i++)
        {
            Binding(bindings[i]).execute();
        }




    }


    //  scripts
    //  <Script>, line 29 - 33

			import com.flow.skins.ButtonSkin;
			import com.flow.skins.CheckboxSkin;
			import com.flow.skins.TextInputSkin;
		

    //  end scripts


    //  supporting function definitions for properties, events, styles, effects
private function _ControlsView_GradientFill1_i() : com.flow.graphics.fills.GradientFill
{
	var temp : com.flow.graphics.fills.GradientFill = new com.flow.graphics.fills.GradientFill();
	temp.rotation = 90;
	temp.colors = new <com.flow.graphics.GradientData>[_ControlsView_GradientData1_c(), _ControlsView_GradientData2_c()];
	itemFill = temp;
	mx.binding.BindingManager.executeBindings(this, "itemFill", itemFill);
	return temp;
}

private function _ControlsView_GradientData1_c() : com.flow.graphics.GradientData
{
	var temp : com.flow.graphics.GradientData = new com.flow.graphics.GradientData();
	temp.color = 14483456;
	temp.ratio = 0;
	return temp;
}

private function _ControlsView_GradientData2_c() : com.flow.graphics.GradientData
{
	var temp : com.flow.graphics.GradientData = new com.flow.graphics.GradientData();
	temp.color = 12255232;
	temp.ratio = 1;
	return temp;
}

private function _ControlsView_SolidStroke1_i() : com.flow.graphics.strokes.SolidStroke
{
	var temp : com.flow.graphics.strokes.SolidStroke = new com.flow.graphics.strokes.SolidStroke();
	temp.color = 10027008;
	itemStroke = temp;
	mx.binding.BindingManager.executeBindings(this, "itemStroke", itemStroke);
	return temp;
}

private function _ControlsView_Container2_c() : com.flow.containers.Container
{
	var temp : com.flow.containers.Container = new com.flow.containers.Container();
	temp.layout = _ControlsView_VBoxLayout1_c();
	temp.children = [_ControlsView_Label1_c(), _ControlsView_Button1_i(), _ControlsView_Checkbox1_i(), _ControlsView_TextInput1_i(), _ControlsView_Label2_i(), _ControlsView_HBox1_c()];
	return temp;
}

private function _ControlsView_VBoxLayout1_c() : com.flow.containers.layout.VBoxLayout
{
	var temp : com.flow.containers.layout.VBoxLayout = new com.flow.containers.layout.VBoxLayout();
	temp.spacing = 10;
	temp.horizontalAlign = "left";
	temp.padding = 10;
	return temp;
}

private function _ControlsView_Label1_c() : com.flow.components.Label
{
	var temp : com.flow.components.Label = new com.flow.components.Label();
	temp.width = 480;
	temp.text = "There are not that many controls available in flow yet. More are comming, and you can always create your own!";
	temp.left = 10;
	temp.right = 10;
	temp.multiline = true;
	return temp;
}

private function _ControlsView_Button1_i() : com.flow.components.Button
{
	var temp : com.flow.components.Button = new com.flow.components.Button();
	temp.label = "Yep, I'm a button";
	temp.verticalCenter = 0;
	temp.left = 8;
	_ControlsView_Button1 = temp;
	mx.binding.BindingManager.executeBindings(this, "_ControlsView_Button1", _ControlsView_Button1);
	return temp;
}

private function _ControlsView_Checkbox1_i() : com.flow.components.Checkbox
{
	var temp : com.flow.components.Checkbox = new com.flow.components.Checkbox();
	temp.verticalCenter = 0;
	temp.left = 8;
	checkbox = temp;
	mx.binding.BindingManager.executeBindings(this, "checkbox", checkbox);
	return temp;
}

private function _ControlsView_TextInput1_i() : com.flow.components.TextInput
{
	var temp : com.flow.components.TextInput = new com.flow.components.TextInput();
	temp.width = 200;
	temp.value = "Text input";
	textInput = temp;
	mx.binding.BindingManager.executeBindings(this, "textInput", textInput);
	return temp;
}

private function _ControlsView_Label2_i() : com.flow.components.Label
{
	var temp : com.flow.components.Label = new com.flow.components.Label();
	temp.multiline = true;
	temp.width = 480;
	_ControlsView_Label2 = temp;
	mx.binding.BindingManager.executeBindings(this, "_ControlsView_Label2", _ControlsView_Label2);
	return temp;
}

private function _ControlsView_HBox1_c() : com.flow.containers.HBox
{
	var temp : com.flow.containers.HBox = new com.flow.containers.HBox();
	temp.spacing = 10;
	temp.verticalAlign = "middle";
	temp.children = [_ControlsView_HScrollBar1_i(), _ControlsView_Label3_i()];
	return temp;
}

private function _ControlsView_HScrollBar1_i() : com.flow.components.HScrollBar
{
	var temp : com.flow.components.HScrollBar = new com.flow.components.HScrollBar();
	temp.minimum = 0;
	temp.maximum = 100;
	temp.width = 200;
	scroller = temp;
	mx.binding.BindingManager.executeBindings(this, "scroller", scroller);
	return temp;
}

private function _ControlsView_Label3_i() : com.flow.components.Label
{
	var temp : com.flow.components.Label = new com.flow.components.Label();
	_ControlsView_Label3 = temp;
	mx.binding.BindingManager.executeBindings(this, "_ControlsView_Label3", _ControlsView_Label3);
	return temp;
}


    //  binding mgmt
    private function _ControlsView_bindingsSetup():Array
    {
        var result:Array = [];

        result[0] = new mx.binding.Binding(this,
            function():mx.core.IFactory
            {

                return (new ButtonSkin);
            },
            null,
            "_ControlsView_Button1.skinClass"
            );

        result[1] = new mx.binding.Binding(this,
            function():String
            {
                var result:* = (checkbox.selected ? 'I\'m a selected checkbox' : 'I\'m an unselected checkbox');
                return (result == undefined ? null : String(result));
            },
            null,
            "checkbox.label"
            );

        result[2] = new mx.binding.Binding(this,
            function():mx.core.IFactory
            {

                return (new CheckboxSkin);
            },
            null,
            "checkbox.skinClass"
            );

        result[3] = new mx.binding.Binding(this,
            function():mx.core.IFactory
            {

                return (new TextInputSkin);
            },
            null,
            "textInput.skinClass"
            );

        result[4] = new mx.binding.Binding(this,
            function():String
            {
                var result:* = "This label is bound to the input above: " + (textInput.value);
                return (result == undefined ? null : String(result));
            },
            null,
            "_ControlsView_Label2.text"
            );

        result[5] = new mx.binding.Binding(this,
            function():String
            {
                var result:* = "Scroll value: " + (Math.round(scroller.value));
                return (result == undefined ? null : String(result));
            },
            null,
            "_ControlsView_Label3.text"
            );


        return result;
    }


    /**
     * @private
     **/
    public static function set watcherSetupUtil(watcherSetupUtil:IWatcherSetupUtil2):void
    {
        (ControlsView)._watcherSetupUtil = watcherSetupUtil;
    }

    private static var _watcherSetupUtil:IWatcherSetupUtil2;



    //  embed carrier vars
    //  end embed carrier vars

    //  binding management vars
    /**
     * @private
     **/
    mx_internal var _bindings : Array = [];
    /**
     * @private
     **/
    mx_internal var _watchers : Array = [];
    /**
     * @private
     **/
    mx_internal var _bindingsByDestination : Object = {};
    /**
     * @private
     **/
    mx_internal var _bindingsBeginWithWord : Object = {};

//  end class def
}

//  end package def
}
