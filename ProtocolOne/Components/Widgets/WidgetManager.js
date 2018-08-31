.pragma library

/**
 * Class Widget
 *
 * Represent Widget instance
 */
function Widget(namespace, pluginContainer){
    this.namespace = namespace;
    this.pluginContainer = pluginContainer;

    this.model = null;
    this.modelReference = null;

    this.getNamespace = function() {
        return this.namespace;
    }

    this.getModelName = function() {
        return this.pluginContainer.model;
    }

    this.useModel = function() {
        return this.pluginContainer.model !== '';
    }

    this.hasModelInstance = function() {
        return this.model !== null;
    }

    this.useSingletonModel = function() {
        return this.pluginContainer.singletonModel === true;
    }

    this.getName = function() {
        return this.pluginContainer.name;
    }

    this.getVersion = function() {
        return this.pluginContainer.version;
    }

    this.getSettings = function() {
        if (!this.hasModelInstance()) {
            throw new Error('Widget model `' + this.getName() + '` not exists');
        }

        return this.model.settings;
    }

    this.getView = function(name) {
        var views;

        if (typeof this.pluginContainer.view === 'string') {
            return this.pluginContainer.view;
        }

        if (!this.pluginContainer.view instanceof Array) {
            throw new Error('PluginContainer `' + this.getName() +'` has unknown view format');
        }

        views = this.pluginContainer.view.filter(function(view) {
            if (name) {
                return view.name === name;
            }

            return view.hasOwnProperty('byDefault')
                && view.byDefault;
        });

        if (views.length === 0) {
            throw new Error('PluginContainer  `' + this.getName() +'` view `' + name + '` not exists');
        }

        return views.shift().source;
    }
}

/**
 * Class WidgetManager
 *
 * Widget component core. Keep attention about widgets life circle.
 */
function WidgetManager() {
    var _widgets = {}
        , _initialized = false
        , _modelsByReference = {}
        , _parentComp = Qt.createComponent('WidgetManagerPrivate.qml')
        , _private = _parentComp.createObject(null)
        , _globalParent = null;

    /**
     * Should be called once to confirm all widgets registration. All WidgetContainer wait`s for this moment to
     * update they views.
     */
    this.initialize = function(parent) {
        _globalParent = parent;

        this.forceModelCreation();
        _initialized = true;
        _private.widgetsReady();
    }

    this.forceModelCreation = function() {
        var widget
            , namespace;

        for (namespace in _widgets) {
            widget = _widgets[namespace];

            if (widget.useSingletonModel()) {
                widget.model = createObject(widget.getNamespace(), widget.getModelName());
                widget.modelReference = getTempId('id_persist');

                this.addModelReference(widget.modelReference, widget.model);
            }
        }
    }

    /**
     * Return true if WidgetManager initialized.
     */
    this.isReady = function() {
        return _initialized;
    }

    /**
     * Return current instanse of WidgetManagerPrivate.qml
     */
    this.getPrivateWrapper = function() {
        return _private;
    }

    /**
     * Register widget with given namespace.
     *
     * Look at test folder for more examples and documentation.
     */
    this.registerWidget = function(namespace) {
        var pluginContainer = createObject(namespace, 'PluginContainer')
            , widget = new Widget(namespace, pluginContainer);

        _widgets[namespace] = widget;

        log('Widget `' + widget.getName() + ' ' + widget.getVersion() + '` registered');
        return widget;
    }

    this.createView = function(widgetName, parentObj) {
        return this.createNamedView(widgetName, null, parentObj)
    }

    this.addModelReference = function(modelReference, model) {
        _modelsByReference[modelReference] = model;
    }

    this.createNamedView = function(widgetName, viewName, parentObj) {
        var widget = this.getWidgetByName(widgetName)
            , namespace = widget.getNamespace()
            , view = widget.getView(viewName)
            , viewNamespace = namespace + '.View'
            , modelReference
            , modelName = widget.getModelName()
            , model;

        if (!widget.useModel()) {
            return createObject(viewNamespace, view, parentObj);
        }

        if (!widget.useSingletonModel()) {
            model = createObject(namespace, modelName);
            modelReference = getTempId('id');
            this.addModelReference(modelReference, model);

            return createViewObject(viewNamespace, view, modelReference, parentObj);
        }

        if (!widget.hasModelInstance()) {
            throw new Error('Error: Widget `' + widget.getName() + '` has empty model instance');
        }

        return createViewObject(viewNamespace, view, widget.modelReference, parentObj);
    }

    this.getModelByReference = function(reference) {
        var model = _modelsByReference[reference];
        if (reference.indexOf('id_persist') === -1) {
            delete _modelsByReference[reference];
        }

        return model;
    }

    this.hasWidgetByName = function(namePart) {
        for (var widgetName in _widgets) {
            if (widgetName.indexOf(namePart) !== -1) {
                return true;
            }
        }

        return false;
    }

    this.getWidgetByName = function(namePart) {
        for (var widgetName in _widgets) {
            if (widgetName.indexOf(namePart) !== -1) {
                return _widgets[widgetName];
            }
        }

        throw new Error('Error: Widget with name part `' + namePart + '` not registered');
    };

    this.getSettings = function(namePart) {
        return this.getWidgetByName(namePart).getSettings();
    }

    function getTempId(prefix) {
        return prefix
            + '_'
            + (+new Date())
            + '_'
            + Math.random();
    }

    function getObjectPath(namespace, object) {
        return "../../../" + namespace.replace(/\./g, '/') + "/" + object + ".qml";
    }

    function createObject(namespace, object, parentObj) {
        var comp = Qt.createComponent(getObjectPath(namespace, object));
        if (comp.status !== 1) {
            throw new Error(comp.errorString());
        }

        return comp.createObject(parentObj || _globalParent || _private);
    }

    function createViewObject(namespace, object, modelReference, parentObj) {
        var comp = Qt.createComponent(getObjectPath(namespace, object));
        if (comp.status !== 1) {
            throw new Error(comp.errorString());
        }

        return comp.createObject(parentObj || _globalParent || _private,
                                 {
                                     model: _internal.getModelByReference(modelReference),
                                     __modelReference: modelReference
                                 });
    }
}

var _internal = new WidgetManager()
    , debug = true;

/**
 * Exported functions
 */
function log() {
    if (debug) {
        console.log.apply(null, arguments);
    }
}

function registerWidget(name) {
    return _internal.registerWidget(name);
}

function createView(widgetName, parentObj) {
    return _internal.createView(widgetName, parentObj);
}

function createNamedView(widgetName, viewName, parentObj) {
    return _internal.createNamedView(widgetName, viewName, parentObj);
}

function init(parent) {
    _internal.initialize(parent);
}

function isReady() {
    return _internal.isReady();
}

function getWidgetByName(name) {
    return _internal.getWidgetByName(name);
}

function getWidgetSettings(name) {
    return _internal.getSettings(name);
}

function hasWidgetByName(name) {
    return _internal.hasWidgetByName(name);
}
