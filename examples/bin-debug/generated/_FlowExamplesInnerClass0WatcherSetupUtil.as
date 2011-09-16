






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
public class _FlowExamplesInnerClass0WatcherSetupUtil
    implements mx.binding.IWatcherSetupUtil2
{
    public function _FlowExamplesInnerClass0WatcherSetupUtil()
    {
        super();
    }

    public static function init(fbs:IFlexModuleFactory):void
    {
        import FlowExamplesInnerClass0;
        (FlowExamplesInnerClass0).watcherSetupUtil = new _FlowExamplesInnerClass0WatcherSetupUtil();
    }

    public function setup(target:Object,
                          propertyGetter:Function,
                          staticPropertyGetter:Function,
                          bindings:Array,
                          watchers:Array):void
    {
        import mx.core.IFlexModuleFactory;
        import com.flow.graphics.fills.GradientFill;
        import mx.binding.BindingManager;
        import com.flow.components.Label;
        import mx.core.DeferredInstanceFromClass;
        import __AS3__.vec.Vector;
        import mx.core.IDeferredInstance;
        import mx.binding.IBindingClient;
        import com.flow.graphics.strokes.SolidStroke;
        import FlowExamples;
        import mx.core.IPropertyChangeNotifier;
        import flash.events.IEventDispatcher;
        import mx.core.IStateClient2;
        import mx.core.ClassFactory;
        import mx.core.IFactory;
        import mx.states.SetProperty;
        import mx.core.mx_internal;
        import mx.core.DeferredInstanceFromFunction;
        import flash.events.EventDispatcher;
        import mx.states.State;
        import flash.events.Event;
        import com.flow.graphics.GradientData;

        // writeWatcher id=0 shouldWriteSelf=true class=flex2.compiler.as3.binding.PropertyWatcher shouldWriteChildren=true
        watchers[0] = new mx.binding.PropertyWatcher("rendererIndex",
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


        // writeWatcherBottom id=0 shouldWriteSelf=true class=flex2.compiler.as3.binding.PropertyWatcher
        watchers[0].updateParent(target);

 





    }
}

}
