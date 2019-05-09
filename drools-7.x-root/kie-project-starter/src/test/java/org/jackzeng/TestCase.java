package org.jackzeng;

import org.kie.api.KieServices;
import org.kie.api.command.Command;
import org.kie.api.command.KieCommands;
import org.kie.api.runtime.ExecutionResults;
import org.kie.api.runtime.KieContainer;
import org.kie.api.runtime.KieSession;
import org.kie.api.runtime.StatelessKieSession;

import java.util.ArrayList;
import java.util.List;

/**
 * @author xijin.zeng created on 2019/5/9
 */
public class TestCase {

    private static KieServices ks;
    private static KieContainer container;

    static {
        ks = KieServices.Factory.get();
        container = ks.getKieClasspathContainer();
    }

    public static void main(String[] args) {
//        statefulTest();
        statelessTest();
    }

    private static void statelessTest() {
        StatelessKieSession session = container.newStatelessKieSession("defaultSession");
        TestBean bean = new TestBean();
        bean.setAge(12);

        KieCommands kieCommands = ks.getCommands();

        List<Command> cmds = new ArrayList<Command>();
//        cmds.add( kieCommands.newSetGlobal( "list1", new ArrayList(), true ) );
        cmds.add( kieCommands.newInsert( bean, "person" ) );
//        cmds.add( kieCommands.newQuery( "Get People" "getPeople" );

        ExecutionResults results = session.execute( kieCommands.newBatchExecution( cmds ) );
//        results.getValue( "list1" ); // returns the ArrayList
        TestBean newBean = (TestBean)results.getValue( "person" ); // returns the inserted fact Person
        System.out.println(newBean);
//        results.getValue( "Get People" );// returns the query as a QueryResults instance.
    }

    private static void statefulTest() {
        KieSession session = container.newKieSession("statefulSession");
        TestBean bean = new TestBean();
        bean.setAge(12);

        session.insert(bean);
        session.fireAllRules();

    }
}
