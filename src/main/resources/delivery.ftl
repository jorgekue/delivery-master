Umgebung;Zeit;Komponente;Aktion;Status;Hinweise
<#list model.content.environments as e>
${e};Allgemein;00:00;;;
    <#list model.content.general_pre_activities as pre>
        <#if pre.envs?seq_contains(e)>
            <#if pre.hints??>
${e};Allgemein;${pre.time};${pre.name};;${pre.hints}
            <#else>
${e};Allgemein;${pre.time};${pre.name};;
            </#if>
        </#if>
    </#list>
    <#list model.content.component as i>
        <#list model.content.componenttypes as c>
            <#if i.typ?contains(c.typ)>
${e};${i.name};00:00;Version ${i.version};;
                <#list c.activities as a>
                    <#if a.envs?seq_contains(e)>
                        <#if i.tags?? && a.tags??>
                            <#list a.tags as t>
                                <#if i.tags?seq_contains(t)>
                                    <#if a.hints??>
${e};${i.name};${a.time};${a.name};;${a.hints}
                                    <#else>
${e};${i.name};${a.time};${a.name};;
                                    </#if>
                                    <#break>
                                </#if>
                            </#list>
                        <#else>
                            <#if a.hints??>
${e};${i.name};${a.time};${a.name};;${a.hints}
                            <#else>
${e};${i.name};${a.time};${a.name};;
                            </#if>
                        </#if>
                    </#if>
                </#list>
            </#if>
        </#list>
    </#list>
${e};Allgemein;00:00;;;
    <#list model.content.general_post_activities as post>
        <#if post.envs?seq_contains(e)>
            <#if post.hints??>
${e};Allgemein;${post.time};${post.name};;${post.hints}
            <#else>
${e};Allgemein;${post.time};${post.name};;
            </#if>
        </#if>
    </#list>
</#list>


