package java.awt;

import java.io.PrintStream;

import java.io.PrintWriter;

import java.util.Vector;

import java.util.Locale;

import java.util.EventListener;

import java.util.Iterator;

import java.util.HashSet;

import java.util.Map;

import java.util.Set;

import java.util.Collections;

import java.awt.peer.ComponentPeer;

import java.awt.peer.ContainerPeer;

import java.awt.peer.LightweightPeer;

import java.awt.image.BufferStrategy;

import java.awt.image.ImageObserver;

import java.awt.image.ImageProducer;

import java.awt.image.ColorModel;

import java.awt.image.VolatileImage;

import java.awt.event.*;

import java.io.Serializable;

import java.io.ObjectOutputStream;

import java.io.ObjectInputStream;

import java.io.IOException;

import java.beans.PropertyChangeListener;

import java.beans.PropertyChangeSupport;

import java.awt.event.InputMethodListener;

import java.awt.event.InputMethodEvent;

import java.awt.im.InputContext;

import java.awt.im.InputMethodRequests;

import java.awt.dnd.DropTarget;

import java.lang.reflect.InvocationTargetException;

import java.lang.reflect.Method;

import java.security.AccessController;

import java.security.PrivilegedAction;

import javax.accessibility.*;

import java.util.logging.*;

import java.applet.Applet;

import sun.security.action.GetPropertyAction;

import sun.awt.AppContext;

import sun.awt.ConstrainableGraphics;

import sun.awt.DebugHelper;

import sun.awt.SubRegionShowable;

import sun.awt.WindowClosingListener;

import sun.awt.CausedFocusEvent;

import sun.awt.EmbeddedFrame;

import sun.awt.dnd.SunDropTargetEvent;

import sun.awt.im.CompositionArea;

import sun.java2d.SunGraphics2D;

import sun.awt.RequestFocusController;

public abstract class Component implements ImageObserver, MenuContainer, Serializable {
    private static final Logger focusLog = Logger.getLogger ("java.awt.focus.Component");
    private static final Logger log = Logger.getLogger ("java.awt.Component");
    transient ComponentPeer peer;
    transient Container parent;
    transient AppContext appContext;
    int x;
    int y;
    int width;
    int height;
    Color foreground;
    Color background;
    Font font;
    Font peerFont;
    Cursor cursor;
    Locale locale;
    transient GraphicsConfiguration graphicsConfig = null;
    transient BufferStrategy bufferStrategy = null;
    boolean ignoreRepaint = false;
    boolean visible = true;
    boolean enabled = true;
    volatile boolean valid = false;
    DropTarget dropTarget;
    Vector popups;
    private String name;
    private boolean nameExplicitlySet = false;
    private boolean focusable = true;
    private static final int FOCUS_TRAVERSABLE_UNKNOWN = 0;
    private static final int FOCUS_TRAVERSABLE_DEFAULT = 1;
    private static final int FOCUS_TRAVERSABLE_SET = 2;
    private int isFocusTraversableOverridden = FOCUS_TRAVERSABLE_UNKNOWN;
    Set [] focusTraversalKeys;
    private static final String [] focusTraversalKeyPropertyNames = {"forwardFocusTraversalKeys", "backwardFocusTraversalKeys",
      "upCycleFocusTraversalKeys", "downCycleFocusTraversalKeys"};
    private boolean focusTraversalKeysEnabled = true;
    static final Object LOCK = new AWTTreeLock ();
    static class AWTTreeLock {
    }

    Dimension minSize;
    boolean minSizeSet;
    Dimension prefSize;
    boolean prefSizeSet;
    Dimension maxSize;
    boolean maxSizeSet;
    transient ComponentOrientation componentOrientation = ComponentOrientation.UNKNOWN;
    boolean newEventsOnly = false;
    transient ComponentListener componentListener;
    transient FocusListener focusListener;
    transient HierarchyListener hierarchyListener;
    transient HierarchyBoundsListener hierarchyBoundsListener;
    transient KeyListener keyListener;
    transient MouseListener mouseListener;
    transient MouseMotionListener mouseMotionListener;
    transient MouseWheelListener mouseWheelListener;
    transient InputMethodListener inputMethodListener;
    transient RuntimeException windowClosingException = null;
    final static String actionListenerK = "actionL";
    final static String adjustmentListenerK = "adjustmentL";
    final static String componentListenerK = "componentL";
    final static String containerListenerK = "containerL";
    final static String focusListenerK = "focusL";
    final static String itemListenerK = "itemL";
    final static String keyListenerK = "keyL";
    final static String mouseListenerK = "mouseL";
    final static String mouseMotionListenerK = "mouseMotionL";
    final static String mouseWheelListenerK = "mouseWheelL";
    final static String textListenerK = "textL";
    final static String ownedWindowK = "ownedL";
    final static String windowListenerK = "windowL";
    final static String inputMethodListenerK = "inputMethodL";
    final static String hierarchyListenerK = "hierarchyL";
    final static String hierarchyBoundsListenerK = "hierarchyBoundsL";
    final static String windowStateListenerK = "windowStateL";
    final static String windowFocusListenerK = "windowFocusL";
    long eventMask = AWTEvent.INPUT_METHODS_ENABLED_MASK;
    private static final DebugHelper dbg = DebugHelper.create (Component.class);
    static boolean isInc;
    static int incRate;

    static {
        Toolkit.loadLibraries (); if (! GraphicsEnvironment.isHeadless ()) {
            initIDs ();}
        String s = (String) java.security.AccessController.doPrivileged (new GetPropertyAction ("awt.image.incrementaldraw"));
        isInc = (s == null || s.equals ("true")); s = (String) java.security.AccessController.doPrivileged (new
          GetPropertyAction ("awt.image.redrawrate")); incRate = (s != null) ? Integer.parseInt (s) : 100;}

    public static final float TOP_ALIGNMENT = 0.0f;
    public static final float CENTER_ALIGNMENT = 0.5f;
    public static final float BOTTOM_ALIGNMENT = 1.0f;
    public static final float LEFT_ALIGNMENT = 0.0f;
    public static final float RIGHT_ALIGNMENT = 1.0f;
    private static final long serialVersionUID = - 7644114512714619750L;
    private PropertyChangeSupport changeSupport;
    boolean isPacked = false;
    private int boundsOp = ComponentPeer.DEFAULT_OPERATION;
    public enum BaselineResizeBehavior {
        CONSTANT_ASCENT,
        CONSTANT_DESCENT,
        CENTER_OFFSET,
        OTHER}

    int getBoundsOp () {
        assert Thread.holdsLock (getTreeLock ());
        return boundsOp;
    }

    void setBoundsOp (int op) {
        assert Thread.holdsLock (getTreeLock ());
        if (op == ComponentPeer.RESET_OPERATION) {
            boundsOp = ComponentPeer.DEFAULT_OPERATION;} else if (boundsOp == ComponentPeer.DEFAULT_OPERATION) {
            boundsOp = op;}

    }

    protected Component () {
        appContext = AppContext.getAppContext ();}

    void initializeFocusTraversalKeys () {
        focusTraversalKeys = new Set [3];}

    String constructComponentName () {
        return null;
    }

    public String getName () {
        if (name == null && ! nameExplicitlySet) {
            synchronized (this) {
                if (name == null && ! nameExplicitlySet) name = constructComponentName ();
            }
        }
        return name;
    }

    public void setName (String name) {
        String oldName;
        synchronized (this) {
            oldName = this.name; this.name = name; nameExplicitlySet = true;}
        firePropertyChange ("name", oldName, name);}

    public Container getParent () {
        return getParent_NoClientCode ();
    }

    final Container getParent_NoClientCode () {
        return parent;
    }

    @Deprecated
    public ComponentPeer getPeer () {
        return peer;
    }

    public synchronized void setDropTarget (DropTarget dt) {
        if (dt == dropTarget || (dropTarget != null && dropTarget.equals (dt))) return;

        DropTarget old;
        if ((old = dropTarget) != null) {
            if (peer != null) dropTarget.removeNotify (peer);
            DropTarget t = dropTarget;
            dropTarget = null; try {
                t.setComponent (null);} catch (IllegalArgumentException iae) {
            }
        }
        if ((dropTarget = dt) != null) {
            try {
                dropTarget.setComponent (this); if (peer != null) dropTarget.addNotify (peer);
            } catch (IllegalArgumentException iae) {
                if (old != null) {
                    try {
                        old.setComponent (this); if (peer != null) dropTarget.addNotify (peer);
                    } catch (IllegalArgumentException iae1) {
                    }
                }
            }
        }
    }

    public synchronized DropTarget getDropTarget () {
        return dropTarget;
    }

    public GraphicsConfiguration getGraphicsConfiguration () {
        synchronized (getTreeLock ()) {
            GraphicsConfiguration gc = graphicsConfig;
            Component parent = getParent ();
            while ((gc == null) && (parent != null)) {
                gc = parent.getGraphicsConfiguration (); parent = parent.getParent ();} return gc;
        }
    }

    final GraphicsConfiguration getGraphicsConfiguration_NoClientCode () {
        GraphicsConfiguration gc = this.graphicsConfig;
        Component par = this.parent;
        while ((gc == null) && (par != null)) {
            gc = par.getGraphicsConfiguration_NoClientCode (); par = par.parent;} return gc;
    }

    void resetGC () {
        synchronized (getTreeLock ()) {
            graphicsConfig = null;}
    }

    void setGCFromPeer () {
        synchronized (getTreeLock ()) {
            if (peer != null) {
                graphicsConfig = peer.getGraphicsConfiguration ();} else {
                graphicsConfig = null;}
        }
    }

    void checkGD (String stringID) {
        if (graphicsConfig != null) {
            if (! graphicsConfig.getDevice ().getIDstring ().equals (stringID)) {
                throw new IllegalArgumentException ("adding a container to a container on a different GraphicsDevice");
            }
        }
    }

    public final Object getTreeLock () {
        return LOCK;
    }

    public Toolkit getToolkit () {
        return getToolkitImpl ();
    }

    final Toolkit getToolkitImpl () {
        ComponentPeer peer = this.peer;
        if ((peer != null) && ! (peer instanceof LightweightPeer)) {
            return peer.getToolkit ();
        }
        Container parent = this.parent;
        if (parent != null) {
            return parent.getToolkitImpl ();
        }
        return Toolkit.getDefaultToolkit ();
    }

    public boolean isValid () {
        return (peer != null) && valid;
    }

    public boolean isDisplayable () {
        return getPeer () != null;
    }

    public boolean isVisible () {
        return isVisible_NoClientCode ();
    }

    final boolean isVisible_NoClientCode () {
        return visible;
    }

    boolean isRecursivelyVisible () {
        return visible && (parent == null || parent.isRecursivelyVisible ());
    }

    Point pointRelativeToComponent (Point absolute) {
        Point compCoords = getLocationOnScreen ();
        return new Point (absolute.x - compCoords.x, absolute.y - compCoords.y);
    }

    Component findUnderMouseInWindow (PointerInfo pi) {
        if (! isShowing ()) {
            return null;
        }
        Window win = getContainingWindow ();
        if (! Toolkit.getDefaultToolkit ().getMouseInfoPeer ().isWindowUnderMouse (win)) {
            return null;
        }
        final boolean INCLUDE_DISABLED = true;
        Point relativeToWindow = win.pointRelativeToComponent (pi.getLocation ());
        Component inTheSameWindow = win.findComponentAt (relativeToWindow.x, relativeToWindow.y, INCLUDE_DISABLED);
        return inTheSameWindow;
    }

    public Point getMousePosition () throws HeadlessException {
        if (GraphicsEnvironment.isHeadless ()) {
            throw new HeadlessException ();
        }
        PointerInfo pi = (PointerInfo) java.security.AccessController.doPrivileged (new java.security.PrivilegedAction () {
            public Object run () {
                return MouseInfo.getPointerInfo ();
            }

        }

        );
        synchronized (getTreeLock ()) {
            Component inTheSameWindow = findUnderMouseInWindow (pi);
            if (! isSameOrAncestorOf (inTheSameWindow, true)) {
                return null;
            }
            return pointRelativeToComponent (pi.getLocation ());
        }
    }

    boolean isSameOrAncestorOf (Component comp, boolean allowChildren) {
        return comp == this;
    }

    public boolean isShowing () {
        if (visible && (peer != null)) {
            Container parent = this.parent;
            return (parent == null) || parent.isShowing ();
        }
        return false;
    }

    public boolean isEnabled () {
        return isEnabledImpl ();
    }

    final boolean isEnabledImpl () {
        return enabled;
    }

    public void setEnabled (boolean b) {
        enable (b);}

    @Deprecated
    public void enable () {
        if (! enabled) {
            synchronized (getTreeLock ()) {
                enabled = true; ComponentPeer peer = this.peer;
                if (peer != null) {
                    peer.enable (); if (visible) {
                        updateCursorImmediately ();}
                }
            }
            if (accessibleContext != null) {
                accessibleContext.firePropertyChange (AccessibleContext.ACCESSIBLE_STATE_PROPERTY, null, AccessibleState.
                  ENABLED);}
        }
    }

    @Deprecated
    public void enable (boolean b) {
        if (b) {
            enable ();} else {
            disable ();}
    }

    @Deprecated
    public void disable () {
        if (enabled) {
            KeyboardFocusManager.clearMostRecentFocusOwner (this); synchronized (getTreeLock ()) {
                enabled = false; if (isFocusOwner ()) {
                    autoTransferFocus (false);}
                ComponentPeer peer = this.peer;
                if (peer != null) {
                    peer.disable (); if (visible) {
                        updateCursorImmediately ();}
                }
            }
            if (accessibleContext != null) {
                accessibleContext.firePropertyChange (AccessibleContext.ACCESSIBLE_STATE_PROPERTY, null, AccessibleState.
                  ENABLED);}
        }
    }

    public boolean isDoubleBuffered () {
        return false;
    }

    public void enableInputMethods (boolean enable) {
        if (enable) {
            if ((eventMask & AWTEvent.INPUT_METHODS_ENABLED_MASK) != 0) return;

            if (isFocusOwner ()) {
                InputContext inputContext = getInputContext ();
                if (inputContext != null) {
                    FocusEvent focusGainedEvent = new FocusEvent (this, FocusEvent.FOCUS_GAINED);
                    inputContext.dispatchEvent (focusGainedEvent);}
            }
            eventMask |= AWTEvent.INPUT_METHODS_ENABLED_MASK;} else {
            if ((eventMask & AWTEvent.INPUT_METHODS_ENABLED_MASK) != 0) {
                InputContext inputContext = getInputContext ();
                if (inputContext != null) {
                    inputContext.endComposition (); inputContext.removeNotify (this);}
            }
            eventMask &= ~ AWTEvent.INPUT_METHODS_ENABLED_MASK;}
    }

    public void setVisible (boolean b) {
        show (b);}

    @Deprecated
    public void show () {
        if (! visible) {
            synchronized (getTreeLock ()) {
                visible = true; ComponentPeer peer = this.peer;
                if (peer != null) {
                    peer.show (); createHierarchyEvents (HierarchyEvent.HIERARCHY_CHANGED, this, parent, HierarchyEvent.
                      SHOWING_CHANGED, Toolkit.enabledOnToolkit (AWTEvent.HIERARCHY_EVENT_MASK)); if (peer instanceof
                      LightweightPeer) {
                        repaint ();}
                    updateCursorImmediately ();}
                if (componentListener != null || (eventMask & AWTEvent.COMPONENT_EVENT_MASK) != 0 || Toolkit.enabledOnToolkit (
                  AWTEvent.COMPONENT_EVENT_MASK)) {
                    ComponentEvent e = new ComponentEvent (this, ComponentEvent.COMPONENT_SHOWN);
                    Toolkit.getEventQueue ().postEvent (e);}
            }
            Container parent = this.parent;
            if (parent != null) {
                parent.invalidate ();}
        }
    }

    @Deprecated
    public void show (boolean b) {
        if (b) {
            show ();} else {
            hide ();}
    }

    boolean containsFocus () {
        return isFocusOwner ();
    }

