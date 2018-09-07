//*********************************************************************************//
//*** Read/Write Lock pattern allows for concurrent reads but exclusive writes. ***//
//*********************************************************************************//


import java.util.*;

public class Bid {
	private int bid = 0;
	private ReadWriteLock lockManager = new ReadWriteLock();

	public int getBid() throws InterruptedException {
		lockManager.readLock();
		int bid = this.bid;
		lockManager.done();
		return bid;
	} // getBid()

	public void setBid(int bid) throws InterruptedException {
		lockManager.writeLock();
		if (bid > this.bid) {
			this.bid = bid;
		} // if
		lockManager.done();
	} // setBid(int)
} // class Bid

//*** ReadWriteLockPattern:  Role = 1(ReadWriteLock object/class.
//							** Contains Role 1a.
//							** Contains Role 1b.
//							** Contains Role 1c.
//							** Contains Role 1d.
//							** Contains Role 1e.
//							** Contains Role 1f.
//							** Contains Role 1g.);
//	ID = 1.
public class ReadWriteLock{

	//*** ReadWriteLockPattern:  Role = 1a(Counter declaration outside of any methods within Role 1 (will contain count of number of threads waiting to get a read lock).);
    //	ID = 1.
	private int waitingForReadLock = 0;

	//*** ReadWriteLockPattern:  Role = 1b(Counter declaration outside of any methods within Role 1 (will contain count of number of read locks issued but have not yet been released by the threads they were issued to).);
    //	ID = 1.
	private int outstandingReadLocks = 0;

	//*** ReadWriteLockPattern:  Role = 1c(Arraylist declaration outside of any methods within Role 1 (will contain a list of threads waiting to get a write lock).);
    //	ID = 1.
	@SuppressWarnings("unchecked")
	private ArrayList waitingForWriteLock = new ArrayList();

	//*** ReadWriteLockPattern:  Role = 1d(Thread creation outside of any methods within Role 1 (will contain the thread that currently has the write lock and will be null when no thread has the write lock).);
	//		ID = 1.
	private Thread writeLockedThread;

	//*** ReadWriteLockPattern:  Role = 1e(Synchronized method to issue a read lock.
    //							** Contains Role 1ea
    //							** Contains Role 1eb);
    //	ID = 1.
	//*** ReadWriteLockPattern:  Role = 1ea(Boolean check if a thread contained in variable Role 1d has the write lock.
    ///							** If true i.e. a thread has the write lock then processing continues to Role 1eaa and then Role 1eab.
    //							** If false then processing continues to 1eb.);
    //	ID = 1.
	//*** ReadWriteLockPattern:  Role = 1eaa(Increment variable Role 1a by 1.);
    //	ID = 1.
	//*** ReadWriteLockPattern:  Role = 1eab(Loop iteratively checking if a thread contained in variable Role 1d has the write lock.);
	//							** As long as true i.e. a thread has the write lock Role 1eaba occurs
	//							** When condition becomes false processing continues to Role 1eac.);
    //	ID = 1.
	//*** ReadWriteLockPattern:  Role = 1eaba(wait() is called to pause further processing);
    //	ID = 1.
	//*** ReadWriteLockPattern:  Role = 1eac(Decrement variable Role 1a by 1.);
    //	ID = 1.
	//*** ReadWriteLockPattern:  Role = 1eb(Increment variable Role 1b by 1.);
    //	ID = 1.
	synchronized public void readLock() throws InterruptedException {
		if (writeLockedThread != null) {
			waitingForReadLock++;
			while (writeLockedThread != null){
				wait();
			}//while
			waitingForReadLock--;
			//waitingForReadLock++;
		}//if
		outstandingReadLocks++;
	}//readLock()

