<master>
<property name="title">@page_title@</property>
<property name="focus">entry.title</property>   
<h2>@page_title@</h2>
@context_bar@
<hr>

<script langauge="javascript">
    function setEntryDateToToday() {
        document.forms['entry'].entry_date.value = '@today_html@';
    }
</script>

<formtemplate id="entry" style="standard-lars"></formtemplate>