    void clearMostRecentFocusOwnerOnHide () {
        KeyboardFocusManager.clearMostRecentFocusOwner (this);}

    void clearCurrentFocusCycleRootOnHide () {
    }

    @Deprecated
    public void hide () {
        isPacked = false; if (visible) {
            clearCurrentFocusCycleRootOnHide (); clearMostRecentFocusOwnerOnHide (); synchronized (getTreeLock ()) {
                visible = false; if (containsFocus ()) {
                    autoTransferFocus (true);}
                ComponentPeer peer = this.peer;
                if (peer != null) {
                    peer.hide (); createHierarchyEvents (HierarchyEvent.HIERARCHY_CHANGED, this, parent, HierarchyEvent.
                      SHOWING_CHANGED, Toolkit.enabledOnToolkit (AWTEvent.HIERARCHY_EVENT_MASK)); if (peer instanceof
                      LightweightPeer) {
                        repaint ();}
                    updateCursorImmediately ();}
                if (componentListener != null || (eventMask & AWTEvent.COMPONENT_EVENT_MASK) != 0 || Toolkit.enabledOnToolkit (
                  AWTEvent.COMPONENT_EVENT_MASK)) {
                    ComponentEvent e = new ComponentEvent (this, ComponentEvent.COMPONENT_HIDDEN);
                    Toolkit.getEventQueue ().postEvent (e);}
            }
            Container parent = this.parent;
            if (parent != null) {
                parent.invalidate ();}
        }
    }

    public Color getForeground () {
        Color foreground = this.foreground;
        if (foreground != null) {
            return foreground;
        }
        Container parent = this.parent;
        return (parent != null) ? parent.getForeground () : null;
    }

    public void setForeground (Color c) {
        Color oldColor = foreground;
        ComponentPeer peer = this.peer;
        foreground = c; if (peer != null) {
            c = getForeground (); if (c != null) {
                peer.setForeground (c);}
        }
        firePropertyChange ("foreground", oldColor, c);}

    public boolean isForegroundSet () {
        return (foreground != null);
    }

    public Color getBackground () {
        Color background = this.background;
        if (background != null) {
            return background;
        }
        Container parent = this.parent;
        return (parent != null) ? parent.getBackground () : null;
    }

    public void setBackground (Color c) {
        Color oldColor = background;
        ComponentPeer peer = this.peer;
        background = c; if (peer != null) {
            c = getBackground (); if (c != null) {
                peer.setBackground (c);}
        }
        firePropertyChange ("background", oldColor, c);}

    public boolean isBackgroundSet () {
        return (background != null);
    }

    public Font getFont () {
        return getFont_NoClientCode ();
    }

    final Font getFont_NoClientCode () {
        Font font = this.font;
        if (font != null) {
            return font;
        }
        Container parent = this.parent;
        return (parent != null) ? parent.getFont_NoClientCode () : null;
    }

    public void setFont (Font f) {
        Font oldFont, newFont;
        synchronized (getTreeLock ()) {
            synchronized (this) {
                oldFont = font; newFont = font = f;}
            ComponentPeer peer = this.peer;
            if (peer != null) {
                f = getFont (); if (f != null) {
                    peer.setFont (f); peerFont = f;}
            }
        }
        firePropertyChange ("font", oldFont, newFont); if (valid && f != oldFont && (oldFont == null || ! oldFont.equals (f))) {
            invalidate ();}
    }

    public boolean isFontSet () {
        return (font != null);
    }

    public Locale getLocale () {
        Locale locale = this.locale;
        if (locale != null) {
            return locale;
        }
        Container parent = this.parent;
        if (parent == null) {
            throw new IllegalComponentStateException ("This component must have a parent in order to determine its locale");
        } else {
            return parent.getLocale ();
        }
    }

    public void setLocale (Locale l) {
        Locale oldValue = locale;
        locale = l; firePropertyChange ("locale", oldValue, l); if (valid) {
            invalidate ();}
    }

    public ColorModel getColorModel () {
        ComponentPeer peer = this.peer;
        if ((peer != null) && ! (peer instanceof LightweightPeer)) {
            return peer.getColorModel ();
        } else if (GraphicsEnvironment.isHeadless ()) {
            return ColorModel.getRGBdefault ();
        }

        return getToolkit ().getColorModel ();
    }

    public Point getLocation () {
        return location ();
    }

    public Point getLocationOnScreen () {
        synchronized (getTreeLock ()) {
            return getLocationOnScreen_NoTreeLock ();
        }
    }

    final Point getLocationOnScreen_NoTreeLock () {
        if (peer != null && isShowing ()) {
            if (peer instanceof LightweightPeer) {
                Container host = getNativeContainer ();
                Point pt = host.peer.getLocationOnScreen ();
                for (Component c = this;
                c != host; c = c.getParent ()) {
                    pt.x += c.x; pt.y += c.y;}
                return pt;
            } else {
                Point pt = peer.getLocationOnScreen ();
                return pt;
            }
        } else {
            throw new IllegalComponentStateException ("component must be showing on the screen to determine its location");
        }
    }

    @Deprecated
    public Point location () {
        return location_NoClientCode ();
    }

    private Point location_NoClientCode () {
        return new Point (x, y);
    }

    public void setLocation (int x, int y) {
        move (x, y);}

    @Deprecated
    public void move (int x, int y) {
        synchronized (getTreeLock ()) {
            setBoundsOp (ComponentPeer.SET_LOCATION); setBounds (x, y, width, height);}
    }

    public void setLocation (Point p) {
        setLocation (p.x, p.y);}

    public Dimension getSize () {
        return size ();
    }

    @Deprecated
    public Dimension size () {
        return new Dimension (width, height);
    }

    public void setSize (int width, int height) {
        resize (width, height);}

    @Deprecated
    public void resize (int width, int height) {
        synchronized (getTreeLock ()) {
            setBoundsOp (ComponentPeer.SET_SIZE); setBounds (x, y, width, height);}
    }

    public void setSize (Dimension d) {
        resize (d);}

    @Deprecated
    public void resize (Dimension d) {
        setSize (d.width, d.height);}

    public Rectangle getBounds () {
        return bounds ();
    }

    @Deprecated
    public Rectangle bounds () {
        return new Rectangle (x, y, width, height);
    }

    public void setBounds (int x, int y, int width, int height) {
        reshape (x, y, width, height);}

    @Deprecated
    public void reshape (int x, int y, int width, int height) {
        synchronized (getTreeLock ()) {
            try {
                setBoundsOp (ComponentPeer.SET_BOUNDS); boolean resized = (this.width != width) || (this.height != height);
                boolean moved = (this.x != x) || (this.y != y);
                if (! resized && ! moved) {
                    return;
                }
                int oldX = this.x;
                int oldY = this.y;
                int oldWidth = this.width;
                int oldHeight = this.height;
                this.x = x; this.y = y; this.width = width; this.height = height; if (resized) {
                    isPacked = false;}
                boolean needNotify = true;
                if (peer != null) {
                    if (! (peer instanceof LightweightPeer)) {
                        reshapeNativePeer (x, y, width, height, getBoundsOp ()); resized = (oldWidth != this.width) || (
                          oldHeight != this.height); moved = (oldX != this.x) || (oldY != this.y); if (this instanceof Window) {
                            needNotify = false;}
                    }
                    if (resized) {
                        invalidate ();}
                    if (parent != null && parent.valid) {
                        parent.invalidate ();}
                }
                if (needNotify) {
                    notifyNewBounds (resized, moved);}
                repaintParentIfNeeded (oldX, oldY, oldWidth, oldHeight);} finally {
                setBoundsOp (ComponentPeer.RESET_OPERATION);}
        }
    }

    private void repaintParentIfNeeded (int oldX, int oldY, int oldWidth, int oldHeight) {
        if (parent != null && peer instanceof LightweightPeer && isShowing ()) {
            parent.repaint (oldX, oldY, oldWidth, oldHeight); repaint ();}
    }

    private void reshapeNativePeer (int x, int y, int width, int height, int op) {
        int nativeX = x;
        int nativeY = y;
        for (Component c = parent;
        (c != null) && (c.peer instanceof LightweightPeer); c = c.parent) {
            nativeX += c.x; nativeY += c.y;}
        peer.setBounds (nativeX, nativeY, width, height, op);}

    private void notifyNewBounds (boolean resized, boolean moved) {
        if (componentListener != null || (eventMask & AWTEvent.COMPONENT_EVENT_MASK) != 0 || Toolkit.enabledOnToolkit (AWTEvent
          .COMPONENT_EVENT_MASK)) {
            if (resized) {
                ComponentEvent e = new ComponentEvent (this, ComponentEvent.COMPONENT_RESIZED);
                Toolkit.getEventQueue ().postEvent (e);}
            if (moved) {
                ComponentEvent e = new ComponentEvent (this, ComponentEvent.COMPONENT_MOVED);
                Toolkit.getEventQueue ().postEvent (e);}
        } else {
            if (this instanceof Container && ((Container) this).ncomponents > 0) {
                boolean enabledOnToolkit = Toolkit.enabledOnToolkit (AWTEvent.HIERARCHY_BOUNDS_EVENT_MASK);
                if (resized) {
                    ((Container) this).createChildHierarchyEvents (HierarchyEvent.ANCESTOR_RESIZED, 0, enabledOnToolkit);}
                if (moved) {
                    ((Container) this).createChildHierarchyEvents (HierarchyEvent.ANCESTOR_MOVED, 0, enabledOnToolkit);}
            }
        }
    }

    public void setBounds (Rectangle r) {
        setBounds (r.x, r.y, r.width, r.height);}

    public int getX () {
        return x;
    }

    public int getY () {
        return y;
    }

    public int getWidth () {
        return width;
    }

    public int getHeight () {
        return height;
    }

    public Rectangle getBounds (Rectangle rv) {
        if (rv == null) {
            return new Rectangle (getX (), getY (), getWidth (), getHeight ());
        } else {
            rv.setBounds (getX (), getY (), getWidth (), getHeight ()); return rv;
        }
    }

    public Dimension getSize (Dimension rv) {
        if (rv == null) {
            return new Dimension (getWidth (), getHeight ());
        } else {
            rv.setSize (getWidth (), getHeight ()); return rv;
        }
    }

    public Point getLocation (Point rv) {
        if (rv == null) {
            return new Point (getX (), getY ());
        } else {
            rv.setLocation (getX (), getY ()); return rv;
        }
    }

    public boolean isOpaque () {
        if (getPeer () == null) {
            return false;
        } else {
            return ! isLightweight ();
        }
    }

    public boolean isLightweight () {
        return getPeer () instanceof LightweightPeer;
    }

    public void setPreferredSize (Dimension preferredSize) {
        Dimension old;
        if (prefSizeSet) {
            old = this.prefSize;} else {
            old = null;}
        this.prefSize = preferredSize; prefSizeSet = (preferredSize != null); firePropertyChange ("preferredSize", old,
          preferredSize);}

    public boolean isPreferredSizeSet () {
        return prefSizeSet;
    }

    public Dimension getPreferredSize () {
        return preferredSize ();
    }

    @Deprecated
    public Dimension preferredSize () {
        Dimension dim = prefSize;
        if (dim == null || ! (isPreferredSizeSet () || isValid ())) {
            synchronized (getTreeLock ()) {
                prefSize = (peer != null) ? peer.preferredSize () : getMinimumSize (); dim = prefSize;}
        }
        return new Dimension (dim);
    }

    public void setMinimumSize (Dimension minimumSize) {
        Dimension old;
        if (minSizeSet) {
            old = this.minSize;} else {
            old = null;}
        this.minSize = minimumSize; minSizeSet = (minimumSize != null); firePropertyChange ("minimumSize", old, minimumSize);}

    public boolean isMinimumSizeSet () {
        return minSizeSet;
    }

    public Dimension getMinimumSize () {
        return minimumSize ();
    }

    @Deprecated
    public Dimension minimumSize () {
        Dimension dim = minSize;
        if (dim == null || ! (isMinimumSizeSet () || isValid ())) {
            synchronized (getTreeLock ()) {
                minSize = (peer != null) ? peer.minimumSize () : size (); dim = minSize;}
        }
        return new Dimension (dim);
    }

    public void setMaximumSize (Dimension maximumSize) {
        Dimension old;
        if (maxSizeSet) {
            old = this.maxSize;} else {
            old = null;}
        this.maxSize = maximumSize; maxSizeSet = (maximumSize != null); firePropertyChange ("maximumSize", old, maximumSize);}

    public boolean isMaximumSizeSet () {
        return maxSizeSet;
    }

    public Dimension getMaximumSize () {
        if (isMaximumSizeSet ()) {
            return new Dimension (maxSize);
        }
        return new Dimension (Short.MAX_VALUE, Short.MAX_VALUE);
    }

    public float getAlignmentX () {
        return CENTER_ALIGNMENT;
    }

    public float getAlignmentY () {
        return CENTER_ALIGNMENT;
    }

    public int getBaseline (int width, int height) {
        if (width < 0 || height < 0) {
            throw new IllegalArgumentException ("Width and height must be >= 0");
        }
        return - 1;
    }

    public BaselineResizeBehavior getBaselineResizeBehavior () {
        return BaselineResizeBehavior.OTHER;
    }

    public void doLayout () {
        layout ();}

    @Deprecated
    public void layout () {
    }

    public void validate () {
        synchronized (getTreeLock ()) {
            ComponentPeer peer = this.peer;
            if (! valid && peer != null) {
                Font newfont = getFont ();
                Font oldfont = peerFont;
                if (newfont != oldfont && (oldfont == null || ! oldfont.equals (newfont))) {
                    peer.setFont (newfont); peerFont = newfont;}
                peer.layout ();}
            valid = true;}
    }

    public void invalidate () {
        synchronized (getTreeLock ()) {
            valid = false; if (! isPreferredSizeSet ()) {
                prefSize = null;}
            if (! isMinimumSizeSet ()) {
                minSize = null;}
            if (! isMaximumSizeSet ()) {
                maxSize = null;}
            if (parent != null && parent.valid) {
                parent.invalidate ();}
        }
    }

    public Graphics getGraphics () {
        if (peer instanceof LightweightPeer) {
            if (parent == null) return null;

            Graphics g = parent.getGraphics ();
            if (g == null) return null;

            if (g instanceof ConstrainableGraphics) {
                ((ConstrainableGraphics) g).constrain (x, y, width, height);} else {
                g.translate (x, y); g.setClip (0, 0, width, height);}
            g.setFont (getFont ()); return g;
        } else {
            ComponentPeer peer = this.peer;
            return (peer != null) ? peer.getGraphics () : null;
        }
    }

    final Graphics getGraphics_NoClientCode () {
        ComponentPeer peer = this.peer;
        if (peer instanceof LightweightPeer) {
            Container parent = this.parent;
            if (parent == null) return null;

            Graphics g = parent.getGraphics_NoClientCode ();
            if (g == null) return null;

            if (g instanceof ConstrainableGraphics) {
                ((ConstrainableGraphics) g).constrain (x, y, width, height);} else {
                g.translate (x, y); g.setClip (0, 0, width, height);}
            g.setFont (getFont_NoClientCode ()); return g;
        } else {
            return (peer != null) ? peer.getGraphics () : null;
        }
    }

    public FontMetrics getFontMetrics (Font font) {
        if (sun.font.FontManager.usePlatformFontMetrics ()) {
            if (peer != null && ! (peer instanceof LightweightPeer)) {
                return peer.getFontMetrics (font);
            }
        }
        return sun.font.FontDesignMetrics.getMetrics (font);
    }

    public void setCursor (Cursor cursor) {
        this.cursor = cursor; updateCursorImmediately ();}

    final void updateCursorImmediately () {
        if (peer instanceof LightweightPeer) {
            Container nativeContainer = getNativeContainer ();
            if (nativeContainer == null) return;

            ComponentPeer cPeer = nativeContainer.getPeer ();
            if (cPeer != null) {
                cPeer.updateCursorImmediately ();}
        } else if (peer != null) {
            peer.updateCursorImmediately ();}

    }

