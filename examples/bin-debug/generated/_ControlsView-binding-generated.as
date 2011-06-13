

import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.IEventDispatcher;
import mx.core.IPropertyChangeNotifier;
import mx.events.PropertyChangeEvent;
import mx.utils.ObjectProxy;
import mx.utils.UIDUtil;

import com.flow.graphics.fills.GradientFill;
import com.flow.components.TextInput;
import com.flow.components.Checkbox;
import com.flow.graphics.strokes.SolidStroke;
import com.flow.components.HScrollBar;

class BindableProperty
{
	/*
	 * generated bindable wrapper for property checkbox (public)
	 * - generated setter
	 * - generated getter
	 * - original public var 'checkbox' moved to '_1536891843checkbox'
	 */

    [Bindable(event="propertyChange")]
    public function get checkbox():com.flow.components.Checkbox
    {
        return this._1536891843checkbox;
    }

    public function set checkbox(value:com.flow.components.Checkbox):void
    {
    	var oldValue:Object = this._1536891843checkbox;
        if (oldValue !== value)
        {
            this._1536891843checkbox = value;
           if (this.hasEventListener("propertyChange"))
               this.dispatchEvent(mx.events.PropertyChangeEvent.createUpdateEvent(this, "checkbox", oldValue, value));
        }
    }

	/*
	 * generated bindable wrapper for property itemFill (public)
	 * - generated setter
	 * - generated getter
	 * - original public var 'itemFill' moved to '_1177101110itemFill'
	 */

    [Bindable(event="propertyChange")]
    public function get itemFill():com.flow.graphics.fills.GradientFill
    {
        return this._1177101110itemFill;
    }

    public function set itemFill(value:com.flow.graphics.fills.GradientFill):void
    {
    	var oldValue:Object = this._1177101110itemFill;
        if (oldValue !== value)
        {
            this._1177101110itemFill = value;
           if (this.hasEventListener("propertyChange"))
               this.dispatchEvent(mx.events.PropertyChangeEvent.createUpdateEvent(this, "itemFill", oldValue, value));
        }
    }

	/*
	 * generated bindable wrapper for property itemStroke (public)
	 * - generated setter
	 * - generated getter
	 * - original public var 'itemStroke' moved to '_2000290603itemStroke'
	 */

    [Bindable(event="propertyChange")]
    public function get itemStroke():com.flow.graphics.strokes.SolidStroke
    {
        return this._2000290603itemStroke;
    }

    public function set itemStroke(value:com.flow.graphics.strokes.SolidStroke):void
    {
    	var oldValue:Object = this._2000290603itemStroke;
        if (oldValue !== value)
        {
            this._2000290603itemStroke = value;
           if (this.hasEventListener("propertyChange"))
               this.dispatchEvent(mx.events.PropertyChangeEvent.createUpdateEvent(this, "itemStroke", oldValue, value));
        }
    }

	/*
	 * generated bindable wrapper for property scroller (public)
	 * - generated setter
	 * - generated getter
	 * - original public var 'scroller' moved to '_402164678scroller'
	 */

    [Bindable(event="propertyChange")]
    public function get scroller():com.flow.components.HScrollBar
    {
        return this._402164678scroller;
    }

    public function set scroller(value:com.flow.components.HScrollBar):void
    {
    	var oldValue:Object = this._402164678scroller;
        if (oldValue !== value)
        {
            this._402164678scroller = value;
           if (this.hasEventListener("propertyChange"))
               this.dispatchEvent(mx.events.PropertyChangeEvent.createUpdateEvent(this, "scroller", oldValue, value));
        }
    }

	/*
	 * generated bindable wrapper for property textInput (public)
	 * - generated setter
	 * - generated getter
	 * - original public var 'textInput' moved to '_1058056547textInput'
	 */

    [Bindable(event="propertyChange")]
    public function get textInput():com.flow.components.TextInput
    {
        return this._1058056547textInput;
    }

    public function set textInput(value:com.flow.components.TextInput):void
    {
    	var oldValue:Object = this._1058056547textInput;
        if (oldValue !== value)
        {
            this._1058056547textInput = value;
           if (this.hasEventListener("propertyChange"))
               this.dispatchEvent(mx.events.PropertyChangeEvent.createUpdateEvent(this, "textInput", oldValue, value));
        }
    }



}
