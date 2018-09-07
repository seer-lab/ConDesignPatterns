import java.util.ArrayList;

public abstract class AbstractGameObject {
    private static final Object lockObject = new Object ();
    private boolean glowing;
    public static final Object getLockObject () {
        return lockObject;
    }

    public boolean isGlowing () {
        return glowing;
    }

    public void setGlowing (boolean newValue) {
        glowing = newValue;
    }

}

class GameCharacter extends AbstractGameObject {
    private ArrayList < E > myWeapons = new ArrayList ();
    public void dropAllWeapons () {
        synchronized (getLockObject ()) {
            for (int i = myWeapons.size () - 1;
            i >= 0; i --) {
                ((Weapons) myWeapons.get (i)).setGlowing (true);
            }
        }
    }

}