    public Cursor getCursor () {
        return getCursor_NoClientCode ();
    }

    final Cursor getCursor_NoClientCode () {
        Cursor cursor = this.cursor;
        if (cursor != null) {
            return cursor;
        }
        Container parent = this.parent;
        if (parent != null) {
            return parent.getCursor_NoClientCode ();
        } else {
            return Cursor.getPredefinedCursor (Cursor.DEFAULT_CURSOR);
        }
    }

    public boolean isCursorSet () {
        return (cursor != null);
    }

    public void paint (Graphics g) {
    }

    public void update (Graphics g) {
        paint (g);}

    public void paintAll (Graphics g) {
        if (isShowing ()) {
            GraphicsCallback.PeerPaintCallback.getInstance ().runOneComponent (this, new Rectangle (0, 0, width, height), g, g.
              getClip (), GraphicsCallback.LIGHTWEIGHTS | GraphicsCallback.HEAVYWEIGHTS);}
    }

    void lightweightPaint (Graphics g) {
        paint (g);}

    void paintHeavyweightComponents (Graphics g) {
    }

    public void repaint () {
        repaint (0, 0, 0, width, height);}

    public void repaint (long tm) {
        repaint (tm, 0, 0, width, height);}

    public void repaint (int x, int y, int width, int height) {
        repaint (0, x, y, width, height);}

    public void repaint (long tm, int x, int y, int width, int height) {
        if (this.peer instanceof LightweightPeer) {
            if (parent != null) {
                int px = this.x + ((x < 0) ? 0 : x);
                int py = this.y + ((y < 0) ? 0 : y);
                int pwidth = (width > this.width) ? this.width : width;
                int pheight = (height > this.height) ? this.height : height;
                parent.repaint (tm, px, py, pwidth, pheight);}
        } else {
            if (isVisible () && (this.peer != null) && (width > 0) && (height > 0)) {
                PaintEvent e = new PaintEvent (this, PaintEvent.UPDATE, new Rectangle (x, y, width, height));
                Toolkit.getEventQueue ().postEvent (e);}
        }
    }

    public void print (Graphics g) {
        paint (g);}

    public void printAll (Graphics g) {
        if (isShowing ()) {
            GraphicsCallback.PeerPrintCallback.getInstance ().runOneComponent (this, new Rectangle (0, 0, width, height), g, g.
              getClip (), GraphicsCallback.LIGHTWEIGHTS | GraphicsCallback.HEAVYWEIGHTS);}
    }

    void lightweightPrint (Graphics g) {
        print (g);}

    void printHeavyweightComponents (Graphics g) {
    }

    private Insets getInsets_NoClientCode () {
        ComponentPeer peer = this.peer;
        if (peer instanceof ContainerPeer) {
            return (Insets) ((ContainerPeer) peer).insets ().clone ();
        }
        return new Insets (0, 0, 0, 0);
    }

    public boolean imageUpdate (Image img, int infoflags, int x, int y, int w, int h) {
        int rate = - 1;
        if ((infoflags & (FRAMEBITS | ALLBITS)) != 0) {
            rate = 0;} else if ((infoflags & SOMEBITS) != 0) {
            if (isInc) {
                rate = incRate; if (rate < 0) {
                    rate = 0;}
            }
        }

        if (rate >= 0) {
            repaint (rate, 0, 0, width, height);}
        return (infoflags & (ALLBITS | ABORT)) == 0;
    }

    public Image createImage (ImageProducer producer) {
        ComponentPeer peer = this.peer;
        if ((peer != null) && ! (peer instanceof LightweightPeer)) {
            return peer.createImage (producer);
        }
        return getToolkit ().createImage (producer);
    }

    public Image createImage (int width, int height) {
        ComponentPeer peer = this.peer;
        if (peer instanceof LightweightPeer) {
            if (parent != null) {
                return parent.createImage (width, height);
            } else {
                return null;
            }
        } else {
            return (peer != null) ? peer.createImage (width, height) : null;
        }
    }

    public VolatileImage createVolatileImage (int width, int height) {
        ComponentPeer peer = this.peer;
        if (peer instanceof LightweightPeer) {
            if (parent != null) {
                return parent.createVolatileImage (width, height);
            } else {
                return null;
            }
        } else {
            return (peer != null) ? peer.createVolatileImage (width, height) : null;
        }
    }

    public VolatileImage createVolatileImage (int width, int height, ImageCapabilities caps) throws AWTException {
        return createVolatileImage (width, height);
    }

    public boolean prepareImage (Image image, ImageObserver observer) {
        return prepareImage (image, - 1, - 1, observer);
    }

    public boolean prepareImage (Image image, int width, int height, ImageObserver observer) {
        ComponentPeer peer = this.peer;
        if (peer instanceof LightweightPeer) {
            return (parent != null) ? parent.prepareImage (image, width, height, observer) : getToolkit ().prepareImage (image,
              width, height, observer);
        } else {
            return (peer != null) ? peer.prepareImage (image, width, height, observer) : getToolkit ().prepareImage (image,
              width, height, observer);
        }
    }

    public int checkImage (Image image, ImageObserver observer) {
        return checkImage (image, - 1, - 1, observer);
    }

    public int checkImage (Image image, int width, int height, ImageObserver observer) {
        ComponentPeer peer = this.peer;
        if (peer instanceof LightweightPeer) {
            return (parent != null) ? parent.checkImage (image, width, height, observer) : getToolkit ().checkImage (image,
              width, height, observer);
        } else {
            return (peer != null) ? peer.checkImage (image, width, height, observer) : getToolkit ().checkImage (image, width,
              height, observer);
        }
    }

    void createBufferStrategy (int numBuffers) {
        BufferCapabilities bufferCaps;
        if (numBuffers > 1) {
            bufferCaps = new BufferCapabilities (new ImageCapabilities (true), new ImageCapabilities (true), BufferCapabilities
              .FlipContents.UNDEFINED); try {
                createBufferStrategy (numBuffers, bufferCaps); return;
            } catch (AWTException e) {
            }
        }
        bufferCaps = new BufferCapabilities (new ImageCapabilities (true), new ImageCapabilities (true), null); try {
            createBufferStrategy (numBuffers, bufferCaps); return;
        } catch (AWTException e) {
        }
        bufferCaps = new BufferCapabilities (new ImageCapabilities (false), new ImageCapabilities (false), null); try {
            createBufferStrategy (numBuffers, bufferCaps); return;
        } catch (AWTException e) {
        }
        throw new InternalError ("Could not create a buffer strategy");
    }

    void createBufferStrategy (int numBuffers, BufferCapabilities caps) throws AWTException {
        if (numBuffers < 1) {
            throw new IllegalArgumentException ("Number of buffers must be at least 1");
        }
        if (caps == null) {
            throw new IllegalArgumentException ("No capabilities specified");
        }
        if (bufferStrategy != null) {
            bufferStrategy.dispose ();}
        if (numBuffers == 1) {
            bufferStrategy = new SingleBufferStrategy (caps);} else {
            if (caps.isPageFlipping ()) {
                bufferStrategy = new FlipSubRegionBufferStrategy (numBuffers, caps);} else {
                bufferStrategy = new BltSubRegionBufferStrategy (numBuffers, caps);}
        }
    }

    BufferStrategy getBufferStrategy () {
        return bufferStrategy;
    }

    Image getBackBuffer () {
        if (bufferStrategy != null) {
            if (bufferStrategy instanceof BltBufferStrategy) {
                BltBufferStrategy bltBS = (BltBufferStrategy) bufferStrategy;
                return bltBS.getBackBuffer ();
            } else if (bufferStrategy instanceof FlipBufferStrategy) {
                FlipBufferStrategy flipBS = (FlipBufferStrategy) bufferStrategy;
                return flipBS.getBackBuffer ();
            }

        }
        return null;
    }

    protected class FlipBufferStrategy extends BufferStrategy {
        protected int numBuffers;
        protected BufferCapabilities caps;
        protected Image drawBuffer;
        protected VolatileImage drawVBuffer;
        protected boolean validatedContents;
        int width;
        int height;

        protected FlipBufferStrategy (int numBuffers, BufferCapabilities caps) throws AWTException {
            if (! (Component.this instanceof Window) && ! (Component.this instanceof Canvas)) {
                throw new ClassCastException ("Component must be a Canvas or Window");
            }
            this.numBuffers = numBuffers; this.caps = caps; createBuffers (numBuffers, caps);}

        protected void createBuffers (int numBuffers, BufferCapabilities caps) throws AWTException {
            if (numBuffers < 2) {
                throw new IllegalArgumentException ("Number of buffers cannot be less than two");
            } else if (peer == null) {
                throw new IllegalStateException ("Component must have a valid peer");
            } else if (caps == null || ! caps.isPageFlipping ()) {
                throw new IllegalArgumentException ("Page flipping capabilities must be specified");
            }

            width = getWidth (); height = getHeight (); if (drawBuffer == null) {
                peer.createBuffers (numBuffers, caps);} else {
                drawBuffer = null; drawVBuffer = null; destroyBuffers (); peer.createBuffers (numBuffers, caps);}
            updateInternalBuffers ();}

        private void updateInternalBuffers () {
            drawBuffer = getBackBuffer (); if (drawBuffer instanceof VolatileImage) {
                drawVBuffer = (VolatileImage) drawBuffer;} else {
                drawVBuffer = null;}
        }

        protected Image getBackBuffer () {
            if (peer != null) {
                return peer.getBackBuffer ();
            } else {
                throw new IllegalStateException ("Component must have a valid peer");
            }
        }

        protected void flip (BufferCapabilities.FlipContents flipAction) {
            if (peer != null) {
                peer.flip (flipAction);} else {
                throw new IllegalStateException ("Component must have a valid peer");
            }
        }

        protected void destroyBuffers () {
            if (peer != null) {
                peer.destroyBuffers ();} else {
                throw new IllegalStateException ("Component must have a valid peer");
            }
        }

        public BufferCapabilities getCapabilities () {
            return caps;
        }

        public Graphics getDrawGraphics () {
            revalidate (); return drawBuffer.getGraphics ();
        }

        protected void revalidate () {
            revalidate (true);}

        void revalidate (boolean checkSize) {
            validatedContents = false; if (checkSize && (getWidth () != width || getHeight () != height)) {
                try {
                    createBuffers (numBuffers, caps);} catch (AWTException e) {
                }
                validatedContents = true;}
            updateInternalBuffers (); if (drawVBuffer != null) {
                GraphicsConfiguration gc = getGraphicsConfiguration_NoClientCode ();
                int returnCode = drawVBuffer.validate (gc);
                if (returnCode == VolatileImage.IMAGE_INCOMPATIBLE) {
                    try {
                        createBuffers (numBuffers, caps);} catch (AWTException e) {
                    }
                    if (drawVBuffer != null) {
                        drawVBuffer.validate (gc);}
                    validatedContents = true;} else if (returnCode == VolatileImage.IMAGE_RESTORED) {
                    validatedContents = true;}

            }
        }

        public boolean contentsLost () {
            if (drawVBuffer == null) {
                return false;
            }
            return drawVBuffer.contentsLost ();
        }

        public boolean contentsRestored () {
            return validatedContents;
        }

        public void show () {
            flip (caps.getFlipContents ());}

        public void dispose () {
            if (Component.this.bufferStrategy == this) {
                Component.this.bufferStrategy = null; if (peer != null) {
                    destroyBuffers ();}
            }
        }

    }

    protected class BltBufferStrategy extends BufferStrategy {
        protected BufferCapabilities caps;
        protected VolatileImage [] backBuffers;
        protected boolean validatedContents;
        protected int width;
        protected int height;
        private Insets insets;

        protected BltBufferStrategy (int numBuffers, BufferCapabilities caps) {
            this.caps = caps; createBackBuffers (numBuffers - 1);}

        public void dispose () {
            if (backBuffers != null) {
                for (int counter = backBuffers.length - 1;
                counter >= 0; counter --) {
                    if (backBuffers [counter] != null) {
                        backBuffers [counter].flush (); backBuffers [counter] = null;}
                }
            }
            if (Component.this.bufferStrategy == this) {
                Component.this.bufferStrategy = null;}
        }

        protected void createBackBuffers (int numBuffers) {
            if (numBuffers == 0) {
                backBuffers = null;} else {
                width = getWidth (); height = getHeight (); insets = getInsets_NoClientCode (); int iWidth = width - insets.
                  left - insets.right;
                int iHeight = height - insets.top - insets.bottom;
                iWidth = Math.max (1, iWidth); iHeight = Math.max (1, iHeight); if (backBuffers == null) {
                    backBuffers = new VolatileImage [numBuffers];} else {
                    for (int i = 0;
                    i < numBuffers; i ++) {
                        if (backBuffers [i] != null) {
                            backBuffers [i].flush (); backBuffers [i] = null;}
                    }
                }
                for (int i = 0;
                i < numBuffers; i ++) {
                    backBuffers [i] = createVolatileImage (iWidth, iHeight);}
            }
        }

        public BufferCapabilities getCapabilities () {
            return caps;
        }

        public Graphics getDrawGraphics () {
            revalidate (); Image backBuffer = getBackBuffer ();
            if (backBuffer == null) {
                return getGraphics ();
            }
            SunGraphics2D g = (SunGraphics2D) backBuffer.getGraphics ();
            g.constrain (- insets.left, - insets.top, backBuffer.getWidth (null) + insets.left, backBuffer.getHeight (null) +
              insets.top); return g;
        }

        Image getBackBuffer () {
            if (backBuffers != null) {
                return backBuffers [backBuffers.length - 1];
            } else {
                return null;
            }
        }

        public void show () {
            showSubRegion (insets.left, insets.top, width - insets.right, height - insets.bottom);}

        void showSubRegion (int x1, int y1, int x2, int y2) {
            if (backBuffers == null) {
                return;
            }
            x1 -= insets.left; x2 -= insets.left; y1 -= insets.top; y2 -= insets.top; Graphics g = getGraphics_NoClientCode ();
            if (g == null) {
                return;
            }
            try {
                g.translate (insets.left, insets.top); for (int i = 0;
                i < backBuffers.length; i ++) {
                    g.drawImage (backBuffers [i], x1, y1, x2, y2, x1, y1, x2, y2, null); g.dispose (); g = null; g = backBuffers
                      [i].getGraphics ();}
            } finally {
                if (g != null) {
                    g.dispose ();}
            }
        }

        protected void revalidate () {
            revalidate (true);}

        void revalidate (boolean checkSize) {
            validatedContents = false; if (backBuffers == null) {
                return;
            }
            if (checkSize) {
                Insets insets = getInsets_NoClientCode ();
                if (getWidth () != width || getHeight () != height || ! insets.equals (this.insets)) {
                    createBackBuffers (backBuffers.length); validatedContents = true;}
            }
            GraphicsConfiguration gc = getGraphicsConfiguration_NoClientCode ();
            int returnCode = backBuffers [backBuffers.length - 1].validate (gc);
            if (returnCode == VolatileImage.IMAGE_INCOMPATIBLE) {
                if (checkSize) {
                    createBackBuffers (backBuffers.length); backBuffers [backBuffers.length - 1].validate (gc);}
                validatedContents = true;} else if (returnCode == VolatileImage.IMAGE_RESTORED) {
                validatedContents = true;}

        }

        public boolean contentsLost () {
            if (backBuffers == null) {
                return false;
            } else {
                return backBuffers [backBuffers.length - 1].contentsLost ();
            }
        }

        public boolean contentsRestored () {
            return validatedContents;
        }

    }

    private class FlipSubRegionBufferStrategy extends FlipBufferStrategy implements SubRegionShowable {

        protected FlipSubRegionBufferStrategy (int numBuffers, BufferCapabilities caps) throws AWTException {
            super (numBuffers, caps);}

        public void show (int x1, int y1, int x2, int y2) {
            show ();}

        public boolean validateAndShow (int x1, int y1, int x2, int y2) {
            revalidate (false); if (! contentsRestored () && ! contentsLost ()) {
                show (); return ! contentsLost ();
            }
            return false;
        }

    }

