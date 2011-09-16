
package 
{
import FlowExamplesInnerClass0;
import com.flow.components.Button;
import com.flow.containers.Application;
import com.flow.containers.List;
import com.flow.containers.ScrollArea;
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
import com.flow.view.ScrollingView;
import com.flow.components.Label;
import com.flow.graphics.fills.BitmapFill;
import com.flow.view.BoxLayout;
import mx.core.IFactory;
import com.flow.view.TransitionsView;
import String;
import com.flow.containers.layout.HBoxLayout;
import com.flow.view.BasicLayoutView;
import com.flow.containers.Application;
import com.flow.view.ControlsView;
import com.flow.graphics.Image;

public class FlowExamples extends com.flow.containers.Application
{
	public function FlowExamples() {}

	[Bindable]
	public var segmentTitles : Array;
	[Bindable]
	public var section : com.flow.containers.ScrollArea;
	[Bindable]
	public var sectionCounter : com.flow.containers.List;
	[Bindable]
	public var prev : com.flow.components.Button;
	[Bindable]
	public var next : com.flow.components.Button;

	mx_internal var _bindings : Array;
	mx_internal var _watchers : Array;
	mx_internal var _bindingsByDestination : Object;
	mx_internal var _bindingsBeginWithWord : Object;

include "/Users/artman/Documents/Flow/examples/src/FlowExamples.mxml:30,60";

}}
