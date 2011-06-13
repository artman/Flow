






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
public class _FlowExamplesWatcherSetupUtil
    implements mx.binding.IWatcherSetupUtil2
{
    public function _FlowExamplesWatcherSetupUtil()
    {
        super();
    }

    public static function init(fbs:IFlexModuleFactory):void
    {
        import FlowExamples;
        (FlowExamples).watcherSetupUtil = new _FlowExamplesWatcherSetupUtil();
    }

    public function setup(target:Object,
                          propertyGetter:Function,
                          staticPropertyGetter:Function,
                          bindings:Array,
                          watchers:Array):void
    {
        import com.flow.view.ScrollingView;
        import com.flow.components.Label;
        import mx.core.DeferredInstanceFromClass;
        import mx.utils.ObjectProxy;
        import __AS3__.vec.Vector;
        import flash.events.MouseEvent;
        import mx.binding.IBindingClient;
        import com.flow.containers.ScrollArea;
        import mx.core.ClassFactory;
        import mx.core.IFactory;
        import com.flow.view.TransitionsView;
        import mx.core.DeferredInstanceFromFunction;
        import flash.net.navigateToURL;
        import com.flow.view.BasicLayoutView;
        import flash.events.EventDispatcher;
        import com.flow.graphics.Image;
        import com.flow.skins.TextInputSkin;
        import com.flow.containers.Container;
        import com.flow.components.Button;
        import mx.core.IFlexModuleFactory;
        import mx.binding.BindingManager;
        import com.flow.commands.InitApplicationCommand;
        import com.flow.graphics.fills.BitmapFill;
        import mx.core.IDeferredInstance;
        import com.flow.view.BoxLayout;
        import FlowExamplesInnerClass0;
        import assets.WindowBkg;
        import mx.core.IPropertyChangeNotifier;
        import flash.filters.DropShadowFilter;
        import flash.events.IEventDispatcher;
        import com.flow.skins.ButtonSkin;
        import mx.core.mx_internal;
        import com.flow.containers.layout.HBoxLayout;
        import com.flow.view.ControlsView;
        import com.flow.containers.Application;
        import com.flow.managers.TextFormatManager;
        import flash.events.Event;
        import com.flow.containers.List;

        // writeWatcher id=3 shouldWriteSelf=true class=flex2.compiler.as3.binding.PropertyWatcher shouldWriteChildren=true
        watchers[3] = new mx.binding.PropertyWatcher("segmentTitles",
                                                                             {
                propertyChange: true
            }
,
                                                                         // writeWatcherListeners id=3 size=1
        [
        bindings[5]
        ]
,
                                                                 propertyGetter
);

        // writeWatcher id=0 shouldWriteSelf=true class=flex2.compiler.as3.binding.PropertyWatcher shouldWriteChildren=true
        watchers[0] = new mx.binding.PropertyWatcher("sectionCounter",
                                                                             {
                propertyChange: true
            }
,
                                                                         // writeWatcherListeners id=0 size=4
        [
        bindings[2],
        bindings[4],
        bindings[6],
        bindings[7]
        ]
,
                                                                 propertyGetter
);

        // writeWatcher id=2 shouldWriteSelf=true class=flex2.compiler.as3.binding.PropertyWatcher shouldWriteChildren=true
        watchers[2] = new mx.binding.PropertyWatcher("selectedIndex",
                                                                             {
                propertyChange: true
            }
,
                                                                         // writeWatcherListeners id=2 size=3
        [
        bindings[4],
        bindings[6],
        bindings[7]
        ]
,
                                                                 null
);

        // writeWatcher id=4 shouldWriteSelf=true class=flex2.compiler.as3.binding.PropertyWatcher shouldWriteChildren=true
        watchers[4] = new mx.binding.PropertyWatcher("dataProvider",
                                                                             {
                propertyChange: true
            }
,
                                                                         // writeWatcherListeners id=4 size=1
        [
        bindings[7]
        ]
,
                                                                 null
);

        // writeWatcher id=5 shouldWriteSelf=true class=flex2.compiler.as3.binding.PropertyWatcher shouldWriteChildren=true
        watchers[5] = new mx.binding.PropertyWatcher("length",
                                                                             null
,
                                                                         // writeWatcherListeners id=5 size=1
        [
        bindings[7]
        ]
,
                                                                 null
);

        // writeWatcher id=1 shouldWriteSelf=true class=flex2.compiler.as3.binding.PropertyWatcher shouldWriteChildren=true
        watchers[1] = new mx.binding.PropertyWatcher("selectedItem",
                                                                             {
                propertyChange: true
            }
,
                                                                         // writeWatcherListeners id=1 size=1
        [
        bindings[2]
        ]
,
                                                                 null
);


        // writeWatcherBottom id=3 shouldWriteSelf=true class=flex2.compiler.as3.binding.PropertyWatcher
        watchers[3].updateParent(target);

 





        // writeWatcherBottom id=0 shouldWriteSelf=true class=flex2.compiler.as3.binding.PropertyWatcher
        watchers[0].updateParent(target);

 





        // writeWatcherBottom id=2 shouldWriteSelf=true class=flex2.compiler.as3.binding.PropertyWatcher
        watchers[0].addChild(watchers[2]);

 





        // writeWatcherBottom id=4 shouldWriteSelf=true class=flex2.compiler.as3.binding.PropertyWatcher
        watchers[0].addChild(watchers[4]);

 





        // writeWatcherBottom id=5 shouldWriteSelf=true class=flex2.compiler.as3.binding.PropertyWatcher
        watchers[4].addChild(watchers[5]);

 





        // writeWatcherBottom id=1 shouldWriteSelf=true class=flex2.compiler.as3.binding.PropertyWatcher
        watchers[0].addChild(watchers[1]);

 





    }
}

}
