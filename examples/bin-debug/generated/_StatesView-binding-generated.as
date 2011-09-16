

import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.IEventDispatcher;
import mx.core.IPropertyChangeNotifier;
import mx.events.PropertyChangeEvent;
import mx.utils.ObjectProxy;
import mx.utils.UIDUtil;

import com.flow.components.Button;

class BindableProperty
{
	/*
	 * generated bindable wrapper for property _StatesView_Button1 (public)
	 * - generated setter
	 * - generated getter
	 * - original public var '_StatesView_Button1' moved to '_33819290_StatesView_Button1'
	 */

    [Bindable(event="propertyChange")]
    public function get _StatesView_Button1():com.flow.components.Button
    {
        return this._33819290_StatesView_Button1;
    }

    public function set _StatesView_Button1(value:com.flow.components.Button):void
    {
    	var oldValue:Object = this._33819290_StatesView_Button1;
        if (oldValue !== value)
        {
            this._33819290_StatesView_Button1 = value;
           if (this.hasEventListener("propertyChange"))
               this.dispatchEvent(mx.events.PropertyChangeEvent.createUpdateEvent(this, "_StatesView_Button1", oldValue, value));
        }
    }



}
