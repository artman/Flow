






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
public class _com_flow_view_BasicLayoutViewWatcherSetupUtil
    implements mx.binding.IWatcherSetupUtil2
{
    public function _com_flow_view_BasicLayoutViewWatcherSetupUtil()
    {
        super();
    }

    public static function init(fbs:IFlexModuleFactory):void
    {
        import com.flow.view.BasicLayoutView;
        (com.flow.view.BasicLayoutView).watcherSetupUtil = new _com_flow_view_BasicLayoutViewWatcherSetupUtil();
    }

    public function setup(target:Object,
                          propertyGetter:Function,
                          staticPropertyGetter:Function,
                          bindings:Array,
                          watchers:Array):void
    {
        import com.flow.containers.Container;
        import mx.core.IFlexModuleFactory;
        import com.flow.graphics.fills.GradientFill;
        import mx.binding.BindingManager;
        import com.flow.components.Label;
        import com.flow.graphics.fills.IFill;
        import mx.core.DeferredInstanceFromClass;
        import com.flow.graphics.fills.SolidFill;
        import __AS3__.vec.Vector;
        import mx.core.IDeferredInstance;
        import mx.binding.IBindingClient;
        import com.flow.graphics.strokes.SolidStroke;
        import mx.core.IPropertyChangeNotifier;
        import flash.events.IEventDispatcher;
        import mx.core.ClassFactory;
        import mx.core.IFactory;
        import mx.core.mx_internal;
        import mx.core.DeferredInstanceFromFunction;
        import flash.events.EventDispatcher;
        import flash.events.Event;
        import com.flow.graphics.GradientData;
        import com.flow.graphics.strokes.IStroke;

        // writeWatcher id=0 shouldWriteSelf=true class=flex2.compiler.as3.binding.PropertyWatcher shouldWriteChildren=true
        watchers[0] = new mx.binding.PropertyWatcher("itemFill",
                                                                             {
                propertyChange: true
            }
,
                                                                         // writeWatcherListeners id=0 size=10
        [
        bindings[0],
        bindings[2],
        bindings[4],
        bindings[6],
        bindings[8],
        bindings[10],
        bindings[12],
        bindings[14],
        bindings[16],
        bindings[18]
        ]
,
                                                                 propertyGetter
);

        // writeWatcher id=1 shouldWriteSelf=true class=flex2.compiler.as3.binding.PropertyWatcher shouldWriteChildren=true
        watchers[1] = new mx.binding.PropertyWatcher("itemStroke",
                                                                             {
                propertyChange: true
            }
,
                                                                         // writeWatcherListeners id=1 size=10
        [
        bindings[1],
        bindings[3],
        bindings[5],
        bindings[7],
        bindings[9],
        bindings[11],
        bindings[13],
        bindings[15],
        bindings[17],
        bindings[19]
        ]
,
                                                                 propertyGetter
);


        // writeWatcherBottom id=0 shouldWriteSelf=true class=flex2.compiler.as3.binding.PropertyWatcher
        watchers[0].updateParent(target);

 





        // writeWatcherBottom id=1 shouldWriteSelf=true class=flex2.compiler.as3.binding.PropertyWatcher
        watchers[1].updateParent(target);

 





    }
}

}
