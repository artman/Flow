






package
{
import mx.core.IFlexModuleFactory;
import mx.binding.ArrayElementWatcher;
import mx.binding.FunctionReturnWatcher;
import mx.binding.IWatcherSetupUtil2;
import mx.binding.PropertyWatcher;
import mx.binding.RepeaterComponentWatcher;
import mx.binding.RepeaterItemWatcher;
import mx.binding.StaticPropertyWatcher;
import mx.binding.XMLWatcher;
import mx.binding.Watcher;

[ExcludeClass]
public class _com_flow_view_ControlsViewWatcherSetupUtil
    implements mx.binding.IWatcherSetupUtil2
{
    public function _com_flow_view_ControlsViewWatcherSetupUtil()
    {
        super();
    }

    public static function init(fbs:IFlexModuleFactory):void
    {
        import com.flow.view.ControlsView;
        (com.flow.view.ControlsView).watcherSetupUtil = new _com_flow_view_ControlsViewWatcherSetupUtil();
    }

    public function setup(target:Object,
                          propertyGetter:Function,
                          staticPropertyGetter:Function,
                          bindings:Array,
                          watchers:Array):void
    {
        import com.flow.graphics.fills.GradientFill;
        import mx.core.DeferredInstanceFromClass;
        import com.flow.components.Label;
        import __AS3__.vec.Vector;
        import mx.binding.IBindingClient;
        import com.flow.graphics.strokes.SolidStroke;
        import mx.core.ClassFactory;
        import com.flow.skins.CheckboxSkin;
        import mx.core.IFactory;
        import mx.core.DeferredInstanceFromFunction;
        import flash.events.EventDispatcher;
        import com.flow.skins.TextInputSkin;
        import com.flow.containers.Container;
        import com.flow.components.Button;
        import mx.core.IFlexModuleFactory;
        import mx.binding.BindingManager;
        import com.flow.components.Checkbox;
        import com.flow.containers.layout.VBoxLayout;
        import mx.core.IDeferredInstance;
        import com.flow.components.HScrollBar;
        import mx.core.IPropertyChangeNotifier;
        import flash.events.IEventDispatcher;
        import com.flow.components.TextInput;
        import com.flow.skins.ButtonSkin;
        import mx.core.mx_internal;
        import com.flow.containers.HBox;
        import flash.events.Event;
        import com.flow.graphics.GradientData;

        // writeWatcher id=5 shouldWriteSelf=true class=flex2.compiler.as3.binding.PropertyWatcher shouldWriteChildren=true
        watchers[5] = new mx.binding.PropertyWatcher("scroller",
                                                                             {
                propertyChange: true
            }
,
                                                                         // writeWatcherListeners id=5 size=1
        [
        bindings[5]
        ]
,
                                                                 propertyGetter
);

        // writeWatcher id=6 shouldWriteSelf=true class=flex2.compiler.as3.binding.PropertyWatcher shouldWriteChildren=true
        watchers[6] = new mx.binding.PropertyWatcher("value",
                                                                             {
                propertyChange: true
            }
,
                                                                         // writeWatcherListeners id=6 size=1
        [
        bindings[5]
        ]
,
                                                                 null
);

        // writeWatcher id=4 shouldWriteSelf=false class=flex2.compiler.as3.binding.FunctionReturnWatcher shouldWriteChildren=true

        // writeWatcher id=2 shouldWriteSelf=true class=flex2.compiler.as3.binding.PropertyWatcher shouldWriteChildren=true
        watchers[2] = new mx.binding.PropertyWatcher("textInput",
                                                                             {
                propertyChange: true
            }
,
                                                                         // writeWatcherListeners id=2 size=1
        [
        bindings[4]
        ]
,
                                                                 propertyGetter
);

        // writeWatcher id=3 shouldWriteSelf=true class=flex2.compiler.as3.binding.PropertyWatcher shouldWriteChildren=true
        watchers[3] = new mx.binding.PropertyWatcher("value",
                                                                             {
                propertyChange: true
            }
,
                                                                         // writeWatcherListeners id=3 size=1
        [
        bindings[4]
        ]
,
                                                                 null
);

        // writeWatcher id=0 shouldWriteSelf=true class=flex2.compiler.as3.binding.PropertyWatcher shouldWriteChildren=true
        watchers[0] = new mx.binding.PropertyWatcher("checkbox",
                                                                             {
                propertyChange: true
            }
,
                                                                         // writeWatcherListeners id=0 size=1
        [
        bindings[1]
        ]
,
                                                                 propertyGetter
);

        // writeWatcher id=1 shouldWriteSelf=true class=flex2.compiler.as3.binding.PropertyWatcher shouldWriteChildren=true
        watchers[1] = new mx.binding.PropertyWatcher("selected",
                                                                             {
                propertyChange: true
            }
,
                                                                         // writeWatcherListeners id=1 size=1
        [
        bindings[1]
        ]
,
                                                                 null
);


        // writeWatcherBottom id=5 shouldWriteSelf=true class=flex2.compiler.as3.binding.PropertyWatcher
        watchers[5].updateParent(target);

 





        // writeWatcherBottom id=6 shouldWriteSelf=true class=flex2.compiler.as3.binding.PropertyWatcher
        watchers[5].addChild(watchers[6]);

 





        // writeWatcherBottom id=4 shouldWriteSelf=false class=flex2.compiler.as3.binding.FunctionReturnWatcher

 





        // writeWatcherBottom id=2 shouldWriteSelf=true class=flex2.compiler.as3.binding.PropertyWatcher
        watchers[2].updateParent(target);

 





        // writeWatcherBottom id=3 shouldWriteSelf=true class=flex2.compiler.as3.binding.PropertyWatcher
        watchers[2].addChild(watchers[3]);

 





        // writeWatcherBottom id=0 shouldWriteSelf=true class=flex2.compiler.as3.binding.PropertyWatcher
        watchers[0].updateParent(target);

 





        // writeWatcherBottom id=1 shouldWriteSelf=true class=flex2.compiler.as3.binding.PropertyWatcher
        watchers[0].addChild(watchers[1]);

 





    }
}

}
