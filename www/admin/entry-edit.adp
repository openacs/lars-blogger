<master>
<property name="title">@page_title;noquote@</property>
<property name="focus">entry.title</property>   
<property name="context_bar">@context_bar;noquote@</property>   

<script langauge="javascript">
    function setEntryDateToToday() {
        document.forms['entry'].entry_date.value = '@today_html;noquote@';
    }
</script>

<formtemplate id="entry" style="standard-lars"></formtemplate>

