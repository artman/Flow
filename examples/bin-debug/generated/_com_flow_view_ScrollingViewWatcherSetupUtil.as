






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
public class _com_flow_view_ScrollingViewWatcherSetupUtil
    implements mx.binding.IWatcherSetupUtil2
{
    public function _com_flow_view_ScrollingViewWatcherSetupUtil()
    {
        super();
    }

    public static function init(fbs:IFlexModuleFactory):void
    {
        import com.flow.view.ScrollingView;
        (com.flow.view.ScrollingView).watcherSetupUtil = new _com_flow_view_ScrollingViewWatcherSetupUtil();
    }

    public function setup(target:Object,
                          propertyGetter:Function,
                          staticPropertyGetter:Function,
                          bindings:Array,
                          watchers:Array):void
    {
        import com.flow.components.VScrollBar;
        import com.flow.containers.Container;
        import mx.core.IFlexModuleFactory;
        import mx.core.DeferredInstanceFromClass;
        import com.flow.skins.HScrollBarSkin;
        import __AS3__.vec.Vector;
        import mx.core.IDeferredInstance;
        import mx.binding.IBindingClient;
        import com.flow.components.HScrollBar;
        import mx.core.IPropertyChangeNotifier;
        import mx.core.ClassFactory;
        import mx.core.IFactory;
        import mx.core.mx_internal;
        import mx.core.DeferredInstanceFromFunction;
        import com.flow.skins.VScrollBarSkin;
        import com.flow.containers.HBox;
        import com.flow.skins.TextInputSkin;


    }
}

}