    private class BltSubRegionBufferStrategy extends BltBufferStrategy implements SubRegionShowable {

        protected BltSubRegionBufferStrategy (int numBuffers, BufferCapabilities caps) {
            super (numBuffers, caps);}

        public void show (int x1, int y1, int x2, int y2) {
            showSubRegion (x1, y1, x2, y2);}

        public boolean validateAndShow (int x1, int y1, int x2, int y2) {
            revalidate (false); if (! contentsRestored () && ! contentsLost ()) {
                showSubRegion (x1, y1, x2, y2); return ! contentsLost ();
            }
            return false;
        }

    }

    private class SingleBufferStrategy extends BufferStrategy {
        private BufferCapabilities caps;

        public SingleBufferStrategy (BufferCapabilities caps) {
            this.caps = caps;}

        public BufferCapabilities getCapabilities () {
            return caps;
        }

        public Graphics getDrawGraphics () {
            return getGraphics ();
        }

        public boolean contentsLost () {
            return false;
        }

        public boolean contentsRestored () {
            return false;
        }

        public void show () {
        }

    }

    public void setIgnoreRepaint (boolean ignoreRepaint) {
        this.ignoreRepaint = ignoreRepaint;}

    public boolean getIgnoreRepaint () {
        return ignoreRepaint;
    }

    public boolean contains (int x, int y) {
        return inside (x, y);
    }

    @Deprecated
    public boolean inside (int x, int y) {
        return (x >= 0) && (x < width) && (y >= 0) && (y < height);
    }

    public boolean contains (Point p) {
        return contains (p.x, p.y);
    }

    public Component getComponentAt (int x, int y) {
        return locate (x, y);
    }

    @Deprecated
    public Component locate (int x, int y) {
        return contains (x, y) ? this : null;
    }

    public Component getComponentAt (Point p) {
        return getComponentAt (p.x, p.y);
    }

    @Deprecated
    public void deliverEvent (Event e) {
        postEvent (e);}

    public final void dispatchEvent (AWTEvent e) {
        dispatchEventImpl (e);}

    void dispatchEventImpl (AWTEvent e) {
        int id = e.getID ();
        AppContext compContext = appContext;
        if (compContext != null && ! compContext.equals (AppContext.getAppContext ())) {
            log.fine ("Event " + e + " is being dispatched on the wrong AppContext");}
        if (log.isLoggable (Level.FINEST)) {
            log.log (Level.FINEST, "{0}", e);}
        EventQueue.setCurrentEventAndMostRecentTime (e); if (e instanceof SunDropTargetEvent) {
            ((SunDropTargetEvent) e).dispatch (); return;
        }
        if (! e.focusManagerIsDispatching) {
            if (e.isPosted) {
                e = KeyboardFocusManager.retargetFocusEvent (e); e.isPosted = true;}
            if (KeyboardFocusManager.getCurrentKeyboardFocusManager ().dispatchEvent (e)) {
                return;
            }
        }
        if (e instanceof FocusEvent && focusLog.isLoggable (Level.FINE)) {
            focusLog.fine ("" + e);}
        if (id == MouseEvent.MOUSE_WHEEL && (! eventTypeEnabled (id)) && (peer != null && ! peer.handlesWheelScrolling ()) && (
          dispatchMouseWheelToAncestor ((MouseWheelEvent) e))) {
            return;
        }
        Toolkit toolkit = Toolkit.getDefaultToolkit ();
        toolkit.notifyAWTEventListeners (e); if (! e.isConsumed ()) {
            if (e instanceof java.awt.event.KeyEvent) {
                KeyboardFocusManager.getCurrentKeyboardFocusManager ().processKeyEvent (this, (KeyEvent) e); if (e.isConsumed (
                  )) {
                    return;
                }
            }
        }
        if (areInputMethodsEnabled ()) {
            if (((e instanceof InputMethodEvent) && ! (this instanceof CompositionArea)) || (e instanceof InputEvent) || (e
              instanceof FocusEvent)) {
                InputContext inputContext = getInputContext ();
                if (inputContext != null) {
                    inputContext.dispatchEvent (e); if (e.isConsumed ()) {
                        if (e instanceof FocusEvent && focusLog.isLoggable (Level.FINER)) {
                            focusLog.finer ("3579: Skipping " + e);}
                        return;
                    }
                }
            }
        } else {
            if (id == FocusEvent.FOCUS_GAINED) {
                InputContext inputContext = getInputContext ();
                if (inputContext != null && inputContext instanceof sun.awt.im.InputContext) {
                    ((sun.awt.im.InputContext) inputContext).disableNativeIM ();}
            }
        }
        switch (id) {
            case KeyEvent.KEY_PRESSED :
            case KeyEvent.KEY_RELEASED :
                Container p = (Container) ((this instanceof Container) ? this : parent);
                if (p != null) {
                    p.preProcessKeyEvent ((KeyEvent) e); if (e.isConsumed ()) {
                        if (focusLog.isLoggable (Level.FINEST)) focusLog.finest ("Pre-process consumed event");
                        return;
                    }
                }
                break;
            case WindowEvent.WINDOW_CLOSING :
                if (toolkit instanceof WindowClosingListener) {
                    windowClosingException = ((WindowClosingListener) toolkit).windowClosingNotify ((WindowEvent) e); if (
                      checkWindowClosingException ()) {
                        return;
                    }
                }
                break;
            default :
                break;
        }
        if (newEventsOnly) {
            if (eventEnabled (e)) {
                processEvent (e);}
        } else if (id == MouseEvent.MOUSE_WHEEL) {
            autoProcessMouseWheel ((MouseWheelEvent) e);} else if (! (e instanceof MouseEvent && ! postsOldMouseEvents ())) {
            Event olde = e.convertToOld ();
            if (olde != null) {
                int key = olde.key;
                int modifiers = olde.modifiers;
                postEvent (olde); if (olde.isConsumed ()) {
                    e.consume ();}
                switch (olde.id) {
                    case Event.KEY_PRESS :
                    case Event.KEY_RELEASE :
                    case Event.KEY_ACTION :
                    case Event.KEY_ACTION_RELEASE :
                        if (olde.key != key) {
                            ((KeyEvent) e).setKeyChar (olde.getKeyEventChar ());}
                        if (olde.modifiers != modifiers) {
                            ((KeyEvent) e).setModifiers (olde.modifiers);}
                        break;
                    default :
                        break;
                }
            }
        }

        if (id == WindowEvent.WINDOW_CLOSING && ! e.isConsumed ()) {
            if (toolkit instanceof WindowClosingListener) {
                windowClosingException = ((WindowClosingListener) toolkit).windowClosingDelivered ((WindowEvent) e); if (
                  checkWindowClosingException ()) {
                    return;
                }
            }
        }
        if (! (e instanceof KeyEvent)) {
            ComponentPeer tpeer = peer;
            if (e instanceof FocusEvent && (tpeer == null || tpeer instanceof LightweightPeer)) {
                Component source = (Component) e.getSource ();
                if (source != null) {
                    Container target = source.getNativeContainer ();
                    if (target != null) {
                        tpeer = target.getPeer ();}
                }
            }
            if (tpeer != null) {
                tpeer.handleEvent (e);}
        }
    }

    void autoProcessMouseWheel (MouseWheelEvent e) {
    }

    boolean dispatchMouseWheelToAncestor (MouseWheelEvent e) {
        int newX, newY;
        newX = e.getX () + getX (); newY = e.getY () + getY (); MouseWheelEvent newMWE;
        if (dbg.on) {
            dbg.println ("Component.dispatchMouseWheelToAncestor"); dbg.println ("orig event src is of " + e.getSource ().
              getClass ());}
        synchronized (getTreeLock ()) {
            Container anc = getParent ();
            while (anc != null && ! anc.eventEnabled (e)) {
                newX += anc.getX (); newY += anc.getY (); if (! (anc instanceof Window)) {
                    anc = anc.getParent ();} else {
                    break;
                }
            } if (dbg.on) dbg.println ("new event src is " + anc.getClass ());
            if (anc != null && anc.eventEnabled (e)) {
                newMWE = new MouseWheelEvent (anc, e.getID (), e.getWhen (), e.getModifiers (), newX, newY, e.getXOnScreen (), e
                  .getYOnScreen (), e.getClickCount (), e.isPopupTrigger (), e.getScrollType (), e.getScrollAmount (), e.
                  getWheelRotation ()); ((AWTEvent) e).copyPrivateDataInto (newMWE); anc.dispatchEventImpl (newMWE);}
        }
        return true;
    }

    boolean checkWindowClosingException () {
        if (windowClosingException != null) {
            if (this instanceof Dialog) {
                ((Dialog) this).interruptBlocking ();} else {
                windowClosingException.fillInStackTrace (); windowClosingException.printStackTrace (); windowClosingException =
                  null;}
            return true;
        }
        return false;
    }

    boolean areInputMethodsEnabled () {
        return ((eventMask & AWTEvent.INPUT_METHODS_ENABLED_MASK) != 0) && ((eventMask & AWTEvent.KEY_EVENT_MASK) != 0 ||
          keyListener != null);
    }

    boolean eventEnabled (AWTEvent e) {
        return eventTypeEnabled (e.id);
    }

    boolean eventTypeEnabled (int type) {
        switch (type) {
            case ComponentEvent.COMPONENT_MOVED :
            case ComponentEvent.COMPONENT_RESIZED :
            case ComponentEvent.COMPONENT_SHOWN :
            case ComponentEvent.COMPONENT_HIDDEN :
                if ((eventMask & AWTEvent.COMPONENT_EVENT_MASK) != 0 || componentListener != null) {
                    return true;
                }
                break;
            case FocusEvent.FOCUS_GAINED :
            case FocusEvent.FOCUS_LOST :
                if ((eventMask & AWTEvent.FOCUS_EVENT_MASK) != 0 || focusListener != null) {
                    return true;
                }
                break;
            case KeyEvent.KEY_PRESSED :
            case KeyEvent.KEY_RELEASED :
            case KeyEvent.KEY_TYPED :
                if ((eventMask & AWTEvent.KEY_EVENT_MASK) != 0 || keyListener != null) {
                    return true;
                }
                break;
            case MouseEvent.MOUSE_PRESSED :
            case MouseEvent.MOUSE_RELEASED :
            case MouseEvent.MOUSE_ENTERED :
            case MouseEvent.MOUSE_EXITED :
            case MouseEvent.MOUSE_CLICKED :
                if ((eventMask & AWTEvent.MOUSE_EVENT_MASK) != 0 || mouseListener != null) {
                    return true;
                }
                break;
            case MouseEvent.MOUSE_MOVED :
            case MouseEvent.MOUSE_DRAGGED :
                if ((eventMask & AWTEvent.MOUSE_MOTION_EVENT_MASK) != 0 || mouseMotionListener != null) {
                    return true;
                }
                break;
            case MouseEvent.MOUSE_WHEEL :
                if ((eventMask & AWTEvent.MOUSE_WHEEL_EVENT_MASK) != 0 || mouseWheelListener != null) {
                    return true;
                }
                break;
            case InputMethodEvent.INPUT_METHOD_TEXT_CHANGED :
            case InputMethodEvent.CARET_POSITION_CHANGED :
                if ((eventMask & AWTEvent.INPUT_METHOD_EVENT_MASK) != 0 || inputMethodListener != null) {
                    return true;
                }
                break;
            case HierarchyEvent.HIERARCHY_CHANGED :
                if ((eventMask & AWTEvent.HIERARCHY_EVENT_MASK) != 0 || hierarchyListener != null) {
                    return true;
                }
                break;
            case HierarchyEvent.ANCESTOR_MOVED :
            case HierarchyEvent.ANCESTOR_RESIZED :
                if ((eventMask & AWTEvent.HIERARCHY_BOUNDS_EVENT_MASK) != 0 || hierarchyBoundsListener != null) {
                    return true;
                }
                break;
            case ActionEvent.ACTION_PERFORMED :
                if ((eventMask & AWTEvent.ACTION_EVENT_MASK) != 0) {
                    return true;
                }
                break;
            case TextEvent.TEXT_VALUE_CHANGED :
                if ((eventMask & AWTEvent.TEXT_EVENT_MASK) != 0) {
                    return true;
                }
                break;
            case ItemEvent.ITEM_STATE_CHANGED :
                if ((eventMask & AWTEvent.ITEM_EVENT_MASK) != 0) {
                    return true;
                }
                break;
            case AdjustmentEvent.ADJUSTMENT_VALUE_CHANGED :
                if ((eventMask & AWTEvent.ADJUSTMENT_EVENT_MASK) != 0) {
                    return true;
                }
                break;
            default :
                break;
        }
        if (type > AWTEvent.RESERVED_ID_MAX) {
            return true;
        }
        return false;
    }

    @Deprecated
    public boolean postEvent (Event e) {
        ComponentPeer peer = this.peer;
        if (handleEvent (e)) {
            e.consume (); return true;
        }
        Component parent = this.parent;
        int eventx = e.x;
        int eventy = e.y;
        if (parent != null) {
            e.translate (x, y); if (parent.postEvent (e)) {
                e.consume (); return true;
            }
            e.x = eventx; e.y = eventy;}
        return false;
    }

    public synchronized void addComponentListener (ComponentListener l) {
        if (l == null) {
            return;
        }
        componentListener = AWTEventMulticaster.add (componentListener, l); newEventsOnly = true;}

    public synchronized void removeComponentListener (ComponentListener l) {
        if (l == null) {
            return;
        }
        componentListener = AWTEventMulticaster.remove (componentListener, l);}

    public synchronized ComponentListener [] getComponentListeners () {
        return (ComponentListener []) (getListeners (ComponentListener.class));
    }

    public synchronized void addFocusListener (FocusListener l) {
        if (l == null) {
            return;
        }
        focusListener = AWTEventMulticaster.add (focusListener, l); newEventsOnly = true; if (peer instanceof LightweightPeer) {
            parent.proxyEnableEvents (AWTEvent.FOCUS_EVENT_MASK);}
    }

    public synchronized void removeFocusListener (FocusListener l) {
        if (l == null) {
            return;
        }
        focusListener = AWTEventMulticaster.remove (focusListener, l);}

    public synchronized FocusListener [] getFocusListeners () {
        return (FocusListener []) (getListeners (FocusListener.class));
    }

    public void addHierarchyListener (HierarchyListener l) {
        if (l == null) {
            return;
        }
        boolean notifyAncestors;
        synchronized (this) {
            notifyAncestors = (hierarchyListener == null && (eventMask & AWTEvent.HIERARCHY_EVENT_MASK) == 0); hierarchyListener
              = AWTEventMulticaster.add (hierarchyListener, l); notifyAncestors = (notifyAncestors && hierarchyListener != null
              ); newEventsOnly = true;}
        if (notifyAncestors) {
            synchronized (getTreeLock ()) {
                adjustListeningChildrenOnParent (AWTEvent.HIERARCHY_EVENT_MASK, 1);}
        }
    }

    public void removeHierarchyListener (HierarchyListener l) {
        if (l == null) {
            return;
        }
        boolean notifyAncestors;
        synchronized (this) {
            notifyAncestors = (hierarchyListener != null && (eventMask & AWTEvent.HIERARCHY_EVENT_MASK) == 0); hierarchyListener
              = AWTEventMulticaster.remove (hierarchyListener, l); notifyAncestors = (notifyAncestors && hierarchyListener ==
              null);}
        if (notifyAncestors) {
            synchronized (getTreeLock ()) {
                adjustListeningChildrenOnParent (AWTEvent.HIERARCHY_EVENT_MASK, - 1);}
        }
    }

    public synchronized HierarchyListener [] getHierarchyListeners () {
        return (HierarchyListener []) (getListeners (HierarchyListener.class));
    }

