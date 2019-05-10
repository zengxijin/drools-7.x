package org.jackzeng;

import org.drools.core.event.DefaultAgendaEventListener;
import org.kie.api.event.rule.AfterMatchFiredEvent;
import org.kie.api.event.rule.BeforeMatchFiredEvent;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.Collection;

/**
 * @author xijin.zeng created on 2019/5/10
 * setting the kmodule.xml <listeners> fields
 * agendaEventListener => for rule fired
 * ruleRuntimeEventListener => for rule runtime
 * processEventListener => for BPMN engine
 */
public class CustomAgendaEventListener extends DefaultAgendaEventListener {

    private Logger logger = LoggerFactory.getLogger(CustomAgendaEventListener.class);

    /**
     * match and before fired or update facts
     * it's the right place to log the input objects
     * @param event
     */
    @Override
    public void beforeMatchFired(BeforeMatchFiredEvent event) {

    }

    /**
     * match and fired
     * facts maybe updated by `then` actions
     * it's the right place to log the fired rule name, etc
     * @param event
     */
    @Override
    public void afterMatchFired(AfterMatchFiredEvent event) {
        String ruleName = event.getMatch().getRule().getName();
        Long factsCount = event.getKieRuntime().getFactCount();
        Collection collection = event.getKieRuntime().getObjects();
        if (collection != null && collection.size() > 0) {
            for(Object obj: collection) {
                if (obj instanceof BasicInfo) {
                    BasicInfo basicInfo = (BasicInfo) obj;
                    this.log(basicInfo.getSequenceId(), basicInfo.getClientId(), ruleName, factsCount);
                    // fast exit
                    return;
                }
            }
        }

        this.log("unknown", "unknown", ruleName, factsCount);
    }

    private void log(String sequenceId, String clientId, String firedRuleName, Long factsCount) {
        logger.info("sequenceId: {}, clientId: {}, fired rule: {}, facts count: {},",
                sequenceId, clientId, firedRuleName, factsCount);
    }
}
