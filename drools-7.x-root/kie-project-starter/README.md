### Key Points
`kjar` settings in pom.xml
```xml
<packaging>kjar</packaging>
```
`kmodule.xml` in /resources/META-INF and `kbase`, `ksession` settings.

`.drl` files locate in `/resources/`

build the project using:
```bash
mvn clean build
```
upload the jar to workbench and deploy to kie server container