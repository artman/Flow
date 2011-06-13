

import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.IEventDispatcher;
import mx.core.IPropertyChangeNotifier;
import mx.events.PropertyChangeEvent;
import mx.utils.ObjectProxy;
import mx.utils.UIDUtil;

import com.flow.graphics.fills.GradientFill;
import com.flow.graphics.strokes.SolidStroke;

class BindableProperty
{
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



}
