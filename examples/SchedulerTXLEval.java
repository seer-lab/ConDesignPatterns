import java.util.ArrayList;
import java.util.Random;


public class Processor
{
  private Scheduler Sch = new Scheduler();

  public void SolveProblem(IScheduleOrdering InPr)
  {
    int NotUsed = 0;

    try
    {
      Sch.Enter(InPr);
      try
      {
        NotUsed = InPr.SolveProblem();
      }
      finally
      {
        Sch.Done();
      }
    }
    catch (InterruptedException IE)
    {
      System.out.println("Processor.SolveProblem: InterruptedException generated.");
    }

    NotUsed = NotUsed * 5;
  }
}


public class Scheduler
{
  private Thread Runner;
  private ArrayList<IScheduleOrdering> RequestsWaiting = new ArrayList<IScheduleOrdering>();
  private ArrayList<Thread> ThreadsWaiting = new ArrayList<Thread>();

  public synchronized void Enter(IScheduleOrdering InSO) throws InterruptedException
  {
    Thread MyThread = Thread.currentThread();

    if (Runner == null)
    {
      Runner = MyThread;
      return;
    }
    RequestsWaiting.add(InSO);
    ThreadsWaiting.add(MyThread);

    while (MyThread != Runner)
      MyThread.wait();

    int i = ThreadsWaiting.indexOf(MyThread);
    ThreadsWaiting.remove(i);
    RequestsWaiting.remove(i);

  } // Enter

  synchronized public void Done()
  {
    if (Runner != Thread.currentThread())
        throw new IllegalStateException("Scheduler.Done: Wrong Thread");

    // TODO: Fill in
    //The rest of the code in this method can be seen in the text, pg. 483.

    //Runner = (Thread) ThreadsWaiting.get(next);
    synchronized (Runner)
    {
        Runner.notifyAll();
    }
  }  // Done
}


public interface IScheduleOrdering
{
  public boolean ScheduleBefore(IScheduleOrdering InSO);

  public int SolveProblem();
}


public class Main
{

  /**
   * @param args
   */
  public static void main(String[] args)
  {
    Random MyRnd = new Random();

    //Scheduler Sch = new Scheduler();
    Problem P1 = new Problem(1);
    Problem P2 = new Problem(2);
    Problem P3 = new Problem(3);
    Processor Pro = new Processor();

    System.out.println("Starting - ");

    int RndInt = 0;

    for (int i = 1; i <= 100; i++)
    {
      for (int j = 1; j <= 5; j++)
      {
        RndInt = MyRnd.nextInt(3) + 1;

        if (RndInt == 1)
          Pro.SolveProblem(P1);
        else if (RndInt == 2)
          Pro.SolveProblem(P2);
        else
          Pro.SolveProblem(P3);
      }

      System.out.println("");
    }

    System.out.println("Finishing.");
  }
}


public class Problem implements IScheduleOrdering
{
  int Rank;

  public Problem(int InRank)
  {
    Rank = InRank;
  }

  @Override
  public boolean ScheduleBefore(IScheduleOrdering InSO)
  {
    // TODO Auto-generated method stub
    return false;
  }

  @Override
  public int SolveProblem()
  {
    System.out.print(Rank);
    System.out.print(" ");

    // This math is nonsense.  Don't read anything in to it
    int q = 0;

    for (int i = 1; i < 1000000; i += 7)
    {
      q = i * 3;
      q = q + 17;
    }

    return q;
  }
}

