
package com.flow.view
{
import com.flow.containers.Container;
import com.flow.graphics.Image;
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
import com.flow.components.Button;
import com.flow.effects.BlurEffect;
import com.flow.components.Label;
import com.flow.effects.BevelEffect;
import com.flow.containers.VBox;
import com.flow.effects.transitions.EffectTransition;
import com.flow.containers.layout.VBoxLayout;
import com.flow.effects.ChihulyEffect;
import com.flow.containers.HBox;

public class TransitionsView extends com.flow.containers.Container
{
	public function TransitionsView() {}

	[Bindable]
	public var postcard : com.flow.graphics.Image;
	[Bindable]
	public var postcard2 : com.flow.graphics.Image;

	mx_internal var _bindings : Array;
	mx_internal var _watchers : Array;
	mx_internal var _bindingsByDestination : Object;
	mx_internal var _bindingsBeginWithWord : Object;

include "/Users/artman/Documents/Flow/examples/src/com/flow/view/TransitionsView.mxml:29,35";

}}
