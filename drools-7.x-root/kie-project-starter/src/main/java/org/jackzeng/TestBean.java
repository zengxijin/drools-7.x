package org.jackzeng;

import lombok.Data;

/**
 * @author xijin.zeng created on 2019/5/9
 */
@Data
public class TestBean {
    private String result;
    private Integer age;

    public TestBean(String result, Integer age) {
        this.result = result;
        this.age = age;
    }

    public TestBean() {
    }
}
