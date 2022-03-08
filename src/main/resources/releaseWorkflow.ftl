<#-- Generate the main workflow for our release -->
name: Release Workflow
on:
  workflow_dispatch

jobs:
<#list model.content.environments as e>
    <#assign autoPre = model.content.general_pre_activities?filter(a -> (a.envs?seq_contains(e) && (a.execution?? && a.execution?contains("auto")) ) ) >
    <#if autoPre?size gt 0 >
  ${e}-PreActivities:
    uses: ./.github/workflows/activitiesPre.yml
    with:
      env: ${e}
    </#if>
<#-- Generate components reusable worflow calls -->
    <#assign needsClausePost = "">
    <#list model.content.components as c>
        <#list model.content.componentTypes as ct>
            <#if c.componentType?contains(ct.componentType)>
                <#assign autoComp = ct.activities?filter(a -> (a.envs?seq_contains(e) && (a.execution?? && a.execution?contains("auto")) ) ) >
                <#if autoComp?size gt 0 >
                    <#if needsClausePost?length gt 0 >
                        <#assign needsClausePost += "," >
                    </#if>
                    <#assign needsClausePost += "${e}-${c.name}">
  ${e}-${c.name}:
    uses: ./.github/workflows/component${ct.componentType}.yml
    needs: ${e}-PreActivities
    with:
      env: ${e}
      name: ${c.name}
      version: ${c.version}
      tags: '${c.tags?join(",")}'
                </#if>
            </#if>
        </#list>
    </#list>
    <#assign autoPost = model.content.general_post_activities?filter(a -> (a.envs?seq_contains(e) && (a.execution?? && a.execution?contains("auto")) ) ) >
    <#if autoPost?size gt 0 >
  ${e}-PostActivities:
    uses: ./.github/workflows/activitiesPost.yml
    with:
      env: ${e}
    needs: [${needsClausePost}]
    </#if>
</#list>

