import java.util.ArrayList;


public class ReadWriteLock {

	private int waitingForReadLock = 0;
	private int outstandingReadLocks = 0;
	private ArrayList<Thread> waitingForWriteLock = new ArrayList<Thread>();
	private Thread writeLockedThread = null;

	
	private int heldReadingLocks = 0;
	private boolean writing = false;
	private Thread writingThread = null;
	
	synchronized public void readLock() throws InterruptedException{
		
		
		// Wait till no thread is writing then read
		while (writing && writingThread == null) {
			//System.out.println("waiting for read " + Thread.currentThread().toString());
			this.wait();
			//Thread.sleep(100); // Sleep for 100ms then try again
		}
		
		// Acquire the reading lock
		//System.out.println(Thread.currentThread().toString() + " read lock");
		heldReadingLocks++;
		
	}
	
	public void writeLock() throws InterruptedException{
		
		// Toggle the flag for wanting the write lock object
		writing = true;
		
		// Wait for the number of heldReadingLocks to fall to 0
		while (heldReadingLocks != 0){
			//System.out.println("waiting for write " + Thread.currentThread().toString());
			Thread.sleep(1000); // Sleep for 1000ms then try again
		}
		
		// Acquired write lock
		//System.out.println(Thread.currentThread().toString() + " write lock");
		writingThread = Thread.currentThread();
		return;
		
	}
	
	synchronized public void done(){
		
		// The writing thread, can release the writing lock
		if (Thread.currentThread() == this.writingThread) {
			//System.out.println(Thread.currentThread().toString() + " write unlock");
			writing = false;
			writingThread = null;
		}
		else{ // Otherwise, release a read lock
			//System.out.println(Thread.currentThread().toString() + " read unlock");
			heldReadingLocks--;
		}
		notifyAll();
	}
}
