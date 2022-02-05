# delivery-master

Generates dynamically a delivery plan for a release consisting on different components to be deployed across different staging environments as an excel sheet.

This is done via maven-plugin yaml-codegen-maven (see pom.xml for more details) in conjunction with a model file and a freemarker template.

Use the command
`mvn generate-resources`
and in target directory you will get the delivery plan as the generated result.

Before you will generate the delivery plan please define the release as the instance model and the components model in the model file under `/src/main/resources/delivery-model.yml`.
The characteristics of a release are the defined environments you will go though and the concrete components you have to consider within the release.
```javascript
# define necessary environments for release
# possible environment are [INT, FUNC, PRE, HOT, PROD]

environments: [INT, FUNC, PRE, PROD]

# define necessary components and their caracteristics for release
# possible tags: [DEPLOY, DB, CONFIG], if tags is not set thea all actions are considered by default
instances:
  -
    name: Program1
    typ: Wildfly-EAR
    version: 1.0.6
    tags: [DEPLOY, DB, CONFIG]
  -
    name: Program2
    typ: Win-EXE
    version: 1.2.7
    tags: [DEPLOY, DB, CONFIG]
...
```