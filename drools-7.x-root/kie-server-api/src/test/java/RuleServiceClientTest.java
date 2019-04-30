import com.bkjk.credit.test_pro.MyBean;
import org.jackzeng.ServerClient;
import org.kie.api.KieServices;
import org.kie.api.command.Command;
import org.kie.api.command.KieCommands;
import org.kie.api.runtime.ExecutionResults;
import org.kie.server.api.model.ServiceResponse;
import org.kie.server.client.RuleServicesClient;

import java.util.Arrays;

/**
 * @author xijin.zeng created on 2019/4/30
 */
public class RuleServiceClientTest {
    // quick test
    public static void main(String[] args) {
        // call kie rules service
        RuleServicesClient ruleClient = ServerClient.getRuleClient();

        KieCommands commandsFactory = KieServices.Factory.get().getCommands();
        MyBean myBean = new MyBean();
        myBean.setAge(12);

        Command<?> insert = commandsFactory.newInsert(myBean, "returnKey", true, "");
        Command<?> fireAllRules = commandsFactory.newFireAllRules("my-id");
        Command<?> batchCommand = commandsFactory.newBatchExecution(Arrays.asList(insert, fireAllRules), "statelessCfg");

        ServiceResponse<ExecutionResults> executeResponse = ruleClient.executeCommandsWithResults("test-pro_1.1.0", batchCommand);

        System.out.println(executeResponse.getResult());
    }
}
