//************************************************************************************************//
//*** Lock Object pattern:                                                                     ***//
//*** This design pattern is a refinement of the Single Threaded Executio design pattern.      ***//  
//*** It enables a single thread to have exclusive access to multiple objects.                 ***//
//*** To avoid a thread having to obtain a lock on every single object it needs                ***//
//*** (consuming lots of overhead), the solution offered by this design pattern is to          ***//
//*** have threads acquire a synchronization lock on an object created for the sole            ***//
//*** purpose of being the subject of locks, before continuing with any operations.            ***//
//*** This object is referred to as a lock object hence the name of the pattern.               ***//
//*** NB:  For the purposes of our experiment we will focus on one common method.              ***//
//*** 		creating a static method in the class e.g. getLockObject() that returns a lock     ***//
//*** 		(the sole lock).  Subclasses of this class call this method to get the lock object ***//
//*** 		to synchronize operations in the program.                                          ***//
//************************************************************************************************//

import java.util.ArrayList;

//***LockObjectPattern:  Role = 1(Creation of static object in a class - lock object.); 
//ID = 1. 
//***LockObjectPattern:  Role = 2(Creation of static method in the same class are Role 1 - getLockObject().
//							** Contains Role 2a.); 
//ID = 1.   
//***LockObjectPattern:  Role = 2a(Return of lock object, Role 1.); 
//ID = 1.  
public abstract class AbstractGameObject {
	private static final Object lockObject = new Object();
	//...	
	//...
	private boolean glowing; //True if this object is glowing.
	//...
	//...
	public static final Object getLockObject (){
		return lockObject;
	}
	//...
	//...
	public boolean isGlowing() {
		return glowing;
	}
	
	public void setGlowing (boolean newValue){
		glowing = newValue;
	}
}

//***LockObjectPattern:  Role = 3(Synchronized calls to method Role 2.); 
//ID = 1. 
class GameCharacter extends AbstractGameObject {
	//...
	private ArrayList<E> myWeapons = new ArrayList();
	
	public void dropAllWeapons (){
		synchronized (getLockObject()){
			for (int i = myWeapons.size()-1; i>=0; i--){
				((Weapons)myWeapons.get(i)).setGlowing(true);
			}
		}
	}
	//...
}