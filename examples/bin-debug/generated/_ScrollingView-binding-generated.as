

import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.IEventDispatcher;
import mx.core.IPropertyChangeNotifier;
import mx.events.PropertyChangeEvent;
import mx.utils.ObjectProxy;
import mx.utils.UIDUtil;

import com.flow.containers.Scroller;

class BindableProperty
{
	/*
	 * generated bindable wrapper for property scroller (public)
	 * - generated setter
	 * - generated getter
	 * - original public var 'scroller' moved to '_402164678scroller'
	 */

    [Bindable(event="propertyChange")]
    public function get scroller():com.flow.containers.Scroller
    {
        return this._402164678scroller;
    }

    public function set scroller(value:com.flow.containers.Scroller):void
    {
    	var oldValue:Object = this._402164678scroller;
        if (oldValue !== value)
        {
            this._402164678scroller = value;
           if (this.hasEventListener("propertyChange"))
               this.dispatchEvent(mx.events.PropertyChangeEvent.createUpdateEvent(this, "scroller", oldValue, value));
        }
    }



}
