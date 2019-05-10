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

```bash
curl \
-H "Content-Type: application/json" \
-H "Accept: application/json" \
-H "Authorization: Basic a2llc2VydmVyOmJramtAMTIz" \
--data @post_body.json http://10.241.0.41:8235/kie-server/services/rest/server/containers/instances/kie-project-starter_1.1
```