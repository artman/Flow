






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
public class _com_flow_view_RemoteProceduresViewWatcherSetupUtil
    implements mx.binding.IWatcherSetupUtil2
{
    public function _com_flow_view_RemoteProceduresViewWatcherSetupUtil()
    {
        super();
    }

    public static function init(fbs:IFlexModuleFactory):void
    {
        import com.flow.view.RemoteProceduresView;
        (com.flow.view.RemoteProceduresView).watcherSetupUtil = new _com_flow_view_RemoteProceduresViewWatcherSetupUtil();
    }

    public function setup(target:Object,
                          propertyGetter:Function,
                          staticPropertyGetter:Function,
                          bindings:Array,
                          watchers:Array):void
    {
        import mx.core.DeferredInstanceFromClass;
        import com.flow.components.Label;
        import __AS3__.vec.Vector;
        import mx.binding.IBindingClient;
        import flash.events.MouseEvent;
        import com.flow.net.AMFGateway;
        import com.flow.net.RemoteProcedureHTTP;
        import mx.core.ClassFactory;
        import mx.core.IFactory;
        import mx.core.DeferredInstanceFromFunction;
        import flash.events.EventDispatcher;
        import com.flow.net.RemoteProcedureAMF;
        import com.flow.skins.TextInputSkin;
        import com.flow.containers.Container;
        import com.flow.components.Button;
        import mx.core.IFlexModuleFactory;
        import mx.binding.BindingManager;
        import com.flow.containers.VBox;
        import mx.core.IDeferredInstance;
        import com.flow.components.Spacing;
        import mx.core.IPropertyChangeNotifier;
        import flash.events.IEventDispatcher;
        import com.flow.components.TextInput;
        import com.flow.skins.ButtonSkin;
        import mx.core.mx_internal;
        import com.flow.containers.HBox;
        import flash.events.Event;

        // writeWatcher id=0 shouldWriteSelf=true class=flex2.compiler.as3.binding.PropertyWatcher shouldWriteChildren=true
        watchers[0] = new mx.binding.PropertyWatcher("gateway",
                                                                             {
                propertyChange: true
            }
,
                                                                         // writeWatcherListeners id=0 size=1
        [
        bindings[0]
        ]
,
                                                                 propertyGetter
);

        // writeWatcher id=3 shouldWriteSelf=true class=flex2.compiler.as3.binding.PropertyWatcher shouldWriteChildren=true
        watchers[3] = new mx.binding.PropertyWatcher("urlInput",
                                                                             {
                propertyChange: true
            }
,
                                                                         // writeWatcherListeners id=3 size=1
        [
        bindings[2]
        ]
,
                                                                 propertyGetter
);

        // writeWatcher id=4 shouldWriteSelf=true class=flex2.compiler.as3.binding.PropertyWatcher shouldWriteChildren=true
        watchers[4] = new mx.binding.PropertyWatcher("value",
                                                                             {
                propertyChange: true
            }
,
                                                                         // writeWatcherListeners id=4 size=1
        [
        bindings[2]
        ]
,
                                                                 null
);

        // writeWatcher id=1 shouldWriteSelf=true class=flex2.compiler.as3.binding.PropertyWatcher shouldWriteChildren=true
        watchers[1] = new mx.binding.PropertyWatcher("paramInput",
                                                                             {
                propertyChange: true
            }
,
                                                                         // writeWatcherListeners id=1 size=1
        [
        bindings[1]
        ]
,
                                                                 propertyGetter
);

        // writeWatcher id=2 shouldWriteSelf=true class=flex2.compiler.as3.binding.PropertyWatcher shouldWriteChildren=true
        watchers[2] = new mx.binding.PropertyWatcher("value",
                                                                             {
                propertyChange: true
            }
,
                                                                         // writeWatcherListeners id=2 size=1
        [
        bindings[1]
        ]
,
                                                                 null
);

        // writeWatcher id=5 shouldWriteSelf=true class=flex2.compiler.as3.binding.PropertyWatcher shouldWriteChildren=true
        watchers[5] = new mx.binding.PropertyWatcher("helloWorld",
                                                                             {
                propertyChange: true
            }
,
                                                                         // writeWatcherListeners id=5 size=1
        [
        bindings[4]
        ]
,
                                                                 propertyGetter
);

        // writeWatcher id=6 shouldWriteSelf=true class=flex2.compiler.as3.binding.PropertyWatcher shouldWriteChildren=true
        watchers[6] = new mx.binding.PropertyWatcher("lastResult",
                                                                             {
                propertyChange: true
            }
,
                                                                         // writeWatcherListeners id=6 size=1
        [
        bindings[4]
        ]
,
                                                                 null
);

        // writeWatcher id=7 shouldWriteSelf=true class=flex2.compiler.as3.binding.PropertyWatcher shouldWriteChildren=true
        watchers[7] = new mx.binding.PropertyWatcher("httpRequest",
                                                                             {
                propertyChange: true
            }
,
                                                                         // writeWatcherListeners id=7 size=1
        [
        bindings[7]
        ]
,
                                                                 propertyGetter
);

        // writeWatcher id=8 shouldWriteSelf=true class=flex2.compiler.as3.binding.PropertyWatcher shouldWriteChildren=true
        watchers[8] = new mx.binding.PropertyWatcher("lastResult",
                                                                             {
                propertyChange: true
            }
,
                                                                         // writeWatcherListeners id=8 size=1
        [
        bindings[7]
        ]
,
                                                                 null
);

        // writeWatcher id=9 shouldWriteSelf=false class=flex2.compiler.as3.binding.FunctionReturnWatcher shouldWriteChildren=true


        // writeWatcherBottom id=0 shouldWriteSelf=true class=flex2.compiler.as3.binding.PropertyWatcher
        watchers[0].updateParent(target);

 





        // writeWatcherBottom id=3 shouldWriteSelf=true class=flex2.compiler.as3.binding.PropertyWatcher
        watchers[3].updateParent(target);

 





        // writeWatcherBottom id=4 shouldWriteSelf=true class=flex2.compiler.as3.binding.PropertyWatcher
        watchers[3].addChild(watchers[4]);

 





        // writeWatcherBottom id=1 shouldWriteSelf=true class=flex2.compiler.as3.binding.PropertyWatcher
        watchers[1].updateParent(target);

 





        // writeWatcherBottom id=2 shouldWriteSelf=true class=flex2.compiler.as3.binding.PropertyWatcher
        watchers[1].addChild(watchers[2]);

 





        // writeWatcherBottom id=5 shouldWriteSelf=true class=flex2.compiler.as3.binding.PropertyWatcher
        watchers[5].updateParent(target);

 





        // writeWatcherBottom id=6 shouldWriteSelf=true class=flex2.compiler.as3.binding.PropertyWatcher
        watchers[5].addChild(watchers[6]);

 





        // writeWatcherBottom id=7 shouldWriteSelf=true class=flex2.compiler.as3.binding.PropertyWatcher
        watchers[7].updateParent(target);

 





        // writeWatcherBottom id=8 shouldWriteSelf=true class=flex2.compiler.as3.binding.PropertyWatcher
        watchers[7].addChild(watchers[8]);

 





        // writeWatcherBottom id=9 shouldWriteSelf=false class=flex2.compiler.as3.binding.FunctionReturnWatcher

 





    }
}

}
