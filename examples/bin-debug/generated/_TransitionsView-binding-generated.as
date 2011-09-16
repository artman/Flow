

import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.IEventDispatcher;
import mx.core.IPropertyChangeNotifier;
import mx.events.PropertyChangeEvent;
import mx.utils.ObjectProxy;
import mx.utils.UIDUtil;

import com.flow.graphics.Image;

class BindableProperty
{
	/*
	 * generated bindable wrapper for property postcard (public)
	 * - generated setter
	 * - generated getter
	 * - original public var 'postcard' moved to '_757449648postcard'
	 */

    [Bindable(event="propertyChange")]
    public function get postcard():com.flow.graphics.Image
    {
        return this._757449648postcard;
    }

    public function set postcard(value:com.flow.graphics.Image):void
    {
    	var oldValue:Object = this._757449648postcard;
        if (oldValue !== value)
        {
            this._757449648postcard = value;
           if (this.hasEventListener("propertyChange"))
               this.dispatchEvent(mx.events.PropertyChangeEvent.createUpdateEvent(this, "postcard", oldValue, value));
        }
    }

	/*
	 * generated bindable wrapper for property postcard2 (public)
	 * - generated setter
	 * - generated getter
	 * - original public var 'postcard2' moved to '_2006102658postcard2'
	 */

    [Bindable(event="propertyChange")]
    public function get postcard2():com.flow.graphics.Image
    {
        return this._2006102658postcard2;
    }

    public function set postcard2(value:com.flow.graphics.Image):void
    {
    	var oldValue:Object = this._2006102658postcard2;
        if (oldValue !== value)
        {
            this._2006102658postcard2 = value;
           if (this.hasEventListener("propertyChange"))
               this.dispatchEvent(mx.events.PropertyChangeEvent.createUpdateEvent(this, "postcard2", oldValue, value));
        }
    }



}
