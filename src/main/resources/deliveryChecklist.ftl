Environment;Component;Time;Activity;Description;Status;Hints
<#function lineStr activities env name>
  <#local str = env+";"+name+";"+activities.time+";"+activities.name+";"+activities.description+";;">
  <#if activities.hints??>
    <#local str += activities.hints>
  </#if>
  <#return str>
</#function>
<#list model.content.environments as e>
${e};General;00:00;;;;
    <#list model.content.general_pre_activities as pre>
        <#if pre.envs?seq_contains(e)>
${lineStr(pre,e,"General")}
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
${lineStr(a,e,c.name)}
                                    <#break>
                                </#if>
                            </#list>
                        <#else>
${lineStr(a,e,c.name)}
                        </#if>
                    </#if>
                </#list>
            </#if>
        </#list>
    </#list>
${e};General;00:00;;;;
    <#list model.content.general_post_activities as post>
        <#if post.envs?seq_contains(e)>
${lineStr(post,e,"General")}
        </#if>
    </#list>
</#list>


