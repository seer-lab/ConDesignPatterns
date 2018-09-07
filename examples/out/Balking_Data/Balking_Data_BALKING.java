import java.io.IOException;

import java.io.FileWriter;

import java.io.Writer;

public class Data {
    private String filename;
    private String content;
    private boolean changed;

    public Data (String filename, String content) {
        this.filename = filename;
        this.content = content;
        this.changed = true;
    }

    public synchronized void change (String newContent) {
        content = newContent;
        changed = true;
    }

    /* "@BalkingPatternAnnotation(patternInstanceID=1, roleID=1, roleDescription='Ensuring method is synchronized - 
      guarded')"*/
    public synchronized void save () throws IOException {

        /*
"@BalkingPatternAnnotation(patternInstanceID=1, roleID=2, roleDescription='Ensure an if statement that tests a flag right at the start of the synchronized method')"
        */
        if (! changed) {
            System.out.println (Thread.currentThread ().getName () + " balks");

            /*
"@BalkingPatternAnnotation(patternInstanceID=1, roleID=3, roleDescription='Ensuring one of the if or else tests of the flag in Role 2 does an immediate return - balking')"
            */
            return;
        }
        doSave ();
        changed = false;
    }

    private void doSave () throws IOException {
        System.out.println (Thread.currentThread ().getName () + " calls doSave, content = " + content);
        Writer writer = new FileWriter (filename);
        writer.write (content);
        writer.close ();
    }

}

