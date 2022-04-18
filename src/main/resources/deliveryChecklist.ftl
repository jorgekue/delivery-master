<#assign roles = model.content.roles![] >
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
${e};General;00:00;;;;
    <#list model.content.general_pre_activities as pre>
        <#if pre.envs?seq_contains(e)>
${lineStr(pre,e,roles,"General")}
        </#if>
    </#list>
    <#list model.content.components as c>
        <#list model.content.componentTypes as ct>
            <#if c.componentType?contains(ct.componentType)>
${e};${c.name};00:00;Version ${c.version};;;
                <#list ct.activities as a>
                    <#if a.envs?seq_contains(e)>
                        <#if c.tags?? && a.tags??>
                            <#list a.tags as t>
                                <#if c.tags?seq_contains(t)>
${lineStr(a,e,roles,c.name)}
                                    <#break>
                                </#if>
                            </#list>
                        <#else>
${lineStr(a,e,roles,c.name)}
                        </#if>
                    </#if>
                </#list>
            </#if>
        </#list>
    </#list>
${e};General;00:00;;;;
    <#list model.content.general_post_activities as post>
        <#if post.envs?seq_contains(e)>
${lineStr(post,e,roles,"General")}
        </#if>
    </#list>
</#list>


