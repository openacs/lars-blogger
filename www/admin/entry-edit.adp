<master>
<property name="title">@page_title@</property>
<property name="focus">entry.title</property>   
<property name="context_bar">@context_bar@</property>   

<script langauge="javascript">
    function setEntryDateToToday() {
        document.forms['entry'].entry_date.value = '@today_html@';
    }
</script>

<formtemplate id="entry" style="standard-lars"></formtemplate>