	//*** ReadWriteLockPattern:  Role = 1f(Method to issue a write lock.
    //							** Contains Role 1fa
    //							** Contains Role 1fb
    //							** Contains Role 1fc
    //							** Contains Role 1fd);
    //	ID = 1.
    //*** ReadWriteLockPattern:  Role = 1fa(New thread creation outside of any critical section.);
    //	ID = 1.
    //*** ReadWriteLockPattern:  Role = 1fb(Critical section creation by synchronization of this Read/Write Lock object Role 1.
    //							** Contains Role 1fba);
    //	ID = 1.
    //*** ReadWriteLockPattern:  Role = 1fba(Within Role 1fb a check to whether thread object Role 1d is null and variable Role 1b is zero.
    //							** If true proceed with Role 1fbaa and 1fbab.
    //							** If false proceed with Role 1fbac and 1fbad);
    //	ID = 1.
    //*** ReadWriteLockPattern:  Role = 1fbaa(Assign the current thread to thread Role 1d.);
    //	ID = 1.
    //*** ReadWriteLockPattern:  Role = 1fbab(Return to the calling object that is using this method Role 1f of an instance of this object Role 1 .);
    //	ID = 1.
    //*** ReadWriteLockPattern:  Role = 1fbac(Make thread Role 1fa the current thread.);
    //	ID = 1.
    //*** ReadWriteLockPattern:  Role = 1fbad(Add thread Role 1fa to arraylist Role 1c.);
    //	ID = 1.
    //*** ReadWriteLockPattern:  Role = 1fc(Critical section creation by synchronization of thread Role 1fa.
    //							** Contains Role 1fca);
    //	ID = 1.
    //*** ReadWriteLockPattern:  Role = 1fca(A loop within critical section Role 1fc to check if the new thread Role 1fa is NOT the same as thread Role 1d.
    //							** If true proceed with Role 1fcaa.
    //							** If false then new thread Role 1fa is allowed to continue to run and proceeds to Role 1fd.);
    //	ID = 1.
    //*** ReadWriteLockPattern:  Role = 1fcaa(New thread Role 1fa is placed in a waiting state until method Role 1g wakes it up using a nofityAll().);
    //	ID = 1.
    //*** ReadWriteLockPattern:  Role = 1fd(Critical section creation by synchronization of this Read Write Lock object Role 1.
    //							** Contains Role 1fda);
    //	ID = 1.
    //*** ReadWriteLockPattern:  Role = 1fda(Remove current thread (Role 1fa) from the arraylist of waiting threads (Role 1c).);
    //	ID = 1.
	@SuppressWarnings("unchecked")
	public void writeLock() throws InterruptedException {
		Thread thisThread;
		synchronized (this) {
			if (writeLockedThread==null && outstandingReadLocks==0){
				writeLockedThread = Thread.currentThread();
				return;
			}//if
			thisThread = Thread.currentThread();
			waitingForWriteLock.add(thisThread);
		}//synchronized(this)
		synchronized(thisThread){
			while (thisThread != writeLockedThread){
				thisThread.wait();
			}//while
		}//synchronized (thisThread)
		synchronized(this){
			waitingForWriteLock.remove(thisThread);
		}//synchronized (this)
	}//writeLock

	//Call to the done method indicates current thread is finished with the resource
    //*** ReadWriteLockPattern:  Role = 1g(Synchronized method called when the current thread is finished with resource.);
    //							** Contains Role 1ga.);
    //	ID = 1.
    //*** ReadWriteLockPattern:  Role = 1ga(NotifyAll to wake up other waiting threads.);
    //	ID = 1.
	synchronized public void done(){
		if(outstandingReadLocks > 0)
		{
			outstandingReadLocks--;
			if(outstandingReadLocks == 0 && waitingForWriteLock.size() > 0)
			{
				writeLockedThread = (Thread)waitingForWriteLock.get(0);
				writeLockedThread.notifyAll();
			}//if
		}
		else if (Thread.currentThread() == writeLockedThread)
		{
			if(outstandingReadLocks == 0 && waitingForWriteLock.size()>0){
				writeLockedThread = (Thread)waitingForWriteLock.get(0);
				writeLockedThread.notifyAll();
			}
			else
			{
				writeLockedThread = null;
				if(waitingForReadLock > 0)
					notifyAll();
			}//if
		}
		else
		{
			String msg = "Thread does not have lock";
			throw new IllegalStateException(msg);
		}//if
	}//done()
}// class ReadWriteLock()
