<#-- Generate the CSV-File with the manual activities beside the automated Jobs-->
<#function lineStr activities env name>
  <#local str = env+";"+name+";"+activities.time+";"+activities.name+";"+activities.description+";;">
  <#if activities.hints??>
    <#local str += activities.hints>
  </#if>
  <#return str>
</#function>
Environment;Component;Time;Activity;Description;Status;Hints
<#list model.content.environments as e>
    <#assign manPre = model.content.general_pre_activities?filter(a -> (a.envs?seq_contains(e) && (a.execution?? && a.execution?contains("manual") || !(a.execution??)))) >
    <#if manPre?size gt 0 >
${e};General;00:00;;;;
        <#list model.content.general_pre_activities as pre>
            <#if pre.envs?seq_contains(e)>
                <#if ( pre.execution?? && pre.execution?contains("manual" ) || !(pre.execution??) ) >
${lineStr(pre,e,"General")}
                </#if>
            </#if>
        </#list>
    </#if>
<#-- Generate components manual activities before -->
    <#list model.content.components as c>
        <#list model.content.componentTypes as ct>
            <#if c.componentType?contains(ct.componentType)>
                <#assign manCompBefore = ct.activities?filter(a -> (a.envs?seq_contains(e) && (a.execution?? && a.execution?contains("manualBefore") || !(a.execution??)))) >
                <#if manCompBefore?size gt 0 >
${e};${c.name};00:00;Version ${c.version};;;
                    <#list ct.activities as a>
                        <#if a.envs?seq_contains(e)>
                            <#if (c.tags?? && a.tags?? && ((a.tags?filter(t -> c.tags?seq_contains(t)))?size gt 0) || !(c.tags?? && a.tags??)) >
                                <#if ( a.execution?? && a.execution?contains("manualBefore" ) || !(a.execution??) ) >
${lineStr(a,e,c.name)}
                                </#if>
                            </#if>
                        </#if>
                    </#list>
                </#if>
            </#if>
        </#list>
    </#list>
<#-- Approval activity for reviewers -->
${e};General;10:00;Approval;Approval for Environment ${e};;Approval in your GitHub-Environments
<#-- Generate components manual activities after -->
    <#list model.content.components as c>
        <#list model.content.componentTypes as ct>
            <#if c.componentType?contains(ct.componentType)>
                <#assign manCompAfter = ct.activities?filter(a -> (a.envs?seq_contains(e) && a.execution?contains("manualAfter"))) >
                <#if manCompAfter?size gt 0 >
${e};${c.name};00:00;Version ${c.version};;;
                    <#list ct.activities as a>
                        <#if a.envs?seq_contains(e)>
                            <#if (c.tags?? && a.tags?? && ((a.tags?filter(t -> c.tags?seq_contains(t)))?size gt 0) || !(c.tags?? && a.tags??)) >
                                <#if a.execution?contains("manualAfter") >
${lineStr(a,e,c.name)}
                                </#if>
                            </#if>
                        </#if>
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
${lineStr(post,e,"General")}
                </#if>
            </#if>
        </#list>
    </#if>
</#list>