    public void addHierarchyBoundsListener (HierarchyBoundsListener l) {
        if (l == null) {
            return;
        }
        boolean notifyAncestors;
        synchronized (this) {
            notifyAncestors = (hierarchyBoundsListener == null && (eventMask & AWTEvent.HIERARCHY_BOUNDS_EVENT_MASK) == 0);
              hierarchyBoundsListener = AWTEventMulticaster.add (hierarchyBoundsListener, l); notifyAncestors = (
              notifyAncestors && hierarchyBoundsListener != null); newEventsOnly = true;}
        if (notifyAncestors) {
            synchronized (getTreeLock ()) {
                adjustListeningChildrenOnParent (AWTEvent.HIERARCHY_BOUNDS_EVENT_MASK, 1);}
        }
    }

    public void removeHierarchyBoundsListener (HierarchyBoundsListener l) {
        if (l == null) {
            return;
        }
        boolean notifyAncestors;
        synchronized (this) {
            notifyAncestors = (hierarchyBoundsListener != null && (eventMask & AWTEvent.HIERARCHY_BOUNDS_EVENT_MASK) == 0);
              hierarchyBoundsListener = AWTEventMulticaster.remove (hierarchyBoundsListener, l); notifyAncestors = (
              notifyAncestors && hierarchyBoundsListener == null);}
        if (notifyAncestors) {
            synchronized (getTreeLock ()) {
                adjustListeningChildrenOnParent (AWTEvent.HIERARCHY_BOUNDS_EVENT_MASK, - 1);}
        }
    }

    int numListening (long mask) {
        if (dbg.on) {
            dbg.assertion (mask == AWTEvent.HIERARCHY_EVENT_MASK || mask == AWTEvent.HIERARCHY_BOUNDS_EVENT_MASK);}
        if ((mask == AWTEvent.HIERARCHY_EVENT_MASK && (hierarchyListener != null || (eventMask & AWTEvent.HIERARCHY_EVENT_MASK)
          != 0)) || (mask == AWTEvent.HIERARCHY_BOUNDS_EVENT_MASK && (hierarchyBoundsListener != null || (eventMask & AWTEvent.
          HIERARCHY_BOUNDS_EVENT_MASK) != 0))) {
            return 1;
        } else {
            return 0;
        }
    }

    int countHierarchyMembers () {
        return 1;
    }

    int createHierarchyEvents (int id, Component changed, Container changedParent, long changeFlags, boolean enabledOnToolkit) {
        switch (id) {
            case HierarchyEvent.HIERARCHY_CHANGED :
                if (hierarchyListener != null || (eventMask & AWTEvent.HIERARCHY_EVENT_MASK) != 0 || enabledOnToolkit) {
                    HierarchyEvent e = new HierarchyEvent (this, id, changed, changedParent, changeFlags);
                    dispatchEvent (e); return 1;
                }
                break;
            case HierarchyEvent.ANCESTOR_MOVED :
            case HierarchyEvent.ANCESTOR_RESIZED :
                if (dbg.on) {
                    dbg.assertion (changeFlags == 0);}
                if (hierarchyBoundsListener != null || (eventMask & AWTEvent.HIERARCHY_BOUNDS_EVENT_MASK) != 0 ||
                  enabledOnToolkit) {
                    HierarchyEvent e = new HierarchyEvent (this, id, changed, changedParent);
                    dispatchEvent (e); return 1;
                }
                break;
            default :
                if (dbg.on) {
                    dbg.assertion (false);}
                break;
        }
        return 0;
    }

    public synchronized HierarchyBoundsListener [] getHierarchyBoundsListeners () {
        return (HierarchyBoundsListener []) (getListeners (HierarchyBoundsListener.class));
    }

    void adjustListeningChildrenOnParent (long mask, int num) {
        if (parent != null) {
            parent.adjustListeningChildren (mask, num);}
    }

    public synchronized void addKeyListener (KeyListener l) {
        if (l == null) {
            return;
        }
        keyListener = AWTEventMulticaster.add (keyListener, l); newEventsOnly = true; if (peer instanceof LightweightPeer) {
            parent.proxyEnableEvents (AWTEvent.KEY_EVENT_MASK);}
    }

    public synchronized void removeKeyListener (KeyListener l) {
        if (l == null) {
            return;
        }
        keyListener = AWTEventMulticaster.remove (keyListener, l);}

    public synchronized KeyListener [] getKeyListeners () {
        return (KeyListener []) (getListeners (KeyListener.class));
    }

    public synchronized void addMouseListener (MouseListener l) {
        if (l == null) {
            return;
        }
        mouseListener = AWTEventMulticaster.add (mouseListener, l); newEventsOnly = true; if (peer instanceof LightweightPeer) {
            parent.proxyEnableEvents (AWTEvent.MOUSE_EVENT_MASK);}
    }

    public synchronized void removeMouseListener (MouseListener l) {
        if (l == null) {
            return;
        }
        mouseListener = AWTEventMulticaster.remove (mouseListener, l);}

    public synchronized MouseListener [] getMouseListeners () {
        return (MouseListener []) (getListeners (MouseListener.class));
    }

    public synchronized void addMouseMotionListener (MouseMotionListener l) {
        if (l == null) {
            return;
        }
        mouseMotionListener = AWTEventMulticaster.add (mouseMotionListener, l); newEventsOnly = true; if (peer instanceof
          LightweightPeer) {
            parent.proxyEnableEvents (AWTEvent.MOUSE_MOTION_EVENT_MASK);}
    }

    public synchronized void removeMouseMotionListener (MouseMotionListener l) {
        if (l == null) {
            return;
        }
        mouseMotionListener = AWTEventMulticaster.remove (mouseMotionListener, l);}

    public synchronized MouseMotionListener [] getMouseMotionListeners () {
        return (MouseMotionListener []) (getListeners (MouseMotionListener.class));
    }

    public synchronized void addMouseWheelListener (MouseWheelListener l) {
        if (l == null) {
            return;
        }
        mouseWheelListener = AWTEventMulticaster.add (mouseWheelListener, l); newEventsOnly = true; dbg.println (
          "Component.addMouseWheelListener(): newEventsOnly = " + newEventsOnly); if (peer instanceof LightweightPeer) {
            parent.proxyEnableEvents (AWTEvent.MOUSE_WHEEL_EVENT_MASK);}
    }

    public synchronized void removeMouseWheelListener (MouseWheelListener l) {
        if (l == null) {
            return;
        }
        mouseWheelListener = AWTEventMulticaster.remove (mouseWheelListener, l);}

    public synchronized MouseWheelListener [] getMouseWheelListeners () {
        return (MouseWheelListener []) (getListeners (MouseWheelListener.class));
    }

    public synchronized void addInputMethodListener (InputMethodListener l) {
        if (l == null) {
            return;
        }
        inputMethodListener = AWTEventMulticaster.add (inputMethodListener, l); newEventsOnly = true;}

    public synchronized void removeInputMethodListener (InputMethodListener l) {
        if (l == null) {
            return;
        }
        inputMethodListener = AWTEventMulticaster.remove (inputMethodListener, l);}

    public synchronized InputMethodListener [] getInputMethodListeners () {
        return (InputMethodListener []) (getListeners (InputMethodListener.class));
    }

    public < T extends EventListener > getListeners (Class < T > listenerType) {
        EventListener l = null;
        if (listenerType == ComponentListener.class) {
            l = componentListener;} else if (listenerType == FocusListener.class) {
            l = focusListener;} else if (listenerType == HierarchyListener.class) {
            l = hierarchyListener;} else if (listenerType == HierarchyBoundsListener.class) {
            l = hierarchyBoundsListener;} else if (listenerType == KeyListener.class) {
            l = keyListener;} else if (listenerType == MouseListener.class) {
            l = mouseListener;} else if (listenerType == MouseMotionListener.class) {
            l = mouseMotionListener;} else if (listenerType == MouseWheelListener.class) {
            l = mouseWheelListener;} else if (listenerType == InputMethodListener.class) {
            l = inputMethodListener;} else if (listenerType == PropertyChangeListener.class) {
            return (T []) getPropertyChangeListeners ();
        }

        return AWTEventMulticaster.getListeners (l, listenerType);
    }

    public InputMethodRequests getInputMethodRequests () {
        return null;
    }

    public InputContext getInputContext () {
        Container parent = this.parent;
        if (parent == null) {
            return null;
        } else {
            return parent.getInputContext ();
        }
    }

    protected final void enableEvents (long eventsToEnable) {
        long notifyAncestors = 0;
        synchronized (this) {
            if ((eventsToEnable & AWTEvent.HIERARCHY_EVENT_MASK) != 0 && hierarchyListener == null && (eventMask & AWTEvent.
              HIERARCHY_EVENT_MASK) == 0) {
                notifyAncestors |= AWTEvent.HIERARCHY_EVENT_MASK;}
            if ((eventsToEnable & AWTEvent.HIERARCHY_BOUNDS_EVENT_MASK) != 0 && hierarchyBoundsListener == null && (eventMask &
              AWTEvent.HIERARCHY_BOUNDS_EVENT_MASK) == 0) {
                notifyAncestors |= AWTEvent.HIERARCHY_BOUNDS_EVENT_MASK;}
            eventMask |= eventsToEnable; newEventsOnly = true;}
        if (peer instanceof LightweightPeer) {
            parent.proxyEnableEvents (eventMask);}
        if (notifyAncestors != 0) {
            synchronized (getTreeLock ()) {
                adjustListeningChildrenOnParent (notifyAncestors, 1);}
        }
    }

    protected final void disableEvents (long eventsToDisable) {
        long notifyAncestors = 0;
        synchronized (this) {
            if ((eventsToDisable & AWTEvent.HIERARCHY_EVENT_MASK) != 0 && hierarchyListener == null && (eventMask & AWTEvent.
              HIERARCHY_EVENT_MASK) != 0) {
                notifyAncestors |= AWTEvent.HIERARCHY_EVENT_MASK;}
            if ((eventsToDisable & AWTEvent.HIERARCHY_BOUNDS_EVENT_MASK) != 0 && hierarchyBoundsListener == null && (eventMask &
              AWTEvent.HIERARCHY_BOUNDS_EVENT_MASK) != 0) {
                notifyAncestors |= AWTEvent.HIERARCHY_BOUNDS_EVENT_MASK;}
            eventMask &= ~ eventsToDisable;}
        if (notifyAncestors != 0) {
            synchronized (getTreeLock ()) {
                adjustListeningChildrenOnParent (notifyAncestors, - 1);}
        }
    }

    transient EventQueueItem [] eventCache;
    transient private boolean coalescingEnabled = checkCoalescing ();
    private static final Map < Class < ? >, Boolean > coalesceMap = new java.util.WeakHashMap < Class < ? >, Boolean > ();
    private boolean checkCoalescing () {
        if (getClass ().getClassLoader () == null) {
            return false;
        }
        final Class < ? extends Component > clazz = getClass ();
        synchronized (coalesceMap) {
            Boolean value = coalesceMap.get (clazz);
            if (value != null) {
                return value;
            }
            Boolean enabled = java.security.AccessController.doPrivileged (new java.security.PrivilegedAction < Boolean > () {
                public Boolean run () {
                    return isCoalesceEventsOverriden (clazz);
                }

            }

            );
            coalesceMap.put (clazz, enabled); return enabled;
        }
    }

    private static final Class [] coalesceEventsParams = {AWTEvent.class, AWTEvent.class};
    private static boolean isCoalesceEventsOverriden (Class clazz) {
        assert Thread.holdsLock (coalesceMap);
        Class superclass = clazz.getSuperclass ();
        if (superclass == null) {
            return false;
        }
        if (superclass.getClassLoader () != null) {
            Boolean value = coalesceMap.get (superclass);
            if (value == null) {
                if (isCoalesceEventsOverriden (superclass)) {
                    coalesceMap.put (superclass, true); return true;
                }
            } else if (value) {
                return true;
            }

        }
        try {
            clazz.getDeclaredMethod ("coalesceEvents", coalesceEventsParams); return true;
        } catch (NoSuchMethodException e) {
            return false;
        }
    }

    final boolean isCoalescingEnabled () {
        return coalescingEnabled;
    }

    protected AWTEvent coalesceEvents (AWTEvent existingEvent, AWTEvent newEvent) {
        return null;
    }

    protected void processEvent (AWTEvent e) {
        if (e instanceof FocusEvent) {
            processFocusEvent ((FocusEvent) e);} else if (e instanceof MouseEvent) {
            switch (e.getID ()) {
                case MouseEvent.MOUSE_PRESSED :
                case MouseEvent.MOUSE_RELEASED :
                case MouseEvent.MOUSE_CLICKED :
                case MouseEvent.MOUSE_ENTERED :
                case MouseEvent.MOUSE_EXITED :
                    processMouseEvent ((MouseEvent) e); break;
                case MouseEvent.MOUSE_MOVED :
                case MouseEvent.MOUSE_DRAGGED :
                    processMouseMotionEvent ((MouseEvent) e); break;
                case MouseEvent.MOUSE_WHEEL :
                    processMouseWheelEvent ((MouseWheelEvent) e); break;
            }
        } else if (e instanceof KeyEvent) {
            processKeyEvent ((KeyEvent) e);} else if (e instanceof ComponentEvent) {
            processComponentEvent ((ComponentEvent) e);} else if (e instanceof InputMethodEvent) {
            processInputMethodEvent ((InputMethodEvent) e);} else if (e instanceof HierarchyEvent) {
            switch (e.getID ()) {
                case HierarchyEvent.HIERARCHY_CHANGED :
                    processHierarchyEvent ((HierarchyEvent) e); break;
                case HierarchyEvent.ANCESTOR_MOVED :
                case HierarchyEvent.ANCESTOR_RESIZED :
                    processHierarchyBoundsEvent ((HierarchyEvent) e); break;
            }
        }

    }

    protected void processComponentEvent (ComponentEvent e) {
        ComponentListener listener = componentListener;
        if (listener != null) {
            int id = e.getID ();
            switch (id) {
                case ComponentEvent.COMPONENT_RESIZED :
                    listener.componentResized (e); break;
                case ComponentEvent.COMPONENT_MOVED :
                    listener.componentMoved (e); break;
                case ComponentEvent.COMPONENT_SHOWN :
                    listener.componentShown (e); break;
                case ComponentEvent.COMPONENT_HIDDEN :
                    listener.componentHidden (e); break;
            }
        }
    }

    protected void processFocusEvent (FocusEvent e) {
        FocusListener listener = focusListener;
        if (listener != null) {
            int id = e.getID ();
            switch (id) {
                case FocusEvent.FOCUS_GAINED :
                    listener.focusGained (e); break;
                case FocusEvent.FOCUS_LOST :
                    listener.focusLost (e); break;
            }
        }
    }

    protected void processKeyEvent (KeyEvent e) {
        KeyListener listener = keyListener;
        if (listener != null) {
            int id = e.getID ();
            switch (id) {
                case KeyEvent.KEY_TYPED :
                    listener.keyTyped (e); break;
                case KeyEvent.KEY_PRESSED :
                    listener.keyPressed (e); break;
                case KeyEvent.KEY_RELEASED :
                    listener.keyReleased (e); break;
            }
        }
    }

    protected void processMouseEvent (MouseEvent e) {
        MouseListener listener = mouseListener;
        if (listener != null) {
            int id = e.getID ();
            switch (id) {
                case MouseEvent.MOUSE_PRESSED :
                    listener.mousePressed (e); break;
                case MouseEvent.MOUSE_RELEASED :
                    listener.mouseReleased (e); break;
                case MouseEvent.MOUSE_CLICKED :
                    listener.mouseClicked (e); break;
                case MouseEvent.MOUSE_EXITED :
                    listener.mouseExited (e); break;
                case MouseEvent.MOUSE_ENTERED :
                    listener.mouseEntered (e); break;
            }
        }
    }

    protected void processMouseMotionEvent (MouseEvent e) {
        MouseMotionListener listener = mouseMotionListener;
        if (listener != null) {
            int id = e.getID ();
            switch (id) {
                case MouseEvent.MOUSE_MOVED :
                    listener.mouseMoved (e); break;
                case MouseEvent.MOUSE_DRAGGED :
                    listener.mouseDragged (e); break;
            }
        }
    }

