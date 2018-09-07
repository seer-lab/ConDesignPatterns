import java.util.ArrayList;

public abstract class AbstractGameObject {

    /*
"@LockObjectPatternAnnotation(patternInstanceID=1, roleID=1, roleDescription='Creation of static object in a class - lock object.')"
    */
    private static final Object lockObject = new Object ();
    private boolean glowing;

    /*
"@LockObjectPatternAnnotation(patternInstanceID=1, roleID=2, roleDescription='Creation of static method in the same class as Role 1 - getLockObject().')"
    */
    public static final Object getLockObject () {

        /* "@LockObjectPatternAnnotation(patternInstanceID=1, roleID=2a, roleDescription='Return of lock object, Role 1.')"*/
        return lockObject;
    }

    public boolean isGlowing () {
        return glowing;
    }

    public void setGlowing (boolean newValue) {
        glowing = newValue;}

}

class GameCharacter extends AbstractGameObject {
    private ArrayList < E > myWeapons = new ArrayList ();
    public void dropAllWeapons () {

        /* "@LockObjectPatternAnnotation(patternInstanceID=1, roleID=3, roleDescription='Synchronized calls to method Role 
          2.')"*/
        synchronized (getLockObject ()) {
            for (int i = myWeapons.size () - 1;
            i >= 0; i --) {
                ((Weapons) myWeapons.get (i)).setGlowing (true);}
        }
    }

}

