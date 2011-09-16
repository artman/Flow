

import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.IEventDispatcher;
import mx.core.IPropertyChangeNotifier;
import mx.events.PropertyChangeEvent;
import mx.utils.ObjectProxy;
import mx.utils.UIDUtil;

import com.flow.graphics.strokes.SolidStroke;
import com.flow.graphics.GradientData;
import FlowExamples;

class BindableProperty
{
	/*
	 * generated bindable wrapper for property _FlowExamplesInnerClass0_GradientData1 (public)
	 * - generated setter
	 * - generated getter
	 * - original public var '_FlowExamplesInnerClass0_GradientData1' moved to '_31702896_FlowExamplesInnerClass0_GradientData1'
	 */

    [Bindable(event="propertyChange")]
    public function get _FlowExamplesInnerClass0_GradientData1():com.flow.graphics.GradientData
    {
        return this._31702896_FlowExamplesInnerClass0_GradientData1;
    }

    public function set _FlowExamplesInnerClass0_GradientData1(value:com.flow.graphics.GradientData):void
    {
    	var oldValue:Object = this._31702896_FlowExamplesInnerClass0_GradientData1;
        if (oldValue !== value)
        {
            this._31702896_FlowExamplesInnerClass0_GradientData1 = value;
           if (this.hasEventListener("propertyChange"))
               this.dispatchEvent(mx.events.PropertyChangeEvent.createUpdateEvent(this, "_FlowExamplesInnerClass0_GradientData1", oldValue, value));
        }
    }

	/*
	 * generated bindable wrapper for property _FlowExamplesInnerClass0_GradientData2 (public)
	 * - generated setter
	 * - generated getter
	 * - original public var '_FlowExamplesInnerClass0_GradientData2' moved to '_31702895_FlowExamplesInnerClass0_GradientData2'
	 */

    [Bindable(event="propertyChange")]
    public function get _FlowExamplesInnerClass0_GradientData2():com.flow.graphics.GradientData
    {
        return this._31702895_FlowExamplesInnerClass0_GradientData2;
    }

    public function set _FlowExamplesInnerClass0_GradientData2(value:com.flow.graphics.GradientData):void
    {
    	var oldValue:Object = this._31702895_FlowExamplesInnerClass0_GradientData2;
        if (oldValue !== value)
        {
            this._31702895_FlowExamplesInnerClass0_GradientData2 = value;
           if (this.hasEventListener("propertyChange"))
               this.dispatchEvent(mx.events.PropertyChangeEvent.createUpdateEvent(this, "_FlowExamplesInnerClass0_GradientData2", oldValue, value));
        }
    }

	/*
	 * generated bindable wrapper for property _FlowExamplesInnerClass0_SolidStroke1 (public)
	 * - generated setter
	 * - generated getter
	 * - original public var '_FlowExamplesInnerClass0_SolidStroke1' moved to '_1979510933_FlowExamplesInnerClass0_SolidStroke1'
	 */

    [Bindable(event="propertyChange")]
    public function get _FlowExamplesInnerClass0_SolidStroke1():com.flow.graphics.strokes.SolidStroke
    {
        return this._1979510933_FlowExamplesInnerClass0_SolidStroke1;
    }

    public function set _FlowExamplesInnerClass0_SolidStroke1(value:com.flow.graphics.strokes.SolidStroke):void
    {
    	var oldValue:Object = this._1979510933_FlowExamplesInnerClass0_SolidStroke1;
        if (oldValue !== value)
        {
            this._1979510933_FlowExamplesInnerClass0_SolidStroke1 = value;
           if (this.hasEventListener("propertyChange"))
               this.dispatchEvent(mx.events.PropertyChangeEvent.createUpdateEvent(this, "_FlowExamplesInnerClass0_SolidStroke1", oldValue, value));
        }
    }

	/*
	 * generated bindable wrapper for property outerDocument (public)
	 * - generated setter
	 * - generated getter
	 * - original public var 'outerDocument' moved to '_88844982outerDocument'
	 */

    [Bindable(event="propertyChange")]
    public function get outerDocument():FlowExamples
    {
        return this._88844982outerDocument;
    }

    public function set outerDocument(value:FlowExamples):void
    {
    	var oldValue:Object = this._88844982outerDocument;
        if (oldValue !== value)
        {
            this._88844982outerDocument = value;
           if (this.hasEventListener("propertyChange"))
               this.dispatchEvent(mx.events.PropertyChangeEvent.createUpdateEvent(this, "outerDocument", oldValue, value));
        }
    }



}