    protected void processMouseWheelEvent (MouseWheelEvent e) {
        MouseWheelListener listener = mouseWheelListener;
        if (listener != null) {
            int id = e.getID ();
            switch (id) {
                case MouseEvent.MOUSE_WHEEL :
                    listener.mouseWheelMoved (e); break;
            }
        }
    }

    boolean postsOldMouseEvents () {
        return false;
    }

    protected void processInputMethodEvent (InputMethodEvent e) {
        InputMethodListener listener = inputMethodListener;
        if (listener != null) {
            int id = e.getID ();
            switch (id) {
                case InputMethodEvent.INPUT_METHOD_TEXT_CHANGED :
                    listener.inputMethodTextChanged (e); break;
                case InputMethodEvent.CARET_POSITION_CHANGED :
                    listener.caretPositionChanged (e); break;
            }
        }
    }

    protected void processHierarchyEvent (HierarchyEvent e) {
        HierarchyListener listener = hierarchyListener;
        if (listener != null) {
            int id = e.getID ();
            switch (id) {
                case HierarchyEvent.HIERARCHY_CHANGED :
                    listener.hierarchyChanged (e); break;
            }
        }
    }

    protected void processHierarchyBoundsEvent (HierarchyEvent e) {
        HierarchyBoundsListener listener = hierarchyBoundsListener;
        if (listener != null) {
            int id = e.getID ();
            switch (id) {
                case HierarchyEvent.ANCESTOR_MOVED :
                    listener.ancestorMoved (e); break;
                case HierarchyEvent.ANCESTOR_RESIZED :
                    listener.ancestorResized (e); break;
            }
        }
    }

    @Deprecated
    public boolean handleEvent (Event evt) {
        switch (evt.id) {
            case Event.MOUSE_ENTER :
                return mouseEnter (evt, evt.x, evt.y);
            case Event.MOUSE_EXIT :
                return mouseExit (evt, evt.x, evt.y);
            case Event.MOUSE_MOVE :
                return mouseMove (evt, evt.x, evt.y);
            case Event.MOUSE_DOWN :
                return mouseDown (evt, evt.x, evt.y);
            case Event.MOUSE_DRAG :
                return mouseDrag (evt, evt.x, evt.y);
            case Event.MOUSE_UP :
                return mouseUp (evt, evt.x, evt.y);
            case Event.KEY_PRESS :
            case Event.KEY_ACTION :
                return keyDown (evt, evt.key);
            case Event.KEY_RELEASE :
            case Event.KEY_ACTION_RELEASE :
                return keyUp (evt, evt.key);
            case Event.ACTION_EVENT :
                return action (evt, evt.arg);
            case Event.GOT_FOCUS :
                return gotFocus (evt, evt.arg);
            case Event.LOST_FOCUS :
                return lostFocus (evt, evt.arg);
        }
        return false;
    }

    @Deprecated
    public boolean mouseDown (Event evt, int x, int y) {
        return false;
    }

    @Deprecated
    public boolean mouseDrag (Event evt, int x, int y) {
        return false;
    }

    @Deprecated
    public boolean mouseUp (Event evt, int x, int y) {
        return false;
    }

    @Deprecated
    public boolean mouseMove (Event evt, int x, int y) {
        return false;
    }

    @Deprecated
    public boolean mouseEnter (Event evt, int x, int y) {
        return false;
    }

    @Deprecated
    public boolean mouseExit (Event evt, int x, int y) {
        return false;
    }

    @Deprecated
    public boolean keyDown (Event evt, int key) {
        return false;
    }

    @Deprecated
    public boolean keyUp (Event evt, int key) {
        return false;
    }

    @Deprecated
    public boolean action (Event evt, Object what) {
        return false;
    }

    public void addNotify () {
        synchronized (getTreeLock ()) {
            ComponentPeer peer = this.peer;
            if (peer == null || peer instanceof LightweightPeer) {
                if (peer == null) {
                    this.peer = peer = getToolkit ().createComponent (this);}
                if (parent != null) {
                    long mask = 0;
                    if ((mouseListener != null) || ((eventMask & AWTEvent.MOUSE_EVENT_MASK) != 0)) {
                        mask |= AWTEvent.MOUSE_EVENT_MASK;}
                    if ((mouseMotionListener != null) || ((eventMask & AWTEvent.MOUSE_MOTION_EVENT_MASK) != 0)) {
                        mask |= AWTEvent.MOUSE_MOTION_EVENT_MASK;}
                    if ((mouseWheelListener != null) || ((eventMask & AWTEvent.MOUSE_WHEEL_EVENT_MASK) != 0)) {
                        mask |= AWTEvent.MOUSE_WHEEL_EVENT_MASK;}
                    if (focusListener != null || (eventMask & AWTEvent.FOCUS_EVENT_MASK) != 0) {
                        mask |= AWTEvent.FOCUS_EVENT_MASK;}
                    if (keyListener != null || (eventMask & AWTEvent.KEY_EVENT_MASK) != 0) {
                        mask |= AWTEvent.KEY_EVENT_MASK;}
                    if (mask != 0) {
                        parent.proxyEnableEvents (mask);}
                }
            } else {
                Container parent = this.parent;
                if (parent != null && parent.peer instanceof LightweightPeer) {
                    nativeInLightFixer = new NativeInLightFixer ();}
            }
            invalidate (); int npopups = (popups != null ? popups.size () : 0);
            for (int i = 0;
            i < npopups; i ++) {
                PopupMenu popup = (PopupMenu) popups.elementAt (i);
                popup.addNotify ();}
            if (dropTarget != null) dropTarget.addNotify (peer);
            peerFont = getFont (); if (parent != null && parent.peer != null) {
                ContainerPeer parentContPeer = (ContainerPeer) parent.peer;
                if (parentContPeer instanceof LightweightPeer && ! (peer instanceof LightweightPeer)) {
                    Container hwParent = getNativeContainer ();
                    if (hwParent != null && hwParent.peer != null) {
                        parentContPeer = (ContainerPeer) hwParent.peer;}
                }
                if (parentContPeer.isRestackSupported ()) {
                    parentContPeer.restack ();}
            }
            if (hierarchyListener != null || (eventMask & AWTEvent.HIERARCHY_EVENT_MASK) != 0 || Toolkit.enabledOnToolkit (
              AWTEvent.HIERARCHY_EVENT_MASK)) {
                HierarchyEvent e = new HierarchyEvent (this, HierarchyEvent.HIERARCHY_CHANGED, this, parent, HierarchyEvent.
                  DISPLAYABILITY_CHANGED | ((isRecursivelyVisible ()) ? HierarchyEvent.SHOWING_CHANGED : 0));
                dispatchEvent (e);}
        }
    }

    public void removeNotify () {
        KeyboardFocusManager.clearMostRecentFocusOwner (this); if (KeyboardFocusManager.getCurrentKeyboardFocusManager ().
          getPermanentFocusOwner () == this) {
            KeyboardFocusManager.getCurrentKeyboardFocusManager ().setGlobalPermanentFocusOwner (null);}
        synchronized (getTreeLock ()) {
            if (isFocusOwner () && KeyboardFocusManager.isAutoFocusTransferEnabled () && ! nextFocusHelper ()) {
                KeyboardFocusManager.getCurrentKeyboardFocusManager ().clearGlobalFocusOwner ();}
            int npopups = (popups != null ? popups.size () : 0);
            for (int i = 0;
            i < npopups; i ++) {
                PopupMenu popup = (PopupMenu) popups.elementAt (i);
                popup.removeNotify ();}
            if ((eventMask & AWTEvent.INPUT_METHODS_ENABLED_MASK) != 0) {
                InputContext inputContext = getInputContext ();
                if (inputContext != null) {
                    inputContext.removeNotify (this);}
            }
            if (nativeInLightFixer != null) {
                nativeInLightFixer.uninstall ();}
            ComponentPeer p = peer;
            if (p != null) {
                if (bufferStrategy instanceof FlipBufferStrategy) {
                    ((FlipBufferStrategy) bufferStrategy).destroyBuffers ();}
                if (dropTarget != null) dropTarget.removeNotify (peer);
                if (visible) {
                    p.hide ();}
                peer = null; peerFont = null; Toolkit.getEventQueue ().removeSourceEvents (this, false); KeyboardFocusManager.
                  getCurrentKeyboardFocusManager ().discardKeyEvents (this); p.dispose ();}
            if (hierarchyListener != null || (eventMask & AWTEvent.HIERARCHY_EVENT_MASK) != 0 || Toolkit.enabledOnToolkit (
              AWTEvent.HIERARCHY_EVENT_MASK)) {
                HierarchyEvent e = new HierarchyEvent (this, HierarchyEvent.HIERARCHY_CHANGED, this, parent, HierarchyEvent.
                  DISPLAYABILITY_CHANGED | ((isRecursivelyVisible ()) ? HierarchyEvent.SHOWING_CHANGED : 0));
                dispatchEvent (e);}
        }
    }

    @Deprecated
    public boolean gotFocus (Event evt, Object what) {
        return false;
    }

    @Deprecated
    public boolean lostFocus (Event evt, Object what) {
        return false;
    }

    @Deprecated
    public boolean isFocusTraversable () {
        if (isFocusTraversableOverridden == FOCUS_TRAVERSABLE_UNKNOWN) {
            isFocusTraversableOverridden = FOCUS_TRAVERSABLE_DEFAULT;}
        return focusable;
    }

    public boolean isFocusable () {
        return isFocusTraversable ();
    }

    public void setFocusable (boolean focusable) {
        boolean oldFocusable;
        synchronized (this) {
            oldFocusable = this.focusable; this.focusable = focusable;}
        isFocusTraversableOverridden = FOCUS_TRAVERSABLE_SET; firePropertyChange ("focusable", oldFocusable, focusable); if (
          oldFocusable && ! focusable) {
            if (isFocusOwner ()) {
                autoTransferFocus (true);}
            KeyboardFocusManager.clearMostRecentFocusOwner (this);}
    }

    final boolean isFocusTraversableOverridden () {
        return (isFocusTraversableOverridden != FOCUS_TRAVERSABLE_DEFAULT);
    }

    public void setFocusTraversalKeys (int id, Set < ? extends AWTKeyStroke > keystrokes) {
        if (id < 0 || id >= KeyboardFocusManager.TRAVERSAL_KEY_LENGTH - 1) {
            throw new IllegalArgumentException ("invalid focus traversal key identifier");
        }
        setFocusTraversalKeys_NoIDCheck (id, keystrokes);}

    public Set < AWTKeyStroke > getFocusTraversalKeys (int id) {
        if (id < 0 || id >= KeyboardFocusManager.TRAVERSAL_KEY_LENGTH - 1) {
            throw new IllegalArgumentException ("invalid focus traversal key identifier");
        }
        return getFocusTraversalKeys_NoIDCheck (id);
    }

    final void setFocusTraversalKeys_NoIDCheck (int id, Set < ? extends AWTKeyStroke > keystrokes) {
        Set oldKeys;
        synchronized (this) {
            if (focusTraversalKeys == null) {
                initializeFocusTraversalKeys ();}
            if (keystrokes != null) {
                for (Iterator iter = keystrokes.iterator ();
                iter.hasNext ();) {
                    Object obj = iter.next ();
                    if (obj == null) {
                        throw new IllegalArgumentException ("cannot set null focus traversal key");
                    }
                    if (! (obj instanceof AWTKeyStroke)) {
                        throw new IllegalArgumentException ("object is expected to be AWTKeyStroke");
                    }
                    AWTKeyStroke keystroke = (AWTKeyStroke) obj;
                    if (keystroke.getKeyChar () != KeyEvent.CHAR_UNDEFINED) {
                        throw new IllegalArgumentException ("focus traversal keys cannot map to KEY_TYPED events");
                    }
                    for (int i = 0;
                    i < focusTraversalKeys.length; i ++) {
                        if (i == id) {
                            continue;
                        }
                        if (getFocusTraversalKeys_NoIDCheck (i).contains (keystroke)) {
                            throw new IllegalArgumentException ("focus traversal keys must be unique for a Component");
                        }
                    }
                }
            }
            oldKeys = focusTraversalKeys [id]; focusTraversalKeys [id] = (keystrokes != null) ? Collections.unmodifiableSet (
              new HashSet (keystrokes)) : null;}
        firePropertyChange (focusTraversalKeyPropertyNames [id], oldKeys, keystrokes);}

    final Set getFocusTraversalKeys_NoIDCheck (int id) {
        Set keystrokes = (focusTraversalKeys != null) ? focusTraversalKeys [id] : null;
        if (keystrokes != null) {
            return keystrokes;
        } else {
            Container parent = this.parent;
            if (parent != null) {
                return parent.getFocusTraversalKeys (id);
            } else {
                return KeyboardFocusManager.getCurrentKeyboardFocusManager ().getDefaultFocusTraversalKeys (id);
            }
        }
    }

    public boolean areFocusTraversalKeysSet (int id) {
        if (id < 0 || id >= KeyboardFocusManager.TRAVERSAL_KEY_LENGTH - 1) {
            throw new IllegalArgumentException ("invalid focus traversal key identifier");
        }
        return (focusTraversalKeys != null && focusTraversalKeys [id] != null);
    }

    public void setFocusTraversalKeysEnabled (boolean focusTraversalKeysEnabled) {
        boolean oldFocusTraversalKeysEnabled;
        synchronized (this) {
            oldFocusTraversalKeysEnabled = this.focusTraversalKeysEnabled; this.focusTraversalKeysEnabled =
              focusTraversalKeysEnabled;}
        firePropertyChange ("focusTraversalKeysEnabled", oldFocusTraversalKeysEnabled, focusTraversalKeysEnabled);}

    public boolean getFocusTraversalKeysEnabled () {
        return focusTraversalKeysEnabled;
    }

    public void requestFocus () {
        requestFocusHelper (false, true);}

    void requestFocus (CausedFocusEvent.Cause cause) {
        requestFocusHelper (false, true, cause);}

    protected boolean requestFocus (boolean temporary) {
        return requestFocusHelper (temporary, true);
    }

    boolean requestFocus (boolean temporary, CausedFocusEvent.Cause cause) {
        return requestFocusHelper (temporary, true, cause);
    }

    public boolean requestFocusInWindow () {
        return requestFocusHelper (false, false);
    }

    boolean requestFocusInWindow (CausedFocusEvent.Cause cause) {
        return requestFocusHelper (false, false, cause);
    }

    protected boolean requestFocusInWindow (boolean temporary) {
        return requestFocusHelper (temporary, false);
    }

    boolean requestFocusInWindow (boolean temporary, CausedFocusEvent.Cause cause) {
        return requestFocusHelper (temporary, false, cause);
    }

    final boolean requestFocusHelper (boolean temporary, boolean focusedWindowChangeAllowed) {
        return requestFocusHelper (temporary, focusedWindowChangeAllowed, CausedFocusEvent.Cause.UNKNOWN);
    }

    final boolean requestFocusHelper (boolean temporary, boolean focusedWindowChangeAllowed, CausedFocusEvent.Cause cause) {
        if (! isRequestFocusAccepted (temporary, focusedWindowChangeAllowed, cause)) {
            focusLog.finest ("requestFocus is not accepted"); return false;
        }
        KeyboardFocusManager.setMostRecentFocusOwner (this); Component window = this;
        while ((window != null) && ! (window instanceof Window)) {
            if (! window.isVisible ()) {
                focusLog.finest ("component is recurively invisible"); return false;
            }
            window = window.parent;} ComponentPeer peer = this.peer;
        Component heavyweight = (peer instanceof LightweightPeer) ? getNativeContainer () : this;
        if (heavyweight == null || ! heavyweight.isVisible ()) {
            focusLog.finest ("Component is not a part of visible hierarchy"); return false;
        }
        peer = heavyweight.peer; if (peer == null) {
            focusLog.finest ("Peer is null"); return false;
        }
        long time = EventQueue.getMostRecentEventTime ();
        boolean success = peer.requestFocus (this, temporary, focusedWindowChangeAllowed, time, cause);
        if (! success) {
            KeyboardFocusManager.getCurrentKeyboardFocusManager (appContext).dequeueKeyEvents (time, this); focusLog.finest (
              "Peer request failed");} else {
            if (focusLog.isLoggable (Level.FINEST)) focusLog.finest ("Pass for " + this);
        }
        return success;
    }

