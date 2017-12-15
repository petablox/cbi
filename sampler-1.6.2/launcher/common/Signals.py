def __fill_callbacks(handlers, kind, callbacks):
    members = kind.__dict__
    for name in members:
        if name.startswith('on_') and not name in callbacks:
            value = members[name]
            import types
            if type(value) == types.FunctionType:
                import new
                callbacks[name] = new.instancemethod(value, handlers, handlers.__class__)

    for base in kind.__bases__:
        __fill_callbacks(handlers, base, callbacks)


def autoconnect(handlers, xml):
    callbacks = {}
    __fill_callbacks(handlers, handlers.__class__, callbacks)
    xml.signal_autoconnect(callbacks)
