
package com.flow.view
{
import com.flow.components.TextInput;
import com.flow.containers.Container;
import com.flow.net.AMFGateway;
import com.flow.net.RemoteProcedureAMF;
import com.flow.net.RemoteProcedureHTTP;
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
import com.flow.components.Label;
import com.flow.containers.VBox;
import com.flow.containers.HBox;
import com.flow.components.Spacing;

public class RemoteProceduresView extends com.flow.containers.Container
{
	public function RemoteProceduresView() {}

	[Bindable]
	public var gateway : com.flow.net.AMFGateway;
	[Bindable]
	public var helloWorld : com.flow.net.RemoteProcedureAMF;
	[Bindable]
	public var httpRequest : com.flow.net.RemoteProcedureHTTP;
	[Bindable]
	public var paramInput : com.flow.components.TextInput;
	[Bindable]
	public var urlInput : com.flow.components.TextInput;

	mx_internal var _bindings : Array;
	mx_internal var _watchers : Array;
	mx_internal var _bindingsByDestination : Object;
	mx_internal var _bindingsBeginWithWord : Object;

include "/Users/artman/Documents/Flow/examples/src/com/flow/view/RemoteProceduresView.mxml:28,31";

}}
