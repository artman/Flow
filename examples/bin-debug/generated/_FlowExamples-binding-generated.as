

import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.IEventDispatcher;
import mx.core.IPropertyChangeNotifier;
import mx.events.PropertyChangeEvent;
import mx.utils.ObjectProxy;
import mx.utils.UIDUtil;

import flash.profiler.*;
import com.flow.components.Button;
import flash.external.*;
import flash.display.*;
import flash.net.*;
import flash.debugger.*;
import flash.utils.*;
import flash.printing.*;
import flash.text.*;
import flash.geom.*;
import com.flow.containers.ScrollArea;
import flash.events.*;
import flash.accessibility.*;
import mx.binding.*;
import flash.ui.*;
import flash.media.*;
import flash.xml.*;
import mx.styles.*;
import mx.filters.*;
import flash.system.*;
import flash.errors.*;
import com.flow.containers.List;

class BindableProperty
{
	/*
	 * generated bindable wrapper for property next (public)
	 * - generated setter
	 * - generated getter
	 * - original public var 'next' moved to '_3377907next'
	 */

    [Bindable(event="propertyChange")]
    public function get next():com.flow.components.Button
    {
        return this._3377907next;
    }

    public function set next(value:com.flow.components.Button):void
    {
    	var oldValue:Object = this._3377907next;
        if (oldValue !== value)
        {
            this._3377907next = value;
           if (this.hasEventListener("propertyChange"))
               this.dispatchEvent(mx.events.PropertyChangeEvent.createUpdateEvent(this, "next", oldValue, value));
        }
    }

	/*
	 * generated bindable wrapper for property prev (public)
	 * - generated setter
	 * - generated getter
	 * - original public var 'prev' moved to '_3449395prev'
	 */

    [Bindable(event="propertyChange")]
    public function get prev():com.flow.components.Button
    {
        return this._3449395prev;
    }

    public function set prev(value:com.flow.components.Button):void
    {
    	var oldValue:Object = this._3449395prev;
        if (oldValue !== value)
        {
            this._3449395prev = value;
           if (this.hasEventListener("propertyChange"))
               this.dispatchEvent(mx.events.PropertyChangeEvent.createUpdateEvent(this, "prev", oldValue, value));
        }
    }

	/*
	 * generated bindable wrapper for property section (public)
	 * - generated setter
	 * - generated getter
	 * - original public var 'section' moved to '_1970241253section'
	 */

    [Bindable(event="propertyChange")]
    public function get section():com.flow.containers.ScrollArea
    {
        return this._1970241253section;
    }

    public function set section(value:com.flow.containers.ScrollArea):void
    {
    	var oldValue:Object = this._1970241253section;
        if (oldValue !== value)
        {
            this._1970241253section = value;
           if (this.hasEventListener("propertyChange"))
               this.dispatchEvent(mx.events.PropertyChangeEvent.createUpdateEvent(this, "section", oldValue, value));
        }
    }

	/*
	 * generated bindable wrapper for property sectionCounter (public)
	 * - generated setter
	 * - generated getter
	 * - original public var 'sectionCounter' moved to '_1132211369sectionCounter'
	 */

    [Bindable(event="propertyChange")]
    public function get sectionCounter():com.flow.containers.List
    {
        return this._1132211369sectionCounter;
    }

    public function set sectionCounter(value:com.flow.containers.List):void
    {
    	var oldValue:Object = this._1132211369sectionCounter;
        if (oldValue !== value)
        {
            this._1132211369sectionCounter = value;
           if (this.hasEventListener("propertyChange"))
               this.dispatchEvent(mx.events.PropertyChangeEvent.createUpdateEvent(this, "sectionCounter", oldValue, value));
        }
    }

	/*
	 * generated bindable wrapper for property segmentTitles (public)
	 * - generated setter
	 * - generated getter
	 * - original public var 'segmentTitles' moved to '_928759250segmentTitles'
	 */

    [Bindable(event="propertyChange")]
    public function get segmentTitles():Array
    {
        return this._928759250segmentTitles;
    }

    public function set segmentTitles(value:Array):void
    {
    	var oldValue:Object = this._928759250segmentTitles;
        if (oldValue !== value)
        {
            this._928759250segmentTitles = value;
           if (this.hasEventListener("propertyChange"))
               this.dispatchEvent(mx.events.PropertyChangeEvent.createUpdateEvent(this, "segmentTitles", oldValue, value));
        }
    }



}
