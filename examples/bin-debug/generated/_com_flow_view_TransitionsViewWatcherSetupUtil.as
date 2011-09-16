






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
public class _com_flow_view_TransitionsViewWatcherSetupUtil
    implements mx.binding.IWatcherSetupUtil2
{
    public function _com_flow_view_TransitionsViewWatcherSetupUtil()
    {
        super();
    }

    public static function init(fbs:IFlexModuleFactory):void
    {
        import com.flow.view.TransitionsView;
        (com.flow.view.TransitionsView).watcherSetupUtil = new _com_flow_view_TransitionsViewWatcherSetupUtil();
    }

    public function setup(target:Object,
                          propertyGetter:Function,
                          staticPropertyGetter:Function,
                          bindings:Array,
                          watchers:Array):void
    {
        import mx.core.DeferredInstanceFromClass;
        import com.flow.components.Label;
        import com.flow.effects.transitions.EffectTransition;
        import __AS3__.vec.Vector;
        import mx.binding.IBindingClient;
        import flash.events.MouseEvent;
        import mx.core.ClassFactory;
        import com.flow.skins.CheckboxSkin;
        import mx.core.IFactory;
        import mx.core.DeferredInstanceFromFunction;
        import flash.events.EventDispatcher;
        import com.flow.graphics.Image;
        import com.flow.skins.TextInputSkin;
        import com.flow.containers.Container;
        import com.flow.components.Button;
        import mx.core.IFlexModuleFactory;
        import mx.binding.BindingManager;
        import com.flow.effects.BlurEffect;
        import com.flow.containers.VBox;
        import com.flow.containers.layout.VBoxLayout;
        import com.flow.effects.ChihulyEffect;
        import mx.core.IDeferredInstance;
        import mx.core.IPropertyChangeNotifier;
        import flash.events.IEventDispatcher;
        import com.flow.skins.ButtonSkin;
        import com.flow.effects.BevelEffect;
        import mx.core.mx_internal;
        import assets.Postcard;
        import com.flow.containers.HBox;
        import flash.events.Event;


    }
}

}