    private boolean isRequestFocusAccepted (boolean temporary, boolean focusedWindowChangeAllowed, CausedFocusEvent.Cause cause
      ) {
        if (! isFocusable () || ! isVisible ()) {
            focusLog.finest ("Not focusable or not visible"); return false;
        }
        ComponentPeer peer = this.peer;
        if (peer == null) {
            focusLog.finest ("peer is null"); return false;
        }
        Window window = getContainingWindow ();
        if (window == null || ! ((Window) window).isFocusableWindow ()) {
            focusLog.finest ("Component doesn't have toplevel"); return false;
        }
        Component focusOwner = KeyboardFocusManager.getMostRecentFocusOwner (window);
        if (focusOwner == null) {
            focusOwner = KeyboardFocusManager.getCurrentKeyboardFocusManager ().getFocusOwner (); if (focusOwner != null &&
              getContainingWindow (focusOwner) != window) {
                focusOwner = null;}
        }
        if (focusOwner == this || focusOwner == null) {
            focusLog.finest ("focus owner is null or this"); return true;
        }
        if (CausedFocusEvent.Cause.ACTIVATION == cause) {
            focusLog.finest ("cause is activation"); return true;
        }
        boolean ret = Component.requestFocusController.acceptRequestFocus (focusOwner, this, temporary,
          focusedWindowChangeAllowed, cause);
        if (focusLog.isLoggable (Level.FINEST)) {
            focusLog.log (Level.FINEST, "RequestFocusController returns {0}", ret);}
        return ret;
    }

    private static RequestFocusController requestFocusController = new DummyRequestFocusController ();
    private static class DummyRequestFocusController implements RequestFocusController {
        public boolean acceptRequestFocus (Component from, Component to, boolean temporary, boolean focusedWindowChangeAllowed,
          CausedFocusEvent.Cause cause) {
            return true;
        }

    };

    synchronized static void setRequestFocusController (RequestFocusController requestController) {
        if (requestController == null) {
            requestFocusController = new DummyRequestFocusController ();} else {
            requestFocusController = requestController;}
    }

    private void autoTransferFocus (boolean clearOnFailure) {
        Component toTest = KeyboardFocusManager.getCurrentKeyboardFocusManager ().getFocusOwner ();
        if (toTest != this) {
            if (toTest != null) {
                toTest.autoTransferFocus (clearOnFailure);}
            return;
        }
        if (! KeyboardFocusManager.isAutoFocusTransferEnabled ()) {
            return;
        }
        if (! (isDisplayable () && isVisible () && isEnabled () && isFocusable ())) {
            doAutoTransfer (clearOnFailure); return;
        }
        toTest = getParent (); while (toTest != null && ! (toTest instanceof Window)) {
            if (! (toTest.isDisplayable () && toTest.isVisible () && (toTest.isEnabled () || toTest.isLightweight ()))) {
                doAutoTransfer (clearOnFailure); return;
            }
            toTest = toTest.getParent ();}}

    private void doAutoTransfer (boolean clearOnFailure) {
        if (focusLog.isLoggable (Level.FINER)) {
            focusLog.log (Level.FINER, "this = " + this + ", clearOnFailure = " + clearOnFailure);}
        if (clearOnFailure) {
            if (! nextFocusHelper ()) {
                if (focusLog.isLoggable (Level.FINER)) {
                    focusLog.log (Level.FINER, "clear global focus owner");}
                KeyboardFocusManager.getCurrentKeyboardFocusManager ().clearGlobalFocusOwner ();}
        } else {
            transferFocus ();}
    }

    public void transferFocus () {
        nextFocus ();}

    public Container getFocusCycleRootAncestor () {
        Container rootAncestor = this.parent;
        while (rootAncestor != null && ! rootAncestor.isFocusCycleRoot ()) {
            rootAncestor = rootAncestor.parent;} return rootAncestor;
    }

    public boolean isFocusCycleRoot (Container container) {
        Container rootAncestor = getFocusCycleRootAncestor ();
        return (rootAncestor == container);
    }

    @Deprecated
    public void nextFocus () {
        nextFocusHelper ();}

    private boolean nextFocusHelper () {
        Component toFocus = preNextFocusHelper ();
        if (focusLog.isLoggable (Level.FINER)) {
            focusLog.log (Level.FINER, "toFocus = " + toFocus);}
        if (isFocusOwner () && toFocus == this) {
            return false;
        }
        return postNextFocusHelper (toFocus, CausedFocusEvent.Cause.TRAVERSAL_FORWARD);
    }

    Container getTraversalRoot () {
        return getFocusCycleRootAncestor ();
    }

    final Component preNextFocusHelper () {
        Container rootAncestor = getTraversalRoot ();
        Component comp = this;
        while (rootAncestor != null && ! (rootAncestor.isShowing () && rootAncestor.isFocusable () && rootAncestor.isEnabled ()
          )) {
            comp = rootAncestor; rootAncestor = comp.getFocusCycleRootAncestor ();} if (focusLog.isLoggable (Level.FINER)) {
            focusLog.log (Level.FINER, "comp = " + comp + ", root = " + rootAncestor);}
        if (rootAncestor != null) {
            FocusTraversalPolicy policy = rootAncestor.getFocusTraversalPolicy ();
            Component toFocus = policy.getComponentAfter (rootAncestor, comp);
            if (focusLog.isLoggable (Level.FINER)) {
                focusLog.log (Level.FINER, "component after is " + toFocus);}
            if (toFocus == null) {
                toFocus = policy.getDefaultComponent (rootAncestor); if (focusLog.isLoggable (Level.FINER)) {
                    focusLog.log (Level.FINER, "default component is " + toFocus);}
            }
            if (toFocus == null) {
                Applet applet = EmbeddedFrame.getAppletIfAncestorOf (this);
                if (applet != null) {
                    toFocus = applet;}
            }
            return toFocus;
        }
        return null;
    }

    static boolean postNextFocusHelper (Component toFocus, CausedFocusEvent.Cause cause) {
        if (toFocus != null) {
            if (focusLog.isLoggable (Level.FINER)) focusLog.finer ("Next component " + toFocus);
            boolean res = toFocus.requestFocusInWindow (cause);
            if (focusLog.isLoggable (Level.FINER)) focusLog.finer ("Request focus returned " + res);
            return res;
        }
        return false;
    }

    public void transferFocusBackward () {
        Container rootAncestor = getTraversalRoot ();
        Component comp = this;
        while (rootAncestor != null && ! (rootAncestor.isShowing () && rootAncestor.isFocusable () && rootAncestor.isEnabled ()
          )) {
            comp = rootAncestor; rootAncestor = comp.getFocusCycleRootAncestor ();} if (rootAncestor != null) {
            FocusTraversalPolicy policy = rootAncestor.getFocusTraversalPolicy ();
            Component toFocus = policy.getComponentBefore (rootAncestor, comp);
            if (toFocus == null) {
                toFocus = policy.getDefaultComponent (rootAncestor);}
            if (toFocus != null) {
                toFocus.requestFocusInWindow (CausedFocusEvent.Cause.TRAVERSAL_BACKWARD);}
        }
    }

    public void transferFocusUpCycle () {
        Container rootAncestor;
        for (rootAncestor = getFocusCycleRootAncestor (); rootAncestor != null && ! (rootAncestor.isShowing () && rootAncestor.
          isFocusable () && rootAncestor.isEnabled ()); rootAncestor = rootAncestor.getFocusCycleRootAncestor ()) {
        }
        if (rootAncestor != null) {
            Container rootAncestorRootAncestor = rootAncestor.getFocusCycleRootAncestor ();
            KeyboardFocusManager.getCurrentKeyboardFocusManager ().setGlobalCurrentFocusCycleRoot ((rootAncestorRootAncestor !=
              null) ? rootAncestorRootAncestor : rootAncestor); rootAncestor.requestFocus (CausedFocusEvent.Cause.TRAVERSAL_UP)
              ;} else {
            Window window = getContainingWindow ();
            if (window != null) {
                Component toFocus = window.getFocusTraversalPolicy ().getDefaultComponent (window);
                if (toFocus != null) {
                    KeyboardFocusManager.getCurrentKeyboardFocusManager ().setGlobalCurrentFocusCycleRoot (window); toFocus.
                      requestFocus (CausedFocusEvent.Cause.TRAVERSAL_UP);}
            }
        }
    }

    public boolean hasFocus () {
        return (KeyboardFocusManager.getCurrentKeyboardFocusManager ().getFocusOwner () == this);
    }

    public boolean isFocusOwner () {
        return hasFocus ();
    }

    public void add (PopupMenu popup) {
        synchronized (getTreeLock ()) {
            if (popup.parent != null) {
                popup.parent.remove (popup);}
            if (popups == null) {
                popups = new Vector ();}
            popups.addElement (popup); popup.parent = this; if (peer != null) {
                if (popup.peer == null) {
                    popup.addNotify ();}
            }
        }
    }

    public void remove (MenuComponent popup) {
        synchronized (getTreeLock ()) {
            if (popups == null) {
                return;
            }
            int index = popups.indexOf (popup);
            if (index >= 0) {
                PopupMenu pmenu = (PopupMenu) popup;
                if (pmenu.peer != null) {
                    pmenu.removeNotify ();}
                pmenu.parent = null; popups.removeElementAt (index); if (popups.size () == 0) {
                    popups = null;}
            }
        }
    }

    protected String paramString () {
        String thisName = getName ();
        String str = (thisName != null ? thisName : "") + "," + x + "," + y + "," + width + "x" + height;
        if (! valid) {
            str += ",invalid";}
        if (! visible) {
            str += ",hidden";}
        if (! enabled) {
            str += ",disabled";}
        return str;
    }

    public String toString () {
        return getClass ().getName () + "[" + paramString () + "]";
    }

    public void list () {
        list (System.out, 0);}

    public void list (PrintStream out) {
        list (out, 0);}

    public void list (PrintStream out, int indent) {
        for (int i = 0;
        i < indent; i ++) {
            out.print (" ");}
        out.println (this);}

    public void list (PrintWriter out) {
        list (out, 0);}

    public void list (PrintWriter out, int indent) {
        for (int i = 0;
        i < indent; i ++) {
            out.print (" ");}
        out.println (this);}

    Container getNativeContainer () {
        Container p = parent;
        while (p != null && p.peer instanceof LightweightPeer) {
            p = p.getParent ();} return p;
    }

    public synchronized void addPropertyChangeListener (PropertyChangeListener listener) {
        if (listener == null) {
            return;
        }
        if (changeSupport == null) {
            changeSupport = new PropertyChangeSupport (this);}
        changeSupport.addPropertyChangeListener (listener);}

    public synchronized void removePropertyChangeListener (PropertyChangeListener listener) {
        if (listener == null || changeSupport == null) {
            return;
        }
        changeSupport.removePropertyChangeListener (listener);}

    public synchronized PropertyChangeListener [] getPropertyChangeListeners () {
        if (changeSupport == null) {
            return new PropertyChangeListener [0];
        }
        return changeSupport.getPropertyChangeListeners ();
    }

    public synchronized void addPropertyChangeListener (String propertyName, PropertyChangeListener listener) {
        if (listener == null) {
            return;
        }
        if (changeSupport == null) {
            changeSupport = new PropertyChangeSupport (this);}
        changeSupport.addPropertyChangeListener (propertyName, listener);}

    public synchronized void removePropertyChangeListener (String propertyName, PropertyChangeListener listener) {
        if (listener == null || changeSupport == null) {
            return;
        }
        changeSupport.removePropertyChangeListener (propertyName, listener);}

    public synchronized PropertyChangeListener [] getPropertyChangeListeners (String propertyName) {
        if (changeSupport == null) {
            return new PropertyChangeListener [0];
        }
        return changeSupport.getPropertyChangeListeners (propertyName);
    }

    protected void firePropertyChange (String propertyName, Object oldValue, Object newValue) {
        PropertyChangeSupport changeSupport = this.changeSupport;
        if (changeSupport == null || (oldValue != null && newValue != null && oldValue.equals (newValue))) {
            return;
        }
        changeSupport.firePropertyChange (propertyName, oldValue, newValue);}

    protected void firePropertyChange (String propertyName, boolean oldValue, boolean newValue) {
        PropertyChangeSupport changeSupport = this.changeSupport;
        if (changeSupport == null || oldValue == newValue) {
            return;
        }
        changeSupport.firePropertyChange (propertyName, oldValue, newValue);}

    protected void firePropertyChange (String propertyName, int oldValue, int newValue) {
        PropertyChangeSupport changeSupport = this.changeSupport;
        if (changeSupport == null || oldValue == newValue) {
            return;
        }
        changeSupport.firePropertyChange (propertyName, oldValue, newValue);}

    public void firePropertyChange (String propertyName, byte oldValue, byte newValue) {
        if (changeSupport == null || oldValue == newValue) {
            return;
        }
        firePropertyChange (propertyName, Byte.valueOf (oldValue), Byte.valueOf (newValue));}

    public void firePropertyChange (String propertyName, char oldValue, char newValue) {
        if (changeSupport == null || oldValue == newValue) {
            return;
        }
        firePropertyChange (propertyName, new Character (oldValue), new Character (newValue));}

    public void firePropertyChange (String propertyName, short oldValue, short newValue) {
        if (changeSupport == null || oldValue == newValue) {
            return;
        }
        firePropertyChange (propertyName, Short.valueOf (oldValue), Short.valueOf (newValue));}

    public void firePropertyChange (String propertyName, long oldValue, long newValue) {
        if (changeSupport == null || oldValue == newValue) {
            return;
        }
        firePropertyChange (propertyName, Long.valueOf (oldValue), Long.valueOf (newValue));}

    public void firePropertyChange (String propertyName, float oldValue, float newValue) {
        if (changeSupport == null || oldValue == newValue) {
            return;
        }
        firePropertyChange (propertyName, Float.valueOf (oldValue), Float.valueOf (newValue));}

    public void firePropertyChange (String propertyName, double oldValue, double newValue) {
        if (changeSupport == null || oldValue == newValue) {
            return;
        }
        firePropertyChange (propertyName, Double.valueOf (oldValue), Double.valueOf (newValue));}

    private int componentSerializedDataVersion = 4;
    private void doSwingSerialization () {
        Package swingPackage = Package.getPackage ("javax.swing");
        for (Class klass = Component.this.getClass ();
        klass != null; klass = klass.getSuperclass ()) {
            if (klass.getPackage () == swingPackage && klass.getClassLoader () == null) {
                final Class swingClass = klass;
                Method [] methods = (Method []) AccessController.doPrivileged (new PrivilegedAction () {
                    public Object run () {
                        return swingClass.getDeclaredMethods ();
                    }

                }

                );
                for (int counter = methods.length - 1;
                counter >= 0; counter --) {
                    final Method method = methods [counter];
                    if (method.getName ().equals ("compWriteObjectNotify")) {
                        AccessController.doPrivileged (new PrivilegedAction () {
                            public Object run () {
                                method.setAccessible (true); return null;
                            }

                        }

                        ); try {
                            method.invoke (this, (Object []) null);} catch (IllegalAccessException iae) {
                        } catch (InvocationTargetException ite) {
                        }
                        return;
                    }
                }
            }
        }
    }

    private void writeObject (ObjectOutputStream s) throws IOException {
        doSwingSerialization (); s.defaultWriteObject (); AWTEventMulticaster.save (s, componentListenerK, componentListener);
          AWTEventMulticaster.save (s, focusListenerK, focusListener); AWTEventMulticaster.save (s, keyListenerK, keyListener);
          AWTEventMulticaster.save (s, mouseListenerK, mouseListener); AWTEventMulticaster.save (s, mouseMotionListenerK,
          mouseMotionListener); AWTEventMulticaster.save (s, inputMethodListenerK, inputMethodListener); s.writeObject (null); s
          .writeObject (componentOrientation); AWTEventMulticaster.save (s, hierarchyListenerK, hierarchyListener);
          AWTEventMulticaster.save (s, hierarchyBoundsListenerK, hierarchyBoundsListener); s.writeObject (null);
          AWTEventMulticaster.save (s, mouseWheelListenerK, mouseWheelListener); s.writeObject (null);}

