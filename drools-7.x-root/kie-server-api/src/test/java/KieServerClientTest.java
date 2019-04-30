import org.jackzeng.ServerClient;
import org.kie.server.api.model.*;
import org.kie.server.client.KieServicesClient;

/**
 * @author xijin.zeng created on 2019/4/30
 */
public class KieServerClientTest {
    // quick test
    public static void main(String[] args) {

        // Listing Server capabilities
        KieServicesClient client = ServerClient.getClient();
        KieServerInfo serverInfo = client.getServerInfo().getResult();
        System.out.println(serverInfo);

        // Listing Container info
        KieContainerResource kieContainerResource = client.getContainerInfo("test-pro_1.1.0").getResult();
        System.out.println(kieContainerResource);
        System.out.println(kieContainerResource.getContainerId());
        System.out.println(kieContainerResource.getStatus());

        // Listing Container info with filter
        KieContainerResourceFilter filter = new KieContainerResourceFilter.Builder()
                .releaseId("com.bkjk.credit", "test-pro", "1.1.0")
                .status(KieContainerStatus.STARTED)
                .build();
        KieContainerResourceList containersList = client.listContainers(filter).getResult();
        System.out.println(containersList.getContainers());

    }
}
