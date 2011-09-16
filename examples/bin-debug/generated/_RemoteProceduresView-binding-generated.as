

import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.IEventDispatcher;
import mx.core.IPropertyChangeNotifier;
import mx.events.PropertyChangeEvent;
import mx.utils.ObjectProxy;
import mx.utils.UIDUtil;

import com.flow.components.TextInput;
import com.flow.net.RemoteProcedureAMF;
import com.flow.net.AMFGateway;
import com.flow.net.RemoteProcedureHTTP;

class BindableProperty
{
	/*
	 * generated bindable wrapper for property gateway (public)
	 * - generated setter
	 * - generated getter
	 * - original public var 'gateway' moved to '_189118908gateway'
	 */

    [Bindable(event="propertyChange")]
    public function get gateway():com.flow.net.AMFGateway
    {
        return this._189118908gateway;
    }

    public function set gateway(value:com.flow.net.AMFGateway):void
    {
    	var oldValue:Object = this._189118908gateway;
        if (oldValue !== value)
        {
            this._189118908gateway = value;
           if (this.hasEventListener("propertyChange"))
               this.dispatchEvent(mx.events.PropertyChangeEvent.createUpdateEvent(this, "gateway", oldValue, value));
        }
    }

	/*
	 * generated bindable wrapper for property helloWorld (public)
	 * - generated setter
	 * - generated getter
	 * - original public var 'helloWorld' moved to '_1554135584helloWorld'
	 */

    [Bindable(event="propertyChange")]
    public function get helloWorld():com.flow.net.RemoteProcedureAMF
    {
        return this._1554135584helloWorld;
    }

    public function set helloWorld(value:com.flow.net.RemoteProcedureAMF):void
    {
    	var oldValue:Object = this._1554135584helloWorld;
        if (oldValue !== value)
        {
            this._1554135584helloWorld = value;
           if (this.hasEventListener("propertyChange"))
               this.dispatchEvent(mx.events.PropertyChangeEvent.createUpdateEvent(this, "helloWorld", oldValue, value));
        }
    }

	/*
	 * generated bindable wrapper for property httpRequest (public)
	 * - generated setter
	 * - generated getter
	 * - original public var 'httpRequest' moved to '_1950177511httpRequest'
	 */

    [Bindable(event="propertyChange")]
    public function get httpRequest():com.flow.net.RemoteProcedureHTTP
    {
        return this._1950177511httpRequest;
    }

    public function set httpRequest(value:com.flow.net.RemoteProcedureHTTP):void
    {
    	var oldValue:Object = this._1950177511httpRequest;
        if (oldValue !== value)
        {
            this._1950177511httpRequest = value;
           if (this.hasEventListener("propertyChange"))
               this.dispatchEvent(mx.events.PropertyChangeEvent.createUpdateEvent(this, "httpRequest", oldValue, value));
        }
    }

	/*
	 * generated bindable wrapper for property paramInput (public)
	 * - generated setter
	 * - generated getter
	 * - original public var 'paramInput' moved to '_432709437paramInput'
	 */

    [Bindable(event="propertyChange")]
    public function get paramInput():com.flow.components.TextInput
    {
        return this._432709437paramInput;
    }

    public function set paramInput(value:com.flow.components.TextInput):void
    {
    	var oldValue:Object = this._432709437paramInput;
        if (oldValue !== value)
        {
            this._432709437paramInput = value;
           if (this.hasEventListener("propertyChange"))
               this.dispatchEvent(mx.events.PropertyChangeEvent.createUpdateEvent(this, "paramInput", oldValue, value));
        }
    }

	/*
	 * generated bindable wrapper for property urlInput (public)
	 * - generated setter
	 * - generated getter
	 * - original public var 'urlInput' moved to '_990662757urlInput'
	 */

    [Bindable(event="propertyChange")]
    public function get urlInput():com.flow.components.TextInput
    {
        return this._990662757urlInput;
    }

    public function set urlInput(value:com.flow.components.TextInput):void
    {
    	var oldValue:Object = this._990662757urlInput;
        if (oldValue !== value)
        {
            this._990662757urlInput = value;
           if (this.hasEventListener("propertyChange"))
               this.dispatchEvent(mx.events.PropertyChangeEvent.createUpdateEvent(this, "urlInput", oldValue, value));
        }
    }



}