    private void readObject (ObjectInputStream s) throws ClassNotFoundException, IOException {
        s.defaultReadObject (); appContext = AppContext.getAppContext (); coalescingEnabled = checkCoalescing (); if (
          componentSerializedDataVersion < 4) {
            focusable = true; isFocusTraversableOverridden = FOCUS_TRAVERSABLE_UNKNOWN; initializeFocusTraversalKeys ();
              focusTraversalKeysEnabled = true;}
        Object keyOrNull;
        while (null != (keyOrNull = s.readObject ())) {
            String key = ((String) keyOrNull).intern ();
            if (componentListenerK == key) addComponentListener ((ComponentListener) (s.readObject ())); else if (
              focusListenerK == key) addFocusListener ((FocusListener) (s.readObject ())); else if (keyListenerK == key)
              addKeyListener ((KeyListener) (s.readObject ())); else if (mouseListenerK == key) addMouseListener ((
              MouseListener) (s.readObject ())); else if (mouseMotionListenerK == key) addMouseMotionListener ((
              MouseMotionListener) (s.readObject ())); else if (inputMethodListenerK == key) addInputMethodListener ((
              InputMethodListener) (s.readObject ())); else s.readObject ();

        } Object orient = null;
        try {
            orient = s.readObject ();} catch (java.io.OptionalDataException e) {
            if (! e.eof) {
                throw (e);
            }
        }
        if (orient != null) {
            componentOrientation = (ComponentOrientation) orient;} else {
            componentOrientation = ComponentOrientation.UNKNOWN;}
        try {
            while (null != (keyOrNull = s.readObject ())) {
                String key = ((String) keyOrNull).intern ();
                if (hierarchyListenerK == key) {
                    addHierarchyListener ((HierarchyListener) (s.readObject ()));} else if (hierarchyBoundsListenerK == key) {
                    addHierarchyBoundsListener ((HierarchyBoundsListener) (s.readObject ()));} else {
                    s.readObject ();}

            }} catch (java.io.OptionalDataException e) {
            if (! e.eof) {
                throw (e);
            }
        }
        try {
            while (null != (keyOrNull = s.readObject ())) {
                String key = ((String) keyOrNull).intern ();
                if (mouseWheelListenerK == key) {
                    addMouseWheelListener ((MouseWheelListener) (s.readObject ()));} else {
                    s.readObject ();}
            }} catch (java.io.OptionalDataException e) {
            if (! e.eof) {
                throw (e);
            }
        }
        if (popups != null) {
            int npopups = popups.size ();
            for (int i = 0;
            i < npopups; i ++) {
                PopupMenu popup = (PopupMenu) popups.elementAt (i);
                popup.parent = this;}
        }
    }

    public void setComponentOrientation (ComponentOrientation o) {
        ComponentOrientation oldValue = componentOrientation;
        componentOrientation = o; firePropertyChange ("componentOrientation", oldValue, o); if (valid) {
            invalidate ();}
    }

    public ComponentOrientation getComponentOrientation () {
        return componentOrientation;
    }

    public void applyComponentOrientation (ComponentOrientation orientation) {
        if (orientation == null) {
            throw new NullPointerException ();
        }
        setComponentOrientation (orientation);}

    transient NativeInLightFixer nativeInLightFixer;
    final boolean canBeFocusOwner () {
        if (! (isEnabled () && isDisplayable () && isVisible () && isFocusable ())) {
            return false;
        }
        synchronized (getTreeLock ()) {
            if (parent != null) {
                return parent.canContainFocusOwner (this);
            }
        }
        return true;
    }

    final class NativeInLightFixer implements ComponentListener, ContainerListener {

        NativeInLightFixer () {
            lightParents = new Vector (); install (parent);}

        void install (Container parent) {
            lightParents.clear (); Container p = parent;
            boolean isLwParentsVisible = true;
            for (; p.peer instanceof LightweightPeer; p = p.parent) {
                p.addComponentListener (this); p.addContainerListener (this); lightParents.addElement (p); isLwParentsVisible &=
                  p.isVisible ();}
            nativeHost = p; p.addContainerListener (this); componentMoved (null); if (! isLwParentsVisible) {
                synchronized (getTreeLock ()) {
                    if (peer != null) {
                        peer.hide ();}
                }
            }
        }

        void uninstall () {
            if (nativeHost != null) {
                removeReferences ();}
        }

        public void componentResized (ComponentEvent e) {
        }

        public void componentMoved (ComponentEvent e) {
            synchronized (getTreeLock ()) {
                int nativeX = x;
                int nativeY = y;
                for (Component c = parent;
                (c != null) && (c.peer instanceof LightweightPeer); c = c.parent) {
                    nativeX += c.x; nativeY += c.y;}
                if (peer != null) {
                    peer.setBounds (nativeX, nativeY, width, height, ComponentPeer.SET_LOCATION);}
            }
        }

        public void componentShown (ComponentEvent e) {
            if (shouldShow ()) {
                synchronized (getTreeLock ()) {
                    if (peer != null) {
                        peer.show ();}
                }
            }
        }

        private boolean shouldShow () {
            boolean isLwParentsVisible = visible;
            for (int i = lightParents.size () - 1;
            i >= 0 && isLwParentsVisible; i --) {
                isLwParentsVisible &= ((Container) lightParents.elementAt (i)).isVisible ();}
            return isLwParentsVisible;
        }

        public void componentHidden (ComponentEvent e) {
            if (visible) {
                synchronized (getTreeLock ()) {
                    if (peer != null) {
                        peer.hide ();}
                }
            }
        }

        public void componentAdded (ContainerEvent e) {
        }

        public void componentRemoved (ContainerEvent e) {
            Component c = e.getChild ();
            if (c == Component.this) {
                removeReferences ();} else {
                int n = lightParents.size ();
                for (int i = 0;
                i < n; i ++) {
                    Container p = (Container) lightParents.elementAt (i);
                    if (p == c) {
                        removeReferences (); break;
                    }
                }
            }
        }

        void removeReferences () {
            int n = lightParents.size ();
            for (int i = 0;
            i < n; i ++) {
                Container c = (Container) lightParents.elementAt (i);
                c.removeComponentListener (this); c.removeContainerListener (this);}
            nativeHost.removeContainerListener (this); lightParents.clear (); nativeHost = null;}

        Vector lightParents;
        Container nativeHost;
    }

    Window getContainingWindow () {
        return getContainingWindow (this);
    }

    static Window getContainingWindow (Component comp) {
        while (comp != null && ! (comp instanceof Window)) {
            comp = comp.getParent ();} return (Window) comp;
    }

    private static native void initIDs ();

    AccessibleContext accessibleContext = null;
    public AccessibleContext getAccessibleContext () {
        return accessibleContext;
    }

    protected abstract class AccessibleAWTComponent extends AccessibleContext implements Serializable, AccessibleComponent {
        private static final long serialVersionUID = 642321655757800191L;

        protected AccessibleAWTComponent () {
        }

        protected ComponentListener accessibleAWTComponentHandler = null;
        protected FocusListener accessibleAWTFocusHandler = null;
        protected class AccessibleAWTComponentHandler implements ComponentListener {
            public void componentHidden (ComponentEvent e) {
                if (accessibleContext != null) {
                    accessibleContext.firePropertyChange (AccessibleContext.ACCESSIBLE_STATE_PROPERTY, AccessibleState.VISIBLE,
                      null);}
            }

            public void componentShown (ComponentEvent e) {
                if (accessibleContext != null) {
                    accessibleContext.firePropertyChange (AccessibleContext.ACCESSIBLE_STATE_PROPERTY, null, AccessibleState.
                      VISIBLE);}
            }

            public void componentMoved (ComponentEvent e) {
            }

            public void componentResized (ComponentEvent e) {
            }

        }

        protected class AccessibleAWTFocusHandler implements FocusListener {
            public void focusGained (FocusEvent event) {
                if (accessibleContext != null) {
                    accessibleContext.firePropertyChange (AccessibleContext.ACCESSIBLE_STATE_PROPERTY, null, AccessibleState.
                      FOCUSED);}
            }

            public void focusLost (FocusEvent event) {
                if (accessibleContext != null) {
                    accessibleContext.firePropertyChange (AccessibleContext.ACCESSIBLE_STATE_PROPERTY, AccessibleState.FOCUSED,
                      null);}
            }

        }

        public void addPropertyChangeListener (PropertyChangeListener listener) {
            if (accessibleAWTComponentHandler == null) {
                accessibleAWTComponentHandler = new AccessibleAWTComponentHandler (); Component.this.addComponentListener (
                  accessibleAWTComponentHandler);}
            if (accessibleAWTFocusHandler == null) {
                accessibleAWTFocusHandler = new AccessibleAWTFocusHandler (); Component.this.addFocusListener (
                  accessibleAWTFocusHandler);}
            super.addPropertyChangeListener (listener);}

        public void removePropertyChangeListener (PropertyChangeListener listener) {
            if (accessibleAWTComponentHandler != null) {
                Component.this.removeComponentListener (accessibleAWTComponentHandler); accessibleAWTComponentHandler = null;}
            if (accessibleAWTFocusHandler != null) {
                Component.this.removeFocusListener (accessibleAWTFocusHandler); accessibleAWTFocusHandler = null;}
            super.removePropertyChangeListener (listener);}

        public String getAccessibleName () {
            return accessibleName;
        }

        public String getAccessibleDescription () {
            return accessibleDescription;
        }

        public AccessibleRole getAccessibleRole () {
            return AccessibleRole.AWT_COMPONENT;
        }

        public AccessibleStateSet getAccessibleStateSet () {
            return Component.this.getAccessibleStateSet ();
        }

        public Accessible getAccessibleParent () {
            if (accessibleParent != null) {
                return accessibleParent;
            } else {
                Container parent = getParent ();
                if (parent instanceof Accessible) {
                    return (Accessible) parent;
                }
            }
            return null;
        }

        public int getAccessibleIndexInParent () {
            return Component.this.getAccessibleIndexInParent ();
        }

        public int getAccessibleChildrenCount () {
            return 0;
        }

        public Accessible getAccessibleChild (int i) {
            return null;
        }

        public Locale getLocale () {
            return Component.this.getLocale ();
        }

        public AccessibleComponent getAccessibleComponent () {
            return this;
        }

        public Color getBackground () {
            return Component.this.getBackground ();
        }

        public void setBackground (Color c) {
            Component.this.setBackground (c);}

        public Color getForeground () {
            return Component.this.getForeground ();
        }

        public void setForeground (Color c) {
            Component.this.setForeground (c);}

        public Cursor getCursor () {
            return Component.this.getCursor ();
        }

        public void setCursor (Cursor cursor) {
            Component.this.setCursor (cursor);}

        public Font getFont () {
            return Component.this.getFont ();
        }

        public void setFont (Font f) {
            Component.this.setFont (f);}

        public FontMetrics getFontMetrics (Font f) {
            if (f == null) {
                return null;
            } else {
                return Component.this.getFontMetrics (f);
            }
        }

        public boolean isEnabled () {
            return Component.this.isEnabled ();
        }

        public void setEnabled (boolean b) {
            boolean old = Component.this.isEnabled ();
            Component.this.setEnabled (b); if (b != old) {
                if (accessibleContext != null) {
                    if (b) {
                        accessibleContext.firePropertyChange (AccessibleContext.ACCESSIBLE_STATE_PROPERTY, null, AccessibleState
                          .ENABLED);} else {
                        accessibleContext.firePropertyChange (AccessibleContext.ACCESSIBLE_STATE_PROPERTY, AccessibleState.
                          ENABLED, null);}
                }
            }
        }

        public boolean isVisible () {
            return Component.this.isVisible ();
        }

        public void setVisible (boolean b) {
            boolean old = Component.this.isVisible ();
            Component.this.setVisible (b); if (b != old) {
                if (accessibleContext != null) {
                    if (b) {
                        accessibleContext.firePropertyChange (AccessibleContext.ACCESSIBLE_STATE_PROPERTY, null, AccessibleState
                          .VISIBLE);} else {
                        accessibleContext.firePropertyChange (AccessibleContext.ACCESSIBLE_STATE_PROPERTY, AccessibleState.
                          VISIBLE, null);}
                }
            }
        }

        public boolean isShowing () {
            return Component.this.isShowing ();
        }

        public boolean contains (Point p) {
            return Component.this.contains (p);
        }

        public Point getLocationOnScreen () {
            synchronized (Component.this.getTreeLock ()) {
                if (Component.this.isShowing ()) {
                    return Component.this.getLocationOnScreen ();
                } else {
                    return null;
                }
            }
        }

        public Point getLocation () {
            return Component.this.getLocation ();
        }

        public void setLocation (Point p) {
            Component.this.setLocation (p);}

        public Rectangle getBounds () {
            return Component.this.getBounds ();
        }

        public void setBounds (Rectangle r) {
            Component.this.setBounds (r);}

        public Dimension getSize () {
            return Component.this.getSize ();
        }

        public void setSize (Dimension d) {
            Component.this.setSize (d);}

        public Accessible getAccessibleAt (Point p) {
            return null;
        }

        public boolean isFocusTraversable () {
            return Component.this.isFocusTraversable ();
        }

        public void requestFocus () {
            Component.this.requestFocus ();}

        public void addFocusListener (FocusListener l) {
            Component.this.addFocusListener (l);}

        public void removeFocusListener (FocusListener l) {
            Component.this.removeFocusListener (l);}

    }

    int getAccessibleIndexInParent () {
        synchronized (getTreeLock ()) {
            int index = - 1;
            Container parent = this.getParent ();
            if (parent != null && parent instanceof Accessible) {
                Component ca [] = parent.getComponents ();
                for (int i = 0;
                i < ca.length; i ++) {
                    if (ca [i] instanceof Accessible) {
                        index ++;}
                    if (this.equals (ca [i])) {
                        return index;
                    }
                }
            }
            return - 1;
        }
    }

    AccessibleStateSet getAccessibleStateSet () {
        synchronized (getTreeLock ()) {
            AccessibleStateSet states = new AccessibleStateSet ();
            if (this.isEnabled ()) {
                states.add (AccessibleState.ENABLED);}
            if (this.isFocusTraversable ()) {
                states.add (AccessibleState.FOCUSABLE);}
            if (this.isVisible ()) {
                states.add (AccessibleState.VISIBLE);}
            if (this.isShowing ()) {
                states.add (AccessibleState.SHOWING);}
            if (this.isFocusOwner ()) {
                states.add (AccessibleState.FOCUSED);}
            if (this instanceof Accessible) {
                AccessibleContext ac = ((Accessible) this).getAccessibleContext ();
                if (ac != null) {
                    Accessible ap = ac.getAccessibleParent ();
                    if (ap != null) {
                        AccessibleContext pac = ap.getAccessibleContext ();
                        if (pac != null) {
                            AccessibleSelection as = pac.getAccessibleSelection ();
                            if (as != null) {
                                states.add (AccessibleState.SELECTABLE); int i = ac.getAccessibleIndexInParent ();
                                if (i >= 0) {
                                    if (as.isAccessibleChildSelected (i)) {
                                        states.add (AccessibleState.SELECTED);}
                                }
                            }
                        }
                    }
                }
            }
            if (Component.isInstanceOf (this, "javax.swing.JComponent")) {
                if (((javax.swing.JComponent) this).isOpaque ()) {
                    states.add (AccessibleState.OPAQUE);}
            }
            return states;
        }
    }

    static boolean isInstanceOf (Object obj, String className) {
        if (obj == null) return false;

        if (className == null) return false;

        Class cls = obj.getClass ();
        while (cls != null) {
            if (cls.getName ().equals (className)) {
                return true;
            }
            cls = cls.getSuperclass ();} return false;
    }

}

