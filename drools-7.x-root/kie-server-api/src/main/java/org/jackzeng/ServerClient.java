package org.jackzeng;

import org.kie.server.api.marshalling.MarshallingFormat;
import org.kie.server.client.KieServicesClient;
import org.kie.server.client.KieServicesConfiguration;
import org.kie.server.client.KieServicesFactory;
import org.kie.server.client.RuleServicesClient;

/**
 * @author xijin.zeng created on 2019/4/30
 */
public class ServerClient {

    // using REST with JSON
    private static final MarshallingFormat FORMAT = MarshallingFormat.JSON;
    private final static KieServicesClient kieServicesClient;

    static {
        KieServicesConfiguration conf = KieServicesFactory.newRestConfiguration(Configs.getKieUrl(), Configs.getKieUser(), Configs.getKiePwd());
        conf.setMarshallingFormat(FORMAT);

        kieServicesClient = KieServicesFactory.newKieServicesClient(conf);
    }

    public static KieServicesClient getClient() {
        return kieServicesClient;
    }

    public static RuleServicesClient getRuleClient() {
        return kieServicesClient.getServicesClient(RuleServicesClient.class);
    }

}
