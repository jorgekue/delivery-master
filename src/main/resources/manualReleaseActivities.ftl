<#-- Generate the CSV-File with the manual activities beside the automated Jobs-->
<#assign roles = model.content.activityRoles![]>
<#function lineStr activity env roles name>
  <#local str = env+";"+name+";"+activity.time+";"+activity.name+";"+activity.description+";;">
  <#if activity.role??>
    <#local str += activity.role +";">
    <#assign roleList = roles?filter(r -> r.rolename?starts_with(activity.role)) >
    <#if roleList?size gt 0>
      <#local str += roleList[0].employee>
    </#if>
    <#local str += ";">
  <#else>
    <#local str += ";;">
  </#if>
  <#if activity.hints??>
    <#local str += activity.hints>
  </#if>
  <#return str>
</#function>
Environment;Component;Time;Activity;Description;Status;Role;Employee;Hints
<#list model.content.environments as e>
    <#assign manPre = model.content.general_pre_activities?filter(a -> (a.envs?seq_contains(e) && (a.execution?? && a.execution?contains("manual") || !(a.execution??)))) >
    <#if manPre?size gt 0 >
${e};General;00:00;;;;
        <#list model.content.general_pre_activities as pre>
            <#if pre.envs?seq_contains(e)>
                <#if ( pre.execution?? && pre.execution?contains("manual" ) || !(pre.execution??) ) >
${lineStr(pre,e,roles,"General")}
                </#if>
            </#if>
        </#list>
    </#if>
<#-- Generate components manual activities before -->
    <#list model.content.components as c>
        <#list model.content.componentTypes as ct>
            <#if c.componentType?contains(ct.componentType)>
<#-- check any manual activities before? -->
                <#assign manCompActivitiesBefore = ct.activities?filter(a -> (
                  a.envs?seq_contains(e) &&
                  (a.execution?? && a.execution?contains("manualBefore") || !(a.execution??) ) &&
                  (c.tags?? && a.tags?? && a.tags?filter(t -> c.tags?seq_contains(t))?size gt 0 || !(c.tags?? && a.tags??))
                  ) )>
                <#if manCompActivitiesBefore?size gt 0 >
${e};${c.name};00:00;Version ${c.version};;;
                    <#list manCompActivitiesBefore as a>
${lineStr(a,e,roles,c.name)}
                    </#list>
                </#if>
            </#if>
        </#list>
    </#list>
<#-- Approval activity for reviewers -->
<#if model.content.reviewRole?? >
<#assign reviewRole = model.content.reviewRole>
${e};General;10:00;Approval;Approval for Environment ${e};;${reviewRole.rolename};${reviewRole.employee};Approval in your GitHub-Environments
<#else>
${e};General;10:00;Approval;Approval for Environment ${e};;;;Approval in your GitHub-Environments
</#if>
<#-- Generate components manual activities after -->
    <#list model.content.components as c>
        <#list model.content.componentTypes as ct>
            <#if c.componentType?contains(ct.componentType)>
<#-- check any manual activities after? -->
                <#assign manCompActivitiesAfter = ct.activities?filter(a -> (
                  a.envs?seq_contains(e) &&
                  (a.execution?? && a.execution?contains("manualAfter") || !(a.execution??) ) &&
                  (c.tags?? && a.tags?? && a.tags?filter(t -> c.tags?seq_contains(t))?size gt 0 || !(c.tags?? && a.tags??))
                  ) )>
                <#if manCompActivitiesAfter?size gt 0 >
${e};${c.name};00:00;Version ${c.version};;;
                    <#list manCompActivitiesAfter as a>
${lineStr(a,e,roles,c.name)}
                    </#list>
                </#if>
            </#if>
        </#list>
    </#list>
    <#assign manPost = model.content.general_post_activities?filter(a -> (a.envs?seq_contains(e) && (a.execution?? && a.execution?contains("manual") || !(a.execution??)))) >
    <#if manPost?size gt 0 >
${e};General;00:00;;;;
        <#list model.content.general_post_activities as post>
            <#if post.envs?seq_contains(e)>
                <#if ( (post.execution?? && post.execution?contains("manual")) || !(post.execution??) ) >
${lineStr(post,e,roles,"General")}
                </#if>
            </#if>
        </#list>
    </#if>
</#list>


