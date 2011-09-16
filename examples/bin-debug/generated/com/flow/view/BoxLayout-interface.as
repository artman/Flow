
package com.flow.view
{
import com.flow.components.TextInput;
import com.flow.containers.Container;
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
import com.flow.containers.Container;
import com.flow.components.Label;
import com.flow.containers.VBox;
import assets.Postcard;
import com.flow.containers.HBox;
import com.flow.graphics.strokes.SolidStroke;
import com.flow.graphics.GradientData;

public class BoxLayout extends com.flow.containers.Container
{
	public function BoxLayout() {}

	[Bindable]
	public var itemFill : com.flow.graphics.fills.GradientFill;
	[Bindable]
	public var itemStroke : com.flow.graphics.strokes.SolidStroke;
	[Bindable]
	public var textInput : com.flow.components.TextInput;

	mx_internal var _bindings : Array;
	mx_internal var _watchers : Array;
	mx_internal var _bindingsByDestination : Object;
	mx_internal var _bindingsBeginWithWord : Object;

include "/Users/artman/Documents/Flow/examples/src/com/flow/view/BoxLayout.mxml:29,31";

}}
