Reusable Workflows are created individual for each componentType!
<#assign output = "de.jk.fm.ext.output.OutputDirective"?new()>
<#assign tagsSeparator = "') || contains(inputs.tags, '">
<#assign envSeparator = "') || contains(inputs.env, '">
<#assign zeroTags = []>
<#function jobcondition lastjobname tags envs>
  <#local str = "">
  <#if lastjobname>
    <#local str += "${r\"${{ always() && !(contains(needs.*.result, 'failure'))\"}">
  </#if>
  <#if tags?size gt 0 >
    <#if lastjobname>
      <#local str += " && ">
    <#else>
      <#local str += "${r\"${{ \"}">
    </#if>
    <#local str += "( contains(inputs.tags, '${tags?join(tagsSeparator)}') )">
  </#if>
  <#if envs?size gt 0 >
    <#if tags?size gt 0 || lastjobname >
      <#local str += " && ">
    <#else>
      <#local str += "${r\"${{ \"}">
    </#if>
    <#local str += "( contains(inputs.env, '${envs?join(envSeparator)}') )">
  </#if>
  <#local str += " }}">
  <#return str>
</#function>
<#-- Workflow Pre activities -->
<#assign autojobsPre = model.content.general_pre_activities?filter(a -> (a.execution?? && a.execution?contains("auto")))>
<#if autojobsPre?size gt 0 >
    <#assign lastjobname = "">
    <@output file="./target/activitiesPre.yml">
name: Pre Activities Workflow
on:
  workflow_call:
    inputs:
      env:
        required: true
        type: string
jobs:
        <#list model.content.general_pre_activities as pre>
            <#if pre.execution?contains("auto")>
  PRE-${pre.name}:
    if: ${jobcondition(lastjobname?length gt 0,zeroTags,pre.envs)}
                <#if lastjobname?length gt 0 >
    needs: ${lastjobname}
                <#else>
    environment: ${r"${{ inputs.env }}"}
                </#if>
                <#assign lastjobname = "PRE-${pre.name}">
    runs-on: ubuntu-latest
    steps:
      - name: ${pre.name}
        run: echo "${pre.name} with params (env=${r"${{ inputs.env }}"})."
            </#if>
        </#list>
    </@output>
</#if>
<#-- ComponentTypes-Workflows -->
<#list model.content.componentTypes as ct>
    <#assign autojobs = ct.activities?filter(a -> (a.execution?? && a.execution?contains("auto")))>
    <#if autojobs?size gt 0 >
        <#assign lastjobname = "">
        <@output file="./target/component${ct.componentType}.yml">
name: ${ct.componentType} Activities Workflow
on:
  workflow_call:
    inputs:
      env:
        required: true
        type: string
      name:
        required: true
        type: string
      version:
        required: true
        type: string
      tags:
        required: false
        type: string

jobs:
            <#list ct.activities as a>
                <#if a.execution?contains("auto")>
  ${ct.componentType}-${a.name}:
                    <#if a.tags??>
    if: ${jobcondition(lastjobname?length gt 0,a.tags,a.envs)}
                    <#else>
    if: ${jobcondition(lastjobname?length gt 0,zeroTags,a.envs)}
                    </#if>
                    <#if lastjobname?length gt 0 >
    needs: ${lastjobname}
                    </#if>
                    <#assign lastjobname = "${ct.componentType}-${a.name}">
    runs-on: ubuntu-latest
<#--    environment: ${r"${{ inputs.env }}"} -->
    steps:
      - name: ${a.name}
        run: echo "${a.name} with params (env=${r"${{ inputs.env }}"}, name=${r"${{ inputs.name }}"}, version=${r"${{ inputs.version }}"})."
                </#if>
            </#list>
        </@output>
    </#if>
</#list>
<#-- Workflow Post activities -->
<#assign autojobsPost = model.content.general_post_activities?filter(a -> (a.execution?? && a.execution?contains("auto")))>
<#if autojobsPost?size gt 0 >
    <#assign lastjobname = "">
    <@output file="./target/activitiesPost.yml">
name: Post Activities Workflow
on:
  workflow_call:
    inputs:
      env:
        required: true
        type: string
jobs:
        <#list model.content.general_post_activities as post>
            <#if post.execution?contains("auto")>
  POST-${post.name}:
    if: ${jobcondition(lastjobname?length gt 0,zeroTags,post.envs)}
                <#if lastjobname?length gt 0 >
    needs: ${lastjobname}
                </#if>
                <#assign lastjobname = "POST-${post.name}">
    runs-on: ubuntu-latest
<#--    environment: ${r"${{ inputs.env }}"} -->
    steps:
      - name: ${post.name}
        run: echo "${post.name} with params (env=${r"${{ inputs.env }}"})."
            </#if>
        </#list>
    </@output>
</#if>

